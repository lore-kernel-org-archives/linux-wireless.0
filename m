Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40217 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbcBHV4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 16:56:20 -0500
Date: Mon, 8 Feb 2016 15:56:14 -0600
From: Rob Herring <robh@kernel.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>,
	wnhuang@chromium.com, devicetree@vger.kernel.org,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 1/3] mwifiex: register platform specific driver
Message-ID: <20160208215614.GB9036@rob-hp-laptop> (sfid-20160208_225624_785891_430EDE6C)
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 08, 2016 at 02:15:26AM -0800, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> Platform device and driver provides easy way to
> interact with device-tree-enabled system.
> 
> This patch registers platform driver and reorganise
> existing device tree specific code.
> Corresponding device tree binding file is
> also created.

Wrap you lines at 72 columns.

> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v3: Don't update adapter->dt_node if mwifiex_plt_dev is NULL 
> ---
>  Documentation/devicetree/bindings/mwifiex.txt      | 29 +++++++++++

This doesn't belong at top level of bindings. bindings/net/wireless/

Also, mwifiex is a linux driver name. Name it after the chips. 
marvell-sd8xxx?

>  drivers/net/wireless/marvell/mwifiex/Makefile      |  1 +
>  drivers/net/wireless/marvell/mwifiex/main.c        |  2 +
>  drivers/net/wireless/marvell/mwifiex/main.h        | 14 +++++
>  .../net/wireless/marvell/mwifiex/platform_drv.c    | 59 ++++++++++++++++++++++
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  6 +--
>  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  2 +-
>  7 files changed, 109 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mwifiex.txt
>  create mode 100644 drivers/net/wireless/marvell/mwifiex/platform_drv.c
> 
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
> +  - compatible : must be "marvell,mwifiex"

The naming should be named after the actual chip.

> +
> +Optional properties:
> +
> +  - mwifiex,caldata* : A series of properties with marvell,caldata prefix,

mwifiex is not a vendor.

> +  		      represent Calibration data downloaded to the device during
> +		      initialization. This is an array of unsigned values.
> +
> +
> +Example:
> +
> +Tx power limit calibration data is configured in below example.
> +The calibration data is an array of unsigned values, the length
> +can vary between hw versions.
> +
> +mwifiex {

These chips are SDIO devices, right? This should be a child node of the 
SDIO controller.

> +	compatible = "marvell,mwifiex";
> +
> +	mwifiex,caldata_00_txpwrlimit_2g_cfg_set = /bits/ 8 <
> +0x01 0x00 0x06 0x00 0x08 0x02 0x89 0x01 ...>;
> +
> +};
> +
