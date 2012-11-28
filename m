Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34656 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2K1KS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 05:18:29 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id qASAISgF013129
	for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 04:18:28 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qASAISpj000520
	for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 04:18:28 -0600
Received: from [172.24.78.8] (h78-8.vpn.ti.com [172.24.78.8])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id qASAIRdM029993	for
 <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 04:18:27 -0600
Message-ID: <1354097868.25524.26.camel@cumari.coelho.fi> (sfid-20121128_111833_530688_DE053E99)
Subject: Re: [PATCH 6/6] wl18xx: ignore irrelevant firmware version fields
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Date: Wed, 28 Nov 2012 12:17:48 +0200
In-Reply-To: <1354024321-20635-7-git-send-email-coelho@ti.com>
References: <1354024321-20635-1-git-send-email-coelho@ti.com>
	 <1354024321-20635-7-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 15:52 +0200, Luciano Coelho wrote:
> For wl18xx, only the chip ID and the minor version number are
> relevant.  Ignore the other numbers which are either not used or
> relate to internal projects or internal branches.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  drivers/net/wireless/ti/wl18xx/wl18xx.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
> index 96a1e43..5d87bd3 100644
> --- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
> +++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
> @@ -26,9 +26,9 @@
>  
>  /* minimum FW required for driver */
>  #define WL18XX_CHIP_VER		8
> -#define WL18XX_IFTYPE_VER	2
> -#define WL18XX_MAJOR_VER	0
> -#define WL18XX_SUBTYPE_VER	0
> +#define WL18XX_IFTYPE_VER	WLCORE_FW_VER_IGNORE
> +#define WL18XX_MAJOR_VER	WLCORE_FW_VER_IGNORE
> +#define WL18XX_SUBTYPE_VER	WLCORE_FW_VER_IGNORE
>  #define WL18XX_MINOR_VER	100

While merging this on top of the wl18xx FW API changes patchset, I
noticed that the version has already changed.  We can't ignore IFTYPE
because MINOR has been restarted from zero.  So, this patch was applied
like this:

diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h
b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 4d295a5..3105fbf 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -27,8 +27,8 @@
 /* minimum FW required for driver */
 #define WL18XX_CHIP_VER                8
 #define WL18XX_IFTYPE_VER      5
-#define WL18XX_MAJOR_VER       0
-#define WL18XX_SUBTYPE_VER     0
+#define WL18XX_MAJOR_VER       WLCORE_FW_VER_IGNORE
+#define WL18XX_SUBTYPE_VER     WLCORE_FW_VER_IGNORE
 #define WL18XX_MINOR_VER       28
 
 #define WL18XX_CMD_MAX_SIZE          740

--
Luca.

