Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46250C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 21:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EDB42082E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 21:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LzP+L+U0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfBDV3m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 16:29:42 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:33481 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729710AbfBDV3m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 16:29:42 -0500
Received: by mail-pg1-f175.google.com with SMTP id z11so508431pgu.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 13:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iDGc0KGaRYrjFx9GZAqmPnOh2Skl2sSowV39XqaUBws=;
        b=LzP+L+U0axCZQ7fyBjuhm71gDKou91E9E6ZjTZj7KfxUlMEM0/ia+JqluHmZAkuCMO
         CakHA0Dxpqg2xSINNTnkIH92Lo/x1fl6E4dHbDVy6Yb/fC43h83U4ewzHsVO4zNBOjRa
         VwM1NxuJk5DJ8/47QQDylIl71o6RaQ196zYqQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iDGc0KGaRYrjFx9GZAqmPnOh2Skl2sSowV39XqaUBws=;
        b=P7nyiquwRgst+yOJZCyje34yRKghpUhPupMFClf1hSyg1eCVTqxP1q50FamKK3VBRT
         zfI6VrbIRiSsmp2y2qh3wl7yW/lhH7PWHsq6orF5EqWr0+90SRl25BmAxz3vP3L0LyTG
         doUpGm0JFg+To3kBM6SBVHIue0GUezsg1IiKZGbCfF29jwbjOR1bRyqiZMXQjoZ13jLZ
         lHiFV7RQ7EdYiw/MVbHArGG8XniHfIhAO0SoqA9a0DfAJttrjEb2kv/n+T+aKp4Gbayi
         i8nL7Ky9yClhjRJGw3uThWBlBZoBPOiGP/0gVyttWYAaaztTzsHjpAq4c793gp2k13eN
         z1WA==
X-Gm-Message-State: AHQUAuZXNf9HGiJcPFKOb8083NSLLYIvHz7XR4HlPDQBhBmcX3wZCQhE
        KJbVcwvK1Wz236GyWQPaykj0PQ==
X-Google-Smtp-Source: AHgI3IZrzAMH448s4K70gZnKpXyx1IvT0L64PBhK6GS8+fGWHuXLrN07abNXLQ+uWFXos9gLSH8PsA==
X-Received: by 2002:a63:e156:: with SMTP id h22mr1312956pgk.255.1549315780752;
        Mon, 04 Feb 2019 13:29:40 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id l185sm1368959pfl.54.2019.02.04.13.29.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Feb 2019 13:29:39 -0800 (PST)
Date:   Mon, 4 Feb 2019 13:29:36 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2] ath10k: implement set_base_macaddr to fix rx-bssid
 mask in multiple APs conf
Message-ID: <20190204212935.GA158434@google.com>
References: <20190204205714.23858-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204205714.23858-1-chunkeey@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Mon, Feb 04, 2019 at 09:57:14PM +0100, Christian Lamparter wrote:
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
> 
> ---
> 
> Changed from v1:
> 	- removed support for obsolete, untested firmwares
> 	- removed unsupported TLV ops
> 	- don't error-out on unsupported platforms

This doesn't break WCN3990 this time (which doesn't support this
command), and I correctly hit the EOPNOTSUPP path:

Tested-by: Brian Norris <briannorris@chromium.org>
