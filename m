Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71691C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 05:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DE7720878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 05:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G5qRwTmM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G5qRwTmM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DE7720878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbeJBMBt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 08:01:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46490 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeJBMBt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 08:01:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6DBE860C1D; Tue,  2 Oct 2018 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538457628;
        bh=DoEeg4cDbMI8mUPOo0m8ztKrfAKZMcuoYqjLBXD7kFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G5qRwTmMn3/LlFnK3Hz1evsBm/yiY6aQM/1n7muFotx59hhIE84voStyiYmzUcD9K
         YVUFugG3b3Z/QWReIINmMP+CABksczgQ9K1K3Rj1PWDQITKvxWyNvoi+U+ZDQ/I6lP
         dmRdfpZxhz8hGPkI1jYqyt7dWkDWD5PnfOpuvTVk=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 026786035F;
        Tue,  2 Oct 2018 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538457628;
        bh=DoEeg4cDbMI8mUPOo0m8ztKrfAKZMcuoYqjLBXD7kFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G5qRwTmMn3/LlFnK3Hz1evsBm/yiY6aQM/1n7muFotx59hhIE84voStyiYmzUcD9K
         YVUFugG3b3Z/QWReIINmMP+CABksczgQ9K1K3Rj1PWDQITKvxWyNvoi+U+ZDQ/I6lP
         dmRdfpZxhz8hGPkI1jYqyt7dWkDWD5PnfOpuvTVk=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 01 Oct 2018 22:20:27 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/2] ath10k: migrate to mac80211 txq scheduling
In-Reply-To: <87k1n4botm.fsf@toke.dk>
References: <1538176574-5580-1-git-send-email-rmanohar@codeaurora.org>
 <87k1n4botm.fsf@toke.dk>
Message-ID: <a944f87d1d94fd246f309cc62680a04b@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-29 03:06, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> -	ath10k_htt_tx_txq_update(hw, f_txq);
>> +	if (ret == -EBUSY) {
>> +		ieee80211_txq_schedule_start(hw, ac);
>> +		ieee80211_return_txq(hw, txq);
>> +		ieee80211_txq_schedule_end(hw, ac);
>> +	}
> 
> And ieee80211_return_txq() should be called regardless of the return
> code (it'll do it's own checking and do nothing if the queue is empty).
> 
Yeah.. Seems like calling return_txq unconditionally is messing with
may_transmit sequence. i.e pull mode.

-Rajkumar
