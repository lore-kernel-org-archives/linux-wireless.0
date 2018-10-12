Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFD4C6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 15:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633E520835
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 15:53:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="avoy+G1+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d//X1OMi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 633E520835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbeJLX0b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 19:26:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60676 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729071AbeJLX0b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 19:26:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0783F6072E; Fri, 12 Oct 2018 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539359604;
        bh=+lSATCgvbOIorg8idWAPcFN6IV1FsAqcjqbrPpUIkSA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=avoy+G1+ZlkhrbIs2ziTFZ/h0Be7D4cn6JlttCSIqTvWzMVnaYNT6d4nfdcVFf0sP
         8u1BnCI501fb4GcD6NeiOHlqIiSRRjYHXjwE3FUNbE37++v4hx8H9WCyMoGocUsb/+
         ul5OLNRUw1EkiRONQgL8a9uJyaAE5nkgSjur29MA=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 104A060591;
        Fri, 12 Oct 2018 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539359603;
        bh=+lSATCgvbOIorg8idWAPcFN6IV1FsAqcjqbrPpUIkSA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=d//X1OMiJcBahVB9tkZDSBz4Cyr6vTmwu1nZBNNYWi5kSG/O6D8hJvXSsK79Xg/dP
         vpbuXvtXytNzIllKaCOD6f6VBCcG57uHl+1VhbJPdeXiBzsGxrHYXVLtFGy24chDxF
         k2D7AXXZ9sOlTxCM7UIba1ih8BI0gwktdAb2EnsU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 104A060591
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: Re: [PATCH] ath10k: Fill the channel survey results for WCN3990 correctly
References: <1538564267-19863-1-git-send-email-pillair@codeaurora.org>
        <20181012143434.3F49060A98@smtp.codeaurora.org>
Date:   Fri, 12 Oct 2018 18:53:19 +0300
In-Reply-To: <20181012143434.3F49060A98@smtp.codeaurora.org> (Kalle Valo's
        message of "Fri, 12 Oct 2018 14:34:34 +0000 (UTC)")
Message-ID: <87murj2mc0.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Rakesh Pillai <pillair@codeaurora.org> wrote:
>
>> The host driver currently expects the channel info event to be
>> received in pairs for all the channels, i.e. the first
>> chan_info event for a particular channel will not have the
>> COMPLETE flag set and the second chan_info event for the
>> same channel will have the COMPLETE flag set.
>> 
>> The HL2.0 firmware sends only one channel info event per channel
>> which is scanned without the COMPLETE flag set. After sending the
>> chan_info_event for all the channels, the HL2.0 firmware sends a
>> chan_info_event with COMPLETE flag set to indicate the completion
>> of the channel info event.
>> 
>> The firmware does not indicate this behavior with any service bitmap
>> and hence a new firmware feature flag is used to handle the modified
>> parsing of the channel info events, in the host driver, for the
>> firmware which sends single channel info event per scanned channel.
>> 
>> Tested HW: WCN3990
>> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
>> 
>> Co-developed-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
>> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> Kbuild bot reported some errors:
>
>>> ERROR: "__udivdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
>>> ERROR: "__divdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
>
> Need to investigate those if they are valid or problem with the bot.

Arnd explained the problem in the other thread:

  "I think the problem is that 'clock_freq' is a 'u64', which means we
   can't use a normal 32-bit division. It looks like it cannot actually
   go beyond the range of a u32, so changing the type should be
   sufficient."

Please investigate that and submit v2.

-- 
Kalle Valo
