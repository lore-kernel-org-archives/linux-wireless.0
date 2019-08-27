Return-Path: <SRS0=iaJH=WX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B22C3A5A3
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Aug 2019 10:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15A95204EC
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Aug 2019 10:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cGXG912v";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fzLMB5U0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfH0Knh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Aug 2019 06:43:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfH0Knh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Aug 2019 06:43:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1CB7B60C72; Tue, 27 Aug 2019 10:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566902616;
        bh=LkwjJ8sIe/mKYQ0XN+V8gxStXXKpfeb3Ryarmdj7ZxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cGXG912vlairHCiZ16jPVJRExnSwYc3tSgYxjrQNXWH01vEWC/x4tpWTgJvlNomm3
         Vrqk6UXBGE0k49FR92k/9I2SKy8fUg7VRvmzj5dSnCHF2ok0weJ0kYFm7/tTIJkkLt
         lwGm96YlpWDGNVSiwQ0XzzoZragONBL0PoXfSBZ8=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 8CDB16025A;
        Tue, 27 Aug 2019 10:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566902615;
        bh=LkwjJ8sIe/mKYQ0XN+V8gxStXXKpfeb3Ryarmdj7ZxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fzLMB5U0MKhUwjvIFIQDve52/b/pinqnJUFPmcXVcGEvk/eHKXahEXqQx0+o/8mLC
         VIgAYZTxT4KutTZVOoBRZ1bGhpkERDHDzLfbTmTjmJEiOzVjcSkd+FzW/VDIyyLdX2
         zJEgrOrpSAUGOWfQAJoIr9tf4IT6Cm07rpiH0/A4=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 27 Aug 2019 16:13:35 +0530
From:   Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 31/49] ath11k: add mac.c
In-Reply-To: <875zmqsudn.fsf@toke.dk>
References: <1566316095-27507-1-git-send-email-kvalo@codeaurora.org>
 <1566316095-27507-32-git-send-email-kvalo@codeaurora.org>
 <8736hvu6e6.fsf@toke.dk> <ac6e7dbbd53e7ba9e82e49baca22b73c@codeaurora.org>
 <875zmqsudn.fsf@toke.dk>
Message-ID: <14737343f1925a771ddd8dadf0f2b5a3@codeaurora.org>
X-Sender: vthiagar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-08-21 15:38, Toke Høiland-Jørgensen wrote:
> Vasanthakumar Thiagarajan <vthiagar@codeaurora.org> writes:
> 
>> On 2019-08-20 22:21, Toke Høiland-Jørgensen wrote:
>>> [... snip ... ]
>>> 
>>>> +static const struct ieee80211_ops ath11k_ops = {
>>>> +	.tx				= ath11k_mac_op_tx,
>>> 
>>> No wake_tx_queue? :(
>> 
>> Yes, packet queueing is handled in firmware. This makes sense
>> especially when we enable 802.11 encap offload support where most of
>> the data path processing in mac80211 will be skipped and packet is
>> given to driver/firmware in 802.3 format itself. Then firmware would
>> take care of all the classification, queueing and encapsulation
>> operations.
> 
> Well, so does ath10k, and yet we still saw a significant improvement by
> moving queueing back into the host where it can be handled by the
> FQ-CoDel-enabled queueing structure.
> 

Sure, we could probably try that with ath11k as well at some point when 
we have a baseline with HE support.

Vasanth
