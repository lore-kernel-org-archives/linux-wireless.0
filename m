Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49778 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbcBHMJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 07:09:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>,
	wnhuang@chromium.com, devicetree@vger.kernel.org,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 1/3] mwifiex: register platform specific driver
Date: Mon, 08 Feb 2016 13:09:45 +0100
Message-ID: <8264177.UI5sMC7XWi@wuerfel> (sfid-20160208_130959_019896_15C38AED)
In-Reply-To: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 February 2016 02:15:26 Amitkumar Karwar wrote:
> diff --git a/Documentation/devicetree/bindings/mwifiex.txt b/Documentation/devicetree/bindings/mwifiex.txt
> new file mode 100644
> index 0000000..39b6a74
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mwifiex.txt
> @@ -0,0 +1,29 @@
> +mwifiex
> +------
> +
> +Required properties:
> +
> +  - name : must be "mwifiex"

This is a very unusual requirement.

Can you use one of the standard device names instead?

> +  - compatible : must be "marvell,mwifiex"
> +
> +Optional properties:
> +
> +  - mwifiex,caldata* : A series of properties with marvell,caldata prefix,
> +                     represent Calibration data downloaded to the device during
> +                     initialization. This is an array of unsigned values.
> +
> +
> +Example:
> +
> +Tx power limit calibration data is configured in below example.
> +The calibration data is an array of unsigned values, the length
> +can vary between hw versions.
> +
> +mwifiex {
> +       compatible = "marvell,mwifiex";
> +
> +       mwifiex,caldata_00_txpwrlimit_2g_cfg_set = /bits/ 8 <
> +0x01 0x00 0x06 0x00 0x08 0x02 0x89 0x01 ...>;
> +
> +};

Should we list the mac-address here as well, or is there always an eeprom
for that but not the calibration data?

	Arnd
