Return-Path: <SRS0=Ysg0=ZR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EB2C432C0
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 11:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 306F82075C
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 11:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EkB1q8ME";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="LIe/LJLM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfKYL5e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Nov 2019 06:57:34 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:46480
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfKYL5e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Nov 2019 06:57:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574683053;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=tZFVJ88MdAoumNhgrNj+oXKHEbGxI6uq6Q2Bv8pwwIk=;
        b=EkB1q8MEMbl+T/0YX6s0lNTysxSuYWIiyuDomi0qYVJQE5D1T8W3w7Ss4uFIz9tW
        LuSUC8L3Xsx6E/pL1dgCRiMKz35JxwTYqC8l4j0xztpjanSvd3wz3UnEPW64DN6ItvJ
        vP/BgfKZCmiO+xXipz2yEXkWIwXm862ebEBACH8g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574683053;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=tZFVJ88MdAoumNhgrNj+oXKHEbGxI6uq6Q2Bv8pwwIk=;
        b=LIe/LJLM7i13CpBXPrNTsTzrQPtNSa9yUvSCQ/U9MwPghPvX254bzBvibOt6mkIQ
        CTSGPcc9cAlcUAdN4itGItlqBJbodiadXvOz0FPd2Xgr6bq6EKZ+R3JZycwnCyPR1ny
        KYNzAanZ5CXlPyQ+r/Ovhl0Md+GCitAnyTjGM/eE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4E9B0C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: add NL80211_FEATURE_ND_RANDOM_MAC_ADDR for NLO
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191108092706.17060-1-wgong@codeaurora.org>
References: <20191108092706.17060-1-wgong@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016ea26c8e0a-1e2cdc6c-9b78-4b45-8a15-bc6e138bc3e5-000000@us-west-2.amazonses.com>
Date:   Mon, 25 Nov 2019 11:57:33 +0000
X-SES-Outgoing: 2019.11.25-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> wrote:

> Add NL80211_FEATURE_ND_RANDOM_MAC_ADDR for NLO will enable the random
> mac address for netdetect case.
> iw command:
> iw phy0 wowlan enable net-detect net-detect
> randomize=AA:7B:A1:AC:B2:41/FF:FF:FF:FF:FF:FF interval 5000 delay 30
> freqs 2412 matches ssid foo.
> After suspend, DUT will send probe request with mac AA:7B:A1:AC:B2:41.
> 
> WCN3990, QCA9377, QCA6174 PCI also support this feature.
> 
> Tested with QCA6174 SDIO with firmware
> WLAN.RMH.4.4.1-00029.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

23b5156a856b ath10k: add NL80211_FEATURE_ND_RANDOM_MAC_ADDR for NLO

-- 
https://patchwork.kernel.org/patch/11234373/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

