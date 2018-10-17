Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBF8ECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B8252150D
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:21:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XYXk19eq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X1BZFLwW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B8252150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbeJQTRA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 15:17:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbeJQTRA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 15:17:00 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6C79E60ADD; Wed, 17 Oct 2018 11:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539775305;
        bh=uJaykkS5I+5CHoY3O/83jqL5YUpH0qm2FhsQt9Oo5Ds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XYXk19eqG70GY3QrFhINMiSAaFcuiGiKPloO6Zqy1lY2CzIhdp/k/zigBk8b/HFFk
         QnFRnhcNvoIF3RYLLDKpzbaTxOFqFPQSPFZV8wOT0qq8C/lsZTBkfnqbW6B+SAkocW
         0FnWIn5ZB9WAcltgvD/WQ73L4mIiphc/+A+fpj9E=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 5F10460A34;
        Wed, 17 Oct 2018 11:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539775304;
        bh=uJaykkS5I+5CHoY3O/83jqL5YUpH0qm2FhsQt9Oo5Ds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X1BZFLwWkE05JsOake+kHayhalyjHl5HcYlE04HYdishAcGC4qfu423Hcs5wZZvSj
         hCIM74U/9ScDPVFl5iV85bEs2bLIPvkkg0Os1SB/4iEwMszM7QfSwSi+pG22c83IJg
         GyXDc/AOKw7COs1MNlWrii6ey1JgQMApv6Kdsv2A=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 17 Oct 2018 16:51:44 +0530
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: Re: [PATCH] ath10k: Fill the channel survey results for WCN3990
 correctly
In-Reply-To: <87murj2mc0.fsf@kamboji.qca.qualcomm.com>
References: <1538564267-19863-1-git-send-email-pillair@codeaurora.org>
 <20181012143434.3F49060A98@smtp.codeaurora.org>
 <87murj2mc0.fsf@kamboji.qca.qualcomm.com>
Message-ID: <c825412eeccfee7a3ca6ebe0b9e68ea8@codeaurora.org>
X-Sender: pillair@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

I have removed the clk_freq variable and now there will be u32 division 
only.
This change has been sent in v2.

Thanks,
Rakesh Pillai.

On 2018-10-12 21:23, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
>> Rakesh Pillai <pillair@codeaurora.org> wrote:
>> 
>>> The host driver currently expects the channel info event to be
>>> received in pairs for all the channels, i.e. the first
>>> chan_info event for a particular channel will not have the
>>> COMPLETE flag set and the second chan_info event for the
>>> same channel will have the COMPLETE flag set.
>>> 
>>> The HL2.0 firmware sends only one channel info event per channel
>>> which is scanned without the COMPLETE flag set. After sending the
>>> chan_info_event for all the channels, the HL2.0 firmware sends a
>>> chan_info_event with COMPLETE flag set to indicate the completion
>>> of the channel info event.
>>> 
>>> The firmware does not indicate this behavior with any service bitmap
>>> and hence a new firmware feature flag is used to handle the modified
>>> parsing of the channel info events, in the host driver, for the
>>> firmware which sends single channel info event per scanned channel.
>>> 
>>> Tested HW: WCN3990
>>> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
>>> 
>>> Co-developed-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
>>> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
>>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>> 
>> Kbuild bot reported some errors:
>> 
>>>> ERROR: "__udivdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] 
>>>> undefined!
>>>> ERROR: "__divdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] 
>>>> undefined!
>> 
>> Need to investigate those if they are valid or problem with the bot.
> 
> Arnd explained the problem in the other thread:
> 
>   "I think the problem is that 'clock_freq' is a 'u64', which means we
>    can't use a normal 32-bit division. It looks like it cannot actually
>    go beyond the range of a u32, so changing the type should be
>    sufficient."
> 
> Please investigate that and submit v2.
