Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36838 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2K2RIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 12:08:41 -0500
Date: Thu, 29 Nov 2012 11:08:33 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Subject: Re: [PATCH 05/11] brcmsmac: hardware info in debugfs
Message-ID: <20121129170833.GE29726@thinkpad-t410> (sfid-20121129_180844_568227_320654D7)
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
 <1354135454-7035-6-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1354135454-7035-6-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 28, 2012 at 09:44:08PM +0100, Arend van Spriel wrote:
> From: Piotr Haber <phaber@broadcom.com>
> 
> Put basic information about hardware in debugfs.
> 
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Piotr Haber <phaber@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/debug.c    |  112 ++++++++++++++++++++
>  drivers/net/wireless/brcm80211/brcmsmac/debug.h    |   23 ++++
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    8 +-
>  drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    1 +
>  4 files changed, 143 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
> index 6ba4136..07e6b88 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/debug.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
> @@ -1,8 +1,120 @@
> +/*
> + * Copyright (c) 2012 Broadcom Corporation
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */

Sorry for being slow in responding about the license issue. As far as
we're concerned this is fine, both here and in debug.h. Please do add
our copyright notice as well:

 Copyright (c) 2012 Canonical Ltd.

Or if John's already applied them I can send a separate patch. Regarding
the license notice:

Acked-by: Seth Forshee <seth.forshee@canonical.com>

Thanks,
Seth

> +#include <linux/debugfs.h>
> +#include <linux/if_ether.h>
> +#include <linux/if.h>
>  #include <linux/net.h>
> +#include <linux/netdevice.h>
> +#include <linux/ieee80211.h>
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <net/mac80211.h>
> +
> +#include <defs.h>
> +#include <brcmu_wifi.h>
> +#include <brcmu_utils.h>
>  #include "types.h"
> +#include "main.h"
>  #include "debug.h"
>  #include "brcms_trace_events.h"
>  
> +static struct dentry *root_folder;
> +
> +void brcms_debugfs_init(void)
> +{
> +	root_folder = debugfs_create_dir(KBUILD_MODNAME, NULL);
> +	if (IS_ERR(root_folder))
> +		root_folder = NULL;
> +}
> +
> +void brcms_debugfs_exit(void)
> +{
> +	if (!root_folder)
> +		return;
> +
> +	debugfs_remove_recursive(root_folder);
> +	root_folder = NULL;
> +}
> +
> +int brcms_debugfs_attach(struct brcms_pub *drvr)
> +{
> +	if (!root_folder)
> +		return -ENODEV;
> +
> +	drvr->dbgfs_dir = debugfs_create_dir(
> +		 dev_name(&drvr->wlc->hw->d11core->dev), root_folder);
> +	return PTR_RET(drvr->dbgfs_dir);
> +}
> +
> +void brcms_debugfs_detach(struct brcms_pub *drvr)
> +{
> +	if (!IS_ERR_OR_NULL(drvr->dbgfs_dir))
> +		debugfs_remove_recursive(drvr->dbgfs_dir);
> +}
> +
> +struct dentry *brcms_debugfs_get_devdir(struct brcms_pub *drvr)
> +{
> +	return drvr->dbgfs_dir;
> +}
> +
> +static
> +ssize_t brcms_debugfs_hardware_read(struct file *f, char __user *data,
> +					size_t count, loff_t *ppos)
> +{
> +	char buf[128];
> +	int res;
> +	struct brcms_pub *drvr = f->private_data;
> +
> +	/* only allow read from start */
> +	if (*ppos > 0)
> +		return 0;
> +
> +	res = scnprintf(buf, sizeof(buf),
> +		"board vendor: %x\n"
> +		"board type: %x\n"
> +		"board revision: %x\n"
> +		"board flags: %x\n"
> +		"board flags2: %x\n"
> +		"firmware revision: %x\n",
> +		drvr->wlc->hw->d11core->bus->boardinfo.vendor,
> +		drvr->wlc->hw->d11core->bus->boardinfo.type,
> +		drvr->wlc->hw->boardrev,
> +		drvr->wlc->hw->boardflags,
> +		drvr->wlc->hw->boardflags2,
> +		drvr->wlc->ucode_rev
> +		);
> +
> +	return simple_read_from_buffer(data, count, ppos, buf, res);
> +}
> +
> +static const struct file_operations brcms_debugfs_hardware_ops = {
> +	.owner = THIS_MODULE,
> +	.open = simple_open,
> +	.read = brcms_debugfs_hardware_read
> +};
> +
> +void brcms_debugfs_create_files(struct brcms_pub *drvr)
> +{
> +	struct dentry *dentry = drvr->dbgfs_dir;
> +
> +	if (!IS_ERR_OR_NULL(dentry))
> +		debugfs_create_file("hardware", S_IRUGO, dentry,
> +				    drvr, &brcms_debugfs_hardware_ops);
> +}
> +
>  #define __brcms_fn(fn)						\
>  void __brcms_ ##fn(struct device *dev, const char *fmt, ...)	\
>  {								\
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.h b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
> index f77066b..796836b 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/debug.h
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
> @@ -1,3 +1,18 @@
> +/*
> + * Copyright (c) 2012 Broadcom Corporation
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
>  #ifndef _BRCMS_DEBUG_H_
>  #define _BRCMS_DEBUG_H_
>  
> @@ -49,4 +64,12 @@ void __brcms_dbg(struct device *dev, u32 level, const char *func,
>  #define brcms_dbg_dma(core, f, a...)		brcms_dbg(core, BRCM_DL_DMA, f, ##a)
>  #define brcms_dbg_ht(core, f, a...)		brcms_dbg(core, BRCM_DL_HT, f, ##a)
>  
> +struct brcms_pub;
> +void brcms_debugfs_init(void);
> +void brcms_debugfs_exit(void);
> +int brcms_debugfs_attach(struct brcms_pub *drvr);
> +void brcms_debugfs_detach(struct brcms_pub *drvr);
> +struct dentry *brcms_debugfs_get_devdir(struct brcms_pub *drvr);
> +void brcms_debugfs_create_files(struct brcms_pub *drvr);
> +
>  #endif /* _BRCMS_DEBUG_H_ */
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index 976720c..85dbaf8 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -846,8 +846,10 @@ static void brcms_free(struct brcms_info *wl)
>  	/* kill dpc */
>  	tasklet_kill(&wl->tasklet);
>  
> -	if (wl->pub)
> +	if (wl->pub) {
> +		brcms_debugfs_detach(wl->pub);
>  		brcms_c_module_unregister(wl->pub, "linux", wl);
> +	}
>  
>  	/* free common resources */
>  	if (wl->wlc) {
> @@ -1077,6 +1079,8 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
>  	    regulatory_hint(wl->wiphy, wl->pub->srom_ccode))
>  		wiphy_err(wl->wiphy, "%s: regulatory hint failed\n", __func__);
>  
> +	brcms_debugfs_attach(wl->pub);
> +	brcms_debugfs_create_files(wl->pub);
>  	n_adapters_found++;
>  	return wl;
>  
> @@ -1185,6 +1189,7 @@ static DECLARE_WORK(brcms_driver_work, brcms_driver_init);
>  
>  static int __init brcms_module_init(void)
>  {
> +	brcms_debugfs_init();
>  	if (!schedule_work(&brcms_driver_work))
>  		return -EBUSY;
>  
> @@ -1202,6 +1207,7 @@ static void __exit brcms_module_exit(void)
>  {
>  	cancel_work_sync(&brcms_driver_work);
>  	bcma_driver_unregister(&brcms_bcma_driver);
> +	brcms_debugfs_exit();
>  }
>  
>  module_init(brcms_module_init);
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
> index 2aafe74..4fb2834 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
> @@ -176,6 +176,7 @@ struct brcms_pub {
>  	bool phy_11ncapable;	/* the PHY/HW is capable of 802.11N */
>  
>  	struct wl_cnt *_cnt;	/* low-level counters in driver */
> +	struct dentry *dbgfs_dir;
>  };
>  
>  enum wlc_par_id {
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
