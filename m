Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35358 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753126AbcISV1y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 17:27:54 -0400
Date: Mon, 19 Sep 2016 16:27:53 -0500
From: Rob Herring <robh@kernel.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        devicetree@vger.kernel.org, Wei-Ning Huang <wnhuang@chromium.org>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH] mwifiex: parse device tree node for PCIe
Message-ID: <20160919212753.GA16598@rob-hp-laptop> (sfid-20160919_232758_486877_8C424610)
References: <1473434254-16782-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473434254-16782-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 09, 2016 at 08:47:34PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> This patch derives device tree node from pcie bus layer framework.
> Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> marvell-8xxx.txt) to accomodate PCIe changes.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  .../bindings/net/wireless/marvell-8xxx.txt         | 64 ++++++++++++++++++++++
>  .../bindings/net/wireless/marvell-sd8xxx.txt       | 63 ---------------------

Resend using -M option so I do have to figure out if you added 1 line or 
changed a bunch.

>  drivers/net/wireless/marvell/mwifiex/pcie.c        | 19 +++++++
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  3 +-
>  4 files changed, 85 insertions(+), 64 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
> new file mode 100644
> index 0000000..a8a95aa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
> @@ -0,0 +1,64 @@
> +Marvell 8897/8997 (sd8897/sd8997/pcie8997) SDIO/PCIE devices
> +------
> +
> +This node provides properties for controlling the marvell sdio/pcie wireless device.
> +The node is expected to be specified as a child node to the SDIO/PCIE controller that
> +connects the device to the system.
> +
> +Required properties:
> +
> +  - compatible : should be one of the following:
> +	* "marvell,sd8897"
> +	* "marvell,sd8997"
> +	* "marvell,pcie8997"

PCIe uses vendor and product IDs for compatible strings. Please read the 
OF PCI bus bindings doc.

Rob
