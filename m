Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C205C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA2CC2087C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DePpT9Q5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VgX4+huU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfBZM6x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:58:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34160 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfBZM6w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 07:58:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 29E9660FEB; Tue, 26 Feb 2019 12:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551185932;
        bh=7eMYse5VkKq52FJrSggS0QfDHMQO7UHad0RlWA1A214=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DePpT9Q5pC1Q40DVT7qU5PavYPjxnX1lWVLFQOJM5SCPJuwnbcpfveVuOIsQsU2FQ
         W40u+CQy2u8+EPkZZj0ZPMCeX0f3G6FqLfni7BY+8WnyKNDq6ABC+BsrE+s1HKwf3U
         Uk34vY4ZPGQHGPlMVZ2gQSvVma98B1TOEZrcRayU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 663EC60FEB;
        Tue, 26 Feb 2019 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551185930;
        bh=7eMYse5VkKq52FJrSggS0QfDHMQO7UHad0RlWA1A214=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=VgX4+huUawN41RLbr89x1Kg6VkkeHzZhURxbHzv7XakcfD5becgDzf6El4UMoyl27
         4lU8POfHUwPXW17tccA72T/sAtrOW+tgIytyCDvTpGg9eXyadfVcfMXZrYm6bS64ja
         UgnWUNpKSPi45k7Qy6EZJe9J+CCwbmTc3mZaTG0c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 663EC60FEB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/2] ath10k: Add support for ack rssi value of
 management tx packets
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550055839-24454-2-git-send-email-aambure@codeaurora.org>
References: <1550055839-24454-2-git-send-email-aambure@codeaurora.org>
To:     Abhishek Ambure <aambure@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226125852.29E9660FEB@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 12:58:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Abhishek Ambure <aambure@codeaurora.org> wrote:

> In WCN3990, WMI_TLV_SERVICE_TX_DATA_MGMT_ACK_RSSI service Indicates that
> the firmware has the capability to send the RSSI value of the ACK for all
> data and management packets transmitted.
> 
> If WMI_RSRC_CFG_FLAG_TX_ACK_RSSI is set in host capability then firmware
> sends RSSI value in "management" tx completion event. Host extracts ack
> rssi values of management packets from their tx completion event.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

4b816f170b1f ath10k: add support for ack rssi value of management tx packets
6ddc3860a566 ath10k: add support for ack rssi value of data tx packets

-- 
https://patchwork.kernel.org/patch/10809625/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

