Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64057 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934503AbaH1Kfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 06:35:52 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so326365wib.6
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 03:35:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140828073041.14691.15099.stgit@potku.adurom.net>
References: <20140828072642.14691.44313.stgit@potku.adurom.net>
	<20140828073041.14691.15099.stgit@potku.adurom.net>
Date: Thu, 28 Aug 2014 12:35:50 +0200
Message-ID: <CA+BoTQk40V_t6M8MEwk77cUtmHpEXR3FKBgonb0T+yDX59B+gw@mail.gmail.com> (sfid-20140828_123556_904290_7466552C)
Subject: Re: [PATCH v2 2/2] ath10k: add testmode
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2014 09:30, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Add testmode interface for starting and using UTF firmware which is used to run
> factory tests. This is implemented by adding new state ATH10K_STATE_UTF and user
> space can enable this state with ATH10K_TM_CMD_UTF_START command. To go back to
> normal mode user space can send ATH10K_TM_CMD_UTF_STOP.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/Makefile   |    1
>  drivers/net/wireless/ath/ath10k/core.c     |   88 ++++--
>  drivers/net/wireless/ath/ath10k/core.h     |   22 +-
>  drivers/net/wireless/ath/ath10k/debug.c    |    5
>  drivers/net/wireless/ath/ath10k/debug.h    |    1
>  drivers/net/wireless/ath/ath10k/hw.h       |    2
>  drivers/net/wireless/ath/ath10k/mac.c      |   10 +
>  drivers/net/wireless/ath/ath10k/testmode.c |  404 ++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/testmode.h |   46 +++
>  drivers/net/wireless/ath/ath10k/wmi.c      |   17 +
>  10 files changed, 566 insertions(+), 30 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath10k/testmode.c
>  create mode 100644 drivers/net/wireless/ath/ath10k/testmode.h
>
> diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
> index 2cfb63ca9327..8b1b1adb477a 100644
> --- a/drivers/net/wireless/ath/ath10k/Makefile
> +++ b/drivers/net/wireless/ath/ath10k/Makefile
> @@ -11,6 +11,7 @@ ath10k_core-y += mac.o \
>                  bmi.o
>
>  ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
> +ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
>  ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
>
>  obj-$(CONFIG_ATH10K_PCI) += ath10k_pci.o
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 651a6da8adf5..c01a37526ad5 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -26,6 +26,7 @@
>  #include "bmi.h"
>  #include "debug.h"
>  #include "htt.h"
> +#include "testmode.h"
>
>  unsigned int ath10k_debug_mask;
>  static bool uart_print;
> @@ -257,21 +258,42 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
>         return 0;
>  }
>
> -static int ath10k_download_fw(struct ath10k *ar)
> +static int ath10k_download_fw(struct ath10k *ar, enum ath10k_firmware_mode mode)
>  {
> -       u32 address;
> +       u32 address, data_len;
> +       const char *mode_name;
> +       const void *data;
>         int ret;
>
>         address = ar->hw_params.patch_load_addr;
>
> -       ret = ath10k_bmi_fast_download(ar, address, ar->firmware_data,
> -                                      ar->firmware_len);
> +       switch (mode) {
> +       case ATH10K_FIRMWARE_MODE_NORMAL:
> +               data = ar->firmware_data;
> +               data_len = ar->firmware_len;
> +               mode_name = "normal";
> +               break;
> +       case ATH10K_FIRMWARE_MODE_UTF:
> +               data = ar->testmode.utf->data;
> +               data_len = ar->testmode.utf->size;
> +               mode_name = "utf";
> +               break;
> +       default:
> +               ath10k_err(ar, "unknown firmware mode: %d\n", mode);
> +               return -EINVAL;
> +       }
> +
> +       ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +                  "boot uploading firmware image %p len %d mode %s\n",
> +                  data, data_len, mode_name);
> +
> +       ret = ath10k_bmi_fast_download(ar, address, data, data_len);
>         if (ret) {
> -               ath10k_err(ar, "could not write fw (%d)\n", ret);
> -               goto exit;
> +               ath10k_err(ar, "failed to download %s firmware: %d\n",
> +                          mode_name, ret);
> +               return ret;
>         }
>
> -exit:
>         return ret;
>  }
>
> @@ -567,7 +589,8 @@ success:
>         return 0;
>  }
>
> -static int ath10k_init_download_firmware(struct ath10k *ar)
> +static int ath10k_init_download_firmware(struct ath10k *ar,
> +                                        enum ath10k_firmware_mode mode)
>  {
>         int ret;
>
> @@ -583,7 +606,7 @@ static int ath10k_init_download_firmware(struct ath10k *ar)
>                 return ret;
>         }
>
> -       ret = ath10k_download_fw(ar);
> +       ret = ath10k_download_fw(ar, mode);
>         if (ret) {
>                 ath10k_err(ar, "failed to download firmware: %d\n", ret);
>                 return ret;
> @@ -685,12 +708,15 @@ static void ath10k_core_restart(struct work_struct *work)
>         case ATH10K_STATE_WEDGED:
>                 ath10k_warn(ar, "device is wedged, will not restart\n");
>                 break;
> +       case ATH10K_STATE_UTF:
> +               ath10k_warn(ar, "firmware restart in UTF mode not supported\n");
> +               break;
>         }
>
>         mutex_unlock(&ar->conf_mutex);
>  }
>
> -int ath10k_core_start(struct ath10k *ar)
> +int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
>  {
>         int status;
>
> @@ -703,7 +729,7 @@ int ath10k_core_start(struct ath10k *ar)
>                 goto err;
>         }
>
> -       status = ath10k_init_download_firmware(ar);
> +       status = ath10k_init_download_firmware(ar, mode);
>         if (status)
>                 goto err;
>
> @@ -760,10 +786,12 @@ int ath10k_core_start(struct ath10k *ar)
>                 goto err_hif_stop;
>         }
>
> -       status = ath10k_htt_connect(&ar->htt);
> -       if (status) {
> -               ath10k_err(ar, "failed to connect htt (%d)\n", status);
> -               goto err_hif_stop;
> +       if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
> +               status = ath10k_htt_connect(&ar->htt);
> +               if (status) {
> +                       ath10k_err(ar, "failed to connect htt (%d)\n", status);
> +                       goto err_hif_stop;
> +               }
>         }
>
>         status = ath10k_wmi_connect(ar);
> @@ -778,11 +806,13 @@ int ath10k_core_start(struct ath10k *ar)
>                 goto err_hif_stop;
>         }
>
> -       status = ath10k_wmi_wait_for_service_ready(ar);
> -       if (status <= 0) {
> -               ath10k_warn(ar, "wmi service ready event not received");
> -               status = -ETIMEDOUT;
> -               goto err_hif_stop;
> +       if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
> +               status = ath10k_wmi_wait_for_service_ready(ar);
> +               if (status <= 0) {
> +                       ath10k_warn(ar, "wmi service ready event not received");
> +                       status = -ETIMEDOUT;
> +                       goto err_hif_stop;
> +               }
>         }
>
>         ath10k_dbg(ar, ATH10K_DBG_BOOT, "firmware %s booted\n",
> @@ -802,10 +832,13 @@ int ath10k_core_start(struct ath10k *ar)
>                 goto err_hif_stop;
>         }
>
> -       status = ath10k_htt_setup(&ar->htt);
> -       if (status) {
> -               ath10k_err(ar, "failed to setup htt: %d\n", status);
> -               goto err_hif_stop;
> +       /* we don't care about HTT in UTF mode */
> +       if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
> +               status = ath10k_htt_setup(&ar->htt);
> +               if (status) {
> +                       ath10k_err(ar, "failed to setup htt: %d\n", status);
> +                       goto err_hif_stop;
> +               }
>         }
>
>         status = ath10k_debug_start(ar);
> @@ -861,7 +894,8 @@ void ath10k_core_stop(struct ath10k *ar)
>         lockdep_assert_held(&ar->conf_mutex);
>
>         /* try to suspend target */
> -       if (ar->state != ATH10K_STATE_RESTARTING)
> +       if (ar->state != ATH10K_STATE_RESTARTING &&
> +           ar->state != ATH10K_STATE_UTF)
>                 ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
>
>         ath10k_debug_stop(ar);
> @@ -914,7 +948,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
>
>         mutex_lock(&ar->conf_mutex);
>
> -       ret = ath10k_core_start(ar);
> +       ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL);
>         if (ret) {
>                 ath10k_err(ar, "could not init core (%d)\n", ret);
>                 ath10k_core_free_firmware_files(ar);
> @@ -1041,6 +1075,8 @@ void ath10k_core_unregister(struct ath10k *ar)
>          * unhappy about callback failures. */
>         ath10k_mac_unregister(ar);
>
> +       ath10k_testmode_destroy(ar);
> +
>         ath10k_core_free_firmware_files(ar);
>
>         ath10k_debug_destroy(ar);
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 4ef476099225..e31df4939b16 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -330,6 +330,17 @@ enum ath10k_state {
>          * prevents completion timeouts and makes the driver more responsive to
>          * userspace commands. This is also prevents recursive recovery. */
>         ATH10K_STATE_WEDGED,
> +
> +       /* factory tests */
> +       ATH10K_STATE_UTF,
> +};
> +
> +enum ath10k_firmware_mode {
> +       /* the default mode, standard 802.11 functionality */
> +       ATH10K_FIRMWARE_MODE_NORMAL,
> +
> +       /* factory tests etc */
> +       ATH10K_FIRMWARE_MODE_UTF,
>  };
>
>  enum ath10k_fw_features {
> @@ -544,6 +555,15 @@ struct ath10k {
>                 struct ath10k_spec_scan config;
>         } spectral;
>
> +       struct {
> +               /* protected by conf_mutex */
> +               const struct firmware *utf;
> +               DECLARE_BITMAP(orig_fw_features, ATH10K_FW_FEATURE_COUNT);
> +
> +               /* protected by data_lock */
> +               bool utf_monitor;
> +       } testmode;
> +
>         /* must be last */
>         u8 drv_priv[0] __aligned(sizeof(void *));
>  };
> @@ -552,7 +572,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
>                                   const struct ath10k_hif_ops *hif_ops);
>  void ath10k_core_destroy(struct ath10k *ar);
>
> -int ath10k_core_start(struct ath10k *ar);
> +int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode);
>  int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
>  void ath10k_core_stop(struct ath10k *ar);
>  int ath10k_core_register(struct ath10k *ar, u32 chip_id);
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index f3f0a80f8bab..928f8b795827 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -134,11 +134,12 @@ void ath10k_print_driver_info(struct ath10k *ar)
>                     ar->fw_api,
>                     ar->htt.target_version_major,
>                     ar->htt.target_version_minor);
> -       ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d\n",
> +       ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",
>                     config_enabled(CONFIG_ATH10K_DEBUG),
>                     config_enabled(CONFIG_ATH10K_DEBUGFS),
>                     config_enabled(CONFIG_ATH10K_TRACING),
> -                   config_enabled(CONFIG_ATH10K_DFS_CERTIFIED));
> +                   config_enabled(CONFIG_ATH10K_DFS_CERTIFIED),
> +                   config_enabled(CONFIG_NL80211_TESTMODE));
>  }
>  EXPORT_SYMBOL(ath10k_print_driver_info);
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
> index 56746539bea2..fdc8ba23301a 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -34,6 +34,7 @@ enum ath10k_debug_mask {
>         ATH10K_DBG_DATA         = 0x00000200,
>         ATH10K_DBG_BMI          = 0x00000400,
>         ATH10K_DBG_REGULATORY   = 0x00000800,
> +       ATH10K_DBG_TESTMODE     = 0x00001000,
>         ATH10K_DBG_ANY          = 0xffffffff,
>  };
>
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index 13568b01de9f..3cf5702c1e7e 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -36,6 +36,8 @@
>  #define ATH10K_FW_API2_FILE            "firmware-2.bin"
>  #define ATH10K_FW_API3_FILE            "firmware-3.bin"
>
> +#define ATH10K_FW_UTF_FILE             "utf.bin"
> +
>  /* includes also the null byte */
>  #define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index b858c8288196..d0efeeb200fd 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -26,6 +26,7 @@
>  #include "wmi.h"
>  #include "htt.h"
>  #include "txrx.h"
> +#include "testmode.h"
>
>  /**********/
>  /* Crypto */
> @@ -2483,8 +2484,12 @@ static int ath10k_start(struct ieee80211_hw *hw)
>         case ATH10K_STATE_RESTARTED:
>         case ATH10K_STATE_WEDGED:
>                 WARN_ON(1);
> +               /* fall through */

Fall through? I see there's a goto ahead..
>                 ret = -EINVAL;
>                 goto err;

> +       case ATH10K_STATE_UTF:
> +               ret = -EBUSY;
> +               goto err;
>         }
>
>         ret = ath10k_hif_power_up(ar);
> @@ -2493,7 +2498,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
>                 goto err_off;
>         }
>
> -       ret = ath10k_core_start(ar);
> +       ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL);
>         if (ret) {
>                 ath10k_err(ar, "Could not init core: %d\n", ret);
>                 goto err_power_down;
> @@ -4472,6 +4477,9 @@ static const struct ieee80211_ops ath10k_ops = {
>         .sta_rc_update                  = ath10k_sta_rc_update,
>         .get_tsf                        = ath10k_get_tsf,
>         .ampdu_action                   = ath10k_ampdu_action,
> +
> +       CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
> +
>  #ifdef CONFIG_PM
>         .suspend                        = ath10k_suspend,
>         .resume                         = ath10k_resume,
> diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
> new file mode 100644
> index 000000000000..e07bdb76174b
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/testmode.c
> @@ -0,0 +1,404 @@
> +/*
> + * Copyright (c) 2014 Qualcomm Atheros, Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#include "testmode.h"
> +
> +#include <net/netlink.h>
> +#include <linux/firmware.h>
> +
> +#include "debug.h"
> +#include "wmi.h"
> +#include "hif.h"
> +#include "hw.h"
> +
> +/* "API" level of the ath10k testmode interface. Bump it after every
> + * incompatible interface change. */

I recall we reached a conclusion to use the following multiline
comment style in ath10k:

/* Foo
 * Bar
 */

Ah, here it is: http://www.spinics.net/lists/linux-wireless/msg123419.html

But this isn't really important.


> +static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
> +{
> +       char filename[100];
> +       int ret;
> +
> +       ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode cmd utf start\n");
> +
> +       mutex_lock(&ar->conf_mutex);
> +
> +       if (ar->state == ATH10K_STATE_UTF) {
> +               ret = -EALREADY;
> +               goto out;
> +       }
> +
> +       /* start utf only when the driver is not in use  */
> +       if (ar->state != ATH10K_STATE_OFF) {
> +               ret = -EBUSY;
> +               goto out;
> +       }
> +
> +       if (ar->testmode.utf != NULL)
> +               /* utf image is already downloaded */
> +               goto power_up;
> +
> +

2 empty newlines.


> +       snprintf(filename, sizeof(filename), "%s/%s",
> +                ar->hw_params.fw.dir, ATH10K_FW_UTF_FILE);
> +
> +       /* load utf image now and release only when the device is removed */
> +       ret = request_firmware(&ar->testmode.utf, filename, ar->dev);
> +       if (ret) {
> +               ath10k_warn(ar, "failed to retrieve utf firmware '%s': %d\n",
> +                           filename, ret);
> +               goto out;
> +       }
> +
> +       BUILD_BUG_ON(sizeof(ar->fw_features) !=
> +                    sizeof(ar->testmode.orig_fw_features));
> +

> +       memcpy(ar->testmode.orig_fw_features, ar->fw_features,
> +              sizeof(ar->fw_features));
> +
> +       /* force to use correct version of WMI interface */
> +       memset(ar->fw_features, 0, sizeof(ar->fw_features));
> +       __set_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features);

I'm a little worried about this.

First of all the comment doesn't really explain why this is done, i.e.
utf.bin isn't FW IE encapsulated and as such fw_features are unknown.

And then what about utf binaries which use 10.2 WMI? Or non-10.x WMI?


> +
> +power_up:
> +       spin_lock_bh(&ar->data_lock);
> +
> +       ar->testmode.utf_monitor = true;
> +
> +       spin_unlock_bh(&ar->data_lock);
> +
> +       ret = ath10k_hif_power_up(ar);
> +       if (ret) {
> +               ath10k_err(ar, "failed to power up hif (testmode): %d\n", ret);
> +               ar->state = ATH10K_STATE_OFF;
> +               goto out;
> +       }
> +
> +       ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_UTF);
> +       if (ret) {
> +               ath10k_err(ar, "failed to start core (testmode): %d\n", ret);
> +               ath10k_hif_power_down(ar);
> +               ar->state = ATH10K_STATE_OFF;
> +               goto out;
> +       }

You don't seem to be freeing firmware on failure here. I'm aware
ath10k_testmode_destroy() takes care of it but if you happen to use a
defect fw (or hit some kind of a fw-hw combination bug) each
subsequent utf start will re-use the firmware binary - it won't
re-read the binary (giving you a chance to replace utf binary with a
different one) unless you reload the whole module or re-bind the
device<->driver via sysfs or physically.


> +static int ath10k_tm_cmd_utf_stop(struct ath10k *ar, struct nlattr *tb[])
> +{
> +       int ret;
> +
> +       ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode cmd utf stop\n");
> +
> +       mutex_lock(&ar->conf_mutex);
> +
> +       if (ar->state != ATH10K_STATE_UTF) {
> +               ret = -ENETDOWN;
> +               goto out;
> +       }
[...]
> +static int ath10k_tm_cmd_wmi(struct ath10k *ar, struct nlattr *tb[])
> +{
> +       struct sk_buff *skb;
> +       int ret, buf_len;
> +       u32 cmd_id;
> +       void *buf;
> +
> +       mutex_lock(&ar->conf_mutex);
> +
> +       if (ar->state != ATH10K_STATE_UTF) {
> +               ret = EHOSTDOWN;

Shouldn't this be a negative number?

Also ath10k_tm_cmd_utf_stop() uses -ENETDOWN for this case.


Michał
