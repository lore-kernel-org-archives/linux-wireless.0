Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:19848 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752083Ab0JMBDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 21:03:49 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0860731826
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 10:03:47 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: ath5k-devel@lists.ath5k.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] Fwd: [PATCH v2] ath5k: Move debugfs under ieee80211/[wiphy-name]
Date: Wed, 13 Oct 2010 10:03:56 +0900
Cc: Ben Greear <greearb@candelatech.com>
References: <4CB4F0F2.8080104@candelatech.com>
In-Reply-To: <4CB4F0F2.8080104@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010131003.56835.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed October 13 2010 08:36:18 Ben Greear wrote:
> Forgot to CC this list earlier.
> 
> Thanks,
> Ben
> 
> -------- Original Message --------
> Subject: [PATCH v2] ath5k:  Move debugfs under ieee80211/[wiphy-name]
> Date: Tue, 12 Oct 2010 10:55:38 -0700
> From: greearb@candelatech.com
> To: linux-wireless@vger.kernel.org
> CC: Ben Greear <greearb@candelatech.com>
> 
> From: Ben Greear <greearb@candelatech.com>
> 
> This automatically keeps things proper when wiphy
> is renamed.
> 
> Based on patch by Johannes Berg <johannes@sipsolutions.net>
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> v1 -> v2:  Remove empty functions that are no longer needed.
> 
> :100644 100644 c9732a6... bc8581e...
> :M	drivers/net/wireless/ath/ath5k/base.c 100644 100644 a3b2171...
> :8f7924f... M	drivers/net/wireless/ath/ath5k/debug.c 100644 100644
> :4f078b1... 236edbd... M	drivers/net/wireless/ath/ath5k/debug.h
> 
>   drivers/net/wireless/ath/ath5k/base.c  |    7 +------
>   drivers/net/wireless/ath/ath5k/debug.c |   20 ++------------------
>   drivers/net/wireless/ath/ath5k/debug.h |   12 ------------
>   3 files changed, 3 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c index c9732a6..bc8581e 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -3543,8 +3543,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
>   	sc->hw = hw;
>   	sc->pdev = pdev;
> 
> -	ath5k_debug_init_device(sc);
> -
>   	/*
>   	 * Mark the device as detached to avoid processing
>   	 * interrupts until setup is complete.
> @@ -3652,6 +3650,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>   		}
>   	}
> 
> +	ath5k_debug_init_device(sc);
> 
>   	/* ready to process interrupts */
>   	__clear_bit(ATH_STAT_INVALID, sc->status);
> @@ -3738,8 +3737,6 @@ init_ath5k_pci(void)
>   {
>   	int ret;
> 
> -	ath5k_debug_init();
> -
>   	ret = pci_register_driver(&ath5k_pci_driver);
>   	if (ret) {
>   		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
> @@ -3753,8 +3750,6 @@ static void __exit
>   exit_ath5k_pci(void)
>   {
>   	pci_unregister_driver(&ath5k_pci_driver);
> -
> -	ath5k_debug_finish();
>   }
> 
>   module_init(init_ath5k_pci);
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c
> b/drivers/net/wireless/ath/ath5k/debug.c index a3b2171..8f7924f 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -72,8 +72,6 @@ module_param_named(debug, ath5k_debug, uint, 0);
>   #include "reg.h"
>   #include "ani.h"
> 
> -static struct dentry *ath5k_global_debugfs;
> -
>   static int ath5k_debugfs_open(struct inode *inode, struct file *file)
>   {
>   	file->private_data = inode->i_private;
> @@ -890,21 +888,13 @@ static const struct file_operations fops_queue = {
>   };
> 
> 
> -/* init */
> -
> -void
> -ath5k_debug_init(void)
> -{
> -	ath5k_global_debugfs = debugfs_create_dir("ath5k", NULL);
> -}
> -
>   void
>   ath5k_debug_init_device(struct ath5k_softc *sc)
>   {
>   	sc->debug.level = ath5k_debug;
> 
> -	sc->debug.debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
> -				ath5k_global_debugfs);
> +	sc->debug.debugfs_phydir = debugfs_create_dir("ath5k",
> +				sc->hw->wiphy->debugfsdir);
> 
>   	sc->debug.debugfs_debug = debugfs_create_file("debug",
>   				S_IWUSR | S_IRUSR,
> @@ -945,12 +935,6 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
>   }
> 
>   void
> -ath5k_debug_finish(void)
> -{
> -	debugfs_remove(ath5k_global_debugfs);
> -}
> -
> -void
>   ath5k_debug_finish_device(struct ath5k_softc *sc)
>   {
>   	debugfs_remove(sc->debug.debugfs_debug);
> diff --git a/drivers/net/wireless/ath/ath5k/debug.h
> b/drivers/net/wireless/ath/ath5k/debug.h index 4f078b1..236edbd 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.h
> +++ b/drivers/net/wireless/ath/ath5k/debug.h
> @@ -138,15 +138,9 @@ enum ath5k_debug_level {
>   	} while (0)
> 
>   void
> -ath5k_debug_init(void);
> -
> -void
>   ath5k_debug_init_device(struct ath5k_softc *sc);
> 
>   void
> -ath5k_debug_finish(void);
> -
> -void
>   ath5k_debug_finish_device(struct ath5k_softc *sc);
> 
>   void
> @@ -174,15 +168,9 @@ ATH5K_DBG_UNLIMIT(struct ath5k_softc *sc, unsigned int
> m, const char *fmt, ...) {}
> 
>   static inline void
> -ath5k_debug_init(void) {}
> -
> -static inline void
>   ath5k_debug_init_device(struct ath5k_softc *sc) {}
> 
>   static inline void
> -ath5k_debug_finish(void) {}
> -
> -static inline void
>   ath5k_debug_finish_device(struct ath5k_softc *sc) {}
> 
>   static inline void

Looks good to me.

Acked-by: Bruno Randolf <br1@einfach.org>
