Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34853 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935002AbdCVTcX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 15:32:23 -0400
Received: by mail-wm0-f54.google.com with SMTP id u132so45872766wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 12:32:22 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: make PCIe bus support a separated module
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170321144841.3537-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d8fc5f50-fd3f-b268-6c6d-47a6f38baded@broadcom.com> (sfid-20170322_203353_317742_05993E92)
Date: Wed, 22 Mar 2017 20:32:17 +0100
MIME-Version: 1.0
In-Reply-To: <20170321144841.3537-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-3-2017 15:48, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Right now whole brcmfmac is a single module. Enabling one bus support
> increases brcmfmac.ko size which may be unwanted for some embedded
> devices like home routers. With this change brcmfmac gets modularized.
> It's possible to build brcmfmac without PCIe support and when required
> just install/load a proper module.
> 
> A similar modification of SDIO and USB support should follow.

Not sure I see much benefit in this. Please note that the individual bus
support can already be selected through Kconfig to reduce the module
size for embedded devices. When using this module approach you have to
export symbols which also have a price when it comes to module size.

Regards,
Arend

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/Kconfig               |  2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile     |  6 ++++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       |  5 +++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c     |  5 +++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/commonring.c |  2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c       | 10 +++-------
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c   |  3 +++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c     |  1 +
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 11 +++++++++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h       |  5 -----
>  10 files changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
> index ab42b1fea03c..d93561f6ef97 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
> +++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
> @@ -57,7 +57,7 @@ config BRCMFMAC_USB
>  	  use the driver for an USB wireless card.
>  
>  config BRCMFMAC_PCIE
> -	bool "PCIE bus interface support for FullMAC driver"
> +	tristate "Broadcom FullMAC WLAN support for PCIE bus"
>  	depends on BRCMFMAC
>  	depends on PCI
>  	depends on HAS_DMA
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
> index 0383ba559edc..f60e6a9a9a77 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
> @@ -46,11 +46,13 @@ brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
>  		bcmsdh.o
>  brcmfmac-$(CONFIG_BRCMFMAC_USB) += \
>  		usb.o
> -brcmfmac-$(CONFIG_BRCMFMAC_PCIE) += \
> -		pcie.o
>  brcmfmac-$(CONFIG_BRCMDBG) += \
>  		debug.o
>  brcmfmac-$(CONFIG_BRCM_TRACING) += \
>  		tracepoint.o
>  brcmfmac-$(CONFIG_OF) += \
>  		of.o
> +
> +obj-$(CONFIG_BRCMFMAC_PCIE) += brcmfmac-pcie.o
> +brcmfmac-pcie-objs += \
> +		pcie.o
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index 05f22ff81d60..536df11f376c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -1095,6 +1095,7 @@ struct brcmf_chip *brcmf_chip_attach(void *ctx,
>  	brcmf_chip_detach(&chip->pub);
>  	return ERR_PTR(err);
>  }
> +EXPORT_SYMBOL_GPL(brcmf_chip_attach);
>  
>  void brcmf_chip_detach(struct brcmf_chip *pub)
>  {
> @@ -1109,6 +1110,7 @@ void brcmf_chip_detach(struct brcmf_chip *pub)
>  	}
>  	kfree(chip);
>  }
> +EXPORT_SYMBOL_GPL(brcmf_chip_detach);
>  
>  struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *pub, u16 coreid)
>  {
> @@ -1122,6 +1124,7 @@ struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *pub, u16 coreid)
>  
>  	return NULL;
>  }
> +EXPORT_SYMBOL_GPL(brcmf_chip_get_core);
>  
>  struct brcmf_core *brcmf_chip_get_chipcommon(struct brcmf_chip *pub)
>  {
> @@ -1176,6 +1179,7 @@ void brcmf_chip_resetcore(struct brcmf_core *pub, u32 prereset, u32 reset,
>  	core = container_of(pub, struct brcmf_core_priv, pub);
>  	core->chip->resetcore(core, prereset, reset, postreset);
>  }
> +EXPORT_SYMBOL_GPL(brcmf_chip_resetcore);
>  
>  static void
>  brcmf_chip_cm3_set_passive(struct brcmf_chip_priv *chip)
> @@ -1317,6 +1321,7 @@ bool brcmf_chip_set_active(struct brcmf_chip *pub, u32 rstvec)
>  
>  	return false;
>  }
> +EXPORT_SYMBOL_GPL(brcmf_chip_set_active);
>  
>  bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
>  {
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 7a2b49587b4d..cfe2ee0947b6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -51,6 +51,7 @@ MODULE_PARM_DESC(txglomsz, "Maximum tx packet chain size [SDIO]");
>  int brcmf_msg_level;
>  module_param_named(debug, brcmf_msg_level, int, S_IRUSR | S_IWUSR);
>  MODULE_PARM_DESC(debug, "Level of debug output");
> +EXPORT_SYMBOL_GPL(brcmf_msg_level);
>  
>  static int brcmf_p2p_enable;
>  module_param_named(p2pon, brcmf_p2p_enable, int, 0);
> @@ -232,6 +233,7 @@ void __brcmf_err(const char *func, const char *fmt, ...)
>  
>  	va_end(args);
>  }
> +EXPORT_SYMBOL_GPL(__brcmf_err);
>  #endif
>  
>  #if defined(CONFIG_BRCM_TRACING) || defined(CONFIG_BRCMDBG)
> @@ -249,6 +251,7 @@ void __brcmf_dbg(u32 level, const char *func, const char *fmt, ...)
>  	trace_brcmf_dbg(level, func, &vaf);
>  	va_end(args);
>  }
> +EXPORT_SYMBOL_GPL(__brcmf_dbg);
>  #endif
>  
>  static void brcmf_mp_attach(void)
> @@ -321,11 +324,13 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
>  	}
>  	return settings;
>  }
> +EXPORT_SYMBOL_GPL(brcmf_get_module_param);
>  
>  void brcmf_release_module_param(struct brcmf_mp_device *module_param)
>  {
>  	kfree(module_param);
>  }
> +EXPORT_SYMBOL_GPL(brcmf_release_module_param);
>  
>  static int __init brcmf_common_pd_probe(struct platform_device *pdev)
>  {
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/commonring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/commonring.c
> index 7b0e52195a85..b83f169869d5 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/commonring.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/commonring.c
> @@ -36,6 +36,7 @@ void brcmf_commonring_register_cb(struct brcmf_commonring *commonring,
>  	commonring->cr_write_wptr = cr_write_wptr;
>  	commonring->cr_ctx = ctx;
>  }
> +EXPORT_SYMBOL_GPL(brcmf_commonring_register_cb);
>  
>  
>  void brcmf_commonring_config(struct brcmf_commonring *commonring, u16 depth,
> @@ -56,6 +57,7 @@ void brcmf_commonring_config(struct brcmf_commonring *commonring, u16 depth,
>  		commonring->cr_write_wptr(commonring->cr_ctx);
>  	commonring->f_ptr = 0;
>  }
> +EXPORT_SYMBOL_GPL(brcmf_commonring_config);
>  
>  
>  void brcmf_commonring_lock(struct brcmf_commonring *commonring)
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index d2be20627b5c..bf3f5980e31b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -34,7 +34,6 @@
>  #include "fwil.h"
>  #include "feature.h"
>  #include "proto.h"
> -#include "pcie.h"
>  #include "common.h"
>  
>  #define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(950)
> @@ -920,6 +919,7 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(brcmf_attach);
>  
>  static int brcmf_revinfo_read(struct seq_file *s, void *data)
>  {
> @@ -1047,6 +1047,7 @@ int brcmf_bus_started(struct device *dev)
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(brcmf_bus_started);
>  
>  void brcmf_bus_add_txhdrlen(struct device *dev, uint len)
>  {
> @@ -1112,6 +1113,7 @@ void brcmf_detach(struct device *dev)
>  	bus_if->drvr = NULL;
>  	kfree(drvr);
>  }
> +EXPORT_SYMBOL_GPL(brcmf_detach);
>  
>  s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data, u32 len)
>  {
> @@ -1169,9 +1171,6 @@ static void brcmf_driver_register(struct work_struct *work)
>  #ifdef CONFIG_BRCMFMAC_USB
>  	brcmf_usb_register();
>  #endif
> -#ifdef CONFIG_BRCMFMAC_PCIE
> -	brcmf_pcie_register();
> -#endif
>  }
>  static DECLARE_WORK(brcmf_driver_work, brcmf_driver_register);
>  
> @@ -1193,8 +1192,5 @@ void __exit brcmf_core_exit(void)
>  #ifdef CONFIG_BRCMFMAC_USB
>  	brcmf_usb_exit();
>  #endif
> -#ifdef CONFIG_BRCMFMAC_PCIE
> -	brcmf_pcie_exit();
> -#endif
>  }
>  
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index c7c1e9906500..dd26cf4e1ab7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -434,6 +434,7 @@ void brcmf_fw_nvram_free(void *nvram)
>  {
>  	kfree(nvram);
>  }
> +EXPORT_SYMBOL_GPL(brcmf_fw_nvram_free);
>  
>  struct brcmf_fw {
>  	struct device *dev;
> @@ -562,6 +563,7 @@ int brcmf_fw_get_firmwares(struct device *dev, u16 flags,
>  	return brcmf_fw_get_firmwares_pcie(dev, flags, code, nvram, fw_cb, 0,
>  					   0);
>  }
> +EXPORT_SYMBOL_GPL(brcmf_fw_get_firmwares_pcie);
>  
>  int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
>  			      struct brcmf_firmware_mapping mapping_table[],
> @@ -604,4 +606,5 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(brcmf_fw_map_chip_to_name);
>  
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> index d2c834c3b2fc..06a8fd60d78a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> @@ -1317,6 +1317,7 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(brcmf_proto_msgbuf_rx_trigger);
>  
>  
>  void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 6fae4cf3f6ab..1c133c0a77d0 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -40,6 +40,8 @@
>  #include "core.h"
>  #include "common.h"
>  
> +MODULE_AUTHOR("Broadcom Corporation");
> +MODULE_LICENSE("Dual BSD/GPL");
>  
>  enum brcmf_pcie_state {
>  	BRCMFMAC_PCIE_STATE_DOWN,
> @@ -1981,7 +1983,7 @@ static struct pci_driver brcmf_pciedrvr = {
>  };
>  
>  
> -void brcmf_pcie_register(void)
> +static int __init brcmf_pcie_init(void)
>  {
>  	int err;
>  
> @@ -1989,11 +1991,16 @@ void brcmf_pcie_register(void)
>  	err = pci_register_driver(&brcmf_pciedrvr);
>  	if (err)
>  		brcmf_err("PCIE driver registration failed, err=%d\n", err);
> +
> +	return err;
>  }
>  
>  
> -void brcmf_pcie_exit(void)
> +static void __exit brcmf_pcie_exit(void)
>  {
>  	brcmf_dbg(PCIE, "Enter\n");
>  	pci_unregister_driver(&brcmf_pciedrvr);
>  }
> +
> +module_init(brcmf_pcie_init);
> +module_exit(brcmf_pcie_exit);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h
> index 6edaaf8ef5ce..e259c32fd6bf 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h
> @@ -21,9 +21,4 @@ struct brcmf_pciedev {
>  	struct brcmf_pciedev_info *devinfo;
>  };
>  
> -
> -void brcmf_pcie_exit(void);
> -void brcmf_pcie_register(void);
> -
> -
>  #endif /* BRCMFMAC_PCIE_H */
> 
