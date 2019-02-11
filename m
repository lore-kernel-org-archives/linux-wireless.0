Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599D0C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27B81218F0
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HFHhPBjP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I+sEeaZI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbfBKQ2c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 11:28:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39762 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfBKQ2b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 11:28:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DAD1160D3E; Mon, 11 Feb 2019 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902510;
        bh=KJv4M2I+kL3UX1HXa2tXIJGnVZjsVRpZKiwcTF+X99w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HFHhPBjPKh1uRugK/yerCzpnhrRmegtmZ0k6lrz6s6ssPSP02f3TxSdIZQCM6ni6t
         3KDL/uCyjiVYdHPt6BC5pt4xp57IkCYMuF8ggYhFTEANOZtki/PyHufkliaxbhb3ct
         74wM58YwBAj0gOnAQ7wzR/kA5UstDq9Vr8A2JtRU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 15DE560C4D;
        Mon, 11 Feb 2019 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902507;
        bh=KJv4M2I+kL3UX1HXa2tXIJGnVZjsVRpZKiwcTF+X99w=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=I+sEeaZIhKuhsyiQIaK5GLUfN+beieWEh/tu7Y6RA8gHI6ta6AfeeExK+9NW7XAnm
         uYyPOf2mlf+FVOIvEmSNUsvSKRjsZ8Lpop099nTWAURsX0xj8fVs6XqVqf9PmGFSKv
         ZWS6iTuPsIeoVSiXORgSeXFABbLvFccartWdXVQo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 15DE560C4D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: implement set_base_macaddr to fix rx-bssid
 mask in multiple APs conf
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190204205714.23858-1-chunkeey@gmail.com>
References: <20190204205714.23858-1-chunkeey@gmail.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Brian Norris <briannorris@chromium.org>,
        Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190211162829.DAD1160D3E@smtp.codeaurora.org>
Date:   Mon, 11 Feb 2019 16:28:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> wrote:

> Many integrated QCA9984 WiFis in various IPQ806x platform routers
> from various vendors (Netgear R7800, ZyXEL NBG6817, TP-LINK C2600,
> etc.) have either blank, bogus or non-unique MAC-addresses in
> their calibration data.
> 
> As a result, OpenWrt utilizes a discouraged binary calibration data
> patching method that allows to modify the device's MAC-addresses right
> at the source. This is because the ath10k' firmware extracts the MAC
> address from the supplied radio/calibration data and issues a response
> to the ath10k linux driver. Which was designed to take the main MAC in
> ath10k_wmi_event_ready().
> 
> Part of the "setting an alternate MAC" issue was already tackled by a
> patch from Brian Norris:
> commit 9d5804662ce1
> ("ath10k: retrieve MAC address from system firmware if provided")
> by allowing the option to specify an alternate MAC-address with the
> established device_get_mac_address() function which extracts the right
> address from DeviceTree/fwnode mac-address or local-mac-address
> properties and saves it for later.
> 
> However, Ben Greear noted that the Qualcomm's ath10k firmware is liable
> to not properly calculate its rx-bssid mask in this case. This can cause
> issues in the popluar "multiple AP with a single ath10k instance"
> configurations.
> 
> To improve MAC address handling, Felix Fietkau suggested to call
> pdev_set_base_macaddr_cmdid before bringing up the first vif and
> use the first vif MAC address there. Which is in ath10k_core_start().
> 
> This patch implement Felix Fietkau's request to
> "call pdev_set_base_macaddr_cmdid before bringing up the first vif".
> The pdev_set_base_macaddr_cmdid is already declared for all devices
> and version. The driver just needed the support code for this
> function.
> 
> Tested on:
> QCA9880/CUS223, firmwares: 10.2.4.13-2, 10.2.4.70.44, 10.2.4-1.0-00041
> QCA9887/MR33 firmware:10.2.4-1.0-00033
> QCA4019/RT-AC58U firmware: 10.4-3.4-00104, 10.4-3.5.3-00057
> QCA9984/R7800 firmware: Candela Technologies (CT) Firmware
> 
> BugLink: https://lists.openwrt.org/pipermail/openwrt-devel/2018-November/014595.html
> Fixes: 9d5804662ce1 ("ath10k: retrieve MAC address from system firmware if provided")
> Cc: Brian Norris <briannorris@chromium.org>
> Cc: Ben Greear <greearb@candelatech.com>
> Cc: Felix Fietkau <nbd@nbd.name>
> Cc: Mathias Kresin <dev@kresin.me>
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> Tested-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

05e7ba24b10d ath10k: implement set_base_macaddr to fix rx-bssid mask in multiple APs conf

-- 
https://patchwork.kernel.org/patch/10796625/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

