Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35759 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbcAMMQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 07:16:44 -0500
Date: Wed, 13 Jan 2016 13:16:41 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2] wl1251: add sysfs interface for bluetooth coexistence
 mode configuration
Message-ID: <20160113121641.GM11560@pali> (sfid-20160113_131705_253414_0E5E8C60)
References: <1451130310-16666-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1451130310-16666-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 December 2015 12:45:10 Pali Rohár wrote:
> Port the bt_coex_mode sysfs interface from wl1251 driver version included
> in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
> This enables userspace applications to set one of the modes
> WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
> The default mode is WL1251_BT_COEX_OFF.
> It should be noted that this driver always enabled bt-coexistence before
> and enabled bt-coexistence directly affects the receiving performance,
> rendering it unusable in some low-signal situations. Especially monitor
> mode is affected very badly with bt-coexistence enabled.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
> I'm resending this patch for review again as after two years there is no
> nl80211 interface for bt coex and wl1251 on Nokia N900 needs it. Once
> there will be common interface for bt coex I can rewrite my patches, but
> I do not want to wait another 2 years...
> 
> Changes:
> In v2 is sysfs node attached directly to wl1251 device instead of creating
> new platform device for sysfs node. So sysfs node is now available at:
> /sys/class/net/wlan0/device/bt_coex_mode
> ---
>  drivers/net/wireless/ti/wl1251/acx.c    |   43 ++++++++++++++--
>  drivers/net/wireless/ti/wl1251/acx.h    |    8 +--
>  drivers/net/wireless/ti/wl1251/init.c   |    6 +--
>  drivers/net/wireless/ti/wl1251/main.c   |   84 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/ti/wl1251/wl1251.h |    8 +++
>  5 files changed, 137 insertions(+), 12 deletions(-)

BUMP!

-- 
Pali Rohár
pali.rohar@gmail.com
