Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51301 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab0KWPxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 10:53:50 -0500
Message-ID: <4CEBE389.1020209@openwrt.org>
Date: Tue, 23 Nov 2010 16:53:45 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul.Shaw@atheros.com, lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k: Add support for Adaptive Power Management
References: <1290525147-6927-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1290525147-6927-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-23 4:12 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> This feature is to mitigate the problem of certain 3
> stream chips that exceed the PCIe power requirements.An EEPROM flag
> controls which chips have APM enabled which is basically read from
> miscellaneous configuration element of the EEPROM header.
> 
> This workaround will reduce power consumption by using 2 Tx chains for
> Single and Double stream rates (5 GHz only).All self generated frames
> (regardless of rate) are sent on 2 chains when this feature is
> enabled(Chip Limitation).
> 
> Cc: Paul Shaw <paul.shaw@atheros.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> Tested-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
I think this code would get a lot more concise if you'd move it to
ar9003_mac.c, since this issue is AR9003 specific anyway.
It would also allow you to avoid adding yet another redundant ath_softc
capability flag, as the driver part really doesn't need to be concerned
with this.

- Felix
