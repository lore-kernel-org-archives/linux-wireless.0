Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19166 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2BMT2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 14:28:55 -0500
Subject: Re: [PATCH 1/3] net: rfkill-gpio: add device tree support
From: Rhyland Klein <rklein@nvidia.com>
To: Marc Dietrich <marvin24@gmx.de>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	Stephen Warren <swarren@nvidia.com>,
	Colin Cross <ccross@android.com>,
	Olof Johansson <olof@lixom.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de>
References: <1ec0e63a7453072689618430ebc2bdd7b62542a2.1329073559.git.marvin24@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Feb 2012 11:25:59 -0800
Message-ID: <1329161159.22948.3.camel@rklein-linux> (sfid-20120213_202904_320627_68022235)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-02-12 at 11:13 -0800, Marc Dietrich wrote:
> This adds device tree support for rfkill-gpio. The optional platform
> paramters gpio_runtime_close and gpio_runtime_setup are not implemented.
> 
> Cc: linux-wireless@vger.kernel.org
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Rhyland Klein <rklein@nvidia.com>
> Signed-off-by: Marc Dietrich <marvin24@gmx.de>
> +
>  static int rfkill_gpio_probe(struct platform_device *pdev)
>  {
>  	struct rfkill_gpio_data *rfkill;
>  	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
> +	struct device_node *np = pdev->dev.of_node;
>  	int ret = 0;
>  	int len = 0;
>  
> +	if (np)
> +		pdata = rfkill_gpio_parse_pdata(pdev);
> +

The only concern I have is the precedence of devicetree settings vs
platform data settings? If there is pdata passed in from board file
initialization, and there is a device tree (a corner case but I think a
valid one) then I believe the order would be that defined pdata would
override the devicetree settings. That way if someone wanted to make a
quick update, they wouldn't need to change the boot loader as well.

>  	if (!pdata) {
>  		pr_warn("%s: No platform data specified\n", __func__);
>  		return -EINVAL;
> @@ -217,6 +273,7 @@ static struct platform_driver rfkill_gpio_driver = {
>  	.driver = {
>  		   .name = "rfkill_gpio",
>  		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(of_rfkill_gpio_match),
>  	},
>  };
>  

-rhyland

