Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D442C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 10:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECEC4205C9
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 10:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="QorpQTvu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECEC4205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbeJBReh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 13:34:37 -0400
Received: from mail.toke.dk ([52.28.52.200]:59285 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbeJBReh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 13:34:37 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538477515; bh=sA0zaNHwZmiBG/g3dwxDP+jTmjkTFLi/yADeRHiDBtg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QorpQTvuk8sNsBeedccksNtpam0RKSq60OrG9XpHNq8HIhEbRRN+oWxOnjUrX0kGn
         iVoC1kzXD4saupcGNIJnyfWMbFHnf3IO84WUONW7fw2zq+b2V3SnnosZ5puoJ3KZ75
         ngnR6pDJerrVCslp+KTZdNGNqAeU/tbkifls4FIEe6HNhJMCrRvYit8RRWcLkimfwE
         pN6aG5ptUbr64LuDlmqo/m/ELJLHCuPhqeQuWjLTsk1R3k/AK8IHzw473nhEiN3I4e
         VcuYuqyZCFZNEQy0UFlL77s4uIB8f+dWIsAPTVnCq3AOrbuhoG6nZ+NHXI0V2vw4Eg
         WJuCrALzVqOaQ==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/2] ath10k: migrate to mac80211 txq scheduling
In-Reply-To: <a944f87d1d94fd246f309cc62680a04b@codeaurora.org>
References: <1538176574-5580-1-git-send-email-rmanohar@codeaurora.org> <87k1n4botm.fsf@toke.dk> <a944f87d1d94fd246f309cc62680a04b@codeaurora.org>
Date:   Tue, 02 Oct 2018 12:51:54 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87lg7gei45.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-09-29 03:06, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> -	ath10k_htt_tx_txq_update(hw, f_txq);
>>> +	if (ret =3D=3D -EBUSY) {
>>> +		ieee80211_txq_schedule_start(hw, ac);
>>> +		ieee80211_return_txq(hw, txq);
>>> +		ieee80211_txq_schedule_end(hw, ac);
>>> +	}
>>=20
>> And ieee80211_return_txq() should be called regardless of the return
>> code (it'll do it's own checking and do nothing if the queue is empty).
>>=20
> Yeah.. Seems like calling return_txq unconditionally is messing with
> may_transmit sequence. i.e pull mode.

Messing with, how?

-Toke
