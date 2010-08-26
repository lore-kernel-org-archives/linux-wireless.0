Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab0HZJnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 05:43:05 -0400
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	Ido Yariv <ido@wizery.com>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>
Date: Thu, 26 Aug 2010 17:42:00 +0800
Subject: RE: [RFC/PATCH 3/6] mmc: add general runtime PM support
Message-ID: <CE761E84DADF2947A4AF22FB8D97A4732A516CE8@shsmsx501.ccr.corp.intel.com>
References: <1281532770-27545-1-git-send-email-ohad@wizery.com>
 <1281532770-27545-4-git-send-email-ohad@wizery.com>
In-Reply-To: <1281532770-27545-4-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>+static int mmc_runtime_suspend(struct device *dev)
>+{
>+	int status = 0;
>+	struct mmc_card *card = dev_to_mmc_card(dev);
>+
>+	mmc_power_save_host(card->host);
>+
>+	return status;
>+}

It seems the power_save callback is not implemented (Null pointer) yet for both mmc and sdio. Does it mean that the power_save callback will be implemented in future or just don't need at all? Thanks.

>+static int mmc_runtime_resume(struct device *dev)
>+{
>+	int status = 0;
>+	struct mmc_card *card = dev_to_mmc_card(dev);
>+
>+	mmc_power_restore_host(card->host);
>+
>+	return status;
>+}
>+
>+static int mmc_runtime_idle(struct device *dev)
>+{
>+	struct mmc_card *card = dev_to_mmc_card(dev);
>+
>+	return pm_runtime_suspend(dev);
>+}
>+
>+static const struct dev_pm_ops mmc_bus_pm_ops = {
>+	.runtime_suspend	= mmc_runtime_suspend,
>+	.runtime_resume		= mmc_runtime_resume,
>+	.runtime_idle		= mmc_runtime_idle,
>+};
>+
> static struct bus_type mmc_bus_type = {
> 	.name		= "mmc",
> 	.dev_attrs	= mmc_dev_attrs,
>@@ -146,6 +180,7 @@ static struct bus_type mmc_bus_type = {
> 	.remove		= mmc_bus_remove,
> 	.suspend	= mmc_bus_suspend,
> 	.resume		= mmc_bus_resume,
>+	.pm		= &mmc_bus_pm_ops,
> };
>
I think this is a good example to implement runtime PM support for mmc driver. But seems it doesn't provide a runtime PM example on host controller driver side. To my understanding, once the functions (mmc card or sdio devices) and mmc/sdio bus enter into rumtime suspend, it should then make the host controller enter into runtime suspend, too. Any ideas on how to achieve this? Thanks.

Best Regards,
Yunpeng Gao
