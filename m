Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA28EC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75D602184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:25:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WhUR1oRd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XcWBIL5G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbfB1JZu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 04:25:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfB1JZu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 04:25:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 13EB06087D; Thu, 28 Feb 2019 09:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551345949;
        bh=3pv8RMNIzEbLrNhrE0MOJNQ77VhVmHn4RtO8mx1dmts=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WhUR1oRdAOOb25eFg/bNsiPuT+tfxLkTxJS5kbatVJ5QE2bWf7ZxAA7Mi5Yj9Ay2w
         FtQ1p79QXEocs1PNiImDP7XQD4HUajubr0RjZrMsMJPvTvUXo7MjZBwJEnVmk/4VHn
         uNN/zD2/0USqXpFTg9FcRjLFnGZe9BC21JzYk1oM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B87466087D;
        Thu, 28 Feb 2019 09:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551345948;
        bh=3pv8RMNIzEbLrNhrE0MOJNQ77VhVmHn4RtO8mx1dmts=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XcWBIL5GcmIHOsBwP9+lKxzCNwhkY5nP5lVgwhCzS++AGHOXOe4vribSPVtdg8nDh
         s+6hFT9O9wdHboCi0mG6kzs9o8EkftJIMzZTxOLckc3suNyPVUZZfT23NXGdmNmjpV
         WFN9a/KnveRXK9TVidUHOVy5G1+fGZBy0KPn9wQI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B87466087D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/21] wil6210: remove rtap_include_phy_info module param
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1550845279-16103-2-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-2-git-send-email-merez@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190228092549.13EB06087D@smtp.codeaurora.org>
Date:   Thu, 28 Feb 2019 09:25:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:

> Due to a HW issue in PHY info collection rtap_include_phy_info is not
> in use, hence can be removed.
> 
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

7 patches applied to ath-next branch of ath.git, thanks.

387f3794b8cf wil6210: remove rtap_include_phy_info module param
0439a5e035f7 wil6210: add option to drop Tx packets when Tx ring is full
bf0353a67491 wil6210: support up to 20 stations in AP mode
6d1ba32c8070 wil6210: accessing 802.3 addresses via utility functions
a380eb5736c0 wil6210: fix invalid sta statistics update
979c9d8d01c4 wil6210: ignore HALP ICR if already handled
de77a53c2d1e wil6210: check null pointer in _wil_cfg80211_merge_extra_ies

-- 
https://patchwork.kernel.org/patch/10826101/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

