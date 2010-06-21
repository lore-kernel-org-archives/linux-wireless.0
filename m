Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64560 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab0FUSCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:02:53 -0400
Received: by pwj8 with SMTP id 8so419382pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 11:02:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C1F51A3.5000407@gmail.com>
References: <4C1F51A3.5000407@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 11:02:32 -0700
Message-ID: <AANLkTim7zJFbV0N0yoV--F3-8_fuv3jWFilozC9wmuP-@mail.gmail.com>
Subject: Re: [RFC] refactor ath9k_platform to sound sane for use in both ath9k
	and ath5k
To: Daniel Golle <daniel.golle@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 21, 2010 at 4:48 AM, Daniel Golle <daniel.golle@gmail.com> wrote:
> I'm developing on OpenWrt to work with EEPROM-less ath5k mini-pci devices.
> This is needed to support the ar71xx-based Senao EAP7660D board which got
> two AR5413 modules soldered into its mini-pci slots. In the original
> Firmware, MAC addresses as well as calibration-data seems to be part of the
> firmware blob stored on the board flash.
> See https://lists.openwrt.org/pipermail/openwrt-devel/2010-June/007366.html
> for the corresponding discussion on OpenWrt-devel.

I don't see much "discussion" there.

> Similarly to the way this happens for ath9k, I managed to get ath5k to use
> the MAC address and eeprom-data supplied by ath9k_platform_data.
> Including ath9k_platform.h in ath5k-sources looks confusing as the name
> ath9k_platform suggests that the supplied ath9k_platform_info struct is
> specific to ath9k devices.
> Consequently, I believe ath9k_platform.h should be renamed into
> ath_platform.h, the macro ATH9K_PLAT_EEP_MAX_WORDS into
> ATH_PLAT_EEP_MAX_WORDS and struct ath9k_platform_data should be refactored
> to be struct ath_platform_data.
> Please let me know if you agree with this in theory; if yes, I'll start
> posting the patches to OpenWrt.

You can stuff any general stuff into the ath module which is shared by both.

  Luis
