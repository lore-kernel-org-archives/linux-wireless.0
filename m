Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5968EC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B79F20823
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:41:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i0sR4P0h";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gEuZG9k5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbfBDPlr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:41:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40518 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfBDPlq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 10:41:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5EFA3606AC; Mon,  4 Feb 2019 15:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549294905;
        bh=GTD+OZTDmZrAFwDoZ5L3LDfQiN/9JDZmeKM2SD8Izsk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=i0sR4P0hzO2eJ3vCLAF9tYeV4d7QO6bd9duYZBzDZN1vSQ6KtbXi3ka4lL5CXEODu
         /JHNU2oXA5EEFwMWSX4G8TQlzdkGsHZatHs/qaLc7cpDuaIwczpGjMYqSQ2CSbBczr
         NqtCV83SGCfzibFPuA3HJd+2rCzhqbbf8qamxUkg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 208C16032C;
        Mon,  4 Feb 2019 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549294904;
        bh=GTD+OZTDmZrAFwDoZ5L3LDfQiN/9JDZmeKM2SD8Izsk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gEuZG9k5dWb6MSfruOLkZnugA535N/1ZZ5j3XGmvucGEymGWZi9X3xpAJMYUb8LQf
         as+XwnjvaqwvGkE+jIxlAb1dXDzRHvbgY0hm041yUe8mNbLktNhClLk0s/ZTVPUX1v
         o/95WuVMlriqYLee+BXVLwA4bv6PSTSzz9Qk3wAc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 208C16032C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Ben Greear <greearb@candelatech.com>,
        Brian Norris <briannorris@chromium.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath10k: implement set_base_macaddr to fix rx-bssid mask in multiple APs conf
References: <20190114153558.972-1-chunkeey@gmail.com>
Date:   Mon, 04 Feb 2019 17:41:39 +0200
In-Reply-To: <20190114153558.972-1-chunkeey@gmail.com> (Christian Lamparter's
        message of "Mon, 14 Jan 2019 16:35:58 +0100")
Message-ID: <87y36vd0i4.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> writes:

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

I prefer listing hardware and firmware version(s) tested in the commit
log. That way it's easier to understand and lates track how this is
supposed to work.

> BugLink: https://lists.openwrt.org/pipermail/openwrt-devel/2018-November/014595.html
> Fixes: 9d5804662ce1 ("ath10k: retrieve MAC address from system firmware if provided")
> Cc: Brian Norris <briannorris@chromium.org>
> Cc: Ben Greear <greearb@candelatech.com>
> Cc: Felix Fietkau <nbd@nbd.name>
> Cc: Mathias Kresin <dev@kresin.me>
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
>
> WARNING: line over 80 characters
> L85: FILE: drivers/net/wireless/ath/ath10k/wmi-ops.h:68:
> +                                 const u8 macaddr[ETH_ALEN]);
>
> The function parameter has been aligned to match other functions
> parameters that extend over 80 characters.

That's fine. In my ath10k-check script I have max-line-lenght 90 chars
anyway.

https://github.com/qca/qca-swiss-army-knife/blob/master/tools/scripts/ath10k/ath10k-check

> @@ -8885,6 +8904,7 @@ static const struct wmi_ops wmi_ops = {
>  
>  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
> +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>  	.gen_pdev_set_rd = ath10k_wmi_op_gen_pdev_set_rd,
>  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>  	.gen_init = ath10k_wmi_op_gen_init,
> @@ -8960,6 +8980,7 @@ static const struct wmi_ops wmi_10_1_ops = {
>  
>  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
> +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>  	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
>  	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
> @@ -9032,6 +9053,7 @@ static const struct wmi_ops wmi_10_2_ops = {
>  
>  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
> +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>  	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
>  	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,

These are in practise obsolete WMI interfaces so not sure if it makes it
worth to support this parameter in them. But on the other hand it won't
hurt either, so dunno.

> @@ -9115,6 +9137,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
>  	.gen_peer_create = ath10k_wmi_op_gen_peer_create,
>  	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
>  	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
> +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>  	.gen_peer_set_param = ath10k_wmi_op_gen_peer_set_param,
>  	.gen_set_psmode = ath10k_wmi_op_gen_set_psmode,
>  	.gen_set_sta_ps = ath10k_wmi_op_gen_set_sta_ps,

This is only used by QCA988X. Did you test with that? If not, IMHO
better not to enable it for 10.2.4 until it's tested.

> @@ -9166,6 +9189,7 @@ static const struct wmi_ops wmi_10_4_ops = {
>  
>  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
> +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>  	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
>  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>  	.gen_init = ath10k_wmi_10_4_op_gen_init,

This looks fine.

-- 
Kalle Valo
