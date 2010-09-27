Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:32635 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab0I0Oio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 10:38:44 -0400
Subject: Re: [FIRMWARE & NVS] wl12xx: Add Firmware and NVS files to support
 Texas Instruments WLAN driver
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285596260-814-1-git-send-email-shahar_levi@ti.com>
References: <1285596260-814-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 17:38:37 +0300
Message-ID: <1285598317.5768.111.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 16:04 +0200, ext Shahar Levi wrote:
> FW & NVS Support wl127x wireless LAN driver (wl1271 & wl1273).
> In order to use those files copy them to target FS at /lib/firmware/.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

The NVS doesn't seem to work correctly with our latest code.  We now
have a check to see if 5GHz is enabled and, if that's the case, enforce
a larger NVS that contains the 5GHz calibration.

In this NVS, you have the general_params.dual_mode_select set to true,
but that only works if the 5GHz calibration is available and the NVS
should be 912 bytes in that case, instead of the legacy 800 bytes.


-- 
Cheers,
Luca.

