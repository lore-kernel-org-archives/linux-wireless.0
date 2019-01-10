Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B9AC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 22:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7365B2064C
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 22:46:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="azNX3eXW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="azNX3eXW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbfAJWq0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 17:46:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729709AbfAJWq0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 17:46:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 65C81608FC; Thu, 10 Jan 2019 22:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547160385;
        bh=QPRU8YDekBZ1hfTTZ1GZ158gXQec4VWvbc+ObW2GGkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=azNX3eXWX9SCjPLoMYHm1rYvsgicDGCD1Cllb58qhZx0E4b/tt8rxmdW5eOzFWrrM
         X89WhC9o6qSM7VnWd+e0FbSlS61Mf8tW0XmdppnYuupt1Iu0/CcG45lPjwotoHd4h7
         tsPMcsCiP2TUWD53290RvKiWmmylGmVgplqMEkAU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 04991608D2;
        Thu, 10 Jan 2019 22:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547160385;
        bh=QPRU8YDekBZ1hfTTZ1GZ158gXQec4VWvbc+ObW2GGkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=azNX3eXWX9SCjPLoMYHm1rYvsgicDGCD1Cllb58qhZx0E4b/tt8rxmdW5eOzFWrrM
         X89WhC9o6qSM7VnWd+e0FbSlS61Mf8tW0XmdppnYuupt1Iu0/CcG45lPjwotoHd4h7
         tsPMcsCiP2TUWD53290RvKiWmmylGmVgplqMEkAU=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 10 Jan 2019 14:46:24 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        make-wifi-fast@lists.bufferbloat.net,
        =?UTF-8?Q?Toke_H=C3=B8iland-J?= =?UTF-8?Q?=C3=B8rgensen?= 
        <toke@toke.dk>
Subject: Re: [PATCH v5 5/6] ath10k: migrate to mac80211 txq scheduling
In-Reply-To: <87o99hvecq.fsf@kamboji.qca.qualcomm.com>
References: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
 <1545181331-5288-6-git-send-email-rmanohar@codeaurora.org>
 <87o99hvecq.fsf@kamboji.qca.qualcomm.com>
Message-ID: <7365e300cf7f73e6c4a0774d6a4b7806@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-19 05:24, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> From: Toke Høiland-Jørgensen <toke@toke.dk>
>> 
>> ath10k maintains common txqs list for all stations. This txq
>> management can be removed by migrating to mac80211 txq APIs
>> and let mac80211 handle txqs reordering based on reported airtime.
>> By doing this, txq fairness maintained in ath10k i.e processing
>> N frames per txq is removed. By adapting to mac80211 APIs,
>> ath10k will support mac80211 based airtime fairness algorithm.
>> 
>> Tested-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
>> Co-developed-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
>> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> 
> Please always add hardware and firmware versions used for testing. But 
> I
> can add that, so no need to resend because of this. Just let me know
> what to add.
> 
Thanks Kalle. Please amend the commit log with

Tested on QCA4019 with firmware version 10.4-3.2.1.1-00015
Tested on QCA9984 with firmware version 10.4-3.9.0.1-00005

-Rajkumar
