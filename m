Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54238 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3IZWZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 18:25:20 -0400
Received: by mail-vc0-f175.google.com with SMTP id ia10so1310472vcb.20
        for <linux-wireless@vger.kernel.org>; Thu, 26 Sep 2013 15:25:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380234106-12802-1-git-send-email-k.eugene.e@gmail.com>
References: <1380234106-12802-1-git-send-email-k.eugene.e@gmail.com>
Date: Thu, 26 Sep 2013 23:25:18 +0100
Message-ID: <CAFSJ42bybEGtkzJ99fZHrcPs=gTnvJVHxM7d8anJvn1VOs7V7A@mail.gmail.com> (sfid-20130927_002527_185686_601E4FEA)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the latest version of wcn36xx driver on top of current
wireless-next tree. Please let me know if you have any problems with
applying it.

2013/9/26 Eugene Krasnikov <k.eugene.e@gmail.com>:
> This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
> far WCN3660/WCN3680 is available only on MSM platform.
>
> Firmware can be found here:
> https://www.codeaurora.org/cgit/external/hisense/platform/vendor/qcom-opensource/wlan/prima/tree/firmware_bin?h=8130_CS
>
> Wiki page is available here:
> http://wireless.kernel.org/en/users/Drivers/wcn36xx
>
> A lot people made a contribution to this driver. Here is the list in
> alphabetical order:
>
> Eugene Krasnikov <k.eugene.e@gmail.com>
> Kalle Valo <kvalo@qca.qualcomm.com>
> Olof Johansson <dev@skyshaper.net>
> Pontus Fuchs <pontus.fuchs@gmail.com>
> Yanbo Li <yanbol@qti.qualcomm.com>
>
> Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
> ---
>  MAINTAINERS                                |    8 +
>  drivers/net/wireless/ath/Kconfig           |    1 +
>  drivers/net/wireless/ath/Makefile          |    1 +
>  drivers/net/wireless/ath/wcn36xx/Kconfig   |   16 +
>  drivers/net/wireless/ath/wcn36xx/Makefile  |    7 +
>  drivers/net/wireless/ath/wcn36xx/debug.c   |  188 ++
>  drivers/net/wireless/ath/wcn36xx/debug.h   |   49 +
>  drivers/net/wireless/ath/wcn36xx/dxe.c     |  805 +++++
>  drivers/net/wireless/ath/wcn36xx/dxe.h     |  284 ++
>  drivers/net/wireless/ath/wcn36xx/hal.h     | 4657 ++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/wcn36xx/main.c    | 1036 +++++++
>  drivers/net/wireless/ath/wcn36xx/pmc.c     |   62 +
>  drivers/net/wireless/ath/wcn36xx/pmc.h     |   33 +
>  drivers/net/wireless/ath/wcn36xx/smd.c     | 2121 +++++++++++++
>  drivers/net/wireless/ath/wcn36xx/smd.h     |  127 +
>  drivers/net/wireless/ath/wcn36xx/txrx.c    |  284 ++
>  drivers/net/wireless/ath/wcn36xx/txrx.h    |  160 +
>  drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  238 ++
>  18 files changed, 10077 insertions(+)
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/Kconfig
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/Makefile
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/debug.c
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/debug.h
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/dxe.c
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/dxe.h
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/hal.h
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/main.c
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.c
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.h
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/smd.c
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/smd.h
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/txrx.c
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/txrx.h
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/wcn36xx.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 705bb96..5cf566d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6745,6 +6745,14 @@ L:       linux-hexagon@vger.kernel.org
>  S:     Supported
>  F:     arch/hexagon/
>
> +QUALCOMM WCN36XX WIRELESS DRIVER
> +M:     Eugene Krasnikov <k.eugene.e@gmail.com>
> +L:     wcn36xx@lists.infradead.org
> +W:     http://wireless.kernel.org/en/users/Drivers/wcn36xx
> +T:     git git://github.com/KrasnikovEugene/wcn36xx.git
> +S:     Supported
> +F:     drivers/net/wireless/ath/wcn36xx/
> +
>  QUICKCAM PARALLEL PORT WEBCAMS
>  M:     Hans Verkuil <hverkuil@xs4all.nl>
>  L:     linux-media@vger.kernel.org
> diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
> index 1abf1d4..ba81d62 100644
> --- a/drivers/net/wireless/ath/Kconfig
> +++ b/drivers/net/wireless/ath/Kconfig
> @@ -32,5 +32,6 @@ source "drivers/net/wireless/ath/ath6kl/Kconfig"
>  source "drivers/net/wireless/ath/ar5523/Kconfig"
>  source "drivers/net/wireless/ath/wil6210/Kconfig"
>  source "drivers/net/wireless/ath/ath10k/Kconfig"
> +source "drivers/net/wireless/ath/wcn36xx/Kconfig"
>
>  endif
> diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
> index fb05cfd..363b056 100644
> --- a/drivers/net/wireless/ath/Makefile
> +++ b/drivers/net/wireless/ath/Makefile
> @@ -5,6 +5,7 @@ obj-$(CONFIG_ATH6KL)            += ath6kl/
>  obj-$(CONFIG_AR5523)           += ar5523/
>  obj-$(CONFIG_WIL6210)          += wil6210/
>  obj-$(CONFIG_ATH10K)           += ath10k/
> +obj-$(CONFIG_WCN36XX)          += wcn36xx/
>
>  obj-$(CONFIG_ATH_COMMON)       += ath.o
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/Kconfig b/drivers/net/wireless/ath/wcn36xx/Kconfig
> new file mode 100644
> index 0000000..591ebae
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/Kconfig
> @@ -0,0 +1,16 @@
> +config WCN36XX
> +       tristate "Qualcomm Atheros WCN3660/3680 support"
> +       depends on MAC80211 && HAS_DMA
> +       ---help---
> +         This module adds support for wireless adapters based on
> +         Qualcomm Atheros WCN3660 and WCN3680 mobile chipsets.
> +
> +         If you choose to build a module, it'll be called wcn36xx.
> +
> +config WCN36XX_DEBUGFS
> +       bool "WCN36XX debugfs support"
> +       depends on WCN36XX
> +       ---help---
> +         Enabled debugfs support
> +
> +         If unsure, say Y to make it easier to debug problems.
> diff --git a/drivers/net/wireless/ath/wcn36xx/Makefile b/drivers/net/wireless/ath/wcn36xx/Makefile
> new file mode 100644
> index 0000000..50c43b4
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/Makefile
> @@ -0,0 +1,7 @@
> +obj-$(CONFIG_WCN36XX) := wcn36xx.o
> +wcn36xx-y +=   main.o \
> +               dxe.o \
> +               txrx.o \
> +               smd.o \
> +               pmc.o \
> +               debug.o
> diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
> new file mode 100644
> index 0000000..682bcd6
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/debug.c
> @@ -0,0 +1,188 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/debugfs.h>
> +#include <linux/uaccess.h>
> +#include "wcn36xx.h"
> +#include "debug.h"
> +#include "pmc.h"
> +
> +#ifdef CONFIG_WCN36XX_DEBUGFS
> +
> +static int wcn36xx_debugfs_open(struct inode *inode, struct file *file)
> +{
> +       file->private_data = inode->i_private;
> +
> +       return 0;
> +}
> +
> +static ssize_t read_file_bool_bmps(struct file *file, char __user *user_buf,
> +                                  size_t count, loff_t *ppos)
> +{
> +       struct wcn36xx *wcn = file->private_data;
> +       struct wcn36xx_vif *vif_priv = NULL;
> +       struct ieee80211_vif *vif = NULL;
> +       char buf[3];
> +
> +       list_for_each_entry(vif_priv, &wcn->vif_list, list) {
> +                       vif = container_of((void *)vif_priv,
> +                                  struct ieee80211_vif,
> +                                  drv_priv);
> +                       if (NL80211_IFTYPE_STATION == vif->type) {
> +                               if (vif_priv->pw_state == WCN36XX_BMPS)
> +                                       buf[0] = '1';
> +                               else
> +                                       buf[0] = '0';
> +                               break;
> +                       }
> +       }
> +       buf[1] = '\n';
> +       buf[2] = 0x00;
> +
> +       return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
> +}
> +
> +static ssize_t write_file_bool_bmps(struct file *file,
> +                                   const char __user *user_buf,
> +                                   size_t count, loff_t *ppos)
> +{
> +       struct wcn36xx *wcn = file->private_data;
> +       struct wcn36xx_vif *vif_priv = NULL;
> +       struct ieee80211_vif *vif = NULL;
> +
> +       char buf[32];
> +       int buf_size;
> +
> +       buf_size = min(count, (sizeof(buf)-1));
> +       if (copy_from_user(buf, user_buf, buf_size))
> +               return -EFAULT;
> +
> +       switch (buf[0]) {
> +       case 'y':
> +       case 'Y':
> +       case '1':
> +               list_for_each_entry(vif_priv, &wcn->vif_list, list) {
> +                       vif = container_of((void *)vif_priv,
> +                                  struct ieee80211_vif,
> +                                  drv_priv);
> +                       if (NL80211_IFTYPE_STATION == vif->type) {
> +                               wcn36xx_enable_keep_alive_null_packet(wcn, vif);
> +                               wcn36xx_pmc_enter_bmps_state(wcn, vif);
> +                       }
> +               }
> +               break;
> +       case 'n':
> +       case 'N':
> +       case '0':
> +               list_for_each_entry(vif_priv, &wcn->vif_list, list) {
> +                       vif = container_of((void *)vif_priv,
> +                                  struct ieee80211_vif,
> +                                  drv_priv);
> +                       if (NL80211_IFTYPE_STATION == vif->type)
> +                               wcn36xx_pmc_exit_bmps_state(wcn, vif);
> +               }
> +               break;
> +       }
> +
> +       return count;
> +}
> +
> +static const struct file_operations fops_wcn36xx_bmps = {
> +       .open  =       wcn36xx_debugfs_open,
> +       .read  =       read_file_bool_bmps,
> +       .write =       write_file_bool_bmps,
> +};
> +
> +static ssize_t write_file_dump(struct file *file,
> +                                   const char __user *user_buf,
> +                                   size_t count, loff_t *ppos)
> +{
> +       struct wcn36xx *wcn = file->private_data;
> +       char buf[255], *tmp;
> +       int buf_size;
> +       u32 arg[WCN36xx_MAX_DUMP_ARGS];
> +       int i;
> +
> +       memset(buf, 0, sizeof(buf));
> +       memset(arg, 0, sizeof(arg));
> +
> +       buf_size = min(count, (sizeof(buf) - 1));
> +       if (copy_from_user(buf, user_buf, buf_size))
> +               return -EFAULT;
> +
> +       tmp = buf;
> +
> +       for (i = 0; i < WCN36xx_MAX_DUMP_ARGS; i++) {
> +               char *begin;
> +               begin = strsep(&tmp, " ");
> +               if (begin == NULL)
> +                       break;
> +
> +               if (kstrtoul(begin, 0, (unsigned long *)(arg + i)) != 0)
> +                       break;
> +       }
> +
> +       wcn36xx_info("DUMP args is %d %d %d %d %d\n", arg[0], arg[1], arg[2],
> +                    arg[3], arg[4]);
> +       wcn36xx_smd_dump_cmd_req(wcn, arg[0], arg[1], arg[2], arg[3], arg[4]);
> +
> +       return count;
> +}
> +
> +static const struct file_operations fops_wcn36xx_dump = {
> +       .open  =       wcn36xx_debugfs_open,
> +       .write =       write_file_dump,
> +};
> +
> +#define ADD_FILE(name, mode, fop, priv_data)           \
> +       do {                                                    \
> +               struct dentry *d;                               \
> +               d = debugfs_create_file(__stringify(name),      \
> +                                       mode, dfs->rootdir,     \
> +                                       priv_data, fop);        \
> +               dfs->file_##name.dentry = d;                    \
> +               if (IS_ERR(d)) {                                \
> +                       wcn36xx_warn("Create the debugfs entry failed");\
> +                       dfs->file_##name.dentry = NULL;         \
> +               }                                               \
> +       } while (0)
> +
> +
> +void wcn36xx_debugfs_init(struct wcn36xx *wcn)
> +{
> +       struct wcn36xx_dfs_entry *dfs = &wcn->dfs;
> +
> +       dfs->rootdir = debugfs_create_dir(KBUILD_MODNAME,
> +                                         wcn->hw->wiphy->debugfsdir);
> +       if (IS_ERR(dfs->rootdir)) {
> +               wcn36xx_warn("Create the debugfs failed\n");
> +               dfs->rootdir = NULL;
> +       }
> +
> +       ADD_FILE(bmps_switcher, S_IRUSR | S_IWUSR,
> +                &fops_wcn36xx_bmps, wcn);
> +       ADD_FILE(dump, S_IWUSR, &fops_wcn36xx_dump, wcn);
> +}
> +
> +void wcn36xx_debugfs_exit(struct wcn36xx *wcn)
> +{
> +       struct wcn36xx_dfs_entry *dfs = &wcn->dfs;
> +       debugfs_remove_recursive(dfs->rootdir);
> +}
> +
> +#endif /* CONFIG_WCN36XX_DEBUGFS */
> diff --git a/drivers/net/wireless/ath/wcn36xx/debug.h b/drivers/net/wireless/ath/wcn36xx/debug.h
> new file mode 100644
> index 0000000..46307aa
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/debug.h
> @@ -0,0 +1,49 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#ifndef _WCN36XX_DEBUG_H_
> +#define _WCN36XX_DEBUG_H_
> +
> +#include <linux/kernel.h>
> +
> +#define WCN36xx_MAX_DUMP_ARGS  5
> +
> +#ifdef CONFIG_WCN36XX_DEBUGFS
> +struct wcn36xx_dfs_file {
> +       struct dentry *dentry;
> +       u32 value;
> +};
> +
> +struct wcn36xx_dfs_entry {
> +       struct dentry *rootdir;
> +       struct wcn36xx_dfs_file file_bmps_switcher;
> +       struct wcn36xx_dfs_file file_dump;
> +};
> +
> +void wcn36xx_debugfs_init(struct wcn36xx *wcn);
> +void wcn36xx_debugfs_exit(struct wcn36xx *wcn);
> +
> +#else
> +static inline void wcn36xx_debugfs_init(struct wcn36xx *wcn)
> +{
> +}
> +static inline void wcn36xx_debugfs_exit(struct wcn36xx *wcn)
> +{
> +}
> +
> +#endif /* CONFIG_WCN36XX_DEBUGFS */
> +
> +#endif /* _WCN36XX_DEBUG_H_ */
> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
> new file mode 100644
> index 0000000..ee25786
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
> @@ -0,0 +1,805 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +/* DXE - DMA transfer engine
> + * we have 2 channels(High prio and Low prio) for TX and 2 channels for RX.
> + * through low channels data packets are transfered
> + * through high channels managment packets are transfered
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/interrupt.h>
> +#include "wcn36xx.h"
> +#include "txrx.h"
> +
> +void *wcn36xx_dxe_get_next_bd(struct wcn36xx *wcn, bool is_low)
> +{
> +       struct wcn36xx_dxe_ch *ch = is_low ?
> +               &wcn->dxe_tx_l_ch :
> +               &wcn->dxe_tx_h_ch;
> +
> +       return ch->head_blk_ctl->bd_cpu_addr;
> +}
> +
> +static void wcn36xx_dxe_write_register(struct wcn36xx *wcn, int addr, int data)
> +{
> +       wcn36xx_dbg(WCN36XX_DBG_DXE,
> +                   "wcn36xx_dxe_write_register: addr=%x, data=%x\n",
> +                   addr, data);
> +
> +       writel(data, wcn->mmio + addr);
> +}
> +
> +static void wcn36xx_dxe_read_register(struct wcn36xx *wcn, int addr, int *data)
> +{
> +       *data = readl(wcn->mmio + addr);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_DXE,
> +                   "wcn36xx_dxe_read_register: addr=%x, data=%x\n",
> +                   addr, *data);
> +}
> +
> +static void wcn36xx_dxe_free_ctl_block(struct wcn36xx_dxe_ch *ch)
> +{
> +       struct wcn36xx_dxe_ctl *ctl = ch->head_blk_ctl, *next;
> +       int i;
> +
> +       for (i = 0; i < ch->desc_num && ctl; i++) {
> +               next = ctl->next;
> +               kfree(ctl);
> +               ctl = next;
> +       }
> +}
> +
> +static int wcn36xx_dxe_allocate_ctl_block(struct wcn36xx_dxe_ch *ch)
> +{
> +       struct wcn36xx_dxe_ctl *prev_ctl = NULL;
> +       struct wcn36xx_dxe_ctl *cur_ctl = NULL;
> +       int i;
> +
> +       for (i = 0; i < ch->desc_num; i++) {
> +               cur_ctl = kzalloc(sizeof(*cur_ctl), GFP_KERNEL);
> +               if (!cur_ctl)
> +                       goto out_fail;
> +
> +               cur_ctl->ctl_blk_order = i;
> +               if (i == 0) {
> +                       ch->head_blk_ctl = cur_ctl;
> +                       ch->tail_blk_ctl = cur_ctl;
> +               } else if (ch->desc_num - 1 == i) {
> +                       prev_ctl->next = cur_ctl;
> +                       cur_ctl->next = ch->head_blk_ctl;
> +               } else {
> +                       prev_ctl->next = cur_ctl;
> +               }
> +               prev_ctl = cur_ctl;
> +       }
> +
> +       return 0;
> +
> +out_fail:
> +       wcn36xx_dxe_free_ctl_block(ch);
> +       return -ENOMEM;
> +}
> +
> +int wcn36xx_dxe_alloc_ctl_blks(struct wcn36xx *wcn)
> +{
> +       int ret;
> +
> +       wcn->dxe_tx_l_ch.ch_type = WCN36XX_DXE_CH_TX_L;
> +       wcn->dxe_tx_h_ch.ch_type = WCN36XX_DXE_CH_TX_H;
> +       wcn->dxe_rx_l_ch.ch_type = WCN36XX_DXE_CH_RX_L;
> +       wcn->dxe_rx_h_ch.ch_type = WCN36XX_DXE_CH_RX_H;
> +
> +       wcn->dxe_tx_l_ch.desc_num = WCN36XX_DXE_CH_DESC_NUMB_TX_L;
> +       wcn->dxe_tx_h_ch.desc_num = WCN36XX_DXE_CH_DESC_NUMB_TX_H;
> +       wcn->dxe_rx_l_ch.desc_num = WCN36XX_DXE_CH_DESC_NUMB_RX_L;
> +       wcn->dxe_rx_h_ch.desc_num = WCN36XX_DXE_CH_DESC_NUMB_RX_H;
> +
> +       wcn->dxe_tx_l_ch.dxe_wq =  WCN36XX_DXE_WQ_TX_L;
> +       wcn->dxe_tx_h_ch.dxe_wq =  WCN36XX_DXE_WQ_TX_H;
> +
> +       wcn->dxe_tx_l_ch.ctrl_bd = WCN36XX_DXE_CTRL_TX_L_BD;
> +       wcn->dxe_tx_h_ch.ctrl_bd = WCN36XX_DXE_CTRL_TX_H_BD;
> +
> +       wcn->dxe_tx_l_ch.ctrl_skb = WCN36XX_DXE_CTRL_TX_L_SKB;
> +       wcn->dxe_tx_h_ch.ctrl_skb = WCN36XX_DXE_CTRL_TX_H_SKB;
> +
> +       wcn->dxe_tx_l_ch.reg_ctrl = WCN36XX_DXE_REG_CTL_TX_L;
> +       wcn->dxe_tx_h_ch.reg_ctrl = WCN36XX_DXE_REG_CTL_TX_H;
> +
> +       wcn->dxe_tx_l_ch.def_ctrl = WCN36XX_DXE_CH_DEFAULT_CTL_TX_L;
> +       wcn->dxe_tx_h_ch.def_ctrl = WCN36XX_DXE_CH_DEFAULT_CTL_TX_H;
> +
> +       /* DXE control block allocation */
> +       ret = wcn36xx_dxe_allocate_ctl_block(&wcn->dxe_tx_l_ch);
> +       if (ret)
> +               goto out_err;
> +       ret = wcn36xx_dxe_allocate_ctl_block(&wcn->dxe_tx_h_ch);
> +       if (ret)
> +               goto out_err;
> +       ret = wcn36xx_dxe_allocate_ctl_block(&wcn->dxe_rx_l_ch);
> +       if (ret)
> +               goto out_err;
> +       ret = wcn36xx_dxe_allocate_ctl_block(&wcn->dxe_rx_h_ch);
> +       if (ret)
> +               goto out_err;
> +
> +       /* Initialize SMSM state  Clear TX Enable RING EMPTY STATE */
> +       ret = wcn->ctrl_ops->smsm_change_state(
> +               WCN36XX_SMSM_WLAN_TX_ENABLE,
> +               WCN36XX_SMSM_WLAN_TX_RINGS_EMPTY);
> +
> +       return 0;
> +
> +out_err:
> +       wcn36xx_err("Failed to allocate DXE control blocks\n");
> +       wcn36xx_dxe_free_ctl_blks(wcn);
> +       return -ENOMEM;
> +}
> +
> +void wcn36xx_dxe_free_ctl_blks(struct wcn36xx *wcn)
> +{
> +       wcn36xx_dxe_free_ctl_block(&wcn->dxe_tx_l_ch);
> +       wcn36xx_dxe_free_ctl_block(&wcn->dxe_tx_h_ch);
> +       wcn36xx_dxe_free_ctl_block(&wcn->dxe_rx_l_ch);
> +       wcn36xx_dxe_free_ctl_block(&wcn->dxe_rx_h_ch);
> +}
> +
> +static int wcn36xx_dxe_init_descs(struct wcn36xx_dxe_ch *wcn_ch)
> +{
> +       struct wcn36xx_dxe_desc *cur_dxe = NULL;
> +       struct wcn36xx_dxe_desc *prev_dxe = NULL;
> +       struct wcn36xx_dxe_ctl *cur_ctl = NULL;
> +       size_t size;
> +       int i;
> +
> +       size = wcn_ch->desc_num * sizeof(struct wcn36xx_dxe_desc);
> +       wcn_ch->cpu_addr = dma_alloc_coherent(NULL, size, &wcn_ch->dma_addr,
> +                                             GFP_KERNEL);
> +       if (!wcn_ch->cpu_addr)
> +               return -ENOMEM;
> +
> +       memset(wcn_ch->cpu_addr, 0, size);
> +
> +       cur_dxe = (struct wcn36xx_dxe_desc *)wcn_ch->cpu_addr;
> +       cur_ctl = wcn_ch->head_blk_ctl;
> +
> +       for (i = 0; i < wcn_ch->desc_num; i++) {
> +               cur_ctl->desc = cur_dxe;
> +               cur_ctl->desc_phy_addr = wcn_ch->dma_addr +
> +                       i * sizeof(struct wcn36xx_dxe_desc);
> +
> +               switch (wcn_ch->ch_type) {
> +               case WCN36XX_DXE_CH_TX_L:
> +                       cur_dxe->ctrl = WCN36XX_DXE_CTRL_TX_L;
> +                       cur_dxe->dst_addr_l = WCN36XX_DXE_WQ_TX_L;
> +                       break;
> +               case WCN36XX_DXE_CH_TX_H:
> +                       cur_dxe->ctrl = WCN36XX_DXE_CTRL_TX_H;
> +                       cur_dxe->dst_addr_l = WCN36XX_DXE_WQ_TX_H;
> +                       break;
> +               case WCN36XX_DXE_CH_RX_L:
> +                       cur_dxe->ctrl = WCN36XX_DXE_CTRL_RX_L;
> +                       cur_dxe->src_addr_l = WCN36XX_DXE_WQ_RX_L;
> +                       break;
> +               case WCN36XX_DXE_CH_RX_H:
> +                       cur_dxe->ctrl = WCN36XX_DXE_CTRL_RX_H;
> +                       cur_dxe->src_addr_l = WCN36XX_DXE_WQ_RX_H;
> +                       break;
> +               }
> +               if (0 == i) {
> +                       cur_dxe->phy_next_l = 0;
> +               } else if ((0 < i) && (i < wcn_ch->desc_num - 1)) {
> +                       prev_dxe->phy_next_l =
> +                               cur_ctl->desc_phy_addr;
> +               } else if (i == (wcn_ch->desc_num - 1)) {
> +                       prev_dxe->phy_next_l =
> +                               cur_ctl->desc_phy_addr;
> +                       cur_dxe->phy_next_l =
> +                               wcn_ch->head_blk_ctl->desc_phy_addr;
> +               }
> +               cur_ctl = cur_ctl->next;
> +               prev_dxe = cur_dxe;
> +               cur_dxe++;
> +       }
> +
> +       return 0;
> +}
> +
> +static void wcn36xx_dxe_init_tx_bd(struct wcn36xx_dxe_ch *ch,
> +                                  struct wcn36xx_dxe_mem_pool *pool)
> +{
> +       int i, chunk_size = pool->chunk_size;
> +       dma_addr_t bd_phy_addr = pool->phy_addr;
> +       void *bd_cpu_addr = pool->virt_addr;
> +       struct wcn36xx_dxe_ctl *cur = ch->head_blk_ctl;
> +
> +       for (i = 0; i < ch->desc_num; i++) {
> +               /* Only every second dxe needs a bd pointer,
> +                  the other will point to the skb data */
> +               if (!(i & 1)) {
> +                       cur->bd_phy_addr = bd_phy_addr;
> +                       cur->bd_cpu_addr = bd_cpu_addr;
> +                       bd_phy_addr += chunk_size;
> +                       bd_cpu_addr += chunk_size;
> +               } else {
> +                       cur->bd_phy_addr = 0;
> +                       cur->bd_cpu_addr = NULL;
> +               }
> +               cur = cur->next;
> +       }
> +}
> +
> +static int wcn36xx_dxe_enable_ch_int(struct wcn36xx *wcn, u16 wcn_ch)
> +{
> +       int reg_data = 0;
> +
> +       wcn36xx_dxe_read_register(wcn,
> +                                 WCN36XX_DXE_INT_MASK_REG,
> +                                 &reg_data);
> +
> +       reg_data |= wcn_ch;
> +
> +       wcn36xx_dxe_write_register(wcn,
> +                                  WCN36XX_DXE_INT_MASK_REG,
> +                                  (int)reg_data);
> +       return 0;
> +}
> +
> +static int wcn36xx_dxe_fill_skb(struct wcn36xx_dxe_ctl *ctl)
> +{
> +       struct wcn36xx_dxe_desc *dxe = ctl->desc;
> +       struct sk_buff *skb;
> +
> +       skb = alloc_skb(WCN36XX_PKT_SIZE, GFP_ATOMIC);
> +       if (skb == NULL)
> +               return -ENOMEM;
> +
> +       dxe->dst_addr_l = dma_map_single(NULL,
> +                                        skb_tail_pointer(skb),
> +                                        WCN36XX_PKT_SIZE,
> +                                        DMA_FROM_DEVICE);
> +       ctl->skb = skb;
> +
> +       return 0;
> +}
> +
> +static int wcn36xx_dxe_ch_alloc_skb(struct wcn36xx *wcn,
> +                                   struct wcn36xx_dxe_ch *wcn_ch)
> +{
> +       int i;
> +       struct wcn36xx_dxe_ctl *cur_ctl = NULL;
> +
> +       cur_ctl = wcn_ch->head_blk_ctl;
> +
> +       for (i = 0; i < wcn_ch->desc_num; i++) {
> +               wcn36xx_dxe_fill_skb(cur_ctl);
> +               cur_ctl = cur_ctl->next;
> +       }
> +
> +       return 0;
> +}
> +
> +static void wcn36xx_dxe_ch_free_skbs(struct wcn36xx *wcn,
> +                                    struct wcn36xx_dxe_ch *wcn_ch)
> +{
> +       struct wcn36xx_dxe_ctl *cur = wcn_ch->head_blk_ctl;
> +       int i;
> +
> +       for (i = 0; i < wcn_ch->desc_num; i++) {
> +               kfree_skb(cur->skb);
> +               cur = cur->next;
> +       }
> +}
> +
> +void wcn36xx_dxe_tx_ack_ind(struct wcn36xx *wcn, u32 status)
> +{
> +       struct ieee80211_tx_info *info;
> +       struct sk_buff *skb;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&wcn->dxe_lock, flags);
> +       skb = wcn->tx_ack_skb;
> +       wcn->tx_ack_skb = NULL;
> +       spin_unlock_irqrestore(&wcn->dxe_lock, flags);
> +
> +       if (!skb) {
> +               wcn36xx_warn("Spurious TX complete indication\n");
> +               return;
> +       }
> +
> +       info = IEEE80211_SKB_CB(skb);
> +
> +       if (status == 1)
> +               info->flags |= IEEE80211_TX_STAT_ACK;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_DXE, "dxe tx ack status: %d\n", status);
> +
> +       ieee80211_tx_status_irqsafe(wcn->hw, skb);
> +       ieee80211_wake_queues(wcn->hw);
> +}
> +
> +static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
> +{
> +       struct wcn36xx_dxe_ctl *ctl = ch->tail_blk_ctl;
> +       struct ieee80211_tx_info *info;
> +       unsigned long flags;
> +
> +       /*
> +        * Make at least one loop of do-while because in case ring is
> +        * completely full head and tail are pointing to the same element
> +        * and while-do will not make any cycles.
> +        */
> +       do {
> +               if (ctl->skb) {
> +                       dma_unmap_single(NULL, ctl->desc->src_addr_l,
> +                                        ctl->skb->len, DMA_TO_DEVICE);
> +                       info = IEEE80211_SKB_CB(ctl->skb);
> +                       if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
> +                               /* Keep frame until TX status comes */
> +                               ieee80211_free_txskb(wcn->hw, ctl->skb);
> +                       }
> +                       spin_lock_irqsave(&ctl->skb_lock, flags);
> +                       if (wcn->queues_stopped) {
> +                               wcn->queues_stopped = false;
> +                               ieee80211_wake_queues(wcn->hw);
> +                       }
> +                       spin_unlock_irqrestore(&ctl->skb_lock, flags);
> +
> +                       ctl->skb = NULL;
> +               }
> +               ctl = ctl->next;
> +       } while (ctl != ch->head_blk_ctl &&
> +              !(ctl->desc->ctrl & WCN36XX_DXE_CTRL_VALID_MASK));
> +
> +       ch->tail_blk_ctl = ctl;
> +}
> +
> +static irqreturn_t wcn36xx_irq_tx_complete(int irq, void *dev)
> +{
> +       struct wcn36xx *wcn = (struct wcn36xx *)dev;
> +       int int_src, int_reason;
> +
> +       wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_INT_SRC_RAW_REG, &int_src);
> +
> +       if (int_src & WCN36XX_INT_MASK_CHAN_TX_H) {
> +               wcn36xx_dxe_read_register(wcn,
> +                                         WCN36XX_DXE_CH_STATUS_REG_ADDR_TX_H,
> +                                         &int_reason);
> +
> +               /* TODO: Check int_reason */
> +
> +               wcn36xx_dxe_write_register(wcn,
> +                                          WCN36XX_DXE_0_INT_CLR,
> +                                          WCN36XX_INT_MASK_CHAN_TX_H);
> +
> +               wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_0_INT_ED_CLR,
> +                                          WCN36XX_INT_MASK_CHAN_TX_H);
> +               wcn36xx_dbg(WCN36XX_DBG_DXE, "dxe tx ready high\n");
> +               reap_tx_dxes(wcn, &wcn->dxe_tx_h_ch);
> +       }
> +
> +       if (int_src & WCN36XX_INT_MASK_CHAN_TX_L) {
> +               wcn36xx_dxe_read_register(wcn,
> +                                         WCN36XX_DXE_CH_STATUS_REG_ADDR_TX_L,
> +                                         &int_reason);
> +               /* TODO: Check int_reason */
> +
> +               wcn36xx_dxe_write_register(wcn,
> +                                          WCN36XX_DXE_0_INT_CLR,
> +                                          WCN36XX_INT_MASK_CHAN_TX_L);
> +
> +               wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_0_INT_ED_CLR,
> +                                          WCN36XX_INT_MASK_CHAN_TX_L);
> +               wcn36xx_dbg(WCN36XX_DBG_DXE, "dxe tx ready low\n");
> +               reap_tx_dxes(wcn, &wcn->dxe_tx_l_ch);
> +       }
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t wcn36xx_irq_rx_ready(int irq, void *dev)
> +{
> +       struct wcn36xx *wcn = (struct wcn36xx *)dev;
> +
> +       disable_irq_nosync(wcn->rx_irq);
> +       wcn36xx_dxe_rx_frame(wcn);
> +       enable_irq(wcn->rx_irq);
> +       return IRQ_HANDLED;
> +}
> +
> +static int wcn36xx_dxe_request_irqs(struct wcn36xx *wcn)
> +{
> +       int ret;
> +
> +       ret = request_irq(wcn->tx_irq, wcn36xx_irq_tx_complete,
> +                         IRQF_TRIGGER_HIGH, "wcn36xx_tx", wcn);
> +       if (ret) {
> +               wcn36xx_err("failed to alloc tx irq\n");
> +               goto out_err;
> +       }
> +
> +       ret = request_irq(wcn->rx_irq, wcn36xx_irq_rx_ready, IRQF_TRIGGER_HIGH,
> +                         "wcn36xx_rx", wcn);
> +       if (ret) {
> +               wcn36xx_err("failed to alloc rx irq\n");
> +               goto out_txirq;
> +       }
> +
> +       enable_irq_wake(wcn->rx_irq);
> +
> +       return 0;
> +
> +out_txirq:
> +       free_irq(wcn->tx_irq, wcn);
> +out_err:
> +       return ret;
> +
> +}
> +
> +static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
> +                                    struct wcn36xx_dxe_ch *ch)
> +{
> +       struct wcn36xx_dxe_ctl *ctl = ch->head_blk_ctl;
> +       struct wcn36xx_dxe_desc *dxe = ctl->desc;
> +       dma_addr_t  dma_addr;
> +       struct sk_buff *skb;
> +
> +       while (!(dxe->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)) {
> +               skb = ctl->skb;
> +               dma_addr = dxe->dst_addr_l;
> +               wcn36xx_dxe_fill_skb(ctl);
> +
> +               switch (ch->ch_type) {
> +               case WCN36XX_DXE_CH_RX_L:
> +                       dxe->ctrl = WCN36XX_DXE_CTRL_RX_L;
> +                       wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
> +                                                  WCN36XX_DXE_INT_CH1_MASK);
> +                       break;
> +               case WCN36XX_DXE_CH_RX_H:
> +                       dxe->ctrl = WCN36XX_DXE_CTRL_RX_H;
> +                       wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
> +                                                  WCN36XX_DXE_INT_CH3_MASK);
> +                       break;
> +               default:
> +                       wcn36xx_warn("Unknown channel\n");
> +               }
> +
> +               dma_unmap_single(NULL, dma_addr, WCN36XX_PKT_SIZE,
> +                                DMA_FROM_DEVICE);
> +               wcn36xx_rx_skb(wcn, skb);
> +               ctl = ctl->next;
> +               dxe = ctl->desc;
> +       }
> +
> +       ch->head_blk_ctl = ctl;
> +
> +       return 0;
> +}
> +
> +void wcn36xx_dxe_rx_frame(struct wcn36xx *wcn)
> +{
> +       int int_src;
> +
> +       wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_INT_SRC_RAW_REG, &int_src);
> +
> +       /* RX_LOW_PRI */
> +       if (int_src & WCN36XX_DXE_INT_CH1_MASK) {
> +               wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_0_INT_CLR,
> +                                          WCN36XX_DXE_INT_CH1_MASK);
> +               wcn36xx_rx_handle_packets(wcn, &(wcn->dxe_rx_l_ch));
> +       }
> +
> +       /* RX_HIGH_PRI */
> +       if (int_src & WCN36XX_DXE_INT_CH3_MASK) {
> +               /* Clean up all the INT within this channel */
> +               wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_0_INT_CLR,
> +                                          WCN36XX_DXE_INT_CH3_MASK);
> +               wcn36xx_rx_handle_packets(wcn, &(wcn->dxe_rx_h_ch));
> +       }
> +
> +       if (!int_src)
> +               wcn36xx_warn("No DXE interrupt pending\n");
> +}
> +
> +int wcn36xx_dxe_allocate_mem_pools(struct wcn36xx *wcn)
> +{
> +       size_t s;
> +       void *cpu_addr;
> +
> +       /* Allocate BD headers for MGMT frames */
> +
> +       /* Where this come from ask QC */
> +       wcn->mgmt_mem_pool.chunk_size = WCN36XX_BD_CHUNK_SIZE +
> +               16 - (WCN36XX_BD_CHUNK_SIZE % 8);
> +
> +       s = wcn->mgmt_mem_pool.chunk_size * WCN36XX_DXE_CH_DESC_NUMB_TX_H;
> +       cpu_addr = dma_alloc_coherent(NULL, s, &wcn->mgmt_mem_pool.phy_addr,
> +                                     GFP_KERNEL);
> +       if (!cpu_addr)
> +               goto out_err;
> +
> +       wcn->mgmt_mem_pool.virt_addr = cpu_addr;
> +       memset(cpu_addr, 0, s);
> +
> +       /* Allocate BD headers for DATA frames */
> +
> +       /* Where this come from ask QC */
> +       wcn->data_mem_pool.chunk_size = WCN36XX_BD_CHUNK_SIZE +
> +               16 - (WCN36XX_BD_CHUNK_SIZE % 8);
> +
> +       s = wcn->data_mem_pool.chunk_size * WCN36XX_DXE_CH_DESC_NUMB_TX_L;
> +       cpu_addr = dma_alloc_coherent(NULL, s, &wcn->data_mem_pool.phy_addr,
> +                                     GFP_KERNEL);
> +       if (!cpu_addr)
> +               goto out_err;
> +
> +       wcn->data_mem_pool.virt_addr = cpu_addr;
> +       memset(cpu_addr, 0, s);
> +
> +       return 0;
> +
> +out_err:
> +       wcn36xx_dxe_free_mem_pools(wcn);
> +       wcn36xx_err("Failed to allocate BD mempool\n");
> +       return -ENOMEM;
> +}
> +
> +void wcn36xx_dxe_free_mem_pools(struct wcn36xx *wcn)
> +{
> +       if (wcn->mgmt_mem_pool.virt_addr)
> +               dma_free_coherent(NULL, wcn->mgmt_mem_pool.chunk_size *
> +                                 WCN36XX_DXE_CH_DESC_NUMB_TX_H,
> +                                 wcn->mgmt_mem_pool.virt_addr,
> +                                 wcn->mgmt_mem_pool.phy_addr);
> +
> +       if (wcn->data_mem_pool.virt_addr) {
> +               dma_free_coherent(NULL, wcn->data_mem_pool.chunk_size *
> +                                 WCN36XX_DXE_CH_DESC_NUMB_TX_L,
> +                                 wcn->data_mem_pool.virt_addr,
> +                                 wcn->data_mem_pool.phy_addr);
> +       }
> +}
> +
> +int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
> +                        struct wcn36xx_vif *vif_priv,
> +                        struct sk_buff *skb,
> +                        bool is_low)
> +{
> +       struct wcn36xx_dxe_ctl *ctl = NULL;
> +       struct wcn36xx_dxe_desc *desc = NULL;
> +       struct wcn36xx_dxe_ch *ch = NULL;
> +       unsigned long flags;
> +
> +       ch = is_low ? &wcn->dxe_tx_l_ch : &wcn->dxe_tx_h_ch;
> +
> +       ctl = ch->head_blk_ctl;
> +
> +       spin_lock_irqsave(&ctl->next->skb_lock, flags);
> +
> +       /*
> +        * If skb is not null that means that we reached the tail of the ring
> +        * hence ring is full. Stop queues to let mac80211 back off until ring
> +        * has an empty slot again.
> +        */
> +       if (NULL != ctl->next->skb) {
> +               ieee80211_stop_queues(wcn->hw);
> +               wcn->queues_stopped = true;
> +               spin_unlock_irqrestore(&ctl->next->skb_lock, flags);
> +               return -EBUSY;
> +       }
> +       spin_unlock_irqrestore(&ctl->next->skb_lock, flags);
> +
> +       ctl->skb = NULL;
> +       desc = ctl->desc;
> +
> +       /* Set source address of the BD we send */
> +       desc->src_addr_l = ctl->bd_phy_addr;
> +
> +       desc->dst_addr_l = ch->dxe_wq;
> +       desc->fr_len = sizeof(struct wcn36xx_tx_bd);
> +       desc->ctrl = ch->ctrl_bd;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_DXE, "DXE TX\n");
> +
> +       wcn36xx_dbg_dump(WCN36XX_DBG_DXE_DUMP, "DESC1 >>> ",
> +                        (char *)desc, sizeof(*desc));
> +       wcn36xx_dbg_dump(WCN36XX_DBG_DXE_DUMP,
> +                        "BD   >>> ", (char *)ctl->bd_cpu_addr,
> +                        sizeof(struct wcn36xx_tx_bd));
> +
> +       /* Set source address of the SKB we send */
> +       ctl = ctl->next;
> +       ctl->skb = skb;
> +       desc = ctl->desc;
> +       if (ctl->bd_cpu_addr) {
> +               wcn36xx_err("bd_cpu_addr cannot be NULL for skb DXE\n");
> +               return -EINVAL;
> +       }
> +
> +       desc->src_addr_l = dma_map_single(NULL,
> +                                         ctl->skb->data,
> +                                         ctl->skb->len,
> +                                         DMA_TO_DEVICE);
> +
> +       desc->dst_addr_l = ch->dxe_wq;
> +       desc->fr_len = ctl->skb->len;
> +
> +       /* set dxe descriptor to VALID */
> +       desc->ctrl = ch->ctrl_skb;
> +
> +       wcn36xx_dbg_dump(WCN36XX_DBG_DXE_DUMP, "DESC2 >>> ",
> +                        (char *)desc, sizeof(*desc));
> +       wcn36xx_dbg_dump(WCN36XX_DBG_DXE_DUMP, "SKB   >>> ",
> +                        (char *)ctl->skb->data, ctl->skb->len);
> +
> +       /* Move the head of the ring to the next empty descriptor */
> +        ch->head_blk_ctl = ctl->next;
> +
> +       /*
> +        * When connected and trying to send data frame chip can be in sleep
> +        * mode and writing to the register will not wake up the chip. Instead
> +        * notify chip about new frame through SMSM bus.
> +        */
> +       if (is_low &&  vif_priv->pw_state == WCN36XX_BMPS) {
> +               wcn->ctrl_ops->smsm_change_state(
> +                                 0,
> +                                 WCN36XX_SMSM_WLAN_TX_ENABLE);
> +       } else {
> +               /* indicate End Of Packet and generate interrupt on descriptor
> +                * done.
> +                */
> +               wcn36xx_dxe_write_register(wcn,
> +                       ch->reg_ctrl, ch->def_ctrl);
> +       }
> +
> +       return 0;
> +}
> +
> +int wcn36xx_dxe_init(struct wcn36xx *wcn)
> +{
> +       int reg_data = 0, ret;
> +
> +       reg_data = WCN36XX_DXE_REG_RESET;
> +       wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_REG_CSR_RESET, reg_data);
> +
> +       /* Setting interrupt path */
> +       reg_data = WCN36XX_DXE_CCU_INT;
> +       wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_REG_CCU_INT, reg_data);
> +
> +       /***************************************/
> +       /* Init descriptors for TX LOW channel */
> +       /***************************************/
> +       wcn36xx_dxe_init_descs(&wcn->dxe_tx_l_ch);
> +       wcn36xx_dxe_init_tx_bd(&wcn->dxe_tx_l_ch, &wcn->data_mem_pool);
> +
> +       /* Write channel head to a NEXT register */
> +       wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_CH_NEXT_DESC_ADDR_TX_L,
> +               wcn->dxe_tx_l_ch.head_blk_ctl->desc_phy_addr);
> +
> +       /* Program DMA destination addr for TX LOW */
> +       wcn36xx_dxe_write_register(wcn,
> +               WCN36XX_DXE_CH_DEST_ADDR_TX_L,
> +               WCN36XX_DXE_WQ_TX_L);
> +
> +       wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_REG_CH_EN, &reg_data);
> +       wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_TX_L);
> +
> +       /***************************************/
> +       /* Init descriptors for TX HIGH channel */
> +       /***************************************/
> +       wcn36xx_dxe_init_descs(&wcn->dxe_tx_h_ch);
> +       wcn36xx_dxe_init_tx_bd(&wcn->dxe_tx_h_ch, &wcn->mgmt_mem_pool);
> +
> +       /* Write channel head to a NEXT register */
> +       wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_CH_NEXT_DESC_ADDR_TX_H,
> +               wcn->dxe_tx_h_ch.head_blk_ctl->desc_phy_addr);
> +
> +       /* Program DMA destination addr for TX HIGH */
> +       wcn36xx_dxe_write_register(wcn,
> +               WCN36XX_DXE_CH_DEST_ADDR_TX_H,
> +               WCN36XX_DXE_WQ_TX_H);
> +
> +       wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_REG_CH_EN, &reg_data);
> +
> +       /* Enable channel interrupts */
> +       wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_TX_H);
> +
> +       /***************************************/
> +       /* Init descriptors for RX LOW channel */
> +       /***************************************/
> +       wcn36xx_dxe_init_descs(&wcn->dxe_rx_l_ch);
> +
> +       /* For RX we need to preallocated buffers */
> +       wcn36xx_dxe_ch_alloc_skb(wcn, &wcn->dxe_rx_l_ch);
> +
> +       /* Write channel head to a NEXT register */
> +       wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_CH_NEXT_DESC_ADDR_RX_L,
> +               wcn->dxe_rx_l_ch.head_blk_ctl->desc_phy_addr);
> +
> +       /* Write DMA source address */
> +       wcn36xx_dxe_write_register(wcn,
> +               WCN36XX_DXE_CH_SRC_ADDR_RX_L,
> +               WCN36XX_DXE_WQ_RX_L);
> +
> +       /* Program preallocated destination address */
> +       wcn36xx_dxe_write_register(wcn,
> +               WCN36XX_DXE_CH_DEST_ADDR_RX_L,
> +               wcn->dxe_rx_l_ch.head_blk_ctl->desc->phy_next_l);
> +
> +       /* Enable default control registers */
> +       wcn36xx_dxe_write_register(wcn,
> +               WCN36XX_DXE_REG_CTL_RX_L,
> +               WCN36XX_DXE_CH_DEFAULT_CTL_RX_L);
> +
> +       /* Enable channel interrupts */
> +       wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_L);
> +
> +       /***************************************/
> +       /* Init descriptors for RX HIGH channel */
> +       /***************************************/
> +       wcn36xx_dxe_init_descs(&wcn->dxe_rx_h_ch);
> +
> +       /* For RX we need to prealocat buffers */
> +       wcn36xx_dxe_ch_alloc_skb(wcn, &wcn->dxe_rx_h_ch);
> +
> +       /* Write chanel head to a NEXT register */
> +       wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_CH_NEXT_DESC_ADDR_RX_H,
> +               wcn->dxe_rx_h_ch.head_blk_ctl->desc_phy_addr);
> +
> +       /* Write DMA source address */
> +       wcn36xx_dxe_write_register(wcn,
> +               WCN36XX_DXE_CH_SRC_ADDR_RX_H,
> +               WCN36XX_DXE_WQ_RX_H);
> +
> +       /* Program preallocated destination address */
> +       wcn36xx_dxe_write_register(wcn,
> +               WCN36XX_DXE_CH_DEST_ADDR_RX_H,
> +                wcn->dxe_rx_h_ch.head_blk_ctl->desc->phy_next_l);
> +
> +       /* Enable default control registers */
> +       wcn36xx_dxe_write_register(wcn,
> +               WCN36XX_DXE_REG_CTL_RX_H,
> +               WCN36XX_DXE_CH_DEFAULT_CTL_RX_H);
> +
> +       /* Enable channel interrupts */
> +       wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_H);
> +
> +       ret = wcn36xx_dxe_request_irqs(wcn);
> +       if (ret < 0)
> +               goto out_err;
> +
> +       return 0;
> +
> +out_err:
> +       return ret;
> +}
> +
> +void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
> +{
> +       free_irq(wcn->tx_irq, wcn);
> +       free_irq(wcn->rx_irq, wcn);
> +
> +       if (wcn->tx_ack_skb) {
> +               ieee80211_tx_status_irqsafe(wcn->hw, wcn->tx_ack_skb);
> +               wcn->tx_ack_skb = NULL;
> +       }
> +
> +       wcn36xx_dxe_ch_free_skbs(wcn, &wcn->dxe_rx_l_ch);
> +       wcn36xx_dxe_ch_free_skbs(wcn, &wcn->dxe_rx_h_ch);
> +}
> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.h b/drivers/net/wireless/ath/wcn36xx/dxe.h
> new file mode 100644
> index 0000000..c88562f
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.h
> @@ -0,0 +1,284 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#ifndef _DXE_H_
> +#define _DXE_H_
> +
> +#include "wcn36xx.h"
> +
> +/*
> +TX_LOW = DMA0
> +TX_HIGH        = DMA4
> +RX_LOW = DMA1
> +RX_HIGH        = DMA3
> +H2H_TEST_RX_TX = DMA2
> +*/
> +
> +/* DXE registers */
> +#define WCN36XX_DXE_MEM_BASE                   0x03000000
> +#define WCN36XX_DXE_MEM_REG                    0x202000
> +
> +#define WCN36XX_DXE_CCU_INT                    0xA0011
> +#define WCN36XX_DXE_REG_CCU_INT                        0x200b10
> +
> +/* TODO This must calculated properly but not hardcoded */
> +#define WCN36XX_DXE_CTRL_TX_L                  0x328a44
> +#define WCN36XX_DXE_CTRL_TX_H                  0x32ce44
> +#define WCN36XX_DXE_CTRL_RX_L                  0x12ad2f
> +#define WCN36XX_DXE_CTRL_RX_H                  0x12d12f
> +#define WCN36XX_DXE_CTRL_TX_H_BD               0x30ce45
> +#define WCN36XX_DXE_CTRL_TX_H_SKB              0x32ce4d
> +#define WCN36XX_DXE_CTRL_TX_L_BD               0x308a45
> +#define WCN36XX_DXE_CTRL_TX_L_SKB              0x328a4d
> +
> +/* TODO This must calculated properly but not hardcoded */
> +#define WCN36XX_DXE_WQ_TX_L                    0x17
> +#define WCN36XX_DXE_WQ_TX_H                    0x17
> +#define WCN36XX_DXE_WQ_RX_L                    0xB
> +#define WCN36XX_DXE_WQ_RX_H                    0x4
> +
> +/* DXE descriptor control filed */
> +#define WCN36XX_DXE_CTRL_VALID_MASK (0x00000001)
> +
> +/* TODO This must calculated properly but not hardcoded */
> +/* DXE default control register values */
> +#define WCN36XX_DXE_CH_DEFAULT_CTL_RX_L                0x847EAD2F
> +#define WCN36XX_DXE_CH_DEFAULT_CTL_RX_H                0x84FED12F
> +#define WCN36XX_DXE_CH_DEFAULT_CTL_TX_H                0x853ECF4D
> +#define WCN36XX_DXE_CH_DEFAULT_CTL_TX_L                0x843e8b4d
> +
> +/* Common DXE registers */
> +#define WCN36XX_DXE_MEM_CSR                    (WCN36XX_DXE_MEM_REG + 0x00)
> +#define WCN36XX_DXE_REG_CSR_RESET              (WCN36XX_DXE_MEM_REG + 0x00)
> +#define WCN36XX_DXE_ENCH_ADDR                  (WCN36XX_DXE_MEM_REG + 0x04)
> +#define WCN36XX_DXE_REG_CH_EN                  (WCN36XX_DXE_MEM_REG + 0x08)
> +#define WCN36XX_DXE_REG_CH_DONE                        (WCN36XX_DXE_MEM_REG + 0x0C)
> +#define WCN36XX_DXE_REG_CH_ERR                 (WCN36XX_DXE_MEM_REG + 0x10)
> +#define WCN36XX_DXE_INT_MASK_REG               (WCN36XX_DXE_MEM_REG + 0x18)
> +#define WCN36XX_DXE_INT_SRC_RAW_REG            (WCN36XX_DXE_MEM_REG + 0x20)
> +       /* #define WCN36XX_DXE_INT_CH6_MASK     0x00000040 */
> +       /* #define WCN36XX_DXE_INT_CH5_MASK     0x00000020 */
> +       #define WCN36XX_DXE_INT_CH4_MASK        0x00000010
> +       #define WCN36XX_DXE_INT_CH3_MASK        0x00000008
> +       /* #define WCN36XX_DXE_INT_CH2_MASK     0x00000004 */
> +       #define WCN36XX_DXE_INT_CH1_MASK        0x00000002
> +       #define WCN36XX_DXE_INT_CH0_MASK        0x00000001
> +#define WCN36XX_DXE_0_INT_CLR                  (WCN36XX_DXE_MEM_REG + 0x30)
> +#define WCN36XX_DXE_0_INT_ED_CLR               (WCN36XX_DXE_MEM_REG + 0x34)
> +#define WCN36XX_DXE_0_INT_DONE_CLR             (WCN36XX_DXE_MEM_REG + 0x38)
> +#define WCN36XX_DXE_0_INT_ERR_CLR              (WCN36XX_DXE_MEM_REG + 0x3C)
> +
> +#define WCN36XX_DXE_0_CH0_STATUS               (WCN36XX_DXE_MEM_REG + 0x404)
> +#define WCN36XX_DXE_0_CH1_STATUS               (WCN36XX_DXE_MEM_REG + 0x444)
> +#define WCN36XX_DXE_0_CH2_STATUS               (WCN36XX_DXE_MEM_REG + 0x484)
> +#define WCN36XX_DXE_0_CH3_STATUS               (WCN36XX_DXE_MEM_REG + 0x4C4)
> +#define WCN36XX_DXE_0_CH4_STATUS               (WCN36XX_DXE_MEM_REG + 0x504)
> +
> +#define WCN36XX_DXE_REG_RESET                  0x5c89
> +
> +/* Temporary BMU Workqueue 4 */
> +#define WCN36XX_DXE_BMU_WQ_RX_LOW              0xB
> +#define WCN36XX_DXE_BMU_WQ_RX_HIGH             0x4
> +/* DMA channel offset */
> +#define WCN36XX_DXE_TX_LOW_OFFSET              0x400
> +#define WCN36XX_DXE_TX_HIGH_OFFSET             0x500
> +#define WCN36XX_DXE_RX_LOW_OFFSET              0x440
> +#define WCN36XX_DXE_RX_HIGH_OFFSET             0x4C0
> +
> +/* Address of the next DXE descriptor */
> +#define WCN36XX_DXE_CH_NEXT_DESC_ADDR          0x001C
> +#define WCN36XX_DXE_CH_NEXT_DESC_ADDR_TX_L     (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_TX_LOW_OFFSET + \
> +                                                WCN36XX_DXE_CH_NEXT_DESC_ADDR)
> +#define WCN36XX_DXE_CH_NEXT_DESC_ADDR_TX_H     (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_TX_HIGH_OFFSET + \
> +                                                WCN36XX_DXE_CH_NEXT_DESC_ADDR)
> +#define WCN36XX_DXE_CH_NEXT_DESC_ADDR_RX_L     (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_LOW_OFFSET + \
> +                                                WCN36XX_DXE_CH_NEXT_DESC_ADDR)
> +#define WCN36XX_DXE_CH_NEXT_DESC_ADDR_RX_H     (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_HIGH_OFFSET + \
> +                                                WCN36XX_DXE_CH_NEXT_DESC_ADDR)
> +
> +/* DXE Descriptor source address */
> +#define WCN36XX_DXE_CH_SRC_ADDR                        0x000C
> +#define WCN36XX_DXE_CH_SRC_ADDR_RX_L           (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_LOW_OFFSET + \
> +                                                WCN36XX_DXE_CH_SRC_ADDR)
> +#define WCN36XX_DXE_CH_SRC_ADDR_RX_H           (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_HIGH_OFFSET + \
> +                                                WCN36XX_DXE_CH_SRC_ADDR)
> +
> +/* DXE Descriptor address destination address */
> +#define WCN36XX_DXE_CH_DEST_ADDR               0x0014
> +#define WCN36XX_DXE_CH_DEST_ADDR_TX_L          (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_TX_LOW_OFFSET + \
> +                                                WCN36XX_DXE_CH_DEST_ADDR)
> +#define WCN36XX_DXE_CH_DEST_ADDR_TX_H          (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_TX_HIGH_OFFSET + \
> +                                                WCN36XX_DXE_CH_DEST_ADDR)
> +#define WCN36XX_DXE_CH_DEST_ADDR_RX_L          (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_LOW_OFFSET + \
> +                                                WCN36XX_DXE_CH_DEST_ADDR)
> +#define WCN36XX_DXE_CH_DEST_ADDR_RX_H          (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_HIGH_OFFSET + \
> +                                                WCN36XX_DXE_CH_DEST_ADDR)
> +
> +/* Interrupt status */
> +#define WCN36XX_DXE_CH_STATUS_REG_ADDR         0x0004
> +#define WCN36XX_DXE_CH_STATUS_REG_ADDR_TX_L    (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_TX_LOW_OFFSET + \
> +                                                WCN36XX_DXE_CH_STATUS_REG_ADDR)
> +#define WCN36XX_DXE_CH_STATUS_REG_ADDR_TX_H    (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_TX_HIGH_OFFSET + \
> +                                                WCN36XX_DXE_CH_STATUS_REG_ADDR)
> +#define WCN36XX_DXE_CH_STATUS_REG_ADDR_RX_L    (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_LOW_OFFSET + \
> +                                                WCN36XX_DXE_CH_STATUS_REG_ADDR)
> +#define WCN36XX_DXE_CH_STATUS_REG_ADDR_RX_H    (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_HIGH_OFFSET + \
> +                                                WCN36XX_DXE_CH_STATUS_REG_ADDR)
> +
> +
> +/* DXE default control register */
> +#define WCN36XX_DXE_REG_CTL_RX_L               (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_LOW_OFFSET)
> +#define WCN36XX_DXE_REG_CTL_RX_H               (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_RX_HIGH_OFFSET)
> +#define WCN36XX_DXE_REG_CTL_TX_H               (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_TX_HIGH_OFFSET)
> +#define WCN36XX_DXE_REG_CTL_TX_L               (WCN36XX_DXE_MEM_REG + \
> +                                                WCN36XX_DXE_TX_LOW_OFFSET)
> +
> +#define WCN36XX_SMSM_WLAN_TX_ENABLE            0x00000400
> +#define WCN36XX_SMSM_WLAN_TX_RINGS_EMPTY       0x00000200
> +
> +
> +/* Interrupt control channel mask */
> +#define WCN36XX_INT_MASK_CHAN_TX_L             0x00000001
> +#define WCN36XX_INT_MASK_CHAN_RX_L             0x00000002
> +#define WCN36XX_INT_MASK_CHAN_RX_H             0x00000008
> +#define WCN36XX_INT_MASK_CHAN_TX_H             0x00000010
> +
> +#define WCN36XX_BD_CHUNK_SIZE                  128
> +
> +#define WCN36XX_PKT_SIZE                       0xF20
> +enum wcn36xx_dxe_ch_type {
> +       WCN36XX_DXE_CH_TX_L,
> +       WCN36XX_DXE_CH_TX_H,
> +       WCN36XX_DXE_CH_RX_L,
> +       WCN36XX_DXE_CH_RX_H
> +};
> +
> +/* amount of descriptors per channel */
> +enum wcn36xx_dxe_ch_desc_num {
> +       WCN36XX_DXE_CH_DESC_NUMB_TX_L           = 128,
> +       WCN36XX_DXE_CH_DESC_NUMB_TX_H           = 10,
> +       WCN36XX_DXE_CH_DESC_NUMB_RX_L           = 512,
> +       WCN36XX_DXE_CH_DESC_NUMB_RX_H           = 40
> +};
> +
> +/**
> + * struct wcn36xx_dxe_desc - describes descriptor of one DXE buffer
> + *
> + * @ctrl: is a union that consists of following bits:
> + * union {
> + *     u32     valid           :1; //0 = DMA stop, 1 = DMA continue with this
> + *                                 //descriptor
> + *     u32     transfer_type   :2; //0 = Host to Host space
> + *     u32     eop             :1; //End of Packet
> + *     u32     bd_handling     :1; //if transferType = Host to BMU, then 0
> + *                                 // means first 128 bytes contain BD, and 1
> + *                                 // means create new empty BD
> + *     u32     siq             :1; // SIQ
> + *     u32     diq             :1; // DIQ
> + *     u32     pdu_rel         :1; //0 = don't release BD and PDUs when done,
> + *                                 // 1 = release them
> + *     u32     bthld_sel       :4; //BMU Threshold Select
> + *     u32     prio            :3; //Specifies the priority level to use for
> + *                                 // the transfer
> + *     u32     stop_channel    :1; //1 = DMA stops processing further, channel
> + *                                 //requires re-enabling after this
> + *     u32     intr            :1; //Interrupt on Descriptor Done
> + *     u32     rsvd            :1; //reserved
> + *     u32     size            :14;//14 bits used - ignored for BMU transfers,
> + *                                 //only used for host to host transfers?
> + * } ctrl;
> + */
> +struct wcn36xx_dxe_desc {
> +       u32     ctrl;
> +       u32     fr_len;
> +
> +       u32     src_addr_l;
> +       u32     dst_addr_l;
> +       u32     phy_next_l;
> +       u32     src_addr_h;
> +       u32     dst_addr_h;
> +       u32     phy_next_h;
> +} __packed;
> +
> +/* DXE Control block */
> +struct wcn36xx_dxe_ctl {
> +       struct wcn36xx_dxe_ctl  *next;
> +       struct wcn36xx_dxe_desc *desc;
> +       unsigned int            desc_phy_addr;
> +       int                     ctl_blk_order;
> +       struct sk_buff          *skb;
> +       spinlock_t              skb_lock;
> +       void                    *bd_cpu_addr;
> +       dma_addr_t              bd_phy_addr;
> +};
> +
> +struct wcn36xx_dxe_ch {
> +       enum wcn36xx_dxe_ch_type        ch_type;
> +       void                            *cpu_addr;
> +       dma_addr_t                      dma_addr;
> +       enum wcn36xx_dxe_ch_desc_num    desc_num;
> +       /* DXE control block ring */
> +       struct wcn36xx_dxe_ctl          *head_blk_ctl;
> +       struct wcn36xx_dxe_ctl          *tail_blk_ctl;
> +
> +       /* DXE channel specific configs */
> +       u32                             dxe_wq;
> +       u32                             ctrl_bd;
> +       u32                             ctrl_skb;
> +       u32                             reg_ctrl;
> +       u32                             def_ctrl;
> +};
> +
> +/* Memory Pool for BD headers */
> +struct wcn36xx_dxe_mem_pool {
> +       int             chunk_size;
> +       void            *virt_addr;
> +       dma_addr_t      phy_addr;
> +};
> +
> +struct wcn36xx_vif;
> +int wcn36xx_dxe_allocate_mem_pools(struct wcn36xx *wcn);
> +void wcn36xx_dxe_free_mem_pools(struct wcn36xx *wcn);
> +void wcn36xx_dxe_rx_frame(struct wcn36xx *wcn);
> +int wcn36xx_dxe_alloc_ctl_blks(struct wcn36xx *wcn);
> +void wcn36xx_dxe_free_ctl_blks(struct wcn36xx *wcn);
> +int wcn36xx_dxe_init(struct wcn36xx *wcn);
> +void wcn36xx_dxe_deinit(struct wcn36xx *wcn);
> +int wcn36xx_dxe_init_channels(struct wcn36xx *wcn);
> +int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
> +                        struct wcn36xx_vif *vif_priv,
> +                        struct sk_buff *skb,
> +                        bool is_low);
> +void wcn36xx_dxe_tx_ack_ind(struct wcn36xx *wcn, u32 status);
> +void *wcn36xx_dxe_get_next_bd(struct wcn36xx *wcn, bool is_low);
> +#endif /* _DXE_H_ */
> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
> new file mode 100644
> index 0000000..c02dbc6
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
> @@ -0,0 +1,4657 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#ifndef _HAL_H_
> +#define _HAL_H_
> +
> +/*---------------------------------------------------------------------------
> +  API VERSIONING INFORMATION
> +
> +  The RIVA API is versioned as MAJOR.MINOR.VERSION.REVISION
> +  The MAJOR is incremented for major product/architecture changes
> +      (and then MINOR/VERSION/REVISION are zeroed)
> +  The MINOR is incremented for minor product/architecture changes
> +      (and then VERSION/REVISION are zeroed)
> +  The VERSION is incremented if a significant API change occurs
> +      (and then REVISION is zeroed)
> +  The REVISION is incremented if an insignificant API change occurs
> +      or if a new API is added
> +  All values are in the range 0..255 (ie they are 8-bit values)
> + ---------------------------------------------------------------------------*/
> +#define WCN36XX_HAL_VER_MAJOR 1
> +#define WCN36XX_HAL_VER_MINOR 4
> +#define WCN36XX_HAL_VER_VERSION 1
> +#define WCN36XX_HAL_VER_REVISION 2
> +
> +/* This is to force compiler to use the maximum of an int ( 4 bytes ) */
> +#define WCN36XX_HAL_MAX_ENUM_SIZE    0x7FFFFFFF
> +#define WCN36XX_HAL_MSG_TYPE_MAX_ENUM_SIZE    0x7FFF
> +
> +/* Max no. of transmit categories */
> +#define STACFG_MAX_TC    8
> +
> +/* The maximum value of access category */
> +#define WCN36XX_HAL_MAX_AC  4
> +
> +#define WCN36XX_HAL_IPV4_ADDR_LEN       4
> +
> +#define WALN_HAL_STA_INVALID_IDX 0xFF
> +#define WCN36XX_HAL_BSS_INVALID_IDX 0xFF
> +
> +/* Default Beacon template size */
> +#define BEACON_TEMPLATE_SIZE 0x180
> +
> +/* Param Change Bitmap sent to HAL */
> +#define PARAM_BCN_INTERVAL_CHANGED                      (1 << 0)
> +#define PARAM_SHORT_PREAMBLE_CHANGED                 (1 << 1)
> +#define PARAM_SHORT_SLOT_TIME_CHANGED                 (1 << 2)
> +#define PARAM_llACOEXIST_CHANGED                            (1 << 3)
> +#define PARAM_llBCOEXIST_CHANGED                            (1 << 4)
> +#define PARAM_llGCOEXIST_CHANGED                            (1 << 5)
> +#define PARAM_HT20MHZCOEXIST_CHANGED                  (1<<6)
> +#define PARAM_NON_GF_DEVICES_PRESENT_CHANGED (1<<7)
> +#define PARAM_RIFS_MODE_CHANGED                            (1<<8)
> +#define PARAM_LSIG_TXOP_FULL_SUPPORT_CHANGED   (1<<9)
> +#define PARAM_OBSS_MODE_CHANGED                               (1<<10)
> +#define PARAM_BEACON_UPDATE_MASK \
> +       (PARAM_BCN_INTERVAL_CHANGED |                                   \
> +        PARAM_SHORT_PREAMBLE_CHANGED |                                 \
> +        PARAM_SHORT_SLOT_TIME_CHANGED |                                \
> +        PARAM_llACOEXIST_CHANGED |                                     \
> +        PARAM_llBCOEXIST_CHANGED |                                     \
> +        PARAM_llGCOEXIST_CHANGED |                                     \
> +        PARAM_HT20MHZCOEXIST_CHANGED |                                 \
> +        PARAM_NON_GF_DEVICES_PRESENT_CHANGED |                         \
> +        PARAM_RIFS_MODE_CHANGED |                                      \
> +        PARAM_LSIG_TXOP_FULL_SUPPORT_CHANGED |                         \
> +        PARAM_OBSS_MODE_CHANGED)
> +
> +/* dump command response Buffer size */
> +#define DUMPCMD_RSP_BUFFER 100
> +
> +/* version string max length (including NULL) */
> +#define WCN36XX_HAL_VERSION_LENGTH  64
> +
> +/* message types for messages exchanged between WDI and HAL */
> +enum wcn36xx_hal_host_msg_type {
> +       /* Init/De-Init */
> +       WCN36XX_HAL_START_REQ = 0,
> +       WCN36XX_HAL_START_RSP = 1,
> +       WCN36XX_HAL_STOP_REQ = 2,
> +       WCN36XX_HAL_STOP_RSP = 3,
> +
> +       /* Scan */
> +       WCN36XX_HAL_INIT_SCAN_REQ = 4,
> +       WCN36XX_HAL_INIT_SCAN_RSP = 5,
> +       WCN36XX_HAL_START_SCAN_REQ = 6,
> +       WCN36XX_HAL_START_SCAN_RSP = 7,
> +       WCN36XX_HAL_END_SCAN_REQ = 8,
> +       WCN36XX_HAL_END_SCAN_RSP = 9,
> +       WCN36XX_HAL_FINISH_SCAN_REQ = 10,
> +       WCN36XX_HAL_FINISH_SCAN_RSP = 11,
> +
> +       /* HW STA configuration/deconfiguration */
> +       WCN36XX_HAL_CONFIG_STA_REQ = 12,
> +       WCN36XX_HAL_CONFIG_STA_RSP = 13,
> +       WCN36XX_HAL_DELETE_STA_REQ = 14,
> +       WCN36XX_HAL_DELETE_STA_RSP = 15,
> +       WCN36XX_HAL_CONFIG_BSS_REQ = 16,
> +       WCN36XX_HAL_CONFIG_BSS_RSP = 17,
> +       WCN36XX_HAL_DELETE_BSS_REQ = 18,
> +       WCN36XX_HAL_DELETE_BSS_RSP = 19,
> +
> +       /* Infra STA asscoiation */
> +       WCN36XX_HAL_JOIN_REQ = 20,
> +       WCN36XX_HAL_JOIN_RSP = 21,
> +       WCN36XX_HAL_POST_ASSOC_REQ = 22,
> +       WCN36XX_HAL_POST_ASSOC_RSP = 23,
> +
> +       /* Security */
> +       WCN36XX_HAL_SET_BSSKEY_REQ = 24,
> +       WCN36XX_HAL_SET_BSSKEY_RSP = 25,
> +       WCN36XX_HAL_SET_STAKEY_REQ = 26,
> +       WCN36XX_HAL_SET_STAKEY_RSP = 27,
> +       WCN36XX_HAL_RMV_BSSKEY_REQ = 28,
> +       WCN36XX_HAL_RMV_BSSKEY_RSP = 29,
> +       WCN36XX_HAL_RMV_STAKEY_REQ = 30,
> +       WCN36XX_HAL_RMV_STAKEY_RSP = 31,
> +
> +       /* Qos Related */
> +       WCN36XX_HAL_ADD_TS_REQ = 32,
> +       WCN36XX_HAL_ADD_TS_RSP = 33,
> +       WCN36XX_HAL_DEL_TS_REQ = 34,
> +       WCN36XX_HAL_DEL_TS_RSP = 35,
> +       WCN36XX_HAL_UPD_EDCA_PARAMS_REQ = 36,
> +       WCN36XX_HAL_UPD_EDCA_PARAMS_RSP = 37,
> +       WCN36XX_HAL_ADD_BA_REQ = 38,
> +       WCN36XX_HAL_ADD_BA_RSP = 39,
> +       WCN36XX_HAL_DEL_BA_REQ = 40,
> +       WCN36XX_HAL_DEL_BA_RSP = 41,
> +
> +       WCN36XX_HAL_CH_SWITCH_REQ = 42,
> +       WCN36XX_HAL_CH_SWITCH_RSP = 43,
> +       WCN36XX_HAL_SET_LINK_ST_REQ = 44,
> +       WCN36XX_HAL_SET_LINK_ST_RSP = 45,
> +       WCN36XX_HAL_GET_STATS_REQ = 46,
> +       WCN36XX_HAL_GET_STATS_RSP = 47,
> +       WCN36XX_HAL_UPDATE_CFG_REQ = 48,
> +       WCN36XX_HAL_UPDATE_CFG_RSP = 49,
> +
> +       WCN36XX_HAL_MISSED_BEACON_IND = 50,
> +       WCN36XX_HAL_UNKNOWN_ADDR2_FRAME_RX_IND = 51,
> +       WCN36XX_HAL_MIC_FAILURE_IND = 52,
> +       WCN36XX_HAL_FATAL_ERROR_IND = 53,
> +       WCN36XX_HAL_SET_KEYDONE_MSG = 54,
> +
> +       /* NV Interface */
> +       WCN36XX_HAL_DOWNLOAD_NV_REQ = 55,
> +       WCN36XX_HAL_DOWNLOAD_NV_RSP = 56,
> +
> +       WCN36XX_HAL_ADD_BA_SESSION_REQ = 57,
> +       WCN36XX_HAL_ADD_BA_SESSION_RSP = 58,
> +       WCN36XX_HAL_TRIGGER_BA_REQ = 59,
> +       WCN36XX_HAL_TRIGGER_BA_RSP = 60,
> +       WCN36XX_HAL_UPDATE_BEACON_REQ = 61,
> +       WCN36XX_HAL_UPDATE_BEACON_RSP = 62,
> +       WCN36XX_HAL_SEND_BEACON_REQ = 63,
> +       WCN36XX_HAL_SEND_BEACON_RSP = 64,
> +
> +       WCN36XX_HAL_SET_BCASTKEY_REQ = 65,
> +       WCN36XX_HAL_SET_BCASTKEY_RSP = 66,
> +       WCN36XX_HAL_DELETE_STA_CONTEXT_IND = 67,
> +       WCN36XX_HAL_UPDATE_PROBE_RSP_TEMPLATE_REQ = 68,
> +       WCN36XX_HAL_UPDATE_PROBE_RSP_TEMPLATE_RSP = 69,
> +
> +       /* PTT interface support */
> +       WCN36XX_HAL_PROCESS_PTT_REQ = 70,
> +       WCN36XX_HAL_PROCESS_PTT_RSP = 71,
> +
> +       /* BTAMP related events */
> +       WCN36XX_HAL_SIGNAL_BTAMP_EVENT_REQ = 72,
> +       WCN36XX_HAL_SIGNAL_BTAMP_EVENT_RSP = 73,
> +       WCN36XX_HAL_TL_HAL_FLUSH_AC_REQ = 74,
> +       WCN36XX_HAL_TL_HAL_FLUSH_AC_RSP = 75,
> +
> +       WCN36XX_HAL_ENTER_IMPS_REQ = 76,
> +       WCN36XX_HAL_EXIT_IMPS_REQ = 77,
> +       WCN36XX_HAL_ENTER_BMPS_REQ = 78,
> +       WCN36XX_HAL_EXIT_BMPS_REQ = 79,
> +       WCN36XX_HAL_ENTER_UAPSD_REQ = 80,
> +       WCN36XX_HAL_EXIT_UAPSD_REQ = 81,
> +       WCN36XX_HAL_UPDATE_UAPSD_PARAM_REQ = 82,
> +       WCN36XX_HAL_CONFIGURE_RXP_FILTER_REQ = 83,
> +       WCN36XX_HAL_ADD_BCN_FILTER_REQ = 84,
> +       WCN36XX_HAL_REM_BCN_FILTER_REQ = 85,
> +       WCN36XX_HAL_ADD_WOWL_BCAST_PTRN = 86,
> +       WCN36XX_HAL_DEL_WOWL_BCAST_PTRN = 87,
> +       WCN36XX_HAL_ENTER_WOWL_REQ = 88,
> +       WCN36XX_HAL_EXIT_WOWL_REQ = 89,
> +       WCN36XX_HAL_HOST_OFFLOAD_REQ = 90,
> +       WCN36XX_HAL_SET_RSSI_THRESH_REQ = 91,
> +       WCN36XX_HAL_GET_RSSI_REQ = 92,
> +       WCN36XX_HAL_SET_UAPSD_AC_PARAMS_REQ = 93,
> +       WCN36XX_HAL_CONFIGURE_APPS_CPU_WAKEUP_STATE_REQ = 94,
> +
> +       WCN36XX_HAL_ENTER_IMPS_RSP = 95,
> +       WCN36XX_HAL_EXIT_IMPS_RSP = 96,
> +       WCN36XX_HAL_ENTER_BMPS_RSP = 97,
> +       WCN36XX_HAL_EXIT_BMPS_RSP = 98,
> +       WCN36XX_HAL_ENTER_UAPSD_RSP = 99,
> +       WCN36XX_HAL_EXIT_UAPSD_RSP = 100,
> +       WCN36XX_HAL_SET_UAPSD_AC_PARAMS_RSP = 101,
> +       WCN36XX_HAL_UPDATE_UAPSD_PARAM_RSP = 102,
> +       WCN36XX_HAL_CONFIGURE_RXP_FILTER_RSP = 103,
> +       WCN36XX_HAL_ADD_BCN_FILTER_RSP = 104,
> +       WCN36XX_HAL_REM_BCN_FILTER_RSP = 105,
> +       WCN36XX_HAL_SET_RSSI_THRESH_RSP = 106,
> +       WCN36XX_HAL_HOST_OFFLOAD_RSP = 107,
> +       WCN36XX_HAL_ADD_WOWL_BCAST_PTRN_RSP = 108,
> +       WCN36XX_HAL_DEL_WOWL_BCAST_PTRN_RSP = 109,
> +       WCN36XX_HAL_ENTER_WOWL_RSP = 110,
> +       WCN36XX_HAL_EXIT_WOWL_RSP = 111,
> +       WCN36XX_HAL_RSSI_NOTIFICATION_IND = 112,
> +       WCN36XX_HAL_GET_RSSI_RSP = 113,
> +       WCN36XX_HAL_CONFIGURE_APPS_CPU_WAKEUP_STATE_RSP = 114,
> +
> +       /* 11k related events */
> +       WCN36XX_HAL_SET_MAX_TX_POWER_REQ = 115,
> +       WCN36XX_HAL_SET_MAX_TX_POWER_RSP = 116,
> +
> +       /* 11R related msgs */
> +       WCN36XX_HAL_AGGR_ADD_TS_REQ = 117,
> +       WCN36XX_HAL_AGGR_ADD_TS_RSP = 118,
> +
> +       /* P2P  WLAN_FEATURE_P2P */
> +       WCN36XX_HAL_SET_P2P_GONOA_REQ = 119,
> +       WCN36XX_HAL_SET_P2P_GONOA_RSP = 120,
> +
> +       /* WLAN Dump commands */
> +       WCN36XX_HAL_DUMP_COMMAND_REQ = 121,
> +       WCN36XX_HAL_DUMP_COMMAND_RSP = 122,
> +
> +       /* OEM_DATA FEATURE SUPPORT */
> +       WCN36XX_HAL_START_OEM_DATA_REQ = 123,
> +       WCN36XX_HAL_START_OEM_DATA_RSP = 124,
> +
> +       /* ADD SELF STA REQ and RSP */
> +       WCN36XX_HAL_ADD_STA_SELF_REQ = 125,
> +       WCN36XX_HAL_ADD_STA_SELF_RSP = 126,
> +
> +       /* DEL SELF STA SUPPORT */
> +       WCN36XX_HAL_DEL_STA_SELF_REQ = 127,
> +       WCN36XX_HAL_DEL_STA_SELF_RSP = 128,
> +
> +       /* Coex Indication */
> +       WCN36XX_HAL_COEX_IND = 129,
> +
> +       /* Tx Complete Indication */
> +       WCN36XX_HAL_OTA_TX_COMPL_IND = 130,
> +
> +       /* Host Suspend/resume messages */
> +       WCN36XX_HAL_HOST_SUSPEND_IND = 131,
> +       WCN36XX_HAL_HOST_RESUME_REQ = 132,
> +       WCN36XX_HAL_HOST_RESUME_RSP = 133,
> +
> +       WCN36XX_HAL_SET_TX_POWER_REQ = 134,
> +       WCN36XX_HAL_SET_TX_POWER_RSP = 135,
> +       WCN36XX_HAL_GET_TX_POWER_REQ = 136,
> +       WCN36XX_HAL_GET_TX_POWER_RSP = 137,
> +
> +       WCN36XX_HAL_P2P_NOA_ATTR_IND = 138,
> +
> +       WCN36XX_HAL_ENABLE_RADAR_DETECT_REQ = 139,
> +       WCN36XX_HAL_ENABLE_RADAR_DETECT_RSP = 140,
> +       WCN36XX_HAL_GET_TPC_REPORT_REQ = 141,
> +       WCN36XX_HAL_GET_TPC_REPORT_RSP = 142,
> +       WCN36XX_HAL_RADAR_DETECT_IND = 143,
> +       WCN36XX_HAL_RADAR_DETECT_INTR_IND = 144,
> +       WCN36XX_HAL_KEEP_ALIVE_REQ = 145,
> +       WCN36XX_HAL_KEEP_ALIVE_RSP = 146,
> +
> +       /* PNO messages */
> +       WCN36XX_HAL_SET_PREF_NETWORK_REQ = 147,
> +       WCN36XX_HAL_SET_PREF_NETWORK_RSP = 148,
> +       WCN36XX_HAL_SET_RSSI_FILTER_REQ = 149,
> +       WCN36XX_HAL_SET_RSSI_FILTER_RSP = 150,
> +       WCN36XX_HAL_UPDATE_SCAN_PARAM_REQ = 151,
> +       WCN36XX_HAL_UPDATE_SCAN_PARAM_RSP = 152,
> +       WCN36XX_HAL_PREF_NETW_FOUND_IND = 153,
> +
> +       WCN36XX_HAL_SET_TX_PER_TRACKING_REQ = 154,
> +       WCN36XX_HAL_SET_TX_PER_TRACKING_RSP = 155,
> +       WCN36XX_HAL_TX_PER_HIT_IND = 156,
> +
> +       WCN36XX_HAL_8023_MULTICAST_LIST_REQ = 157,
> +       WCN36XX_HAL_8023_MULTICAST_LIST_RSP = 158,
> +
> +       WCN36XX_HAL_SET_PACKET_FILTER_REQ = 159,
> +       WCN36XX_HAL_SET_PACKET_FILTER_RSP = 160,
> +       WCN36XX_HAL_PACKET_FILTER_MATCH_COUNT_REQ = 161,
> +       WCN36XX_HAL_PACKET_FILTER_MATCH_COUNT_RSP = 162,
> +       WCN36XX_HAL_CLEAR_PACKET_FILTER_REQ = 163,
> +       WCN36XX_HAL_CLEAR_PACKET_FILTER_RSP = 164,
> +
> +       /*
> +        * This is temp fix. Should be removed once Host and Riva code is
> +        * in sync.
> +        */
> +       WCN36XX_HAL_INIT_SCAN_CON_REQ = 165,
> +
> +       WCN36XX_HAL_SET_POWER_PARAMS_REQ = 166,
> +       WCN36XX_HAL_SET_POWER_PARAMS_RSP = 167,
> +
> +       WCN36XX_HAL_TSM_STATS_REQ = 168,
> +       WCN36XX_HAL_TSM_STATS_RSP = 169,
> +
> +       /* wake reason indication (WOW) */
> +       WCN36XX_HAL_WAKE_REASON_IND = 170,
> +
> +       /* GTK offload support */
> +       WCN36XX_HAL_GTK_OFFLOAD_REQ = 171,
> +       WCN36XX_HAL_GTK_OFFLOAD_RSP = 172,
> +       WCN36XX_HAL_GTK_OFFLOAD_GETINFO_REQ = 173,
> +       WCN36XX_HAL_GTK_OFFLOAD_GETINFO_RSP = 174,
> +
> +       WCN36XX_HAL_FEATURE_CAPS_EXCHANGE_REQ = 175,
> +       WCN36XX_HAL_FEATURE_CAPS_EXCHANGE_RSP = 176,
> +       WCN36XX_HAL_EXCLUDE_UNENCRYPTED_IND = 177,
> +
> +       WCN36XX_HAL_SET_THERMAL_MITIGATION_REQ = 178,
> +       WCN36XX_HAL_SET_THERMAL_MITIGATION_RSP = 179,
> +
> +       WCN36XX_HAL_UPDATE_VHT_OP_MODE_REQ = 182,
> +       WCN36XX_HAL_UPDATE_VHT_OP_MODE_RSP = 183,
> +
> +       WCN36XX_HAL_P2P_NOA_START_IND = 184,
> +
> +       WCN36XX_HAL_GET_ROAM_RSSI_REQ = 185,
> +       WCN36XX_HAL_GET_ROAM_RSSI_RSP = 186,
> +
> +       WCN36XX_HAL_CLASS_B_STATS_IND = 187,
> +       WCN36XX_HAL_DEL_BA_IND = 188,
> +       WCN36XX_HAL_DHCP_START_IND = 189,
> +       WCN36XX_HAL_DHCP_STOP_IND = 190,
> +
> +       WCN36XX_HAL_MSG_MAX = WCN36XX_HAL_MSG_TYPE_MAX_ENUM_SIZE
> +};
> +
> +/* Enumeration for Version */
> +enum wcn36xx_hal_host_msg_version {
> +       WCN36XX_HAL_MSG_VERSION0 = 0,
> +       WCN36XX_HAL_MSG_VERSION1 = 1,
> +       /* define as 2 bytes data */
> +       WCN36XX_HAL_MSG_WCNSS_CTRL_VERSION = 0x7FFF,
> +       WCN36XX_HAL_MSG_VERSION_MAX_FIELD = WCN36XX_HAL_MSG_WCNSS_CTRL_VERSION
> +};
> +
> +enum driver_type {
> +       DRIVER_TYPE_PRODUCTION = 0,
> +       DRIVER_TYPE_MFG = 1,
> +       DRIVER_TYPE_DVT = 2,
> +       DRIVER_TYPE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +enum wcn36xx_hal_stop_type {
> +       HAL_STOP_TYPE_SYS_RESET,
> +       HAL_STOP_TYPE_SYS_DEEP_SLEEP,
> +       HAL_STOP_TYPE_RF_KILL,
> +       HAL_STOP_TYPE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +enum wcn36xx_hal_sys_mode {
> +       HAL_SYS_MODE_NORMAL,
> +       HAL_SYS_MODE_LEARN,
> +       HAL_SYS_MODE_SCAN,
> +       HAL_SYS_MODE_PROMISC,
> +       HAL_SYS_MODE_SUSPEND_LINK,
> +       HAL_SYS_MODE_ROAM_SCAN,
> +       HAL_SYS_MODE_ROAM_SUSPEND_LINK,
> +       HAL_SYS_MODE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +enum phy_chan_bond_state {
> +       /* 20MHz IF bandwidth centered on IF carrier */
> +       PHY_SINGLE_CHANNEL_CENTERED = 0,
> +
> +       /* 40MHz IF bandwidth with lower 20MHz supporting the primary channel */
> +       PHY_DOUBLE_CHANNEL_LOW_PRIMARY = 1,
> +
> +       /* 40MHz IF bandwidth centered on IF carrier */
> +       PHY_DOUBLE_CHANNEL_CENTERED = 2,
> +
> +       /* 40MHz IF bandwidth with higher 20MHz supporting the primary ch */
> +       PHY_DOUBLE_CHANNEL_HIGH_PRIMARY = 3,
> +
> +       /* 20/40MHZ offset LOW 40/80MHZ offset CENTERED */
> +       PHY_QUADRUPLE_CHANNEL_20MHZ_LOW_40MHZ_CENTERED = 4,
> +
> +       /* 20/40MHZ offset CENTERED 40/80MHZ offset CENTERED */
> +       PHY_QUADRUPLE_CHANNEL_20MHZ_CENTERED_40MHZ_CENTERED = 5,
> +
> +       /* 20/40MHZ offset HIGH 40/80MHZ offset CENTERED */
> +       PHY_QUADRUPLE_CHANNEL_20MHZ_HIGH_40MHZ_CENTERED = 6,
> +
> +       /* 20/40MHZ offset LOW 40/80MHZ offset LOW */
> +       PHY_QUADRUPLE_CHANNEL_20MHZ_LOW_40MHZ_LOW = 7,
> +
> +       /* 20/40MHZ offset HIGH 40/80MHZ offset LOW */
> +       PHY_QUADRUPLE_CHANNEL_20MHZ_HIGH_40MHZ_LOW = 8,
> +
> +       /* 20/40MHZ offset LOW 40/80MHZ offset HIGH */
> +       PHY_QUADRUPLE_CHANNEL_20MHZ_LOW_40MHZ_HIGH = 9,
> +
> +       /* 20/40MHZ offset-HIGH 40/80MHZ offset HIGH */
> +       PHY_QUADRUPLE_CHANNEL_20MHZ_HIGH_40MHZ_HIGH = 10,
> +
> +       PHY_CHANNEL_BONDING_STATE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +/* Spatial Multiplexing(SM) Power Save mode */
> +enum wcn36xx_hal_ht_mimo_state {
> +       /* Static SM Power Save mode */
> +       WCN36XX_HAL_HT_MIMO_PS_STATIC = 0,
> +
> +       /* Dynamic SM Power Save mode */
> +       WCN36XX_HAL_HT_MIMO_PS_DYNAMIC = 1,
> +
> +       /* reserved */
> +       WCN36XX_HAL_HT_MIMO_PS_NA = 2,
> +
> +       /* SM Power Save disabled */
> +       WCN36XX_HAL_HT_MIMO_PS_NO_LIMIT = 3,
> +
> +       WCN36XX_HAL_HT_MIMO_PS_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +/* each station added has a rate mode which specifies the sta attributes */
> +enum sta_rate_mode {
> +       STA_TAURUS = 0,
> +       STA_TITAN,
> +       STA_POLARIS,
> +       STA_11b,
> +       STA_11bg,
> +       STA_11a,
> +       STA_11n,
> +       STA_11ac,
> +       STA_INVALID_RATE_MODE = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +/* 1,2,5.5,11 */
> +#define WCN36XX_HAL_NUM_DSSS_RATES           4
> +
> +/* 6,9,12,18,24,36,48,54 */
> +#define WCN36XX_HAL_NUM_OFDM_RATES           8
> +
> +/* 72,96,108 */
> +#define WCN36XX_HAL_NUM_POLARIS_RATES       3
> +
> +#define WCN36XX_HAL_MAC_MAX_SUPPORTED_MCS_SET    16
> +
> +enum wcn36xx_hal_bss_type {
> +       WCN36XX_HAL_INFRASTRUCTURE_MODE,
> +
> +       /* Added for softAP support */
> +       WCN36XX_HAL_INFRA_AP_MODE,
> +
> +       WCN36XX_HAL_IBSS_MODE,
> +
> +       /* Added for BT-AMP support */
> +       WCN36XX_HAL_BTAMP_STA_MODE,
> +
> +       /* Added for BT-AMP support */
> +       WCN36XX_HAL_BTAMP_AP_MODE,
> +
> +       WCN36XX_HAL_AUTO_MODE,
> +
> +       WCN36XX_HAL_DONOT_USE_BSS_TYPE = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +enum wcn36xx_hal_nw_type {
> +       WCN36XX_HAL_11A_NW_TYPE,
> +       WCN36XX_HAL_11B_NW_TYPE,
> +       WCN36XX_HAL_11G_NW_TYPE,
> +       WCN36XX_HAL_11N_NW_TYPE,
> +       WCN36XX_HAL_DONOT_USE_NW_TYPE = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +#define WCN36XX_HAL_MAC_RATESET_EID_MAX            12
> +
> +enum wcn36xx_hal_ht_operating_mode {
> +       /* No Protection */
> +       WCN36XX_HAL_HT_OP_MODE_PURE,
> +
> +       /* Overlap Legacy device present, protection is optional */
> +       WCN36XX_HAL_HT_OP_MODE_OVERLAP_LEGACY,
> +
> +       /* No legacy device, but 20 MHz HT present */
> +       WCN36XX_HAL_HT_OP_MODE_NO_LEGACY_20MHZ_HT,
> +
> +       /* Protection is required */
> +       WCN36XX_HAL_HT_OP_MODE_MIXED,
> +
> +       WCN36XX_HAL_HT_OP_MODE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +/* Encryption type enum used with peer */
> +enum ani_ed_type {
> +       WCN36XX_HAL_ED_NONE,
> +       WCN36XX_HAL_ED_WEP40,
> +       WCN36XX_HAL_ED_WEP104,
> +       WCN36XX_HAL_ED_TKIP,
> +       WCN36XX_HAL_ED_CCMP,
> +       WCN36XX_HAL_ED_WPI,
> +       WCN36XX_HAL_ED_AES_128_CMAC,
> +       WCN36XX_HAL_ED_NOT_IMPLEMENTED = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +#define WLAN_MAX_KEY_RSC_LEN                16
> +#define WLAN_WAPI_KEY_RSC_LEN               16
> +
> +/* MAX key length when ULA is used */
> +#define WCN36XX_HAL_MAC_MAX_KEY_LENGTH              32
> +#define WCN36XX_HAL_MAC_MAX_NUM_OF_DEFAULT_KEYS     4
> +
> +/*
> + * Enum to specify whether key is used for TX only, RX only or both.
> + */
> +enum ani_key_direction {
> +       WCN36XX_HAL_TX_ONLY,
> +       WCN36XX_HAL_RX_ONLY,
> +       WCN36XX_HAL_TX_RX,
> +       WCN36XX_HAL_TX_DEFAULT,
> +       WCN36XX_HAL_DONOT_USE_KEY_DIRECTION = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +enum ani_wep_type {
> +       WCN36XX_HAL_WEP_STATIC,
> +       WCN36XX_HAL_WEP_DYNAMIC,
> +       WCN36XX_HAL_WEP_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +enum wcn36xx_hal_link_state {
> +
> +       WCN36XX_HAL_LINK_IDLE_STATE = 0,
> +       WCN36XX_HAL_LINK_PREASSOC_STATE = 1,
> +       WCN36XX_HAL_LINK_POSTASSOC_STATE = 2,
> +       WCN36XX_HAL_LINK_AP_STATE = 3,
> +       WCN36XX_HAL_LINK_IBSS_STATE = 4,
> +
> +       /* BT-AMP Case */
> +       WCN36XX_HAL_LINK_BTAMP_PREASSOC_STATE = 5,
> +       WCN36XX_HAL_LINK_BTAMP_POSTASSOC_STATE = 6,
> +       WCN36XX_HAL_LINK_BTAMP_AP_STATE = 7,
> +       WCN36XX_HAL_LINK_BTAMP_STA_STATE = 8,
> +
> +       /* Reserved for HAL Internal Use */
> +       WCN36XX_HAL_LINK_LEARN_STATE = 9,
> +       WCN36XX_HAL_LINK_SCAN_STATE = 10,
> +       WCN36XX_HAL_LINK_FINISH_SCAN_STATE = 11,
> +       WCN36XX_HAL_LINK_INIT_CAL_STATE = 12,
> +       WCN36XX_HAL_LINK_FINISH_CAL_STATE = 13,
> +       WCN36XX_HAL_LINK_LISTEN_STATE = 14,
> +
> +       WCN36XX_HAL_LINK_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +enum wcn36xx_hal_stats_mask {
> +       HAL_SUMMARY_STATS_INFO = 0x00000001,
> +       HAL_GLOBAL_CLASS_A_STATS_INFO = 0x00000002,
> +       HAL_GLOBAL_CLASS_B_STATS_INFO = 0x00000004,
> +       HAL_GLOBAL_CLASS_C_STATS_INFO = 0x00000008,
> +       HAL_GLOBAL_CLASS_D_STATS_INFO = 0x00000010,
> +       HAL_PER_STA_STATS_INFO = 0x00000020
> +};
> +
> +/* BT-AMP events type */
> +enum bt_amp_event_type {
> +       BTAMP_EVENT_CONNECTION_START,
> +       BTAMP_EVENT_CONNECTION_STOP,
> +       BTAMP_EVENT_CONNECTION_TERMINATED,
> +
> +       /* This and beyond are invalid values */
> +       BTAMP_EVENT_TYPE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE,
> +};
> +
> +/* PE Statistics */
> +enum pe_stats_mask {
> +       PE_SUMMARY_STATS_INFO = 0x00000001,
> +       PE_GLOBAL_CLASS_A_STATS_INFO = 0x00000002,
> +       PE_GLOBAL_CLASS_B_STATS_INFO = 0x00000004,
> +       PE_GLOBAL_CLASS_C_STATS_INFO = 0x00000008,
> +       PE_GLOBAL_CLASS_D_STATS_INFO = 0x00000010,
> +       PE_PER_STA_STATS_INFO = 0x00000020,
> +
> +       /* This and beyond are invalid values */
> +       PE_STATS_TYPE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +/*
> + * Configuration Parameter IDs
> + */
> +#define WCN36XX_HAL_CFG_STA_ID                         0
> +#define WCN36XX_HAL_CFG_CURRENT_TX_ANTENNA             1
> +#define WCN36XX_HAL_CFG_CURRENT_RX_ANTENNA             2
> +#define WCN36XX_HAL_CFG_LOW_GAIN_OVERRIDE              3
> +#define WCN36XX_HAL_CFG_POWER_STATE_PER_CHAIN          4
> +#define WCN36XX_HAL_CFG_CAL_PERIOD                     5
> +#define WCN36XX_HAL_CFG_CAL_CONTROL                    6
> +#define WCN36XX_HAL_CFG_PROXIMITY                      7
> +#define WCN36XX_HAL_CFG_NETWORK_DENSITY                        8
> +#define WCN36XX_HAL_CFG_MAX_MEDIUM_TIME                        9
> +#define WCN36XX_HAL_CFG_MAX_MPDUS_IN_AMPDU             10
> +#define WCN36XX_HAL_CFG_RTS_THRESHOLD                  11
> +#define WCN36XX_HAL_CFG_SHORT_RETRY_LIMIT              12
> +#define WCN36XX_HAL_CFG_LONG_RETRY_LIMIT               13
> +#define WCN36XX_HAL_CFG_FRAGMENTATION_THRESHOLD                14
> +#define WCN36XX_HAL_CFG_DYNAMIC_THRESHOLD_ZERO         15
> +#define WCN36XX_HAL_CFG_DYNAMIC_THRESHOLD_ONE          16
> +#define WCN36XX_HAL_CFG_DYNAMIC_THRESHOLD_TWO          17
> +#define WCN36XX_HAL_CFG_FIXED_RATE                     18
> +#define WCN36XX_HAL_CFG_RETRYRATE_POLICY               19
> +#define WCN36XX_HAL_CFG_RETRYRATE_SECONDARY            20
> +#define WCN36XX_HAL_CFG_RETRYRATE_TERTIARY             21
> +#define WCN36XX_HAL_CFG_FORCE_POLICY_PROTECTION                22
> +#define WCN36XX_HAL_CFG_FIXED_RATE_MULTICAST_24GHZ     23
> +#define WCN36XX_HAL_CFG_FIXED_RATE_MULTICAST_5GHZ      24
> +#define WCN36XX_HAL_CFG_DEFAULT_RATE_INDEX_24GHZ       25
> +#define WCN36XX_HAL_CFG_DEFAULT_RATE_INDEX_5GHZ                26
> +#define WCN36XX_HAL_CFG_MAX_BA_SESSIONS                        27
> +#define WCN36XX_HAL_CFG_PS_DATA_INACTIVITY_TIMEOUT     28
> +#define WCN36XX_HAL_CFG_PS_ENABLE_BCN_FILTER           29
> +#define WCN36XX_HAL_CFG_PS_ENABLE_RSSI_MONITOR         30
> +#define WCN36XX_HAL_CFG_NUM_BEACON_PER_RSSI_AVERAGE    31
> +#define WCN36XX_HAL_CFG_STATS_PERIOD                   32
> +#define WCN36XX_HAL_CFG_CFP_MAX_DURATION               33
> +#define WCN36XX_HAL_CFG_FRAME_TRANS_ENABLED            34
> +#define WCN36XX_HAL_CFG_DTIM_PERIOD                    35
> +#define WCN36XX_HAL_CFG_EDCA_WMM_ACBK                  36
> +#define WCN36XX_HAL_CFG_EDCA_WMM_ACBE                  37
> +#define WCN36XX_HAL_CFG_EDCA_WMM_ACVO                  38
> +#define WCN36XX_HAL_CFG_EDCA_WMM_ACVI                  39
> +#define WCN36XX_HAL_CFG_BA_THRESHOLD_HIGH              40
> +#define WCN36XX_HAL_CFG_MAX_BA_BUFFERS                 41
> +#define WCN36XX_HAL_CFG_RPE_POLLING_THRESHOLD          42
> +#define WCN36XX_HAL_CFG_RPE_AGING_THRESHOLD_FOR_AC0_REG        43
> +#define WCN36XX_HAL_CFG_RPE_AGING_THRESHOLD_FOR_AC1_REG        44
> +#define WCN36XX_HAL_CFG_RPE_AGING_THRESHOLD_FOR_AC2_REG        45
> +#define WCN36XX_HAL_CFG_RPE_AGING_THRESHOLD_FOR_AC3_REG        46
> +#define WCN36XX_HAL_CFG_NO_OF_ONCHIP_REORDER_SESSIONS  47
> +#define WCN36XX_HAL_CFG_PS_LISTEN_INTERVAL             48
> +#define WCN36XX_HAL_CFG_PS_HEART_BEAT_THRESHOLD                49
> +#define WCN36XX_HAL_CFG_PS_NTH_BEACON_FILTER           50
> +#define WCN36XX_HAL_CFG_PS_MAX_PS_POLL                 51
> +#define WCN36XX_HAL_CFG_PS_MIN_RSSI_THRESHOLD          52
> +#define WCN36XX_HAL_CFG_PS_RSSI_FILTER_PERIOD          53
> +#define WCN36XX_HAL_CFG_PS_BROADCAST_FRAME_FILTER_ENABLE 54
> +#define WCN36XX_HAL_CFG_PS_IGNORE_DTIM                 55
> +#define WCN36XX_HAL_CFG_PS_ENABLE_BCN_EARLY_TERM       56
> +#define WCN36XX_HAL_CFG_DYNAMIC_PS_POLL_VALUE          57
> +#define WCN36XX_HAL_CFG_PS_NULLDATA_AP_RESP_TIMEOUT    58
> +#define WCN36XX_HAL_CFG_TELE_BCN_WAKEUP_EN             59
> +#define WCN36XX_HAL_CFG_TELE_BCN_TRANS_LI              60
> +#define WCN36XX_HAL_CFG_TELE_BCN_TRANS_LI_IDLE_BCNS    61
> +#define WCN36XX_HAL_CFG_TELE_BCN_MAX_LI                        62
> +#define WCN36XX_HAL_CFG_TELE_BCN_MAX_LI_IDLE_BCNS      63
> +#define WCN36XX_HAL_CFG_TX_PWR_CTRL_ENABLE             64
> +#define WCN36XX_HAL_CFG_VALID_RADAR_CHANNEL_LIST       65
> +#define WCN36XX_HAL_CFG_TX_POWER_24_20                 66
> +#define WCN36XX_HAL_CFG_TX_POWER_24_40                 67
> +#define WCN36XX_HAL_CFG_TX_POWER_50_20                 68
> +#define WCN36XX_HAL_CFG_TX_POWER_50_40                 69
> +#define WCN36XX_HAL_CFG_MCAST_BCAST_FILTER_SETTING     70
> +#define WCN36XX_HAL_CFG_BCN_EARLY_TERM_WAKEUP_INTERVAL 71
> +#define WCN36XX_HAL_CFG_MAX_TX_POWER_2_4               72
> +#define WCN36XX_HAL_CFG_MAX_TX_POWER_5                 73
> +#define WCN36XX_HAL_CFG_INFRA_STA_KEEP_ALIVE_PERIOD    74
> +#define WCN36XX_HAL_CFG_ENABLE_CLOSE_LOOP              75
> +#define WCN36XX_HAL_CFG_BTC_EXECUTION_MODE             76
> +#define WCN36XX_HAL_CFG_BTC_DHCP_BT_SLOTS_TO_BLOCK     77
> +#define WCN36XX_HAL_CFG_BTC_A2DP_DHCP_BT_SUB_INTERVALS 78
> +#define WCN36XX_HAL_CFG_PS_TX_INACTIVITY_TIMEOUT       79
> +#define WCN36XX_HAL_CFG_WCNSS_API_VERSION              80
> +#define WCN36XX_HAL_CFG_AP_KEEPALIVE_TIMEOUT           81
> +#define WCN36XX_HAL_CFG_GO_KEEPALIVE_TIMEOUT           82
> +#define WCN36XX_HAL_CFG_ENABLE_MC_ADDR_LIST            83
> +#define WCN36XX_HAL_CFG_BTC_STATIC_LEN_INQ_BT          84
> +#define WCN36XX_HAL_CFG_BTC_STATIC_LEN_PAGE_BT         85
> +#define WCN36XX_HAL_CFG_BTC_STATIC_LEN_CONN_BT         86
> +#define WCN36XX_HAL_CFG_BTC_STATIC_LEN_LE_BT           87
> +#define WCN36XX_HAL_CFG_BTC_STATIC_LEN_INQ_WLAN                88
> +#define WCN36XX_HAL_CFG_BTC_STATIC_LEN_PAGE_WLAN       89
> +#define WCN36XX_HAL_CFG_BTC_STATIC_LEN_CONN_WLAN       90
> +#define WCN36XX_HAL_CFG_BTC_STATIC_LEN_LE_WLAN         91
> +#define WCN36XX_HAL_CFG_BTC_DYN_MAX_LEN_BT             92
> +#define WCN36XX_HAL_CFG_BTC_DYN_MAX_LEN_WLAN           93
> +#define WCN36XX_HAL_CFG_BTC_MAX_SCO_BLOCK_PERC         94
> +#define WCN36XX_HAL_CFG_BTC_DHCP_PROT_ON_A2DP          95
> +#define WCN36XX_HAL_CFG_BTC_DHCP_PROT_ON_SCO           96
> +#define WCN36XX_HAL_CFG_ENABLE_UNICAST_FILTER          97
> +#define WCN36XX_HAL_CFG_MAX_ASSOC_LIMIT                        98
> +#define WCN36XX_HAL_CFG_ENABLE_LPWR_IMG_TRANSITION     99
> +#define WCN36XX_HAL_CFG_ENABLE_MCC_ADAPTIVE_SCHEDULER  100
> +#define WCN36XX_HAL_CFG_ENABLE_DETECT_PS_SUPPORT       101
> +#define WCN36XX_HAL_CFG_AP_LINK_MONITOR_TIMEOUT                102
> +#define WCN36XX_HAL_CFG_BTC_DWELL_TIME_MULTIPLIER      103
> +#define WCN36XX_HAL_CFG_ENABLE_TDLS_OXYGEN_MODE                104
> +#define WCN36XX_HAL_CFG_MAX_PARAMS                     105
> +
> +/* Message definitons - All the messages below need to be packed */
> +
> +/* Definition for HAL API Version. */
> +struct wcnss_wlan_version {
> +       u8 revision;
> +       u8 version;
> +       u8 minor;
> +       u8 major;
> +} __packed;
> +
> +/* Definition for Encryption Keys */
> +struct wcn36xx_hal_keys {
> +       u8 id;
> +
> +       /* 0 for multicast */
> +       u8 unicast;
> +
> +       enum ani_key_direction direction;
> +
> +       /* Usage is unknown */
> +       u8 rsc[WLAN_MAX_KEY_RSC_LEN];
> +
> +       /* =1 for authenticator,=0 for supplicant */
> +       u8 pae_role;
> +
> +       u16 length;
> +       u8 key[WCN36XX_HAL_MAC_MAX_KEY_LENGTH];
> +} __packed;
> +
> +/*
> + * set_sta_key_params Moving here since it is shared by
> + * configbss/setstakey msgs
> + */
> +struct wcn36xx_hal_set_sta_key_params {
> +       /* STA Index */
> +       u16 sta_index;
> +
> +       /* Encryption Type used with peer */
> +       enum ani_ed_type enc_type;
> +
> +       /* STATIC/DYNAMIC - valid only for WEP */
> +       enum ani_wep_type wep_type;
> +
> +       /* Default WEP key, valid only for static WEP, must between 0 and 3. */
> +       u8 def_wep_idx;
> +
> +       /* valid only for non-static WEP encyrptions */
> +       struct wcn36xx_hal_keys key[WCN36XX_HAL_MAC_MAX_NUM_OF_DEFAULT_KEYS];
> +
> +       /*
> +        * Control for Replay Count, 1= Single TID based replay count on Tx
> +        * 0 = Per TID based replay count on TX
> +        */
> +       u8 single_tid_rc;
> +
> +} __packed;
> +
> +/* 4-byte control message header used by HAL*/
> +struct wcn36xx_hal_msg_header {
> +       enum wcn36xx_hal_host_msg_type msg_type:16;
> +       enum wcn36xx_hal_host_msg_version msg_version:16;
> +       u32 len;
> +} __packed;
> +
> +/* Config format required by HAL for each CFG item*/
> +struct wcn36xx_hal_cfg {
> +       /* Cfg Id. The Id required by HAL is exported by HAL
> +        * in shared header file between UMAC and HAL.*/
> +       u16 id;
> +
> +       /* Length of the Cfg. This parameter is used to go to next cfg
> +        * in the TLV format.*/
> +       u16 len;
> +
> +       /* Padding bytes for unaligned address's */
> +       u16 pad_bytes;
> +
> +       /* Reserve bytes for making cfgVal to align address */
> +       u16 reserve;
> +
> +       /* Following the uCfgLen field there should be a 'uCfgLen' bytes
> +        * containing the uCfgValue ; u8 uCfgValue[uCfgLen] */
> +} __packed;
> +
> +struct wcn36xx_hal_mac_start_parameters {
> +       /* Drive Type - Production or FTM etc */
> +       enum driver_type type;
> +
> +       /* Length of the config buffer */
> +       u32 len;
> +
> +       /* Following this there is a TLV formatted buffer of length
> +        * "len" bytes containing all config values.
> +        * The TLV is expected to be formatted like this:
> +        * 0           15            31           31+CFG_LEN-1        length-1
> +        * |   CFG_ID   |   CFG_LEN   |   CFG_BODY    |  CFG_ID  |......|
> +        */
> +} __packed;
> +
> +struct wcn36xx_hal_mac_start_req_msg {
> +       /* config buffer must start in TLV format just here */
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_mac_start_parameters params;
> +} __packed;
> +
> +struct wcn36xx_hal_mac_start_rsp_params {
> +       /* success or failure */
> +       u16 status;
> +
> +       /* Max number of STA supported by the device */
> +       u8 stations;
> +
> +       /* Max number of BSS supported by the device */
> +       u8 bssids;
> +
> +       /* API Version */
> +       struct wcnss_wlan_version version;
> +
> +       /* CRM build information */
> +       u8 crm_version[WCN36XX_HAL_VERSION_LENGTH];
> +
> +       /* hardware/chipset/misc version information */
> +       u8 wlan_version[WCN36XX_HAL_VERSION_LENGTH];
> +
> +} __packed;
> +
> +struct wcn36xx_hal_mac_start_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_mac_start_rsp_params start_rsp_params;
> +} __packed;
> +
> +struct wcn36xx_hal_mac_stop_req_params {
> +       /* The reason for which the device is being stopped */
> +       enum wcn36xx_hal_stop_type reason;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_mac_stop_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_mac_stop_req_params stop_req_params;
> +} __packed;
> +
> +struct wcn36xx_hal_mac_stop_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +} __packed;
> +
> +struct wcn36xx_hal_update_cfg_req_msg {
> +       /*
> +        * Note: The length specified in tHalUpdateCfgReqMsg messages should be
> +        * header.msgLen = sizeof(tHalUpdateCfgReqMsg) + uConfigBufferLen
> +        */
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Length of the config buffer. Allows UMAC to update multiple CFGs */
> +       u32 len;
> +
> +       /*
> +        * Following this there is a TLV formatted buffer of length
> +        * "uConfigBufferLen" bytes containing all config values.
> +        * The TLV is expected to be formatted like this:
> +        * 0           15            31           31+CFG_LEN-1        length-1
> +        * |   CFG_ID   |   CFG_LEN   |   CFG_BODY    |  CFG_ID  |......|
> +        */
> +
> +} __packed;
> +
> +struct wcn36xx_hal_update_cfg_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +} __packed;
> +
> +/* Frame control field format (2 bytes) */
> +struct wcn36xx_hal_mac_frame_ctl {
> +
> +#ifndef ANI_LITTLE_BIT_ENDIAN
> +
> +       u8 subType:4;
> +       u8 type:2;
> +       u8 protVer:2;
> +
> +       u8 order:1;
> +       u8 wep:1;
> +       u8 moreData:1;
> +       u8 powerMgmt:1;
> +       u8 retry:1;
> +       u8 moreFrag:1;
> +       u8 fromDS:1;
> +       u8 toDS:1;
> +
> +#else
> +
> +       u8 protVer:2;
> +       u8 type:2;
> +       u8 subType:4;
> +
> +       u8 toDS:1;
> +       u8 fromDS:1;
> +       u8 moreFrag:1;
> +       u8 retry:1;
> +       u8 powerMgmt:1;
> +       u8 moreData:1;
> +       u8 wep:1;
> +       u8 order:1;
> +
> +#endif
> +
> +};
> +
> +/* Sequence control field */
> +struct wcn36xx_hal_mac_seq_ctl {
> +       u8 fragNum:4;
> +       u8 seqNumLo:4;
> +       u8 seqNumHi:8;
> +};
> +
> +/* Management header format */
> +struct wcn36xx_hal_mac_mgmt_hdr {
> +       struct wcn36xx_hal_mac_frame_ctl fc;
> +       u8 durationLo;
> +       u8 durationHi;
> +       u8 da[6];
> +       u8 sa[6];
> +       u8 bssId[6];
> +       struct wcn36xx_hal_mac_seq_ctl seqControl;
> +};
> +
> +/* FIXME: pronto v1 apparently has 4 */
> +#define WCN36XX_HAL_NUM_BSSID               2
> +
> +/* Scan Entry to hold active BSS idx's */
> +struct wcn36xx_hal_scan_entry {
> +       u8 bss_index[WCN36XX_HAL_NUM_BSSID];
> +       u8 active_bss_count;
> +};
> +
> +struct wcn36xx_hal_init_scan_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* LEARN - AP Role
> +          SCAN - STA Role */
> +       enum wcn36xx_hal_sys_mode mode;
> +
> +       /* BSSID of the BSS */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* Whether BSS needs to be notified */
> +       u8 notify;
> +
> +       /* Kind of frame to be used for notifying the BSS (Data Null, QoS
> +        * Null, or CTS to Self). Must always be a valid frame type. */
> +       u8 frame_type;
> +
> +       /* UMAC has the option of passing the MAC frame to be used for
> +        * notifying the BSS. If non-zero, HAL will use the MAC frame
> +        * buffer pointed to by macMgmtHdr. If zero, HAL will generate the
> +        * appropriate MAC frame based on frameType. */
> +       u8 frame_len;
> +
> +       /* Following the framelength there is a MAC frame buffer if
> +        * frameLength is non-zero. */
> +       struct wcn36xx_hal_mac_mgmt_hdr mac_mgmt_hdr;
> +
> +       /* Entry to hold number of active BSS idx's */
> +       struct wcn36xx_hal_scan_entry scan_entry;
> +};
> +
> +struct wcn36xx_hal_init_scan_con_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* LEARN - AP Role
> +          SCAN - STA Role */
> +       enum wcn36xx_hal_sys_mode mode;
> +
> +       /* BSSID of the BSS */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* Whether BSS needs to be notified */
> +       u8 notify;
> +
> +       /* Kind of frame to be used for notifying the BSS (Data Null, QoS
> +        * Null, or CTS to Self). Must always be a valid frame type. */
> +       u8 frame_type;
> +
> +       /* UMAC has the option of passing the MAC frame to be used for
> +        * notifying the BSS. If non-zero, HAL will use the MAC frame
> +        * buffer pointed to by macMgmtHdr. If zero, HAL will generate the
> +        * appropriate MAC frame based on frameType. */
> +       u8 frame_length;
> +
> +       /* Following the framelength there is a MAC frame buffer if
> +        * frameLength is non-zero. */
> +       struct wcn36xx_hal_mac_mgmt_hdr mac_mgmt_hdr;
> +
> +       /* Entry to hold number of active BSS idx's */
> +       struct wcn36xx_hal_scan_entry scan_entry;
> +
> +       /* Single NoA usage in Scanning */
> +       u8 use_noa;
> +
> +       /* Indicates the scan duration (in ms) */
> +       u16 scan_duration;
> +
> +};
> +
> +struct wcn36xx_hal_init_scan_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_start_scan_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Indicates the channel to scan */
> +       u8 scan_channel;
> +} __packed;
> +
> +struct wcn36xx_hal_start_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       u32 start_tsf[2];
> +       u8 tx_mgmt_power;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_end_scan_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Indicates the channel to stop scanning. Not used really. But
> +        * retained for symmetry with "start Scan" message. It can also
> +        * help in error check if needed. */
> +       u8 scan_channel;
> +} __packed;
> +
> +struct wcn36xx_hal_end_scan_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +} __packed;
> +
> +struct wcn36xx_hal_finish_scan_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Identifies the operational state of the AP/STA
> +        * LEARN - AP Role SCAN - STA Role */
> +       enum wcn36xx_hal_sys_mode mode;
> +
> +       /* Operating channel to tune to. */
> +       u8 oper_channel;
> +
> +       /* Channel Bonding state If 20/40 MHz is operational, this will
> +        * indicate the 40 MHz extension channel in combination with the
> +        * control channel */
> +       enum phy_chan_bond_state cb_state;
> +
> +       /* BSSID of the BSS */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* Whether BSS needs to be notified */
> +       u8 notify;
> +
> +       /* Kind of frame to be used for notifying the BSS (Data Null, QoS
> +        * Null, or CTS to Self). Must always be a valid frame type. */
> +       u8 frame_type;
> +
> +       /* UMAC has the option of passing the MAC frame to be used for
> +        * notifying the BSS. If non-zero, HAL will use the MAC frame
> +        * buffer pointed to by macMgmtHdr. If zero, HAL will generate the
> +        * appropriate MAC frame based on frameType. */
> +       u8 frame_length;
> +
> +       /* Following the framelength there is a MAC frame buffer if
> +        * frameLength is non-zero. */
> +       struct wcn36xx_hal_mac_mgmt_hdr mac_mgmt_hdr;
> +
> +       /* Entry to hold number of active BSS idx's */
> +       struct wcn36xx_hal_scan_entry scan_entry;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_finish_scan_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +} __packed;
> +
> +enum wcn36xx_hal_rate_index {
> +       HW_RATE_INDEX_1MBPS     = 0x82,
> +       HW_RATE_INDEX_2MBPS     = 0x84,
> +       HW_RATE_INDEX_5_5MBPS   = 0x8B,
> +       HW_RATE_INDEX_6MBPS     = 0x0C,
> +       HW_RATE_INDEX_9MBPS     = 0x12,
> +       HW_RATE_INDEX_11MBPS    = 0x96,
> +       HW_RATE_INDEX_12MBPS    = 0x18,
> +       HW_RATE_INDEX_18MBPS    = 0x24,
> +       HW_RATE_INDEX_24MBPS    = 0x30,
> +       HW_RATE_INDEX_36MBPS    = 0x48,
> +       HW_RATE_INDEX_48MBPS    = 0x60,
> +       HW_RATE_INDEX_54MBPS    = 0x6C
> +};
> +
> +struct wcn36xx_hal_supported_rates {
> +       /*
> +        * For Self STA Entry: this represents Self Mode.
> +        * For Peer Stations, this represents the mode of the peer.
> +        * On Station:
> +        *
> +        * --this mode is updated when PE adds the Self Entry.
> +        *
> +        * -- OR when PE sends 'ADD_BSS' message and station context in BSS
> +        *    is used to indicate the mode of the AP.
> +        *
> +        * ON AP:
> +        *
> +        * -- this mode is updated when PE sends 'ADD_BSS' and Sta entry
> +        *     for that BSS is used to indicate the self mode of the AP.
> +        *
> +        * -- OR when a station is associated, PE sends 'ADD_STA' message
> +        *    with this mode updated.
> +        */
> +
> +       enum sta_rate_mode op_rate_mode;
> +
> +       /* 11b, 11a and aniLegacyRates are IE rates which gives rate in
> +        * unit of 500Kbps */
> +       u16 dsss_rates[WCN36XX_HAL_NUM_DSSS_RATES];
> +       u16 ofdm_rates[WCN36XX_HAL_NUM_OFDM_RATES];
> +       u16 legacy_rates[WCN36XX_HAL_NUM_POLARIS_RATES];
> +       u16 reserved;
> +
> +       /* Taurus only supports 26 Titan Rates(no ESF/concat Rates will be
> +        * supported) First 26 bits are reserved for those Titan rates and
> +        * the last 4 bits(bit28-31) for Taurus, 2(bit26-27) bits are
> +        * reserved. */
> +       /* Titan and Taurus Rates */
> +       u32 enhanced_rate_bitmap;
> +
> +       /*
> +        * 0-76 bits used, remaining reserved
> +        * bits 0-15 and 32 should be set.
> +        */
> +       u8 supported_mcs_set[WCN36XX_HAL_MAC_MAX_SUPPORTED_MCS_SET];
> +
> +       /*
> +        * RX Highest Supported Data Rate defines the highest data
> +        * rate that the STA is able to receive, in unites of 1Mbps.
> +        * This value is derived from "Supported MCS Set field" inside
> +        * the HT capability element.
> +        */
> +       u16 rx_highest_data_rate;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_config_sta_params {
> +       /* BSSID of STA */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* ASSOC ID, as assigned by UMAC */
> +       u16 aid;
> +
> +       /* STA entry Type: 0 - Self, 1 - Other/Peer, 2 - BSSID, 3 - BCAST */
> +       u8 type;
> +
> +       /* Short Preamble Supported. */
> +       u8 short_preamble_supported;
> +
> +       /* MAC Address of STA */
> +       u8 mac[ETH_ALEN];
> +
> +       /* Listen interval of the STA */
> +       u16 listen_interval;
> +
> +       /* Support for 11e/WMM */
> +       u8 wmm_enabled;
> +
> +       /* 11n HT capable STA */
> +       u8 ht_capable;
> +
> +       /* TX Width Set: 0 - 20 MHz only, 1 - 20/40 MHz */
> +       u8 tx_channel_width_set;
> +
> +       /* RIFS mode 0 - NA, 1 - Allowed */
> +       u8 rifs_mode;
> +
> +       /* L-SIG TXOP Protection mechanism
> +          0 - No Support, 1 - Supported
> +          SG - there is global field */
> +       u8 lsig_txop_protection;
> +
> +       /* Max Ampdu Size supported by STA. TPE programming.
> +          0 : 8k , 1 : 16k, 2 : 32k, 3 : 64k */
> +       u8 max_ampdu_size;
> +
> +       /* Max Ampdu density. Used by RA.  3 : 0~7 : 2^(11nAMPDUdensity -4) */
> +       u8 max_ampdu_density;
> +
> +       /* Max AMSDU size 1 : 3839 bytes, 0 : 7935 bytes */
> +       u8 max_amsdu_size;
> +
> +       /* Short GI support for 40Mhz packets */
> +       u8 sgi_40mhz;
> +
> +       /* Short GI support for 20Mhz packets */
> +       u8 sgi_20Mhz;
> +
> +       /* TODO move this parameter to the end for 3680 */
> +       /* These rates are the intersection of peer and self capabilities. */
> +       struct wcn36xx_hal_supported_rates supported_rates;
> +
> +       /* Robust Management Frame (RMF) enabled/disabled */
> +       u8 rmf;
> +
> +       /* The unicast encryption type in the association */
> +       u32 encrypt_type;
> +
> +       /* HAL should update the existing STA entry, if this flag is set. UMAC
> +          will set this flag in case of RE-ASSOC, where we want to reuse the
> +          old STA ID. 0 = Add, 1 = Update */
> +       u8 action;
> +
> +       /* U-APSD Flags: 1b per AC.  Encoded as follows:
> +          b7 b6 b5 b4 b3 b2 b1 b0 =
> +          X  X  X  X  BE BK VI VO */
> +       u8 uapsd;
> +
> +       /* Max SP Length */
> +       u8 max_sp_len;
> +
> +       /* 11n Green Field preamble support
> +          0 - Not supported, 1 - Supported */
> +       u8 green_field_capable;
> +
> +       /* MIMO Power Save mode */
> +       enum wcn36xx_hal_ht_mimo_state mimo_ps;
> +
> +       /* Delayed BA Support */
> +       u8 delayed_ba_support;
> +
> +       /* Max AMPDU duration in 32us */
> +       u8 max_ampdu_duration;
> +
> +       /* HT STA should set it to 1 if it is enabled in BSS. HT STA should
> +        * set it to 0 if AP does not support it. This indication is sent
> +        * to HAL and HAL uses this flag to pickup up appropriate 40Mhz
> +        * rates. */
> +       u8 dsss_cck_mode_40mhz;
> +
> +       /* Valid STA Idx when action=Update. Set to 0xFF when invalid!
> +        * Retained for backward compalibity with existing HAL code */
> +       u8 sta_index;
> +
> +       /* BSSID of BSS to which station is associated. Set to 0xFF when
> +        * invalid. Retained for backward compalibity with existing HAL
> +        * code */
> +       u8 bssid_index;
> +
> +       u8 p2p;
> +
> +       /* TODO add this parameter for 3680. */
> +       /* Reserved to align next field on a dword boundary */
> +       /* u8 reserved; */
> +} __packed;
> +
> +struct wcn36xx_hal_config_sta_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_config_sta_params sta_params;
> +} __packed;
> +
> +struct wcn36xx_hal_config_sta_params_v1 {
> +       /* BSSID of STA */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* ASSOC ID, as assigned by UMAC */
> +       u16 aid;
> +
> +       /* STA entry Type: 0 - Self, 1 - Other/Peer, 2 - BSSID, 3 - BCAST */
> +       u8 type;
> +
> +       /* Short Preamble Supported. */
> +       u8 short_preamble_supported;
> +
> +       /* MAC Address of STA */
> +       u8 mac[ETH_ALEN];
> +
> +       /* Listen interval of the STA */
> +       u16 listen_interval;
> +
> +       /* Support for 11e/WMM */
> +       u8 wmm_enabled;
> +
> +       /* 11n HT capable STA */
> +       u8 ht_capable;
> +
> +       /* TX Width Set: 0 - 20 MHz only, 1 - 20/40 MHz */
> +       u8 tx_channel_width_set;
> +
> +       /* RIFS mode 0 - NA, 1 - Allowed */
> +       u8 rifs_mode;
> +
> +       /* L-SIG TXOP Protection mechanism
> +          0 - No Support, 1 - Supported
> +          SG - there is global field */
> +       u8 lsig_txop_protection;
> +
> +       /* Max Ampdu Size supported by STA. TPE programming.
> +          0 : 8k , 1 : 16k, 2 : 32k, 3 : 64k */
> +       u8 max_ampdu_size;
> +
> +       /* Max Ampdu density. Used by RA.  3 : 0~7 : 2^(11nAMPDUdensity -4) */
> +       u8 max_ampdu_density;
> +
> +       /* Max AMSDU size 1 : 3839 bytes, 0 : 7935 bytes */
> +       u8 max_amsdu_size;
> +
> +       /* Short GI support for 40Mhz packets */
> +       u8 sgi_40mhz;
> +
> +       /* Short GI support for 20Mhz packets */
> +       u8 sgi_20Mhz;
> +
> +       /* Robust Management Frame (RMF) enabled/disabled */
> +       u8 rmf;
> +
> +       /* The unicast encryption type in the association */
> +       u32 encrypt_type;
> +
> +       /* HAL should update the existing STA entry, if this flag is set. UMAC
> +          will set this flag in case of RE-ASSOC, where we want to reuse the
> +          old STA ID. 0 = Add, 1 = Update */
> +       u8 action;
> +
> +       /* U-APSD Flags: 1b per AC.  Encoded as follows:
> +          b7 b6 b5 b4 b3 b2 b1 b0 =
> +          X  X  X  X  BE BK VI VO */
> +       u8 uapsd;
> +
> +       /* Max SP Length */
> +       u8 max_sp_len;
> +
> +       /* 11n Green Field preamble support
> +          0 - Not supported, 1 - Supported */
> +       u8 green_field_capable;
> +
> +       /* MIMO Power Save mode */
> +       enum wcn36xx_hal_ht_mimo_state mimo_ps;
> +
> +       /* Delayed BA Support */
> +       u8 delayed_ba_support;
> +
> +       /* Max AMPDU duration in 32us */
> +       u8 max_ampdu_duration;
> +
> +       /* HT STA should set it to 1 if it is enabled in BSS. HT STA should
> +        * set it to 0 if AP does not support it. This indication is sent
> +        * to HAL and HAL uses this flag to pickup up appropriate 40Mhz
> +        * rates. */
> +       u8 dsss_cck_mode_40mhz;
> +
> +       /* Valid STA Idx when action=Update. Set to 0xFF when invalid!
> +        * Retained for backward compalibity with existing HAL code */
> +       u8 sta_index;
> +
> +       /* BSSID of BSS to which station is associated. Set to 0xFF when
> +        * invalid. Retained for backward compalibity with existing HAL
> +        * code */
> +       u8 bssid_index;
> +
> +       u8 p2p;
> +
> +       /* Reserved to align next field on a dword boundary */
> +       u8 reserved;
> +
> +       /* These rates are the intersection of peer and self capabilities. */
> +       struct wcn36xx_hal_supported_rates supported_rates;
> +} __packed;
> +
> +struct wcn36xx_hal_config_sta_req_msg_v1 {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_config_sta_params_v1 sta_params;
> +} __packed;
> +
> +struct config_sta_rsp_params {
> +       /* success or failure */
> +       u32 status;
> +
> +       /* Station index; valid only when 'status' field value SUCCESS */
> +       u8 sta_index;
> +
> +       /* BSSID Index of BSS to which the station is associated */
> +       u8 bssid_index;
> +
> +       /* DPU Index for PTK */
> +       u8 dpu_index;
> +
> +       /* DPU Index for GTK */
> +       u8 bcast_dpu_index;
> +
> +       /* DPU Index for IGTK  */
> +       u8 bcast_mgmt_dpu_idx;
> +
> +       /* PTK DPU signature */
> +       u8 uc_ucast_sig;
> +
> +       /* GTK DPU isignature */
> +       u8 uc_bcast_sig;
> +
> +       /* IGTK DPU signature */
> +       u8 uc_mgmt_sig;
> +
> +       u8 p2p;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_config_sta_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       struct config_sta_rsp_params params;
> +} __packed;
> +
> +/* Delete STA Request message */
> +struct wcn36xx_hal_delete_sta_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Index of STA to delete */
> +       u8 sta_index;
> +
> +} __packed;
> +
> +/* Delete STA Response message */
> +struct wcn36xx_hal_delete_sta_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       /* Index of STA deleted */
> +       u8 sta_id;
> +} __packed;
> +
> +/* 12 Bytes long because this structure can be used to represent rate and
> + * extended rate set IEs. The parser assume this to be at least 12 */
> +struct wcn36xx_hal_rate_set {
> +       u8 num_rates;
> +       u8 rate[WCN36XX_HAL_MAC_RATESET_EID_MAX];
> +} __packed;
> +
> +/* access category record */
> +struct wcn36xx_hal_aci_aifsn {
> +#ifndef ANI_LITTLE_BIT_ENDIAN
> +       u8 rsvd:1;
> +       u8 aci:2;
> +       u8 acm:1;
> +       u8 aifsn:4;
> +#else
> +       u8 aifsn:4;
> +       u8 acm:1;
> +       u8 aci:2;
> +       u8 rsvd:1;
> +#endif
> +} __packed;
> +
> +/* contention window size */
> +struct wcn36xx_hal_mac_cw {
> +#ifndef ANI_LITTLE_BIT_ENDIAN
> +       u8 max:4;
> +       u8 min:4;
> +#else
> +       u8 min:4;
> +       u8 max:4;
> +#endif
> +} __packed;
> +
> +struct wcn36xx_hal_edca_param_record {
> +       struct wcn36xx_hal_aci_aifsn aci;
> +       struct wcn36xx_hal_mac_cw cw;
> +       u16 txop_limit;
> +} __packed;
> +
> +struct wcn36xx_hal_mac_ssid {
> +       u8 length;
> +       u8 ssid[32];
> +} __packed;
> +
> +/* Concurrency role. These are generic IDs that identify the various roles
> + *  in the software system. */
> +enum wcn36xx_hal_con_mode {
> +       WCN36XX_HAL_STA_MODE = 0,
> +
> +       /* to support softAp mode . This is misleading.
> +          It means AP MODE only. */
> +       WCN36XX_HAL_STA_SAP_MODE = 1,
> +
> +       WCN36XX_HAL_P2P_CLIENT_MODE,
> +       WCN36XX_HAL_P2P_GO_MODE,
> +       WCN36XX_HAL_MONITOR_MODE,
> +};
> +
> +/* This is a bit pattern to be set for each mode
> + * bit 0 - sta mode
> + * bit 1 - ap mode
> + * bit 2 - p2p client mode
> + * bit 3 - p2p go mode */
> +enum wcn36xx_hal_concurrency_mode {
> +       HAL_STA = 1,
> +       HAL_SAP = 2,
> +
> +       /* to support sta, softAp  mode . This means STA+AP mode */
> +       HAL_STA_SAP = 3,
> +
> +       HAL_P2P_CLIENT = 4,
> +       HAL_P2P_GO = 8,
> +       HAL_MAX_CONCURRENCY_PERSONA = 4
> +};
> +
> +struct wcn36xx_hal_config_bss_params {
> +       /* BSSID */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* Self Mac Address */
> +       u8 self_mac_addr[ETH_ALEN];
> +
> +       /* BSS type */
> +       enum wcn36xx_hal_bss_type bss_type;
> +
> +       /* Operational Mode: AP =0, STA = 1 */
> +       u8 oper_mode;
> +
> +       /* Network Type */
> +       enum wcn36xx_hal_nw_type nw_type;
> +
> +       /* Used to classify PURE_11G/11G_MIXED to program MTU */
> +       u8 short_slot_time_supported;
> +
> +       /* Co-exist with 11a STA */
> +       u8 lla_coexist;
> +
> +       /* Co-exist with 11b STA */
> +       u8 llb_coexist;
> +
> +       /* Co-exist with 11g STA */
> +       u8 llg_coexist;
> +
> +       /* Coexistence with 11n STA */
> +       u8 ht20_coexist;
> +
> +       /* Non GF coexist flag */
> +       u8 lln_non_gf_coexist;
> +
> +       /* TXOP protection support */
> +       u8 lsig_tx_op_protection_full_support;
> +
> +       /* RIFS mode */
> +       u8 rifs_mode;
> +
> +       /* Beacon Interval in TU */
> +       u16 beacon_interval;
> +
> +       /* DTIM period */
> +       u8 dtim_period;
> +
> +       /* TX Width Set: 0 - 20 MHz only, 1 - 20/40 MHz */
> +       u8 tx_channel_width_set;
> +
> +       /* Operating channel */
> +       u8 oper_channel;
> +
> +       /* Extension channel for channel bonding */
> +       u8 ext_channel;
> +
> +       /* Reserved to align next field on a dword boundary */
> +       u8 reserved;
> +
> +       /* TODO move sta to the end for 3680 */
> +       /* Context of the station being added in HW
> +        *  Add a STA entry for "itself" -
> +        *
> +        *  On AP  - Add the AP itself in an "STA context"
> +        *
> +        *  On STA - Add the AP to which this STA is joining in an
> +        *  "STA context"
> +        */
> +       struct wcn36xx_hal_config_sta_params sta;
> +       /* SSID of the BSS */
> +       struct wcn36xx_hal_mac_ssid ssid;
> +
> +       /* HAL should update the existing BSS entry, if this flag is set.
> +        * UMAC will set this flag in case of reassoc, where we want to
> +        * resue the the old BSSID and still return success 0 = Add, 1 =
> +        * Update */
> +       u8 action;
> +
> +       /* MAC Rate Set */
> +       struct wcn36xx_hal_rate_set rateset;
> +
> +       /* Enable/Disable HT capabilities of the BSS */
> +       u8 ht;
> +
> +       /* Enable/Disable OBSS protection */
> +       u8 obss_prot_enabled;
> +
> +       /* RMF enabled/disabled */
> +       u8 rmf;
> +
> +       /* HT Operating Mode operating mode of the 802.11n STA */
> +       enum wcn36xx_hal_ht_operating_mode ht_oper_mode;
> +
> +       /* Dual CTS Protection: 0 - Unused, 1 - Used */
> +       u8 dual_cts_protection;
> +
> +       /* Probe Response Max retries */
> +       u8 max_probe_resp_retry_limit;
> +
> +       /* To Enable Hidden ssid */
> +       u8 hidden_ssid;
> +
> +       /* To Enable Disable FW Proxy Probe Resp */
> +       u8 proxy_probe_resp;
> +
> +       /* Boolean to indicate if EDCA params are valid. UMAC might not
> +        * have valid EDCA params or might not desire to apply EDCA params
> +        * during config BSS. 0 implies Not Valid ; Non-Zero implies
> +        * valid */
> +       u8 edca_params_valid;
> +
> +       /* EDCA Parameters for Best Effort Access Category */
> +       struct wcn36xx_hal_edca_param_record acbe;
> +
> +       /* EDCA Parameters forBackground Access Category */
> +       struct wcn36xx_hal_edca_param_record acbk;
> +
> +       /* EDCA Parameters for Video Access Category */
> +       struct wcn36xx_hal_edca_param_record acvi;
> +
> +       /* EDCA Parameters for Voice Access Category */
> +       struct wcn36xx_hal_edca_param_record acvo;
> +
> +       /* Ext Bss Config Msg if set */
> +       u8 ext_set_sta_key_param_valid;
> +
> +       /* SetStaKeyParams for ext bss msg */
> +       struct wcn36xx_hal_set_sta_key_params ext_set_sta_key_param;
> +
> +       /* Persona for the BSS can be STA,AP,GO,CLIENT value same as enum
> +        * wcn36xx_hal_con_mode */
> +       u8 wcn36xx_hal_persona;
> +
> +       u8 spectrum_mgt_enable;
> +
> +       /* HAL fills in the tx power used for mgmt frames in txMgmtPower */
> +       s8 tx_mgmt_power;
> +
> +       /* maxTxPower has max power to be used after applying the power
> +        * constraint if any */
> +       s8 max_tx_power;
> +} __packed;
> +
> +struct wcn36xx_hal_config_bss_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_config_bss_params bss_params;
> +} __packed;
> +
> +struct wcn36xx_hal_config_bss_params_v1 {
> +       /* BSSID */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* Self Mac Address */
> +       u8 self_mac_addr[ETH_ALEN];
> +
> +       /* BSS type */
> +       enum wcn36xx_hal_bss_type bss_type;
> +
> +       /* Operational Mode: AP =0, STA = 1 */
> +       u8 oper_mode;
> +
> +       /* Network Type */
> +       enum wcn36xx_hal_nw_type nw_type;
> +
> +       /* Used to classify PURE_11G/11G_MIXED to program MTU */
> +       u8 short_slot_time_supported;
> +
> +       /* Co-exist with 11a STA */
> +       u8 lla_coexist;
> +
> +       /* Co-exist with 11b STA */
> +       u8 llb_coexist;
> +
> +       /* Co-exist with 11g STA */
> +       u8 llg_coexist;
> +
> +       /* Coexistence with 11n STA */
> +       u8 ht20_coexist;
> +
> +       /* Non GF coexist flag */
> +       u8 lln_non_gf_coexist;
> +
> +       /* TXOP protection support */
> +       u8 lsig_tx_op_protection_full_support;
> +
> +       /* RIFS mode */
> +       u8 rifs_mode;
> +
> +       /* Beacon Interval in TU */
> +       u16 beacon_interval;
> +
> +       /* DTIM period */
> +       u8 dtim_period;
> +
> +       /* TX Width Set: 0 - 20 MHz only, 1 - 20/40 MHz */
> +       u8 tx_channel_width_set;
> +
> +       /* Operating channel */
> +       u8 oper_channel;
> +
> +       /* Extension channel for channel bonding */
> +       u8 ext_channel;
> +
> +       /* Reserved to align next field on a dword boundary */
> +       u8 reserved;
> +
> +       /* SSID of the BSS */
> +       struct wcn36xx_hal_mac_ssid ssid;
> +
> +       /* HAL should update the existing BSS entry, if this flag is set.
> +        * UMAC will set this flag in case of reassoc, where we want to
> +        * resue the the old BSSID and still return success 0 = Add, 1 =
> +        * Update */
> +       u8 action;
> +
> +       /* MAC Rate Set */
> +       struct wcn36xx_hal_rate_set rateset;
> +
> +       /* Enable/Disable HT capabilities of the BSS */
> +       u8 ht;
> +
> +       /* Enable/Disable OBSS protection */
> +       u8 obss_prot_enabled;
> +
> +       /* RMF enabled/disabled */
> +       u8 rmf;
> +
> +       /* HT Operating Mode operating mode of the 802.11n STA */
> +       enum wcn36xx_hal_ht_operating_mode ht_oper_mode;
> +
> +       /* Dual CTS Protection: 0 - Unused, 1 - Used */
> +       u8 dual_cts_protection;
> +
> +       /* Probe Response Max retries */
> +       u8 max_probe_resp_retry_limit;
> +
> +       /* To Enable Hidden ssid */
> +       u8 hidden_ssid;
> +
> +       /* To Enable Disable FW Proxy Probe Resp */
> +       u8 proxy_probe_resp;
> +
> +       /* Boolean to indicate if EDCA params are valid. UMAC might not
> +        * have valid EDCA params or might not desire to apply EDCA params
> +        * during config BSS. 0 implies Not Valid ; Non-Zero implies
> +        * valid */
> +       u8 edca_params_valid;
> +
> +       /* EDCA Parameters for Best Effort Access Category */
> +       struct wcn36xx_hal_edca_param_record acbe;
> +
> +       /* EDCA Parameters forBackground Access Category */
> +       struct wcn36xx_hal_edca_param_record acbk;
> +
> +       /* EDCA Parameters for Video Access Category */
> +       struct wcn36xx_hal_edca_param_record acvi;
> +
> +       /* EDCA Parameters for Voice Access Category */
> +       struct wcn36xx_hal_edca_param_record acvo;
> +
> +       /* Ext Bss Config Msg if set */
> +       u8 ext_set_sta_key_param_valid;
> +
> +       /* SetStaKeyParams for ext bss msg */
> +       struct wcn36xx_hal_set_sta_key_params ext_set_sta_key_param;
> +
> +       /* Persona for the BSS can be STA,AP,GO,CLIENT value same as enum
> +        * wcn36xx_hal_con_mode */
> +       u8 wcn36xx_hal_persona;
> +
> +       u8 spectrum_mgt_enable;
> +
> +       /* HAL fills in the tx power used for mgmt frames in txMgmtPower */
> +       s8 tx_mgmt_power;
> +
> +       /* maxTxPower has max power to be used after applying the power
> +        * constraint if any */
> +       s8 max_tx_power;
> +
> +       /* Context of the station being added in HW
> +        *  Add a STA entry for "itself" -
> +        *
> +        *  On AP  - Add the AP itself in an "STA context"
> +        *
> +        *  On STA - Add the AP to which this STA is joining in an
> +        *  "STA context"
> +        */
> +       struct wcn36xx_hal_config_sta_params_v1 sta;
> +} __packed;
> +
> +struct wcn36xx_hal_config_bss_req_msg_v1 {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_config_bss_params_v1 bss_params;
> +} __packed;
> +
> +struct wcn36xx_hal_config_bss_rsp_params {
> +       /* Success or Failure */
> +       u32 status;
> +
> +       /* BSS index allocated by HAL */
> +       u8 bss_index;
> +
> +       /* DPU descriptor index for PTK */
> +       u8 dpu_desc_index;
> +
> +       /* PTK DPU signature */
> +       u8 ucast_dpu_signature;
> +
> +       /* DPU descriptor index for GTK */
> +       u8 bcast_dpu_desc_indx;
> +
> +       /* GTK DPU signature */
> +       u8 bcast_dpu_signature;
> +
> +       /* DPU descriptor for IGTK */
> +       u8 mgmt_dpu_desc_index;
> +
> +       /* IGTK DPU signature */
> +       u8 mgmt_dpu_signature;
> +
> +       /* Station Index for BSS entry */
> +       u8 bss_sta_index;
> +
> +       /* Self station index for this BSS */
> +       u8 bss_self_sta_index;
> +
> +       /* Bcast station for buffering bcast frames in AP role */
> +       u8 bss_bcast_sta_idx;
> +
> +       /* MAC Address of STA(PEER/SELF) in staContext of configBSSReq */
> +       u8 mac[ETH_ALEN];
> +
> +       /* HAL fills in the tx power used for mgmt frames in this field. */
> +       s8 tx_mgmt_power;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_config_bss_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_config_bss_rsp_params bss_rsp_params;
> +} __packed;
> +
> +struct wcn36xx_hal_delete_bss_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* BSS index to be deleted */
> +       u8 bss_index;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_delete_bss_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Success or Failure */
> +       u32 status;
> +
> +       /* BSS index that has been deleted */
> +       u8 bss_index;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_join_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Indicates the BSSID to which STA is going to associate */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* Indicates the channel to switch to. */
> +       u8 channel;
> +
> +       /* Self STA MAC */
> +       u8 self_sta_mac_addr[ETH_ALEN];
> +
> +       /* Local power constraint */
> +       u8 local_power_constraint;
> +
> +       /* Secondary channel offset */
> +       enum phy_chan_bond_state secondary_channel_offset;
> +
> +       /* link State */
> +       enum wcn36xx_hal_link_state link_state;
> +
> +       /* Max TX power */
> +       s8 max_tx_power;
> +} __packed;
> +
> +struct wcn36xx_hal_join_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       /* HAL fills in the tx power used for mgmt frames in this field */
> +       u8 tx_mgmt_power;
> +} __packed;
> +
> +struct post_assoc_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       struct wcn36xx_hal_config_sta_params sta_params;
> +       struct wcn36xx_hal_config_bss_params bss_params;
> +};
> +
> +struct post_assoc_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct config_sta_rsp_params sta_rsp_params;
> +       struct wcn36xx_hal_config_bss_rsp_params bss_rsp_params;
> +};
> +
> +/* This is used to create a set of WEP keys for a given BSS. */
> +struct wcn36xx_hal_set_bss_key_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* BSS Index of the BSS */
> +       u8 bss_idx;
> +
> +       /* Encryption Type used with peer */
> +       enum ani_ed_type enc_type;
> +
> +       /* Number of keys */
> +       u8 num_keys;
> +
> +       /* Array of keys. */
> +       struct wcn36xx_hal_keys keys[WCN36XX_HAL_MAC_MAX_NUM_OF_DEFAULT_KEYS];
> +
> +       /* Control for Replay Count, 1= Single TID based replay count on Tx
> +        * 0 = Per TID based replay count on TX */
> +       u8 single_tid_rc;
> +} __packed;
> +
> +/* tagged version of set bss key */
> +struct wcn36xx_hal_set_bss_key_req_msg_tagged {
> +       struct wcn36xx_hal_set_bss_key_req_msg Msg;
> +       u32 tag;
> +} __packed;
> +
> +struct wcn36xx_hal_set_bss_key_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +} __packed;
> +
> +/*
> + * This is used  configure the key information on a given station.
> + * When the sec_type is WEP40 or WEP104, the def_wep_idx is used to locate
> + * a preconfigured key from a BSS the station assoicated with; otherwise
> + * a new key descriptor is created based on the key field.
> + */
> +struct wcn36xx_hal_set_sta_key_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_set_sta_key_params set_sta_key_params;
> +} __packed;
> +
> +struct wcn36xx_hal_set_sta_key_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +} __packed;
> +
> +struct wcn36xx_hal_remove_bss_key_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* BSS Index of the BSS */
> +       u8 bss_idx;
> +
> +       /* Encryption Type used with peer */
> +       enum ani_ed_type enc_type;
> +
> +       /* Key Id */
> +       u8 key_id;
> +
> +       /* STATIC/DYNAMIC. Used in Nullifying in Key Descriptors for
> +        * Static/Dynamic keys */
> +       enum ani_wep_type wep_type;
> +} __packed;
> +
> +struct wcn36xx_hal_remove_bss_key_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +} __packed;
> +
> +/*
> + * This is used by PE to Remove the key information on a given station.
> + */
> +struct wcn36xx_hal_remove_sta_key_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* STA Index */
> +       u16 sta_idx;
> +
> +       /* Encryption Type used with peer */
> +       enum ani_ed_type enc_type;
> +
> +       /* Key Id */
> +       u8 key_id;
> +
> +       /* Whether to invalidate the Broadcast key or Unicast key. In case
> +        * of WEP, the same key is used for both broadcast and unicast. */
> +       u8 unicast;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_remove_sta_key_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /*success or failure */
> +       u32 status;
> +
> +} __packed;
> +
> +#ifdef FEATURE_OEM_DATA_SUPPORT
> +
> +#ifndef OEM_DATA_REQ_SIZE
> +#define OEM_DATA_REQ_SIZE 134
> +#endif
> +
> +#ifndef OEM_DATA_RSP_SIZE
> +#define OEM_DATA_RSP_SIZE 1968
> +#endif
> +
> +struct start_oem_data_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u32 status;
> +       tSirMacAddr self_mac_addr;
> +       u8 oem_data_req[OEM_DATA_REQ_SIZE];
> +
> +};
> +
> +struct start_oem_data_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 oem_data_rsp[OEM_DATA_RSP_SIZE];
> +};
> +
> +#endif
> +
> +struct wcn36xx_hal_switch_channel_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Channel number */
> +       u8 channel_number;
> +
> +       /* Local power constraint */
> +       u8 local_power_constraint;
> +
> +       /* Secondary channel offset */
> +       enum phy_chan_bond_state secondary_channel_offset;
> +
> +       /* HAL fills in the tx power used for mgmt frames in this field. */
> +       u8 tx_mgmt_power;
> +
> +       /* Max TX power */
> +       u8 max_tx_power;
> +
> +       /* Self STA MAC */
> +       u8 self_sta_mac_addr[ETH_ALEN];
> +
> +       /* VO WIFI comment: BSSID needed to identify session. As the
> +        * request has power constraints, this should be applied only to
> +        * that session Since MTU timing and EDCA are sessionized, this
> +        * struct needs to be sessionized and bssid needs to be out of the
> +        * VOWifi feature flag V IMP: Keep bssId field at the end of this
> +        * msg. It is used to mantain backward compatbility by way of
> +        * ignoring if using new host/old FW or old host/new FW since it is
> +        * at the end of this struct
> +        */
> +       u8 bssid[ETH_ALEN];
> +} __packed;
> +
> +struct wcn36xx_hal_switch_channel_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Status */
> +       u32 status;
> +
> +       /* Channel number - same as in request */
> +       u8 channel_number;
> +
> +       /* HAL fills in the tx power used for mgmt frames in this field */
> +       u8 tx_mgmt_power;
> +
> +       /* BSSID needed to identify session - same as in request */
> +       u8 bssid[ETH_ALEN];
> +
> +} __packed;
> +
> +struct update_edca_params_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /*BSS Index */
> +       u16 bss_index;
> +
> +       /* Best Effort */
> +       struct wcn36xx_hal_edca_param_record acbe;
> +
> +       /* Background */
> +       struct wcn36xx_hal_edca_param_record acbk;
> +
> +       /* Video */
> +       struct wcn36xx_hal_edca_param_record acvi;
> +
> +       /* Voice */
> +       struct wcn36xx_hal_edca_param_record acvo;
> +};
> +
> +struct update_edca_params_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct dpu_stats_params {
> +       /* Index of STA to which the statistics */
> +       u16 sta_index;
> +
> +       /* Encryption mode */
> +       u8 enc_mode;
> +
> +       /* status */
> +       u32 status;
> +
> +       /* Statistics */
> +       u32 send_blocks;
> +       u32 recv_blocks;
> +       u32 replays;
> +       u8 mic_error_cnt;
> +       u32 prot_excl_cnt;
> +       u16 format_err_cnt;
> +       u16 un_decryptable_cnt;
> +       u32 decrypt_err_cnt;
> +       u32 decrypt_ok_cnt;
> +};
> +
> +struct wcn36xx_hal_stats_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Valid STA Idx for per STA stats request */
> +       u32 sta_id;
> +
> +       /* Categories of stats requested as specified in eHalStatsMask */
> +       u32 stats_mask;
> +};
> +
> +struct ani_summary_stats_info {
> +       /* Total number of packets(per AC) that were successfully
> +        * transmitted with retries */
> +       u32 retry_cnt[4];
> +
> +       /* The number of MSDU packets and MMPDU frames per AC that the
> +        * 802.11 station successfully transmitted after more than one
> +        * retransmission attempt */
> +       u32 multiple_retry_cnt[4];
> +
> +       /* Total number of packets(per AC) that were successfully
> +        * transmitted (with and without retries, including multi-cast,
> +        * broadcast) */
> +       u32 tx_frm_cnt[4];
> +
> +       /* Total number of packets that were successfully received (after
> +        * appropriate filter rules including multi-cast, broadcast) */
> +       u32 rx_frm_cnt;
> +
> +       /* Total number of duplicate frames received successfully */
> +       u32 frm_dup_cnt;
> +
> +       /* Total number packets(per AC) failed to transmit */
> +       u32 fail_cnt[4];
> +
> +       /* Total number of RTS/CTS sequence failures for transmission of a
> +        * packet */
> +       u32 rts_fail_cnt;
> +
> +       /* Total number packets failed transmit because of no ACK from the
> +        * remote entity */
> +       u32 ack_fail_cnt;
> +
> +       /* Total number of RTS/CTS sequence success for transmission of a
> +        * packet */
> +       u32 rts_succ_cnt;
> +
> +       /* The sum of the receive error count and dropped-receive-buffer
> +        * error count. HAL will provide this as a sum of (FCS error) +
> +        * (Fail get BD/PDU in HW) */
> +       u32 rx_discard_cnt;
> +
> +       /*
> +        * The receive error count. HAL will provide the RxP FCS error
> +        * global counter. */
> +       u32 rx_error_cnt;
> +
> +       /* The sum of the transmit-directed byte count, transmit-multicast
> +        * byte count and transmit-broadcast byte count. HAL will sum TPE
> +        * UC/MC/BCAST global counters to provide this. */
> +       u32 tx_byte_cnt;
> +};
> +
> +/* defines tx_rate_flags */
> +enum tx_rate_info {
> +       /* Legacy rates */
> +       HAL_TX_RATE_LEGACY = 0x1,
> +
> +       /* HT20 rates */
> +       HAL_TX_RATE_HT20 = 0x2,
> +
> +       /* HT40 rates */
> +       HAL_TX_RATE_HT40 = 0x4,
> +
> +       /* Rate with Short guard interval */
> +       HAL_TX_RATE_SGI = 0x8,
> +
> +       /* Rate with Long guard interval */
> +       HAL_TX_RATE_LGI = 0x10
> +};
> +
> +struct ani_global_class_a_stats_info {
> +       /* The number of MPDU frames received by the 802.11 station for
> +        * MSDU packets or MMPDU frames */
> +       u32 rx_frag_cnt;
> +
> +       /* The number of MPDU frames received by the 802.11 station for
> +        * MSDU packets or MMPDU frames when a promiscuous packet filter
> +        * was enabled */
> +       u32 promiscuous_rx_frag_cnt;
> +
> +       /* The receiver input sensitivity referenced to a FER of 8% at an
> +        * MPDU length of 1024 bytes at the antenna connector. Each element
> +        * of the array shall correspond to a supported rate and the order
> +        * shall be the same as the supporteRates parameter. */
> +       u32 rx_input_sensitivity;
> +
> +       /* The maximum transmit power in dBm upto one decimal. for eg: if
> +        * it is 10.5dBm, the value would be 105 */
> +       u32 max_pwr;
> +
> +       /* Number of times the receiver failed to synchronize with the
> +        * incoming signal after detecting the sync in the preamble of the
> +        * transmitted PLCP protocol data unit. */
> +       u32 sync_fail_cnt;
> +
> +       /* Legacy transmit rate, in units of 500 kbit/sec, for the most
> +        * recently transmitted frame */
> +       u32 tx_rate;
> +
> +       /* mcs index for HT20 and HT40 rates */
> +       u32 mcs_index;
> +
> +       /* to differentiate between HT20 and HT40 rates; short and long
> +        * guard interval */
> +       u32 tx_rate_flags;
> +};
> +
> +struct ani_global_security_stats {
> +       /* The number of unencrypted received MPDU frames that the MAC
> +        * layer discarded when the IEEE 802.11 dot11ExcludeUnencrypted
> +        * management information base (MIB) object is enabled */
> +       u32 rx_wep_unencrypted_frm_cnt;
> +
> +       /* The number of received MSDU packets that that the 802.11 station
> +        * discarded because of MIC failures */
> +       u32 rx_mic_fail_cnt;
> +
> +       /* The number of encrypted MPDU frames that the 802.11 station
> +        * failed to decrypt because of a TKIP ICV error */
> +       u32 tkip_icv_err;
> +
> +       /* The number of received MPDU frames that the 802.11 discarded
> +        * because of an invalid AES-CCMP format */
> +       u32 aes_ccmp_format_err;
> +
> +       /* The number of received MPDU frames that the 802.11 station
> +        * discarded because of the AES-CCMP replay protection procedure */
> +       u32 aes_ccmp_replay_cnt;
> +
> +       /* The number of received MPDU frames that the 802.11 station
> +        * discarded because of errors detected by the AES-CCMP decryption
> +        * algorithm */
> +       u32 aes_ccmp_decrpt_err;
> +
> +       /* The number of encrypted MPDU frames received for which a WEP
> +        * decryption key was not available on the 802.11 station */
> +       u32 wep_undecryptable_cnt;
> +
> +       /* The number of encrypted MPDU frames that the 802.11 station
> +        * failed to decrypt because of a WEP ICV error */
> +       u32 wep_icv_err;
> +
> +       /* The number of received encrypted packets that the 802.11 station
> +        * successfully decrypted */
> +       u32 rx_decrypt_succ_cnt;
> +
> +       /* The number of encrypted packets that the 802.11 station failed
> +        * to decrypt */
> +       u32 rx_decrypt_fail_cnt;
> +};
> +
> +struct ani_global_class_b_stats_info {
> +       struct ani_global_security_stats uc_stats;
> +       struct ani_global_security_stats mc_bc_stats;
> +};
> +
> +struct ani_global_class_c_stats_info {
> +       /* This counter shall be incremented for a received A-MSDU frame
> +        * with the stations MAC address in the address 1 field or an
> +        * A-MSDU frame with a group address in the address 1 field */
> +       u32 rx_amsdu_cnt;
> +
> +       /* This counter shall be incremented when the MAC receives an AMPDU
> +        * from the PHY */
> +       u32 rx_ampdu_cnt;
> +
> +       /* This counter shall be incremented when a Frame is transmitted
> +        * only on the primary channel */
> +       u32 tx_20_frm_cnt;
> +
> +       /* This counter shall be incremented when a Frame is received only
> +        * on the primary channel */
> +       u32 rx_20_frm_cnt;
> +
> +       /* This counter shall be incremented by the number of MPDUs
> +        * received in the A-MPDU when an A-MPDU is received */
> +       u32 rx_mpdu_in_ampdu_cnt;
> +
> +       /* This counter shall be incremented when an MPDU delimiter has a
> +        * CRC error when this is the first CRC error in the received AMPDU
> +        * or when the previous delimiter has been decoded correctly */
> +       u32 ampdu_delimiter_crc_err;
> +};
> +
> +struct ani_per_sta_stats_info {
> +       /* The number of MPDU frames that the 802.11 station transmitted
> +        * and acknowledged through a received 802.11 ACK frame */
> +       u32 tx_frag_cnt[4];
> +
> +       /* This counter shall be incremented when an A-MPDU is transmitted */
> +       u32 tx_ampdu_cnt;
> +
> +       /* This counter shall increment by the number of MPDUs in the AMPDU
> +        * when an A-MPDU is transmitted */
> +       u32 tx_mpdu_in_ampdu_cnt;
> +};
> +
> +struct wcn36xx_hal_stats_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Success or Failure */
> +       u32 status;
> +
> +       /* STA Idx */
> +       u32 sta_index;
> +
> +       /* Categories of STATS being returned as per eHalStatsMask */
> +       u32 stats_mask;
> +
> +       /* message type is same as the request type */
> +       u16 msg_type;
> +
> +       /* length of the entire request, includes the pStatsBuf length too */
> +       u16 msg_len;
> +};
> +
> +struct wcn36xx_hal_set_link_state_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 bssid[ETH_ALEN];
> +       enum wcn36xx_hal_link_state state;
> +       u8 self_mac_addr[ETH_ALEN];
> +
> +} __packed;
> +
> +struct set_link_state_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +/* TSPEC Params */
> +struct wcn36xx_hal_ts_info_tfc {
> +#ifndef ANI_LITTLE_BIT_ENDIAN
> +       u16 ackPolicy:2;
> +       u16 userPrio:3;
> +       u16 psb:1;
> +       u16 aggregation:1;
> +       u16 accessPolicy:2;
> +       u16 direction:2;
> +       u16 tsid:4;
> +       u16 trafficType:1;
> +#else
> +       u16 trafficType:1;
> +       u16 tsid:4;
> +       u16 direction:2;
> +       u16 accessPolicy:2;
> +       u16 aggregation:1;
> +       u16 psb:1;
> +       u16 userPrio:3;
> +       u16 ackPolicy:2;
> +#endif
> +};
> +
> +/* Flag to schedule the traffic type */
> +struct wcn36xx_hal_ts_info_sch {
> +#ifndef ANI_LITTLE_BIT_ENDIAN
> +       u8 rsvd:7;
> +       u8 schedule:1;
> +#else
> +       u8 schedule:1;
> +       u8 rsvd:7;
> +#endif
> +};
> +
> +/* Traffic and scheduling info */
> +struct wcn36xx_hal_ts_info {
> +       struct wcn36xx_hal_ts_info_tfc traffic;
> +       struct wcn36xx_hal_ts_info_sch schedule;
> +};
> +
> +/* Information elements */
> +struct wcn36xx_hal_tspec_ie {
> +       u8 type;
> +       u8 length;
> +       struct wcn36xx_hal_ts_info ts_info;
> +       u16 nom_msdu_size;
> +       u16 max_msdu_size;
> +       u32 min_svc_interval;
> +       u32 max_svc_interval;
> +       u32 inact_interval;
> +       u32 suspend_interval;
> +       u32 svc_start_time;
> +       u32 min_data_rate;
> +       u32 mean_data_rate;
> +       u32 peak_data_rate;
> +       u32 max_burst_sz;
> +       u32 delay_bound;
> +       u32 min_phy_rate;
> +       u16 surplus_bw;
> +       u16 medium_time;
> +};
> +
> +struct add_ts_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Station Index */
> +       u16 sta_index;
> +
> +       /* TSPEC handler uniquely identifying a TSPEC for a STA in a BSS */
> +       u16 tspec_index;
> +
> +       /* To program TPE with required parameters */
> +       struct wcn36xx_hal_tspec_ie tspec;
> +
> +       /* U-APSD Flags: 1b per AC.  Encoded as follows:
> +          b7 b6 b5 b4 b3 b2 b1 b0 =
> +          X  X  X  X  BE BK VI VO */
> +       u8 uapsd;
> +
> +       /* These parameters are for all the access categories */
> +
> +       /* Service Interval */
> +       u32 service_interval[WCN36XX_HAL_MAX_AC];
> +
> +       /* Suspend Interval */
> +       u32 suspend_interval[WCN36XX_HAL_MAX_AC];
> +
> +       /* Delay Interval */
> +       u32 delay_interval[WCN36XX_HAL_MAX_AC];
> +};
> +
> +struct add_rs_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct del_ts_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Station Index */
> +       u16 sta_index;
> +
> +       /* TSPEC identifier uniquely identifying a TSPEC for a STA in a BSS */
> +       u16 tspec_index;
> +
> +       /* To lookup station id using the mac address */
> +       u8 bssid[ETH_ALEN];
> +};
> +
> +struct del_ts_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +/* End of TSpec Parameters */
> +
> +/* Start of BLOCK ACK related Parameters */
> +
> +struct wcn36xx_hal_add_ba_session_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Station Index */
> +       u16 sta_index;
> +
> +       /* Peer MAC Address */
> +       u8 mac_addr[ETH_ALEN];
> +
> +       /* ADDBA Action Frame dialog token
> +          HAL will not interpret this object */
> +       u8 dialog_token;
> +
> +       /* TID for which the BA is being setup
> +          This identifies the TC or TS of interest */
> +       u8 tid;
> +
> +       /* 0 - Delayed BA (Not supported)
> +          1 - Immediate BA */
> +       u8 policy;
> +
> +       /* Indicates the number of buffers for this TID (baTID)
> +          NOTE - This is the requested buffer size. When this
> +          is processed by HAL and subsequently by HDD, it is
> +          possible that HDD may change this buffer size. Any
> +          change in the buffer size should be noted by PE and
> +          advertized appropriately in the ADDBA response */
> +       u16 buffer_size;
> +
> +       /* BA timeout in TU's 0 means no timeout will occur */
> +       u16 timeout;
> +
> +       /* b0..b3 - Fragment Number - Always set to 0
> +          b4..b15 - Starting Sequence Number of first MSDU
> +          for which this BA is setup */
> +       u16 ssn;
> +
> +       /* ADDBA direction
> +          1 - Originator
> +          0 - Recipient */
> +       u8 direction;
> +} __packed;
> +
> +struct wcn36xx_hal_add_ba_session_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       /* Dialog token */
> +       u8 dialog_token;
> +
> +       /* TID for which the BA session has been setup */
> +       u8 ba_tid;
> +
> +       /* BA Buffer Size allocated for the current BA session */
> +       u8 ba_buffer_size;
> +
> +       u8 ba_session_id;
> +
> +       /* Reordering Window buffer */
> +       u8 win_size;
> +
> +       /* Station Index to id the sta */
> +       u8 sta_index;
> +
> +       /* Starting Sequence Number */
> +       u16 ssn;
> +} __packed;
> +
> +struct wcn36xx_hal_add_ba_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Session Id */
> +       u8 session_id;
> +
> +       /* Reorder Window Size */
> +       u8 win_size;
> +/* Old FW 1.2.2.4 does not support this*/
> +#ifdef FEATURE_ON_CHIP_REORDERING
> +       u8 reordering_done_on_chip;
> +#endif
> +} __packed;
> +
> +struct wcn36xx_hal_add_ba_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       /* Dialog token */
> +       u8 dialog_token;
> +} __packed;
> +
> +struct add_ba_info {
> +       u16 ba_enable:1;
> +       u16 starting_seq_num:12;
> +       u16 reserved:3;
> +};
> +
> +struct wcn36xx_hal_trigger_ba_rsp_candidate {
> +       u8 sta_addr[ETH_ALEN];
> +       struct add_ba_info ba_info[STACFG_MAX_TC];
> +} __packed;
> +
> +struct wcn36xx_hal_trigget_ba_req_candidate {
> +       u8 sta_index;
> +       u8 tid_bitmap;
> +} __packed;
> +
> +struct wcn36xx_hal_trigger_ba_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Session Id */
> +       u8 session_id;
> +
> +       /* baCandidateCnt is followed by trigger BA
> +        * Candidate List(tTriggerBaCandidate)
> +        */
> +       u16 candidate_cnt;
> +
> +} __packed;
> +
> +struct wcn36xx_hal_trigger_ba_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* TO SUPPORT BT-AMP */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       /* baCandidateCnt is followed by trigger BA
> +        * Rsp Candidate List(tTriggerRspBaCandidate)
> +        */
> +       u16 candidate_cnt;
> +} __packed;
> +
> +struct wcn36xx_hal_del_ba_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Station Index */
> +       u16 sta_index;
> +
> +       /* TID for which the BA session is being deleted */
> +       u8 tid;
> +
> +       /* DELBA direction
> +          1 - Originator
> +          0 - Recipient */
> +       u8 direction;
> +} __packed;
> +
> +struct wcn36xx_hal_del_ba_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +} __packed;
> +
> +struct tsm_stats_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Traffic Id */
> +       u8 tid;
> +
> +       u8 bssid[ETH_ALEN];
> +};
> +
> +struct tsm_stats_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /*success or failure */
> +       u32 status;
> +
> +       /* Uplink Packet Queue delay */
> +       u16 uplink_pkt_queue_delay;
> +
> +       /* Uplink Packet Queue delay histogram */
> +       u16 uplink_pkt_queue_delay_hist[4];
> +
> +       /* Uplink Packet Transmit delay */
> +       u32 uplink_pkt_tx_delay;
> +
> +       /* Uplink Packet loss */
> +       u16 uplink_pkt_loss;
> +
> +       /* Uplink Packet count */
> +       u16 uplink_pkt_count;
> +
> +       /* Roaming count */
> +       u8 roaming_count;
> +
> +       /* Roaming Delay */
> +       u16 roaming_delay;
> +};
> +
> +struct set_key_done_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /*bssid of the keys */
> +       u8 bssidx;
> +       u8 enc_type;
> +};
> +
> +struct wcn36xx_hal_nv_img_download_req_msg {
> +       /* Note: The length specified in wcn36xx_hal_nv_img_download_req_msg
> +        * messages should be
> +        * header.len = sizeof(wcn36xx_hal_nv_img_download_req_msg) +
> +        * nv_img_buffer_size */
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Fragment sequence number of the NV Image. Note that NV Image
> +        * might not fit into one message due to size limitation of the SMD
> +        * channel FIFO. UMAC can hence choose to chop the NV blob into
> +        * multiple fragments starting with seqeunce number 0, 1, 2 etc.
> +        * The last fragment MUST be indicated by marking the
> +        * isLastFragment field to 1. Note that all the NV blobs would be
> +        * concatenated together by HAL without any padding bytes in
> +        * between.*/
> +       u16 frag_number;
> +
> +       /* Is this the last fragment? When set to 1 it indicates that no
> +        * more fragments will be sent by UMAC and HAL can concatenate all
> +        * the NV blobs rcvd & proceed with the parsing. HAL would generate
> +        * a WCN36XX_HAL_DOWNLOAD_NV_RSP to the WCN36XX_HAL_DOWNLOAD_NV_REQ
> +        * after it receives each fragment */
> +       u16 last_fragment;
> +
> +       /* NV Image size (number of bytes) */
> +       u32 nv_img_buffer_size;
> +
> +       /* Following the 'nv_img_buffer_size', there should be
> +        * nv_img_buffer_size bytes of NV Image i.e.
> +        * u8[nv_img_buffer_size] */
> +} __packed;
> +
> +struct wcn36xx_hal_nv_img_download_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Success or Failure. HAL would generate a
> +        * WCN36XX_HAL_DOWNLOAD_NV_RSP after each fragment */
> +       u32 status;
> +} __packed;
> +
> +struct wcn36xx_hal_nv_store_ind {
> +       /* Note: The length specified in tHalNvStoreInd messages should be
> +        * header.msgLen = sizeof(tHalNvStoreInd) + nvBlobSize */
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* NV Item */
> +       u32 table_id;
> +
> +       /* Size of NV Blob */
> +       u32 nv_blob_size;
> +
> +       /* Following the 'nvBlobSize', there should be nvBlobSize bytes of
> +        * NV blob i.e. u8[nvBlobSize] */
> +};
> +
> +/* End of Block Ack Related Parameters */
> +
> +#define WCN36XX_HAL_CIPHER_SEQ_CTR_SIZE 6
> +
> +/* Definition for MIC failure indication MAC reports this each time a MIC
> + * failure occures on Rx TKIP packet
> + */
> +struct mic_failure_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 bssid[ETH_ALEN];
> +
> +       /* address used to compute MIC */
> +       u8 src_addr[ETH_ALEN];
> +
> +       /* transmitter address */
> +       u8 ta_addr[ETH_ALEN];
> +
> +       u8 dst_addr[ETH_ALEN];
> +
> +       u8 multicast;
> +
> +       /* first byte of IV */
> +       u8 iv1;
> +
> +       /* second byte of IV */
> +       u8 key_id;
> +
> +       /* sequence number */
> +       u8 tsc[WCN36XX_HAL_CIPHER_SEQ_CTR_SIZE];
> +
> +       /* receive address */
> +       u8 rx_addr[ETH_ALEN];
> +};
> +
> +struct update_vht_op_mode_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u16 op_mode;
> +       u16 sta_id;
> +};
> +
> +struct update_vht_op_mode_params_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u32 status;
> +};
> +
> +struct update_beacon_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 bss_index;
> +
> +       /* shortPreamble mode. HAL should update all the STA rates when it
> +        * receives this message */
> +       u8 short_preamble;
> +
> +       /* short Slot time. */
> +       u8 short_slot_time;
> +
> +       /* Beacon Interval */
> +       u16 beacon_interval;
> +
> +       /* Protection related */
> +       u8 lla_coexist;
> +       u8 llb_coexist;
> +       u8 llg_coexist;
> +       u8 ht20_coexist;
> +       u8 lln_non_gf_coexist;
> +       u8 lsig_tx_op_protection_full_support;
> +       u8 rifs_mode;
> +
> +       u16 param_change_bitmap;
> +};
> +
> +struct update_beacon_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_send_beacon_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* length of the template. */
> +       u32 beacon_length;
> +
> +       /* Beacon data. */
> +       u8 beacon[BEACON_TEMPLATE_SIZE];
> +
> +       u8 bssid[ETH_ALEN];
> +
> +       /* TIM IE offset from the beginning of the template. */
> +       u32 tim_ie_offset;
> +
> +       /* P2P IE offset from the begining of the template */
> +       u16 p2p_ie_offset;
> +} __packed;
> +
> +struct send_beacon_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       u32 status;
> +} __packed;
> +
> +struct enable_radar_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 bssid[ETH_ALEN];
> +       u8 channel;
> +};
> +
> +struct enable_radar_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Link Parameters */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct radar_detect_intr_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 radar_det_channel;
> +};
> +
> +struct radar_detect_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* channel number in which the RADAR detected */
> +       u8 channel_number;
> +
> +       /* RADAR pulse width in usecond */
> +       u16 radar_pulse_width;
> +
> +       /* Number of RADAR pulses */
> +       u16 num_radar_pulse;
> +};
> +
> +struct wcn36xx_hal_get_tpc_report_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 sta[ETH_ALEN];
> +       u8 dialog_token;
> +       u8 txpower;
> +};
> +
> +struct wcn36xx_hal_get_tpc_report_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_send_probe_resp_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 probe_resp_template[BEACON_TEMPLATE_SIZE];
> +       u32 probe_resp_template_len;
> +       u32 proxy_probe_req_valid_ie_bmap[8];
> +       u8 bssid[ETH_ALEN];
> +};
> +
> +struct send_probe_resp_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct send_unknown_frame_rx_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_delete_sta_context_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u16 aid;
> +       u16 sta_id;
> +
> +       /* TO SUPPORT BT-AMP */
> +       u8 bssid[ETH_ALEN];
> +
> +       /* HAL copies bssid from the sta table. */
> +       u8 addr2[ETH_ALEN];
> +
> +       /* To unify the keepalive / unknown A2 / tim-based disa */
> +       u16 reason_code;
> +} __packed;
> +
> +struct indicate_del_sta {
> +       struct wcn36xx_hal_msg_header header;
> +       u8 aid;
> +       u8 sta_index;
> +       u8 bss_index;
> +       u8 reason_code;
> +       u32 status;
> +};
> +
> +struct bt_amp_event_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       enum bt_amp_event_type btAmpEventType;
> +};
> +
> +struct bt_amp_event_rsp {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct tl_hal_flush_ac_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Station Index. originates from HAL */
> +       u8 sta_id;
> +
> +       /* TID for which the transmit queue is being flushed */
> +       u8 tid;
> +};
> +
> +struct tl_hal_flush_ac_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Station Index. originates from HAL */
> +       u8 sta_id;
> +
> +       /* TID for which the transmit queue is being flushed */
> +       u8 tid;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_enter_imps_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +};
> +
> +struct wcn36xx_hal_exit_imps_req {
> +       struct wcn36xx_hal_msg_header header;
> +};
> +
> +struct wcn36xx_hal_enter_bmps_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 bss_index;
> +
> +       /* TBTT value derived from the last beacon */
> +#ifndef BUILD_QWPTTSTATIC
> +       u64 tbtt;
> +#endif
> +       u8 dtim_count;
> +
> +       /* DTIM period given to HAL during association may not be valid, if
> +        * association is based on ProbeRsp instead of beacon. */
> +       u8 dtim_period;
> +
> +       /* For CCX and 11R Roaming */
> +       u32 rssi_filter_period;
> +
> +       u32 num_beacon_per_rssi_average;
> +       u8 rssi_filter_enable;
> +} __packed;
> +
> +struct wcn36xx_hal_exit_bmps_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 send_data_null;
> +       u8 bss_index;
> +} __packed;
> +
> +struct wcn36xx_hal_missed_beacon_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 bss_index;
> +} __packed;
> +
> +/* Beacon Filtering data structures */
> +
> +/* The above structure would be followed by multiple of below mentioned
> + * structure
> + */
> +struct beacon_filter_ie {
> +       u8 element_id;
> +       u8 check_ie_presence;
> +       u8 offset;
> +       u8 value;
> +       u8 bitmask;
> +       u8 ref;
> +};
> +
> +struct wcn36xx_hal_add_bcn_filter_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u16 capability_info;
> +       u16 capability_mask;
> +       u16 beacon_interval;
> +       u16 ie_num;
> +       u8 bss_index;
> +       u8 reserved;
> +};
> +
> +struct wcn36xx_hal_rem_bcn_filter_req {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 ie_Count;
> +       u8 rem_ie_id[1];
> +};
> +
> +#define WCN36XX_HAL_IPV4_ARP_REPLY_OFFLOAD                  0
> +#define WCN36XX_HAL_IPV6_NEIGHBOR_DISCOVERY_OFFLOAD         1
> +#define WCN36XX_HAL_IPV6_NS_OFFLOAD                         2
> +#define WCN36XX_HAL_IPV6_ADDR_LEN                           16
> +#define WCN36XX_HAL_OFFLOAD_DISABLE                         0
> +#define WCN36XX_HAL_OFFLOAD_ENABLE                          1
> +#define WCN36XX_HAL_OFFLOAD_BCAST_FILTER_ENABLE             0x2
> +#define WCN36XX_HAL_OFFLOAD_ARP_AND_BCAST_FILTER_ENABLE        \
> +       (HAL_OFFLOAD_ENABLE|HAL_OFFLOAD_BCAST_FILTER_ENABLE)
> +
> +struct wcn36xx_hal_ns_offload_params {
> +       u8 src_ipv6_addr[WCN36XX_HAL_IPV6_ADDR_LEN];
> +       u8 self_ipv6_addr[WCN36XX_HAL_IPV6_ADDR_LEN];
> +
> +       /* Only support 2 possible Network Advertisement IPv6 address */
> +       u8 target_ipv6_addr1[WCN36XX_HAL_IPV6_ADDR_LEN];
> +       u8 target_ipv6_addr2[WCN36XX_HAL_IPV6_ADDR_LEN];
> +
> +       u8 self_addr[ETH_ALEN];
> +       u8 src_ipv6_addr_valid:1;
> +       u8 target_ipv6_addr1_valid:1;
> +       u8 target_ipv6_addr2_valid:1;
> +       u8 reserved1:5;
> +
> +       /* make it DWORD aligned */
> +       u8 reserved2;
> +
> +       /* slot index for this offload */
> +       u32 slot_index;
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_host_offload_req {
> +       u8 offload_Type;
> +
> +       /* enable or disable */
> +       u8 enable;
> +
> +       union {
> +               u8 host_ipv4_addr[4];
> +               u8 host_ipv6_addr[WCN36XX_HAL_IPV6_ADDR_LEN];
> +       } u;
> +};
> +
> +struct wcn36xx_hal_host_offload_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_host_offload_req host_offload_params;
> +       struct wcn36xx_hal_ns_offload_params ns_offload_params;
> +};
> +
> +/* Packet Types. */
> +#define WCN36XX_HAL_KEEP_ALIVE_NULL_PKT              1
> +#define WCN36XX_HAL_KEEP_ALIVE_UNSOLICIT_ARP_RSP     2
> +
> +/* Enable or disable keep alive */
> +#define WCN36XX_HAL_KEEP_ALIVE_DISABLE   0
> +#define WCN36XX_HAL_KEEP_ALIVE_ENABLE    1
> +#define WCN36XX_KEEP_ALIVE_TIME_PERIOD  30 /* unit: s */
> +
> +/* Keep Alive request. */
> +struct wcn36xx_hal_keep_alive_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 packet_type;
> +       u32 time_period;
> +       u8 host_ipv4_addr[WCN36XX_HAL_IPV4_ADDR_LEN];
> +       u8 dest_ipv4_addr[WCN36XX_HAL_IPV4_ADDR_LEN];
> +       u8 dest_addr[ETH_ALEN];
> +       u8 bss_index;
> +} __packed;
> +
> +struct wcn36xx_hal_rssi_threshold_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       s8 threshold1:8;
> +       s8 threshold2:8;
> +       s8 threshold3:8;
> +       u8 thres1_pos_notify:1;
> +       u8 thres1_neg_notify:1;
> +       u8 thres2_pos_notify:1;
> +       u8 thres2_neg_notify:1;
> +       u8 thres3_pos_notify:1;
> +       u8 thres3_neg_notify:1;
> +       u8 reserved10:2;
> +};
> +
> +struct wcn36xx_hal_enter_uapsd_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 bk_delivery:1;
> +       u8 be_delivery:1;
> +       u8 vi_delivery:1;
> +       u8 vo_delivery:1;
> +       u8 bk_trigger:1;
> +       u8 be_trigger:1;
> +       u8 vi_trigger:1;
> +       u8 vo_trigger:1;
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_exit_uapsd_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       u8 bss_index;
> +};
> +
> +#define WCN36XX_HAL_WOWL_BCAST_PATTERN_MAX_SIZE 128
> +#define WCN36XX_HAL_WOWL_BCAST_MAX_NUM_PATTERNS 16
> +
> +struct wcn36xx_hal_wowl_add_bcast_ptrn_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Pattern ID */
> +       u8 id;
> +
> +       /* Pattern byte offset from beginning of the 802.11 packet to start
> +        * of the wake-up pattern */
> +       u8 byte_Offset;
> +
> +       /* Non-Zero Pattern size */
> +       u8 size;
> +
> +       /* Pattern */
> +       u8 pattern[WCN36XX_HAL_WOWL_BCAST_PATTERN_MAX_SIZE];
> +
> +       /* Non-zero pattern mask size */
> +       u8 mask_size;
> +
> +       /* Pattern mask */
> +       u8 mask[WCN36XX_HAL_WOWL_BCAST_PATTERN_MAX_SIZE];
> +
> +       /* Extra pattern */
> +       u8 extra[WCN36XX_HAL_WOWL_BCAST_PATTERN_MAX_SIZE];
> +
> +       /* Extra pattern mask */
> +       u8 mask_extra[WCN36XX_HAL_WOWL_BCAST_PATTERN_MAX_SIZE];
> +
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_wow_del_bcast_ptrn_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Pattern ID of the wakeup pattern to be deleted */
> +       u8 id;
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_wowl_enter_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Enables/disables magic packet filtering */
> +       u8 magic_packet_enable;
> +
> +       /* Magic pattern */
> +       u8 magic_pattern[ETH_ALEN];
> +
> +       /* Enables/disables packet pattern filtering in firmware. Enabling
> +        * this flag enables broadcast pattern matching in Firmware. If
> +        * unicast pattern matching is also desired,
> +        * ucUcastPatternFilteringEnable flag must be set tot true as well
> +        */
> +       u8 pattern_filtering_enable;
> +
> +       /* Enables/disables unicast packet pattern filtering. This flag
> +        * specifies whether we want to do pattern match on unicast packets
> +        * as well and not just broadcast packets. This flag has no effect
> +        * if the ucPatternFilteringEnable (main controlling flag) is set
> +        * to false
> +        */
> +       u8 ucast_pattern_filtering_enable;
> +
> +       /* This configuration is valid only when magicPktEnable=1. It
> +        * requests hardware to wake up when it receives the Channel Switch
> +        * Action Frame.
> +        */
> +       u8 wow_channel_switch_receive;
> +
> +       /* This configuration is valid only when magicPktEnable=1. It
> +        * requests hardware to wake up when it receives the
> +        * Deauthentication Frame.
> +        */
> +       u8 wow_deauth_receive;
> +
> +       /* This configuration is valid only when magicPktEnable=1. It
> +        * requests hardware to wake up when it receives the Disassociation
> +        * Frame.
> +        */
> +       u8 wow_disassoc_receive;
> +
> +       /* This configuration is valid only when magicPktEnable=1. It
> +        * requests hardware to wake up when it has missed consecutive
> +        * beacons. This is a hardware register configuration (NOT a
> +        * firmware configuration).
> +        */
> +       u8 wow_max_missed_beacons;
> +
> +       /* This configuration is valid only when magicPktEnable=1. This is
> +        * a timeout value in units of microsec. It requests hardware to
> +        * unconditionally wake up after it has stayed in WoWLAN mode for
> +        * some time. Set 0 to disable this feature.
> +        */
> +       u8 wow_max_sleep;
> +
> +       /* This configuration directs the WoW packet filtering to look for
> +        * EAP-ID requests embedded in EAPOL frames and use this as a wake
> +        * source.
> +        */
> +       u8 wow_eap_id_request_enable;
> +
> +       /* This configuration directs the WoW packet filtering to look for
> +        * EAPOL-4WAY requests and use this as a wake source.
> +        */
> +       u8 wow_eapol_4way_enable;
> +
> +       /* This configuration allows a host wakeup on an network scan
> +        * offload match.
> +        */
> +       u8 wow_net_scan_offload_match;
> +
> +       /* This configuration allows a host wakeup on any GTK rekeying
> +        * error.
> +        */
> +       u8 wow_gtk_rekey_error;
> +
> +       /* This configuration allows a host wakeup on BSS connection loss.
> +        */
> +       u8 wow_bss_connection_loss;
> +
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_wowl_exit_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_get_rssi_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +};
> +
> +struct wcn36xx_hal_get_roam_rssi_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Valid STA Idx for per STA stats request */
> +       u32 sta_id;
> +};
> +
> +struct wcn36xx_hal_set_uapsd_ac_params_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* STA index */
> +       u8 sta_idx;
> +
> +       /* Access Category */
> +       u8 ac;
> +
> +       /* User Priority */
> +       u8 up;
> +
> +       /* Service Interval */
> +       u32 service_interval;
> +
> +       /* Suspend Interval */
> +       u32 suspend_interval;
> +
> +       /* Delay Interval */
> +       u32 delay_interval;
> +};
> +
> +struct wcn36xx_hal_configure_rxp_filter_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 set_mcst_bcst_filter_setting;
> +       u8 set_mcst_bcst_filter;
> +};
> +
> +struct wcn36xx_hal_enter_imps_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_exit_imps_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_enter_bmps_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       u8 bss_index;
> +} __packed;
> +
> +struct wcn36xx_hal_exit_bmps_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       u8 bss_index;
> +} __packed;
> +
> +struct wcn36xx_hal_enter_uapsd_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_exit_uapsd_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_rssi_notification_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u32 rssi_thres1_pos_cross:1;
> +       u32 rssi_thres1_neg_cross:1;
> +       u32 rssi_thres2_pos_cross:1;
> +       u32 rssi_thres2_neg_cross:1;
> +       u32 rssi_thres3_pos_cross:1;
> +       u32 rssi_thres3_neg_cross:1;
> +       u32 avg_rssi:8;
> +       u32 reserved:18;
> +
> +};
> +
> +struct wcn36xx_hal_get_rssio_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +       s8 rssi;
> +
> +};
> +
> +struct wcn36xx_hal_get_roam_rssi_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       u8 sta_id;
> +       s8 rssi;
> +};
> +
> +struct wcn36xx_hal_wowl_enter_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_wowl_exit_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_add_bcn_filter_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_rem_bcn_filter_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_add_wowl_bcast_ptrn_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_del_wowl_bcast_ptrn_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_host_offload_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_keep_alive_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_set_rssi_thresh_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_set_uapsd_ac_params_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_configure_rxp_filter_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct set_max_tx_pwr_req {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* BSSID is needed to identify which session issued this request.
> +        * As the request has power constraints, this should be applied
> +        * only to that session */
> +       u8 bssid[ETH_ALEN];
> +
> +       u8 self_addr[ETH_ALEN];
> +
> +       /* In request, power == MaxTx power to be used. */
> +       u8 power;
> +};
> +
> +struct set_max_tx_pwr_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* power == tx power used for management frames */
> +       u8 power;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct set_tx_pwr_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* TX Power in milli watts */
> +       u32 tx_power;
> +
> +       u8 bss_index;
> +};
> +
> +struct set_tx_pwr_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct get_tx_pwr_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 sta_id;
> +};
> +
> +struct get_tx_pwr_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       /* TX Power in milli watts */
> +       u32 tx_power;
> +};
> +
> +struct set_p2p_gonoa_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 opp_ps;
> +       u32 ct_window;
> +       u8 count;
> +       u32 duration;
> +       u32 interval;
> +       u32 single_noa_duration;
> +       u8 ps_selection;
> +};
> +
> +struct set_p2p_gonoa_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_add_sta_self_req {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 self_addr[ETH_ALEN];
> +       u32 status;
> +} __packed;
> +
> +struct wcn36xx_hal_add_sta_self_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       /* Self STA Index */
> +       u8 self_sta_index;
> +
> +       /* DPU Index (IGTK, PTK, GTK all same) */
> +       u8 dpu_index;
> +
> +       /* DPU Signature */
> +       u8 dpu_signature;
> +} __packed;
> +
> +struct wcn36xx_hal_del_sta_self_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 self_addr[ETH_ALEN];
> +} __packed;
> +
> +struct wcn36xx_hal_del_sta_self_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /*success or failure */
> +       u32 status;
> +
> +       u8 self_addr[ETH_ALEN];
> +} __packed;
> +
> +struct aggr_add_ts_req {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Station Index */
> +       u16 sta_idx;
> +
> +       /* TSPEC handler uniquely identifying a TSPEC for a STA in a BSS.
> +        * This will carry the bitmap with the bit positions representing
> +        * different AC.s */
> +       u16 tspec_index;
> +
> +       /* Tspec info per AC To program TPE with required parameters */
> +       struct wcn36xx_hal_tspec_ie tspec[WCN36XX_HAL_MAX_AC];
> +
> +       /* U-APSD Flags: 1b per AC.  Encoded as follows:
> +          b7 b6 b5 b4 b3 b2 b1 b0 =
> +          X  X  X  X  BE BK VI VO */
> +       u8 uapsd;
> +
> +       /* These parameters are for all the access categories */
> +
> +       /* Service Interval */
> +       u32 service_interval[WCN36XX_HAL_MAX_AC];
> +
> +       /* Suspend Interval */
> +       u32 suspend_interval[WCN36XX_HAL_MAX_AC];
> +
> +       /* Delay Interval */
> +       u32 delay_interval[WCN36XX_HAL_MAX_AC];
> +};
> +
> +struct aggr_add_ts_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status0;
> +
> +       /* FIXME PRIMA for future use for 11R */
> +       u32 status1;
> +};
> +
> +struct wcn36xx_hal_configure_apps_cpu_wakeup_state_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 is_apps_cpu_awake;
> +};
> +
> +struct wcn36xx_hal_configure_apps_cpu_wakeup_state_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_dump_cmd_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u32 arg1;
> +       u32 arg2;
> +       u32 arg3;
> +       u32 arg4;
> +       u32 arg5;
> +} __packed;
> +
> +struct wcn36xx_hal_dump_cmd_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       /* Length of the responce message */
> +       u32 rsp_length;
> +
> +       /* FIXME: Currently considering the the responce will be less than
> +        * 100bytes */
> +       u8 rsp_buffer[DUMPCMD_RSP_BUFFER];
> +} __packed;
> +
> +#define WLAN_COEX_IND_DATA_SIZE (4)
> +#define WLAN_COEX_IND_TYPE_DISABLE_HB_MONITOR (0)
> +#define WLAN_COEX_IND_TYPE_ENABLE_HB_MONITOR (1)
> +
> +struct coex_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Coex Indication Type */
> +       u32 type;
> +
> +       /* Coex Indication Data */
> +       u32 data[WLAN_COEX_IND_DATA_SIZE];
> +};
> +
> +struct wcn36xx_hal_tx_compl_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Tx Complete Indication Success or Failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_wlan_host_suspend_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u32 configured_mcst_bcst_filter_setting;
> +       u32 active_session_count;
> +};
> +
> +struct wcn36xx_hal_wlan_exclude_unencrpted_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 dot11_exclude_unencrypted;
> +       u8 bssid[ETH_ALEN];
> +};
> +
> +struct noa_attr_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 index;
> +       u8 opp_ps_flag;
> +       u16 ctwin;
> +
> +       u16 noa1_interval_count;
> +       u16 bss_index;
> +       u32 noa1_duration;
> +       u32 noa1_interval;
> +       u32 noa1_starttime;
> +
> +       u16 noa2_interval_count;
> +       u16 reserved2;
> +       u32 noa2_duration;
> +       u32 noa2_interval;
> +       u32 noa2_start_time;
> +
> +       u32 status;
> +};
> +
> +struct noa_start_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u32 status;
> +       u32 bss_index;
> +};
> +
> +struct wcn36xx_hal_wlan_host_resume_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 configured_mcst_bcst_filter_setting;
> +};
> +
> +struct wcn36xx_hal_host_resume_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +struct wcn36xx_hal_del_ba_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u16 sta_idx;
> +
> +       /* Peer MAC Address, whose BA session has timed out */
> +       u8 peer_addr[ETH_ALEN];
> +
> +       /* TID for which a BA session timeout is being triggered */
> +       u8 ba_tid;
> +
> +       /* DELBA direction
> +        * 1 - Originator
> +        * 0 - Recipient
> +        */
> +       u8 direction;
> +
> +       u32 reason_code;
> +
> +       /* TO SUPPORT BT-AMP */
> +       u8 bssid[ETH_ALEN];
> +};
> +
> +/* PNO Messages */
> +
> +/* Max number of channels that a network can be found on */
> +#define WCN36XX_HAL_PNO_MAX_NETW_CHANNELS  26
> +
> +/* Max number of channels that a network can be found on */
> +#define WCN36XX_HAL_PNO_MAX_NETW_CHANNELS_EX  60
> +
> +/* Maximum numbers of networks supported by PNO */
> +#define WCN36XX_HAL_PNO_MAX_SUPP_NETWORKS  16
> +
> +/* The number of scan time intervals that can be programmed into PNO */
> +#define WCN36XX_HAL_PNO_MAX_SCAN_TIMERS    10
> +
> +/* Maximum size of the probe template */
> +#define WCN36XX_HAL_PNO_MAX_PROBE_SIZE     450
> +
> +/* Type of PNO enabling:
> + *
> + * Immediate - scanning will start immediately and PNO procedure will be
> + * repeated based on timer
> + *
> + * Suspend - scanning will start at suspend
> + *
> + * Resume - scanning will start on system resume
> + */
> +enum pno_mode {
> +       PNO_MODE_IMMEDIATE,
> +       PNO_MODE_ON_SUSPEND,
> +       PNO_MODE_ON_RESUME,
> +       PNO_MODE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +/* Authentication type */
> +enum auth_type {
> +       AUTH_TYPE_ANY = 0,
> +       AUTH_TYPE_OPEN_SYSTEM = 1,
> +
> +       /* Upper layer authentication types */
> +       AUTH_TYPE_WPA = 2,
> +       AUTH_TYPE_WPA_PSK = 3,
> +
> +       AUTH_TYPE_RSN = 4,
> +       AUTH_TYPE_RSN_PSK = 5,
> +       AUTH_TYPE_FT_RSN = 6,
> +       AUTH_TYPE_FT_RSN_PSK = 7,
> +       AUTH_TYPE_WAPI_WAI_CERTIFICATE = 8,
> +       AUTH_TYPE_WAPI_WAI_PSK = 9,
> +
> +       AUTH_TYPE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +/* Encryption type */
> +enum ed_type {
> +       ED_ANY = 0,
> +       ED_NONE = 1,
> +       ED_WEP = 2,
> +       ED_TKIP = 3,
> +       ED_CCMP = 4,
> +       ED_WPI = 5,
> +
> +       ED_TYPE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +/* SSID broadcast  type */
> +enum ssid_bcast_type {
> +       BCAST_UNKNOWN = 0,
> +       BCAST_NORMAL = 1,
> +       BCAST_HIDDEN = 2,
> +
> +       BCAST_TYPE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE
> +};
> +
> +/* The network description for which PNO will have to look for */
> +struct network_type {
> +       /* SSID of the BSS */
> +       struct wcn36xx_hal_mac_ssid ssid;
> +
> +       /* Authentication type for the network */
> +       enum auth_type authentication;
> +
> +       /* Encryption type for the network */
> +       enum ed_type encryption;
> +
> +       /* Indicate the channel on which the Network can be found 0 - if
> +        * all channels */
> +       u8 channel_count;
> +       u8 channels[WCN36XX_HAL_PNO_MAX_NETW_CHANNELS];
> +
> +       /* Indicates the RSSI threshold for the network to be considered */
> +       u8 rssi_threshold;
> +};
> +
> +struct scan_timer {
> +       /* How much it should wait */
> +       u32 value;
> +
> +       /* How many times it should repeat that wait value 0 - keep using
> +        * this timer until PNO is disabled */
> +       u32 repeat;
> +
> +       /* e.g: 2 3 4 0 - it will wait 2s between consecutive scans for 3
> +        * times - after that it will wait 4s between consecutive scans
> +        * until disabled */
> +};
> +
> +/* The network parameters to be sent to the PNO algorithm */
> +struct scan_timers_type {
> +       /* set to 0 if you wish for PNO to use its default telescopic timer */
> +       u8 count;
> +
> +       /* A set value represents the amount of time that PNO will wait
> +        * between two consecutive scan procedures If the desired is for a
> +        * uniform timer that fires always at the exact same interval - one
> +        * single value is to be set If there is a desire for a more
> +        * complex - telescopic like timer multiple values can be set -
> +        * once PNO reaches the end of the array it will continue scanning
> +        * at intervals presented by the last value */
> +       struct scan_timer values[WCN36XX_HAL_PNO_MAX_SCAN_TIMERS];
> +};
> +
> +/* Preferred network list request */
> +struct set_pref_netw_list_req {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Enable PNO */
> +       u32 enable;
> +
> +       /* Immediate,  On Suspend,   On Resume */
> +       enum pno_mode mode;
> +
> +       /* Number of networks sent for PNO */
> +       u32 networks_count;
> +
> +       /* The networks that PNO needs to look for */
> +       struct network_type networks[WCN36XX_HAL_PNO_MAX_SUPP_NETWORKS];
> +
> +       /* The scan timers required for PNO */
> +       struct scan_timers_type scan_timers;
> +
> +       /* Probe template for 2.4GHz band */
> +       u16 band_24g_probe_size;
> +       u8 band_24g_probe_template[WCN36XX_HAL_PNO_MAX_PROBE_SIZE];
> +
> +       /* Probe template for 5GHz band */
> +       u16 band_5g_probe_size;
> +       u8 band_5g_probe_template[WCN36XX_HAL_PNO_MAX_PROBE_SIZE];
> +};
> +
> +/* The network description for which PNO will have to look for */
> +struct network_type_new {
> +       /* SSID of the BSS */
> +       struct wcn36xx_hal_mac_ssid ssid;
> +
> +       /* Authentication type for the network */
> +       enum auth_type authentication;
> +
> +       /* Encryption type for the network */
> +       enum ed_type encryption;
> +
> +       /* SSID broadcast type, normal, hidden or unknown */
> +       enum ssid_bcast_type bcast_network_type;
> +
> +       /* Indicate the channel on which the Network can be found 0 - if
> +        * all channels */
> +       u8 channel_count;
> +       u8 channels[WCN36XX_HAL_PNO_MAX_NETW_CHANNELS];
> +
> +       /* Indicates the RSSI threshold for the network to be considered */
> +       u8 rssi_threshold;
> +};
> +
> +/* Preferred network list request new */
> +struct set_pref_netw_list_req_new {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Enable PNO */
> +       u32 enable;
> +
> +       /* Immediate,  On Suspend,   On Resume */
> +       enum pno_mode mode;
> +
> +       /* Number of networks sent for PNO */
> +       u32 networks_count;
> +
> +       /* The networks that PNO needs to look for */
> +       struct network_type_new networks[WCN36XX_HAL_PNO_MAX_SUPP_NETWORKS];
> +
> +       /* The scan timers required for PNO */
> +       struct scan_timers_type scan_timers;
> +
> +       /* Probe template for 2.4GHz band */
> +       u16 band_24g_probe_size;
> +       u8 band_24g_probe_template[WCN36XX_HAL_PNO_MAX_PROBE_SIZE];
> +
> +       /* Probe template for 5GHz band */
> +       u16 band_5g_probe_size;
> +       u8 band_5g_probe_template[WCN36XX_HAL_PNO_MAX_PROBE_SIZE];
> +};
> +
> +/* Preferred network list response */
> +struct set_pref_netw_list_resp {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* status of the request - just to indicate that PNO has
> +        * acknowledged the request and will start scanning */
> +       u32 status;
> +};
> +
> +/* Preferred network found indication */
> +struct pref_netw_found_ind {
> +
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Network that was found with the highest RSSI */
> +       struct wcn36xx_hal_mac_ssid ssid;
> +
> +       /* Indicates the RSSI */
> +       u8 rssi;
> +};
> +
> +/* RSSI Filter request */
> +struct set_rssi_filter_req {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* RSSI Threshold */
> +       u8 rssi_threshold;
> +};
> +
> +/* Set RSSI filter resp */
> +struct set_rssi_filter_resp {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* status of the request */
> +       u32 status;
> +};
> +
> +/* Update scan params - sent from host to PNO to be used during PNO
> + * scanningx */
> +struct wcn36xx_hal_update_scan_params_req {
> +
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Host setting for 11d */
> +       u8 dot11d_enabled;
> +
> +       /* Lets PNO know that host has determined the regulatory domain */
> +       u8 dot11d_resolved;
> +
> +       /* Channels on which PNO is allowed to scan */
> +       u8 channel_count;
> +       u8 channels[WCN36XX_HAL_PNO_MAX_NETW_CHANNELS];
> +
> +       /* Minimum channel time */
> +       u16 active_min_ch_time;
> +
> +       /* Maximum channel time */
> +       u16 active_max_ch_time;
> +
> +       /* Minimum channel time */
> +       u16 passive_min_ch_time;
> +
> +       /* Maximum channel time */
> +       u16 passive_max_ch_time;
> +
> +       /* Cb State */
> +       enum phy_chan_bond_state state;
> +} __packed;
> +
> +/* Update scan params - sent from host to PNO to be used during PNO
> + * scanningx */
> +struct update_scan_params_req_ex {
> +
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Host setting for 11d */
> +       u8 dot11d_enabled;
> +
> +       /* Lets PNO know that host has determined the regulatory domain */
> +       u8 dot11d_resolved;
> +
> +       /* Channels on which PNO is allowed to scan */
> +       u8 channel_count;
> +       u8 channels[WCN36XX_HAL_PNO_MAX_NETW_CHANNELS_EX];
> +
> +       /* Minimum channel time */
> +       u16 active_min_ch_time;
> +
> +       /* Maximum channel time */
> +       u16 active_max_ch_time;
> +
> +       /* Minimum channel time */
> +       u16 passive_min_ch_time;
> +
> +       /* Maximum channel time */
> +       u16 passive_max_ch_time;
> +
> +       /* Cb State */
> +       enum phy_chan_bond_state state;
> +};
> +
> +/* Update scan params - sent from host to PNO to be used during PNO
> + * scanningx */
> +struct wcn36xx_hal_update_scan_params_resp {
> +
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* status of the request */
> +       u32 status;
> +} __packed;
> +
> +struct wcn36xx_hal_set_tx_per_tracking_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* 0: disable, 1:enable */
> +       u8 tx_per_tracking_enable;
> +
> +       /* Check period, unit is sec. */
> +       u8 tx_per_tracking_period;
> +
> +       /* (Fail TX packet)/(Total TX packet) ratio, the unit is 10%. */
> +       u8 tx_per_tracking_ratio;
> +
> +       /* A watermark of check number, once the tx packet exceed this
> +        * number, we do the check, default is 5 */
> +       u32 tx_per_tracking_watermark;
> +};
> +
> +struct wcn36xx_hal_set_tx_per_tracking_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +};
> +
> +struct tx_per_hit_ind_msg {
> +       struct wcn36xx_hal_msg_header header;
> +};
> +
> +/* Packet Filtering Definitions Begin */
> +#define    WCN36XX_HAL_PROTOCOL_DATA_LEN                  8
> +#define    WCN36XX_HAL_MAX_NUM_MULTICAST_ADDRESS        240
> +#define    WCN36XX_HAL_MAX_NUM_FILTERS                   20
> +#define    WCN36XX_HAL_MAX_CMP_PER_FILTER                10
> +
> +enum wcn36xx_hal_receive_packet_filter_type {
> +       HAL_RCV_FILTER_TYPE_INVALID,
> +       HAL_RCV_FILTER_TYPE_FILTER_PKT,
> +       HAL_RCV_FILTER_TYPE_BUFFER_PKT,
> +       HAL_RCV_FILTER_TYPE_MAX_ENUM_SIZE
> +};
> +
> +enum wcn36xx_hal_rcv_pkt_flt_protocol_type {
> +       HAL_FILTER_PROTO_TYPE_INVALID,
> +       HAL_FILTER_PROTO_TYPE_MAC,
> +       HAL_FILTER_PROTO_TYPE_ARP,
> +       HAL_FILTER_PROTO_TYPE_IPV4,
> +       HAL_FILTER_PROTO_TYPE_IPV6,
> +       HAL_FILTER_PROTO_TYPE_UDP,
> +       HAL_FILTER_PROTO_TYPE_MAX
> +};
> +
> +enum wcn36xx_hal_rcv_pkt_flt_cmp_flag_type {
> +       HAL_FILTER_CMP_TYPE_INVALID,
> +       HAL_FILTER_CMP_TYPE_EQUAL,
> +       HAL_FILTER_CMP_TYPE_MASK_EQUAL,
> +       HAL_FILTER_CMP_TYPE_NOT_EQUAL,
> +       HAL_FILTER_CMP_TYPE_MAX
> +};
> +
> +struct wcn36xx_hal_rcv_pkt_filter_params {
> +       u8 protocol_layer;
> +       u8 cmp_flag;
> +
> +       /* Length of the data to compare */
> +       u16 data_length;
> +
> +       /* from start of the respective frame header */
> +       u8 data_offset;
> +
> +       /* Reserved field */
> +       u8 reserved;
> +
> +       /* Data to compare */
> +       u8 compare_data[WCN36XX_HAL_PROTOCOL_DATA_LEN];
> +
> +       /* Mask to be applied on the received packet data before compare */
> +       u8 data_mask[WCN36XX_HAL_PROTOCOL_DATA_LEN];
> +};
> +
> +struct wcn36xx_hal_sessionized_rcv_pkt_filter_cfg_type {
> +       u8 id;
> +       u8 type;
> +       u8 params_count;
> +       u32 coleasce_time;
> +       u8 bss_index;
> +       struct wcn36xx_hal_rcv_pkt_filter_params params[1];
> +};
> +
> +struct wcn36xx_hal_set_rcv_pkt_filter_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 id;
> +       u8 type;
> +       u8 params_count;
> +       u32 coalesce_time;
> +       struct wcn36xx_hal_rcv_pkt_filter_params params[1];
> +};
> +
> +struct wcn36xx_hal_rcv_flt_mc_addr_list_type {
> +       /* from start of the respective frame header */
> +       u8 data_offset;
> +
> +       u32 mc_addr_count;
> +       u8 mc_addr[ETH_ALEN][WCN36XX_HAL_MAX_NUM_MULTICAST_ADDRESS];
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_set_pkt_filter_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_rcv_flt_pkt_match_cnt_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_rcv_flt_pkt_match_cnt {
> +       u8 id;
> +       u32 match_cnt;
> +};
> +
> +struct wcn36xx_hal_rcv_flt_pkt_match_cnt_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Success or Failure */
> +       u32 status;
> +
> +       u32 match_count;
> +       struct wcn36xx_hal_rcv_flt_pkt_match_cnt
> +               matches[WCN36XX_HAL_MAX_NUM_FILTERS];
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_rcv_flt_pkt_clear_param {
> +       /* only valid for response message */
> +       u32 status;
> +       u8 id;
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_rcv_flt_pkt_clear_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_rcv_flt_pkt_clear_param param;
> +};
> +
> +struct wcn36xx_hal_rcv_flt_pkt_clear_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_rcv_flt_pkt_clear_param param;
> +};
> +
> +struct wcn36xx_hal_rcv_flt_pkt_set_mc_list_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       struct wcn36xx_hal_rcv_flt_mc_addr_list_type mc_addr_list;
> +};
> +
> +struct wcn36xx_hal_rcv_flt_pkt_set_mc_list_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       u32 status;
> +       u8 bss_index;
> +};
> +
> +/* Packet Filtering Definitions End */
> +
> +struct wcn36xx_hal_set_power_params_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /*  Ignore DTIM */
> +       u32 ignore_dtim;
> +
> +       /* DTIM Period */
> +       u32 dtim_period;
> +
> +       /* Listen Interval */
> +       u32 listen_interval;
> +
> +       /* Broadcast Multicast Filter  */
> +       u32 bcast_mcast_filter;
> +
> +       /* Beacon Early Termination */
> +       u32 enable_bet;
> +
> +       /* Beacon Early Termination Interval */
> +       u32 bet_interval;
> +} __packed;
> +
> +struct wcn36xx_hal_set_power_params_resp {
> +
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* status of the request */
> +       u32 status;
> +} __packed;
> +
> +/* Capability bitmap exchange definitions and macros starts */
> +
> +enum place_holder_in_cap_bitmap {
> +       MCC = 0,
> +       P2P = 1,
> +       DOT11AC = 2,
> +       SLM_SESSIONIZATION = 3,
> +       DOT11AC_OPMODE = 4,
> +       SAP32STA = 5,
> +       TDLS = 6,
> +       P2P_GO_NOA_DECOUPLE_INIT_SCAN = 7,
> +       WLANACTIVE_OFFLOAD = 8,
> +       BEACON_OFFLOAD = 9,
> +       SCAN_OFFLOAD = 10,
> +       ROAM_OFFLOAD = 11,
> +       BCN_MISS_OFFLOAD = 12,
> +       STA_POWERSAVE = 13,
> +       STA_ADVANCED_PWRSAVE = 14,
> +       AP_UAPSD = 15,
> +       AP_DFS = 16,
> +       BLOCKACK = 17,
> +       PHY_ERR = 18,
> +       BCN_FILTER = 19,
> +       RTT = 20,
> +       RATECTRL = 21,
> +       WOW = 22,
> +       MAX_FEATURE_SUPPORTED = 128,
> +};
> +
> +struct wcn36xx_hal_feat_caps_msg {
> +
> +       struct wcn36xx_hal_msg_header header;
> +
> +       u32 feat_caps[4];
> +} __packed;
> +
> +/* status codes to help debug rekey failures */
> +enum gtk_rekey_status {
> +       WCN36XX_HAL_GTK_REKEY_STATUS_SUCCESS = 0,
> +
> +       /* rekey detected, but not handled */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_NOT_HANDLED = 1,
> +
> +       /* MIC check error on M1 */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_MIC_ERROR = 2,
> +
> +       /* decryption error on M1  */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_DECRYPT_ERROR = 3,
> +
> +       /* M1 replay detected */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_REPLAY_ERROR = 4,
> +
> +       /* missing GTK key descriptor in M1 */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_MISSING_KDE = 5,
> +
> +       /* missing iGTK key descriptor in M1 */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_MISSING_IGTK_KDE = 6,
> +
> +       /* key installation error */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_INSTALL_ERROR = 7,
> +
> +       /* iGTK key installation error */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_IGTK_INSTALL_ERROR = 8,
> +
> +       /* GTK rekey M2 response TX error */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_RESP_TX_ERROR = 9,
> +
> +       /* non-specific general error */
> +       WCN36XX_HAL_GTK_REKEY_STATUS_GEN_ERROR = 255
> +};
> +
> +/* wake reason types */
> +enum wake_reason_type {
> +       WCN36XX_HAL_WAKE_REASON_NONE = 0,
> +
> +       /* magic packet match */
> +       WCN36XX_HAL_WAKE_REASON_MAGIC_PACKET = 1,
> +
> +       /* host defined pattern match */
> +       WCN36XX_HAL_WAKE_REASON_PATTERN_MATCH = 2,
> +
> +       /* EAP-ID frame detected */
> +       WCN36XX_HAL_WAKE_REASON_EAPID_PACKET = 3,
> +
> +       /* start of EAPOL 4-way handshake detected */
> +       WCN36XX_HAL_WAKE_REASON_EAPOL4WAY_PACKET = 4,
> +
> +       /* network scan offload match */
> +       WCN36XX_HAL_WAKE_REASON_NETSCAN_OFFL_MATCH = 5,
> +
> +       /* GTK rekey status wakeup (see status) */
> +       WCN36XX_HAL_WAKE_REASON_GTK_REKEY_STATUS = 6,
> +
> +       /* BSS connection lost */
> +       WCN36XX_HAL_WAKE_REASON_BSS_CONN_LOST = 7,
> +};
> +
> +/*
> +  Wake Packet which is saved at tWakeReasonParams.DataStart
> +  This data is sent for any wake reasons that involve a packet-based wakeup :
> +
> +  WCN36XX_HAL_WAKE_REASON_TYPE_MAGIC_PACKET
> +  WCN36XX_HAL_WAKE_REASON_TYPE_PATTERN_MATCH
> +  WCN36XX_HAL_WAKE_REASON_TYPE_EAPID_PACKET
> +  WCN36XX_HAL_WAKE_REASON_TYPE_EAPOL4WAY_PACKET
> +  WCN36XX_HAL_WAKE_REASON_TYPE_GTK_REKEY_STATUS
> +
> +  The information is provided to the host for auditing and debug purposes
> +
> +*/
> +
> +/* Wake reason indication */
> +struct wcn36xx_hal_wake_reason_ind {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* see tWakeReasonType */
> +       u32 reason;
> +
> +       /* argument specific to the reason type */
> +       u32 reason_arg;
> +
> +       /* length of optional data stored in this message, in case HAL
> +        * truncates the data (i.e. data packets) this length will be less
> +        * than the actual length */
> +       u32 stored_data_len;
> +
> +       /* actual length of data */
> +       u32 actual_data_len;
> +
> +       /* variable length start of data (length == storedDataLen) see
> +        * specific wake type */
> +       u8 data_start[1];
> +
> +       u32 bss_index:8;
> +       u32 reserved:24;
> +};
> +
> +#define WCN36XX_HAL_GTK_KEK_BYTES 16
> +#define WCN36XX_HAL_GTK_KCK_BYTES 16
> +
> +#define WCN36XX_HAL_GTK_OFFLOAD_FLAGS_DISABLE (1 << 0)
> +
> +#define GTK_SET_BSS_KEY_TAG  0x1234AA55
> +
> +struct wcn36xx_hal_gtk_offload_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* optional flags */
> +       u32 flags;
> +
> +       /* Key confirmation key */
> +       u8 kck[WCN36XX_HAL_GTK_KCK_BYTES];
> +
> +       /* key encryption key */
> +       u8 kek[WCN36XX_HAL_GTK_KEK_BYTES];
> +
> +       /* replay counter */
> +       u64 key_replay_counter;
> +
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_gtk_offload_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_gtk_offload_get_info_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +       u8 bss_index;
> +};
> +
> +struct wcn36xx_hal_gtk_offload_get_info_rsp_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +
> +       /* last rekey status when the rekey was offloaded */
> +       u32 last_rekey_status;
> +
> +       /* current replay counter value */
> +       u64 key_replay_counter;
> +
> +       /* total rekey attempts */
> +       u32 total_rekey_count;
> +
> +       /* successful GTK rekeys */
> +       u32 gtk_rekey_count;
> +
> +       /* successful iGTK rekeys */
> +       u32 igtk_rekey_count;
> +
> +       u8 bss_index;
> +};
> +
> +struct dhcp_info {
> +       /* Indicates the device mode which indicates about the DHCP activity */
> +       u8 device_mode;
> +
> +       u8 addr[ETH_ALEN];
> +};
> +
> +struct dhcp_ind_status {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* success or failure */
> +       u32 status;
> +};
> +
> +/*
> + *   Thermal Mitigation mode of operation.
> + *
> + *  WCN36XX_HAL_THERMAL_MITIGATION_MODE_0 - Based on AMPDU disabling aggregation
> + *
> + *  WCN36XX_HAL_THERMAL_MITIGATION_MODE_1 - Based on AMPDU disabling aggregation
> + *  and reducing transmit power
> + *
> + *  WCN36XX_HAL_THERMAL_MITIGATION_MODE_2 - Not supported */
> +enum wcn36xx_hal_thermal_mitigation_mode_type {
> +       HAL_THERMAL_MITIGATION_MODE_INVALID = -1,
> +       HAL_THERMAL_MITIGATION_MODE_0,
> +       HAL_THERMAL_MITIGATION_MODE_1,
> +       HAL_THERMAL_MITIGATION_MODE_2,
> +       HAL_THERMAL_MITIGATION_MODE_MAX = WCN36XX_HAL_MAX_ENUM_SIZE,
> +};
> +
> +
> +/*
> + *   Thermal Mitigation level.
> + * Note the levels are incremental i.e WCN36XX_HAL_THERMAL_MITIGATION_LEVEL_2 =
> + * WCN36XX_HAL_THERMAL_MITIGATION_LEVEL_0 +
> + * WCN36XX_HAL_THERMAL_MITIGATION_LEVEL_1
> + *
> + * WCN36XX_HAL_THERMAL_MITIGATION_LEVEL_0 - lowest level of thermal mitigation.
> + * This level indicates normal mode of operation
> + *
> + * WCN36XX_HAL_THERMAL_MITIGATION_LEVEL_1 - 1st level of thermal mitigation
> + *
> + * WCN36XX_HAL_THERMAL_MITIGATION_LEVEL_2 - 2nd level of thermal mitigation
> + *
> + * WCN36XX_HAL_THERMAL_MITIGATION_LEVEL_3 - 3rd level of thermal mitigation
> + *
> + * WCN36XX_HAL_THERMAL_MITIGATION_LEVEL_4 - 4th level of thermal mitigation
> + */
> +enum wcn36xx_hal_thermal_mitigation_level_type {
> +       HAL_THERMAL_MITIGATION_LEVEL_INVALID = -1,
> +       HAL_THERMAL_MITIGATION_LEVEL_0,
> +       HAL_THERMAL_MITIGATION_LEVEL_1,
> +       HAL_THERMAL_MITIGATION_LEVEL_2,
> +       HAL_THERMAL_MITIGATION_LEVEL_3,
> +       HAL_THERMAL_MITIGATION_LEVEL_4,
> +       HAL_THERMAL_MITIGATION_LEVEL_MAX = WCN36XX_HAL_MAX_ENUM_SIZE,
> +};
> +
> +
> +/* WCN36XX_HAL_SET_THERMAL_MITIGATION_REQ */
> +struct set_thermal_mitigation_req_msg {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Thermal Mitigation Operation Mode */
> +       enum wcn36xx_hal_thermal_mitigation_mode_type mode;
> +
> +       /* Thermal Mitigation Level */
> +       enum wcn36xx_hal_thermal_mitigation_level_type level;
> +};
> +
> +struct set_thermal_mitigation_resp {
> +
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* status of the request */
> +       u32 status;
> +};
> +
> +/* Per STA Class B Statistics. Class B statistics are STA TX/RX stats
> + * provided to FW from Host via periodic messages */
> +struct stats_class_b_ind {
> +       struct wcn36xx_hal_msg_header header;
> +
> +       /* Duration over which this stats was collected */
> +       u32 duration;
> +
> +       /* Per STA Stats */
> +
> +       /* TX stats */
> +       u32 tx_bytes_pushed;
> +       u32 tx_packets_pushed;
> +
> +       /* RX stats */
> +       u32 rx_bytes_rcvd;
> +       u32 rx_packets_rcvd;
> +       u32 rx_time_total;
> +};
> +
> +#endif /* _HAL_H_ */
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> new file mode 100644
> index 0000000..500726e
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -0,0 +1,1036 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include "wcn36xx.h"
> +
> +unsigned int debug_mask;
> +module_param(debug_mask, uint, 0644);
> +MODULE_PARM_DESC(debug_mask, "Debugging mask");
> +
> +#define CHAN2G(_freq, _idx) { \
> +       .band = IEEE80211_BAND_2GHZ, \
> +       .center_freq = (_freq), \
> +       .hw_value = (_idx), \
> +       .max_power = 25, \
> +}
> +
> +#define CHAN5G(_freq, _idx) { \
> +       .band = IEEE80211_BAND_5GHZ, \
> +       .center_freq = (_freq), \
> +       .hw_value = (_idx), \
> +       .max_power = 25, \
> +}
> +
> +/* The wcn firmware expects channel values to matching
> + * their mnemonic values. So use these for .hw_value. */
> +static struct ieee80211_channel wcn_2ghz_channels[] = {
> +       CHAN2G(2412, 1), /* Channel 1 */
> +       CHAN2G(2417, 2), /* Channel 2 */
> +       CHAN2G(2422, 3), /* Channel 3 */
> +       CHAN2G(2427, 4), /* Channel 4 */
> +       CHAN2G(2432, 5), /* Channel 5 */
> +       CHAN2G(2437, 6), /* Channel 6 */
> +       CHAN2G(2442, 7), /* Channel 7 */
> +       CHAN2G(2447, 8), /* Channel 8 */
> +       CHAN2G(2452, 9), /* Channel 9 */
> +       CHAN2G(2457, 10), /* Channel 10 */
> +       CHAN2G(2462, 11), /* Channel 11 */
> +       CHAN2G(2467, 12), /* Channel 12 */
> +       CHAN2G(2472, 13), /* Channel 13 */
> +       CHAN2G(2484, 14)  /* Channel 14 */
> +
> +};
> +
> +static struct ieee80211_channel wcn_5ghz_channels[] = {
> +       CHAN5G(5180, 36),
> +       CHAN5G(5200, 40),
> +       CHAN5G(5220, 44),
> +       CHAN5G(5240, 48),
> +       CHAN5G(5260, 52),
> +       CHAN5G(5280, 56),
> +       CHAN5G(5300, 60),
> +       CHAN5G(5320, 64),
> +       CHAN5G(5500, 100),
> +       CHAN5G(5520, 104),
> +       CHAN5G(5540, 108),
> +       CHAN5G(5560, 112),
> +       CHAN5G(5580, 116),
> +       CHAN5G(5600, 120),
> +       CHAN5G(5620, 124),
> +       CHAN5G(5640, 128),
> +       CHAN5G(5660, 132),
> +       CHAN5G(5700, 140),
> +       CHAN5G(5745, 149),
> +       CHAN5G(5765, 153),
> +       CHAN5G(5785, 157),
> +       CHAN5G(5805, 161),
> +       CHAN5G(5825, 165)
> +};
> +
> +#define RATE(_bitrate, _hw_rate, _flags) { \
> +       .bitrate        = (_bitrate),                   \
> +       .flags          = (_flags),                     \
> +       .hw_value       = (_hw_rate),                   \
> +       .hw_value_short = (_hw_rate)  \
> +}
> +
> +static struct ieee80211_rate wcn_2ghz_rates[] = {
> +       RATE(10, HW_RATE_INDEX_1MBPS, 0),
> +       RATE(20, HW_RATE_INDEX_2MBPS, IEEE80211_RATE_SHORT_PREAMBLE),
> +       RATE(55, HW_RATE_INDEX_5_5MBPS, IEEE80211_RATE_SHORT_PREAMBLE),
> +       RATE(110, HW_RATE_INDEX_11MBPS, IEEE80211_RATE_SHORT_PREAMBLE),
> +       RATE(60, HW_RATE_INDEX_6MBPS, 0),
> +       RATE(90, HW_RATE_INDEX_9MBPS, 0),
> +       RATE(120, HW_RATE_INDEX_12MBPS, 0),
> +       RATE(180, HW_RATE_INDEX_18MBPS, 0),
> +       RATE(240, HW_RATE_INDEX_24MBPS, 0),
> +       RATE(360, HW_RATE_INDEX_36MBPS, 0),
> +       RATE(480, HW_RATE_INDEX_48MBPS, 0),
> +       RATE(540, HW_RATE_INDEX_54MBPS, 0)
> +};
> +
> +static struct ieee80211_rate wcn_5ghz_rates[] = {
> +       RATE(60, HW_RATE_INDEX_6MBPS, 0),
> +       RATE(90, HW_RATE_INDEX_9MBPS, 0),
> +       RATE(120, HW_RATE_INDEX_12MBPS, 0),
> +       RATE(180, HW_RATE_INDEX_18MBPS, 0),
> +       RATE(240, HW_RATE_INDEX_24MBPS, 0),
> +       RATE(360, HW_RATE_INDEX_36MBPS, 0),
> +       RATE(480, HW_RATE_INDEX_48MBPS, 0),
> +       RATE(540, HW_RATE_INDEX_54MBPS, 0)
> +};
> +
> +static struct ieee80211_supported_band wcn_band_2ghz = {
> +       .channels       = wcn_2ghz_channels,
> +       .n_channels     = ARRAY_SIZE(wcn_2ghz_channels),
> +       .bitrates       = wcn_2ghz_rates,
> +       .n_bitrates     = ARRAY_SIZE(wcn_2ghz_rates),
> +       .ht_cap         = {
> +               .cap =  IEEE80211_HT_CAP_GRN_FLD |
> +                       IEEE80211_HT_CAP_SGI_20 |
> +                       IEEE80211_HT_CAP_DSSSCCK40 |
> +                       IEEE80211_HT_CAP_LSIG_TXOP_PROT,
> +               .ht_supported = true,
> +               .ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
> +               .ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
> +               .mcs = {
> +                       .rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
> +                       .rx_highest = cpu_to_le16(72),
> +                       .tx_params = IEEE80211_HT_MCS_TX_DEFINED,
> +               }
> +       }
> +};
> +
> +static struct ieee80211_supported_band wcn_band_5ghz = {
> +       .channels       = wcn_5ghz_channels,
> +       .n_channels     = ARRAY_SIZE(wcn_5ghz_channels),
> +       .bitrates       = wcn_5ghz_rates,
> +       .n_bitrates     = ARRAY_SIZE(wcn_5ghz_rates),
> +       .ht_cap         = {
> +               .cap =  IEEE80211_HT_CAP_GRN_FLD |
> +                       IEEE80211_HT_CAP_SGI_20 |
> +                       IEEE80211_HT_CAP_DSSSCCK40 |
> +                       IEEE80211_HT_CAP_LSIG_TXOP_PROT |
> +                       IEEE80211_HT_CAP_SGI_40 |
> +                       IEEE80211_HT_CAP_SUP_WIDTH_20_40,
> +               .ht_supported = true,
> +               .ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
> +               .ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
> +               .mcs = {
> +                       .rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
> +                       .rx_highest = cpu_to_le16(72),
> +                       .tx_params = IEEE80211_HT_MCS_TX_DEFINED,
> +               }
> +       }
> +};
> +
> +#ifdef CONFIG_PM
> +
> +static const struct wiphy_wowlan_support wowlan_support = {
> +       .flags = WIPHY_WOWLAN_ANY
> +};
> +
> +#endif
> +
> +static inline u8 get_sta_index(struct ieee80211_vif *vif,
> +                              struct wcn36xx_sta *sta_priv)
> +{
> +       return NL80211_IFTYPE_STATION == vif->type ?
> +              sta_priv->bss_sta_index :
> +              sta_priv->sta_index;
> +}
> +
> +static int wcn36xx_start(struct ieee80211_hw *hw)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       int ret;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac start\n");
> +
> +       /* SMD initialization */
> +       ret = wcn36xx_smd_open(wcn);
> +       if (ret) {
> +               wcn36xx_err("Failed to open smd channel: %d\n", ret);
> +               goto out_err;
> +       }
> +
> +       /* Allocate memory pools for Mgmt BD headers and Data BD headers */
> +       ret = wcn36xx_dxe_allocate_mem_pools(wcn);
> +       if (ret) {
> +               wcn36xx_err("Failed to alloc DXE mempool: %d\n", ret);
> +               goto out_smd_close;
> +       }
> +
> +       ret = wcn36xx_dxe_alloc_ctl_blks(wcn);
> +       if (ret) {
> +               wcn36xx_err("Failed to alloc DXE ctl blocks: %d\n", ret);
> +               goto out_free_dxe_pool;
> +       }
> +
> +       wcn->hal_buf = kmalloc(WCN36XX_HAL_BUF_SIZE, GFP_KERNEL);
> +       if (!wcn->hal_buf) {
> +               wcn36xx_err("Failed to allocate smd buf\n");
> +               ret = -ENOMEM;
> +               goto out_free_dxe_ctl;
> +       }
> +
> +       ret = wcn36xx_smd_load_nv(wcn);
> +       if (ret) {
> +               wcn36xx_err("Failed to push NV to chip\n");
> +               goto out_free_smd_buf;
> +       }
> +
> +       ret = wcn36xx_smd_start(wcn);
> +       if (ret) {
> +               wcn36xx_err("Failed to start chip\n");
> +               goto out_free_smd_buf;
> +       }
> +
> +       /* DMA channel initialization */
> +       ret = wcn36xx_dxe_init(wcn);
> +       if (ret) {
> +               wcn36xx_err("DXE init failed\n");
> +               goto out_smd_stop;
> +       }
> +
> +       wcn36xx_debugfs_init(wcn);
> +
> +       if (!wcn36xx_is_fw_version(wcn, 1, 2, 2, 24)) {
> +               ret = wcn36xx_smd_feature_caps_exchange(wcn);
> +               if (ret)
> +                       wcn36xx_warn("Exchange feature caps failed\n");
> +       }
> +       INIT_LIST_HEAD(&wcn->vif_list);
> +       return 0;
> +
> +out_smd_stop:
> +       wcn36xx_smd_stop(wcn);
> +out_free_smd_buf:
> +       kfree(wcn->hal_buf);
> +out_free_dxe_pool:
> +       wcn36xx_dxe_free_mem_pools(wcn);
> +out_free_dxe_ctl:
> +       wcn36xx_dxe_free_ctl_blks(wcn);
> +out_smd_close:
> +       wcn36xx_smd_close(wcn);
> +out_err:
> +       return ret;
> +}
> +
> +static void wcn36xx_stop(struct ieee80211_hw *hw)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac stop\n");
> +
> +       wcn36xx_debugfs_exit(wcn);
> +       wcn36xx_smd_stop(wcn);
> +       wcn36xx_dxe_deinit(wcn);
> +       wcn36xx_smd_close(wcn);
> +
> +       wcn36xx_dxe_free_mem_pools(wcn);
> +       wcn36xx_dxe_free_ctl_blks(wcn);
> +
> +       kfree(wcn->hal_buf);
> +}
> +
> +static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       struct ieee80211_vif *vif = NULL;
> +       struct wcn36xx_vif *tmp;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac config changed 0x%08x\n", changed);
> +
> +       if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
> +               int ch = WCN36XX_HW_CHANNEL(wcn);
> +               wcn36xx_dbg(WCN36XX_DBG_MAC, "wcn36xx_config channel switch=%d\n",
> +                           ch);
> +               list_for_each_entry(tmp, &wcn->vif_list, list) {
> +                       vif = container_of((void *)tmp,
> +                                          struct ieee80211_vif,
> +                                          drv_priv);
> +                       wcn36xx_smd_switch_channel(wcn, vif, ch);
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +#define WCN36XX_SUPPORTED_FILTERS (0)
> +
> +static void wcn36xx_configure_filter(struct ieee80211_hw *hw,
> +                                    unsigned int changed,
> +                                    unsigned int *total, u64 multicast)
> +{
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac configure filter\n");
> +
> +       *total &= WCN36XX_SUPPORTED_FILTERS;
> +}
> +
> +static void wcn36xx_tx(struct ieee80211_hw *hw,
> +                      struct ieee80211_tx_control *control,
> +                      struct sk_buff *skb)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       struct wcn36xx_sta *sta_priv = NULL;
> +
> +       if (control->sta)
> +               sta_priv = (struct wcn36xx_sta *)control->sta->drv_priv;
> +
> +       if (wcn36xx_start_tx(wcn, sta_priv, skb))
> +               ieee80211_free_txskb(wcn->hw, skb);
> +}
> +
> +static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> +                          struct ieee80211_vif *vif,
> +                          struct ieee80211_sta *sta,
> +                          struct ieee80211_key_conf *key_conf)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +       struct wcn36xx_sta *sta_priv = vif_priv->sta;
> +       int ret = 0;
> +       u8 key[WLAN_MAX_KEY_LEN];
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac80211 set key\n");
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "Key: cmd=0x%x algo:0x%x, id:%d, len:%d flags 0x%x\n",
> +                   cmd, key_conf->cipher, key_conf->keyidx,
> +                   key_conf->keylen, key_conf->flags);
> +       wcn36xx_dbg_dump(WCN36XX_DBG_MAC, "KEY: ",
> +                        key_conf->key,
> +                        key_conf->keylen);
> +
> +       switch (key_conf->cipher) {
> +       case WLAN_CIPHER_SUITE_WEP40:
> +               vif_priv->encrypt_type = WCN36XX_HAL_ED_WEP40;
> +               break;
> +       case WLAN_CIPHER_SUITE_WEP104:
> +               vif_priv->encrypt_type = WCN36XX_HAL_ED_WEP40;
> +               break;
> +       case WLAN_CIPHER_SUITE_CCMP:
> +               vif_priv->encrypt_type = WCN36XX_HAL_ED_CCMP;
> +               break;
> +       case WLAN_CIPHER_SUITE_TKIP:
> +               vif_priv->encrypt_type = WCN36XX_HAL_ED_TKIP;
> +               break;
> +       default:
> +               wcn36xx_err("Unsupported key type 0x%x\n",
> +                             key_conf->cipher);
> +               ret = -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       switch (cmd) {
> +       case SET_KEY:
> +               if (WCN36XX_HAL_ED_TKIP == vif_priv->encrypt_type) {
> +                       /*
> +                        * Supplicant is sending key in the wrong order:
> +                        * Temporal Key (16 b) - TX MIC (8 b) - RX MIC (8 b)
> +                        * but HW expects it to be in the order as described in
> +                        * IEEE 802.11 spec (see chapter 11.7) like this:
> +                        * Temporal Key (16 b) - RX MIC (8 b) - TX MIC (8 b)
> +                        */
> +                       memcpy(key, key_conf->key, 16);
> +                       memcpy(key + 16, key_conf->key + 24, 8);
> +                       memcpy(key + 24, key_conf->key + 16, 8);
> +               } else {
> +                       memcpy(key, key_conf->key, key_conf->keylen);
> +               }
> +
> +               if (IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags) {
> +                       sta_priv->is_data_encrypted = true;
> +                       /* Reconfigure bss with encrypt_type */
> +                       if (NL80211_IFTYPE_STATION == vif->type)
> +                               wcn36xx_smd_config_bss(wcn,
> +                                                      vif,
> +                                                      sta,
> +                                                      sta->addr,
> +                                                      true);
> +
> +                       wcn36xx_smd_set_stakey(wcn,
> +                               vif_priv->encrypt_type,
> +                               key_conf->keyidx,
> +                               key_conf->keylen,
> +                               key,
> +                               get_sta_index(vif, sta_priv));
> +               } else {
> +                       wcn36xx_smd_set_bsskey(wcn,
> +                               vif_priv->encrypt_type,
> +                               key_conf->keyidx,
> +                               key_conf->keylen,
> +                               key);
> +                       if ((WLAN_CIPHER_SUITE_WEP40 == key_conf->cipher) ||
> +                           (WLAN_CIPHER_SUITE_WEP104 == key_conf->cipher)) {
> +                               sta_priv->is_data_encrypted = true;
> +                               wcn36xx_smd_set_stakey(wcn,
> +                                       vif_priv->encrypt_type,
> +                                       key_conf->keyidx,
> +                                       key_conf->keylen,
> +                                       key,
> +                                       get_sta_index(vif, sta_priv));
> +                       }
> +               }
> +               break;
> +       case DISABLE_KEY:
> +               if (!(IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags)) {
> +                       wcn36xx_smd_remove_bsskey(wcn,
> +                               vif_priv->encrypt_type,
> +                               key_conf->keyidx);
> +               } else {
> +                       sta_priv->is_data_encrypted = false;
> +                       /* do not remove key if disassociated */
> +                       if (sta_priv->aid)
> +                               wcn36xx_smd_remove_stakey(wcn,
> +                                       vif_priv->encrypt_type,
> +                                       key_conf->keyidx,
> +                                       get_sta_index(vif, sta_priv));
> +               }
> +               break;
> +       default:
> +               wcn36xx_err("Unsupported key cmd 0x%x\n", cmd);
> +               ret = -EOPNOTSUPP;
> +               goto out;
> +               break;
> +       }
> +
> +out:
> +       return ret;
> +}
> +
> +static void wcn36xx_sw_scan_start(struct ieee80211_hw *hw)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +
> +       wcn36xx_smd_init_scan(wcn, HAL_SYS_MODE_SCAN);
> +       wcn36xx_smd_start_scan(wcn);
> +}
> +
> +static void wcn36xx_sw_scan_complete(struct ieee80211_hw *hw)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +
> +       wcn36xx_smd_end_scan(wcn);
> +       wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN);
> +}
> +
> +static void wcn36xx_update_allowed_rates(struct ieee80211_sta *sta,
> +                                        enum ieee80211_band band)
> +{
> +       int i, size;
> +       u16 *rates_table;
> +       struct wcn36xx_sta *sta_priv = (struct wcn36xx_sta *)sta->drv_priv;
> +       u32 rates = sta->supp_rates[band];
> +
> +       memset(&sta_priv->supported_rates, 0,
> +               sizeof(sta_priv->supported_rates));
> +       sta_priv->supported_rates.op_rate_mode = STA_11n;
> +
> +       size = ARRAY_SIZE(sta_priv->supported_rates.dsss_rates);
> +       rates_table = sta_priv->supported_rates.dsss_rates;
> +       if (band == IEEE80211_BAND_2GHZ) {
> +               for (i = 0; i < size; i++) {
> +                       if (rates & 0x01) {
> +                               rates_table[i] = wcn_2ghz_rates[i].hw_value;
> +                               rates = rates >> 1;
> +                       }
> +               }
> +       }
> +
> +       size = ARRAY_SIZE(sta_priv->supported_rates.ofdm_rates);
> +       rates_table = sta_priv->supported_rates.ofdm_rates;
> +       for (i = 0; i < size; i++) {
> +               if (rates & 0x01) {
> +                       rates_table[i] = wcn_5ghz_rates[i].hw_value;
> +                       rates = rates >> 1;
> +               }
> +       }
> +
> +       if (sta->ht_cap.ht_supported) {
> +               BUILD_BUG_ON(sizeof(sta->ht_cap.mcs.rx_mask) >
> +                       sizeof(sta_priv->supported_rates.supported_mcs_set));
> +               memcpy(sta_priv->supported_rates.supported_mcs_set,
> +                      sta->ht_cap.mcs.rx_mask,
> +                      sizeof(sta->ht_cap.mcs.rx_mask));
> +       }
> +}
> +void wcn36xx_set_default_rates(struct wcn36xx_hal_supported_rates *rates)
> +{
> +       u16 ofdm_rates[WCN36XX_HAL_NUM_OFDM_RATES] = {
> +               HW_RATE_INDEX_6MBPS,
> +               HW_RATE_INDEX_9MBPS,
> +               HW_RATE_INDEX_12MBPS,
> +               HW_RATE_INDEX_18MBPS,
> +               HW_RATE_INDEX_24MBPS,
> +               HW_RATE_INDEX_36MBPS,
> +               HW_RATE_INDEX_48MBPS,
> +               HW_RATE_INDEX_54MBPS
> +       };
> +       u16 dsss_rates[WCN36XX_HAL_NUM_DSSS_RATES] = {
> +               HW_RATE_INDEX_1MBPS,
> +               HW_RATE_INDEX_2MBPS,
> +               HW_RATE_INDEX_5_5MBPS,
> +               HW_RATE_INDEX_11MBPS
> +       };
> +
> +       rates->op_rate_mode = STA_11n;
> +       memcpy(rates->dsss_rates, dsss_rates,
> +               sizeof(*dsss_rates) * WCN36XX_HAL_NUM_DSSS_RATES);
> +       memcpy(rates->ofdm_rates, ofdm_rates,
> +               sizeof(*ofdm_rates) * WCN36XX_HAL_NUM_OFDM_RATES);
> +       rates->supported_mcs_set[0] = 0xFF;
> +}
> +static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
> +                                    struct ieee80211_vif *vif,
> +                                    struct ieee80211_bss_conf *bss_conf,
> +                                    u32 changed)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       struct sk_buff *skb = NULL;
> +       u16 tim_off, tim_len;
> +       enum wcn36xx_hal_link_state link_state;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac bss info changed vif %p changed 0x%08x\n",
> +                   vif, changed);
> +
> +       if (changed & BSS_CHANGED_BEACON_INFO) {
> +               wcn36xx_dbg(WCN36XX_DBG_MAC,
> +                           "mac bss changed dtim period %d\n",
> +                           bss_conf->dtim_period);
> +
> +               vif_priv->dtim_period = bss_conf->dtim_period;
> +       }
> +
> +       if (changed & BSS_CHANGED_PS) {
> +               wcn36xx_dbg(WCN36XX_DBG_MAC,
> +                           "mac bss PS set %d\n",
> +                           bss_conf->ps);
> +               if (bss_conf->ps) {
> +                       wcn36xx_pmc_enter_bmps_state(wcn, vif);
> +               } else {
> +                       wcn36xx_pmc_exit_bmps_state(wcn, vif);
> +               }
> +       }
> +
> +       if (changed & BSS_CHANGED_BSSID) {
> +               wcn36xx_dbg(WCN36XX_DBG_MAC, "mac bss changed_bssid %pM\n",
> +                           bss_conf->bssid);
> +
> +               if (!is_zero_ether_addr(bss_conf->bssid)) {
> +                       vif_priv->is_joining = true;
> +                       vif_priv->bss_index = 0xff;
> +                       wcn36xx_smd_join(wcn, bss_conf->bssid,
> +                                        vif->addr, WCN36XX_HW_CHANNEL(wcn));
> +                       wcn36xx_smd_config_bss(wcn, vif, NULL,
> +                                              bss_conf->bssid, false);
> +               } else {
> +                       vif_priv->is_joining = false;
> +                       wcn36xx_smd_delete_bss(wcn, vif);
> +               }
> +       }
> +
> +       if (changed & BSS_CHANGED_SSID) {
> +               wcn36xx_dbg(WCN36XX_DBG_MAC,
> +                           "mac bss changed ssid\n");
> +               wcn36xx_dbg_dump(WCN36XX_DBG_MAC, "ssid ",
> +                                bss_conf->ssid, bss_conf->ssid_len);
> +
> +               vif_priv->ssid.length = bss_conf->ssid_len;
> +               memcpy(&vif_priv->ssid.ssid,
> +                      bss_conf->ssid,
> +                      bss_conf->ssid_len);
> +       }
> +
> +       if (changed & BSS_CHANGED_ASSOC) {
> +               vif_priv->is_joining = false;
> +               if (bss_conf->assoc) {
> +                       struct ieee80211_sta *sta;
> +                       struct wcn36xx_sta *sta_priv;
> +
> +                       wcn36xx_dbg(WCN36XX_DBG_MAC,
> +                                   "mac assoc bss %pM vif %pM AID=%d\n",
> +                                    bss_conf->bssid,
> +                                    vif->addr,
> +                                    bss_conf->aid);
> +
> +                       rcu_read_lock();
> +                       sta = ieee80211_find_sta(vif, bss_conf->bssid);
> +                       if (!sta) {
> +                               wcn36xx_err("sta %pM is not found\n",
> +                                             bss_conf->bssid);
> +                               rcu_read_unlock();
> +                               goto out;
> +                       }
> +                       sta_priv = (struct wcn36xx_sta *)sta->drv_priv;
> +
> +                       wcn36xx_update_allowed_rates(sta, WCN36XX_BAND(wcn));
> +
> +                       wcn36xx_smd_set_link_st(wcn, bss_conf->bssid,
> +                               vif->addr,
> +                               WCN36XX_HAL_LINK_POSTASSOC_STATE);
> +                       wcn36xx_smd_config_bss(wcn, vif, sta,
> +                                              bss_conf->bssid,
> +                                              true);
> +                       sta_priv->aid = bss_conf->aid;
> +                       /*
> +                        * config_sta must be called from  because this is the
> +                        * place where AID is available.
> +                        */
> +                       wcn36xx_smd_config_sta(wcn, vif, sta);
> +                       rcu_read_unlock();
> +               } else {
> +                       wcn36xx_dbg(WCN36XX_DBG_MAC,
> +                                   "disassociated bss %pM vif %pM AID=%d\n",
> +                                   bss_conf->bssid,
> +                                   vif->addr,
> +                                   bss_conf->aid);
> +                       wcn36xx_smd_set_link_st(wcn,
> +                                               bss_conf->bssid,
> +                                               vif->addr,
> +                                               WCN36XX_HAL_LINK_IDLE_STATE);
> +               }
> +       }
> +
> +       if (changed & BSS_CHANGED_AP_PROBE_RESP) {
> +               wcn36xx_dbg(WCN36XX_DBG_MAC, "mac bss changed ap probe resp\n");
> +               skb = ieee80211_proberesp_get(hw, vif);
> +               if (!skb) {
> +                       wcn36xx_err("failed to alloc probereq skb\n");
> +                       goto out;
> +               }
> +
> +               wcn36xx_smd_update_proberesp_tmpl(wcn, vif, skb);
> +               dev_kfree_skb(skb);
> +       }
> +
> +       if (changed & BSS_CHANGED_BEACON_ENABLED) {
> +               wcn36xx_dbg(WCN36XX_DBG_MAC,
> +                           "mac bss changed beacon enabled %d\n",
> +                           bss_conf->enable_beacon);
> +
> +               if (bss_conf->enable_beacon) {
> +                       vif_priv->bss_index = 0xff;
> +                       wcn36xx_smd_config_bss(wcn, vif, NULL,
> +                                              vif->addr, false);
> +                       skb = ieee80211_beacon_get_tim(hw, vif, &tim_off,
> +                                                      &tim_len);
> +                       if (!skb) {
> +                               wcn36xx_err("failed to alloc beacon skb\n");
> +                               goto out;
> +                       }
> +                       wcn36xx_smd_send_beacon(wcn, vif, skb, tim_off, 0);
> +                       dev_kfree_skb(skb);
> +
> +                       if (vif->type == NL80211_IFTYPE_ADHOC ||
> +                           vif->type == NL80211_IFTYPE_MESH_POINT)
> +                               link_state = WCN36XX_HAL_LINK_IBSS_STATE;
> +                       else
> +                               link_state = WCN36XX_HAL_LINK_AP_STATE;
> +
> +                       wcn36xx_smd_set_link_st(wcn, vif->addr, vif->addr,
> +                                               link_state);
> +               } else {
> +                       wcn36xx_smd_set_link_st(wcn, vif->addr, vif->addr,
> +                                               WCN36XX_HAL_LINK_IDLE_STATE);
> +                       wcn36xx_smd_delete_bss(wcn, vif);
> +               }
> +       }
> +out:
> +       return;
> +}
> +
> +/* this is required when using IEEE80211_HW_HAS_RATE_CONTROL */
> +static int wcn36xx_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac set RTS threshold %d\n", value);
> +
> +       wcn36xx_smd_update_cfg(wcn, WCN36XX_HAL_CFG_RTS_THRESHOLD, value);
> +       return 0;
> +}
> +
> +static void wcn36xx_remove_interface(struct ieee80211_hw *hw,
> +                                    struct ieee80211_vif *vif)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac remove interface vif %p\n", vif);
> +
> +       list_del(&vif_priv->list);
> +       wcn36xx_smd_delete_sta_self(wcn, vif->addr);
> +}
> +
> +static int wcn36xx_add_interface(struct ieee80211_hw *hw,
> +                                struct ieee80211_vif *vif)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac add interface vif %p type %d\n",
> +                   vif, vif->type);
> +
> +       if (!(NL80211_IFTYPE_STATION == vif->type ||
> +             NL80211_IFTYPE_AP == vif->type ||
> +             NL80211_IFTYPE_ADHOC == vif->type ||
> +             NL80211_IFTYPE_MESH_POINT == vif->type)) {
> +               wcn36xx_warn("Unsupported interface type requested: %d\n",
> +                            vif->type);
> +               return -EOPNOTSUPP;
> +       }
> +
> +       list_add(&vif_priv->list, &wcn->vif_list);
> +       wcn36xx_smd_add_sta_self(wcn, vif);
> +
> +       return 0;
> +}
> +
> +static int wcn36xx_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +                          struct ieee80211_sta *sta)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +       struct wcn36xx_sta *sta_priv = (struct wcn36xx_sta *)sta->drv_priv;
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac sta add vif %p sta %pM\n",
> +                   vif, sta->addr);
> +
> +       vif_priv->sta = sta_priv;
> +       sta_priv->vif = vif_priv;
> +       /*
> +        * For STA mode HW will be configured on BSS_CHANGED_ASSOC because
> +        * at this stage AID is not available yet.
> +        */
> +       if (NL80211_IFTYPE_STATION != vif->type) {
> +               wcn36xx_update_allowed_rates(sta, WCN36XX_BAND(wcn));
> +               sta_priv->aid = sta->aid;
> +               wcn36xx_smd_config_sta(wcn, vif, sta);
> +       }
> +       return 0;
> +}
> +
> +static int wcn36xx_sta_remove(struct ieee80211_hw *hw,
> +                             struct ieee80211_vif *vif,
> +                             struct ieee80211_sta *sta)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +       struct wcn36xx_sta *sta_priv = (struct wcn36xx_sta *)sta->drv_priv;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac sta remove vif %p sta %pM index %d\n",
> +                   vif, sta->addr, sta_priv->sta_index);
> +
> +       wcn36xx_smd_delete_sta(wcn, sta_priv->sta_index);
> +       vif_priv->sta = NULL;
> +       sta_priv->vif = NULL;
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +
> +static int wcn36xx_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wow)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac suspend\n");
> +
> +       flush_workqueue(wcn->hal_ind_wq);
> +       wcn36xx_smd_set_power_params(wcn, true);
> +       return 0;
> +}
> +
> +static int wcn36xx_resume(struct ieee80211_hw *hw)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac resume\n");
> +
> +       flush_workqueue(wcn->hal_ind_wq);
> +       wcn36xx_smd_set_power_params(wcn, false);
> +       return 0;
> +}
> +
> +#endif
> +
> +static int wcn36xx_ampdu_action(struct ieee80211_hw *hw,
> +                   struct ieee80211_vif *vif,
> +                   enum ieee80211_ampdu_mlme_action action,
> +                   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
> +                   u8 buf_size)
> +{
> +       struct wcn36xx *wcn = hw->priv;
> +       struct wcn36xx_sta *sta_priv = NULL;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "mac ampdu action action %d tid %d\n",
> +                   action, tid);
> +
> +       sta_priv = (struct wcn36xx_sta *)sta->drv_priv;
> +
> +       switch (action) {
> +       case IEEE80211_AMPDU_RX_START:
> +               sta_priv->tid = tid;
> +               wcn36xx_smd_add_ba_session(wcn, sta, tid, ssn, 0,
> +                       get_sta_index(vif, sta_priv));
> +               wcn36xx_smd_add_ba(wcn);
> +               wcn36xx_smd_trigger_ba(wcn, get_sta_index(vif, sta_priv));
> +               ieee80211_start_tx_ba_session(sta, tid, 0);
> +               break;
> +       case IEEE80211_AMPDU_RX_STOP:
> +               wcn36xx_smd_del_ba(wcn, tid, get_sta_index(vif, sta_priv));
> +               break;
> +       case IEEE80211_AMPDU_TX_START:
> +               ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
> +               break;
> +       case IEEE80211_AMPDU_TX_OPERATIONAL:
> +               wcn36xx_smd_add_ba_session(wcn, sta, tid, ssn, 1,
> +                       get_sta_index(vif, sta_priv));
> +               break;
> +       case IEEE80211_AMPDU_TX_STOP_FLUSH:
> +       case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
> +       case IEEE80211_AMPDU_TX_STOP_CONT:
> +               ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
> +               break;
> +       default:
> +               wcn36xx_err("Unknown AMPDU action\n");
> +       }
> +
> +       return 0;
> +}
> +
> +static const struct ieee80211_ops wcn36xx_ops = {
> +       .start                  = wcn36xx_start,
> +       .stop                   = wcn36xx_stop,
> +       .add_interface          = wcn36xx_add_interface,
> +       .remove_interface       = wcn36xx_remove_interface,
> +#ifdef CONFIG_PM
> +       .suspend                = wcn36xx_suspend,
> +       .resume                 = wcn36xx_resume,
> +#endif
> +       .config                 = wcn36xx_config,
> +       .configure_filter       = wcn36xx_configure_filter,
> +       .tx                     = wcn36xx_tx,
> +       .set_key                = wcn36xx_set_key,
> +       .sw_scan_start          = wcn36xx_sw_scan_start,
> +       .sw_scan_complete       = wcn36xx_sw_scan_complete,
> +       .bss_info_changed       = wcn36xx_bss_info_changed,
> +       .set_rts_threshold      = wcn36xx_set_rts_threshold,
> +       .sta_add                = wcn36xx_sta_add,
> +       .sta_remove             = wcn36xx_sta_remove,
> +       .ampdu_action           = wcn36xx_ampdu_action,
> +};
> +
> +static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
> +{
> +       int ret = 0;
> +
> +       static const u32 cipher_suites[] = {
> +               WLAN_CIPHER_SUITE_WEP40,
> +               WLAN_CIPHER_SUITE_WEP104,
> +               WLAN_CIPHER_SUITE_TKIP,
> +               WLAN_CIPHER_SUITE_CCMP,
> +       };
> +
> +       wcn->hw->flags = IEEE80211_HW_SIGNAL_DBM |
> +               IEEE80211_HW_HAS_RATE_CONTROL |
> +               IEEE80211_HW_SUPPORTS_PS |
> +               IEEE80211_HW_CONNECTION_MONITOR |
> +               IEEE80211_HW_AMPDU_AGGREGATION |
> +               IEEE80211_HW_TIMING_BEACON_ONLY;
> +
> +       wcn->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
> +               BIT(NL80211_IFTYPE_AP) |
> +               BIT(NL80211_IFTYPE_ADHOC) |
> +               BIT(NL80211_IFTYPE_MESH_POINT);
> +
> +       wcn->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wcn_band_2ghz;
> +       wcn->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wcn_band_5ghz;
> +
> +       wcn->hw->wiphy->cipher_suites = cipher_suites;
> +       wcn->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
> +
> +       wcn->hw->wiphy->flags |= WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
> +
> +#ifdef CONFIG_PM
> +       wcn->hw->wiphy->wowlan = &wowlan_support;
> +#endif
> +
> +       wcn->hw->max_listen_interval = 200;
> +
> +       wcn->hw->queues = 4;
> +
> +       SET_IEEE80211_DEV(wcn->hw, wcn->dev);
> +
> +       wcn->hw->sta_data_size = sizeof(struct wcn36xx_sta);
> +       wcn->hw->vif_data_size = sizeof(struct wcn36xx_vif);
> +
> +       return ret;
> +}
> +
> +static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
> +                                         struct platform_device *pdev)
> +{
> +       struct resource *res;
> +       /* Set TX IRQ */
> +       res = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> +                                          "wcnss_wlantx_irq");
> +       if (!res) {
> +               wcn36xx_err("failed to get tx_irq\n");
> +               return -ENOENT;
> +       }
> +       wcn->tx_irq = res->start;
> +
> +       /* Set RX IRQ */
> +       res = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> +                                          "wcnss_wlanrx_irq");
> +       if (!res) {
> +               wcn36xx_err("failed to get rx_irq\n");
> +               return -ENOENT;
> +       }
> +       wcn->rx_irq = res->start;
> +
> +       /* Map the memory */
> +       res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +                                                "wcnss_mmio");
> +       if (!res) {
> +               wcn36xx_err("failed to get mmio\n");
> +               return -ENOENT;
> +       }
> +       wcn->mmio = ioremap(res->start, resource_size(res));
> +       if (!wcn->mmio) {
> +               wcn36xx_err("failed to map io memory\n");
> +               return -ENOMEM;
> +       }
> +       return 0;
> +}
> +
> +static int wcn36xx_probe(struct platform_device *pdev)
> +{
> +       struct ieee80211_hw *hw;
> +       struct wcn36xx *wcn;
> +       int ret;
> +       u8 addr[ETH_ALEN];
> +
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "platform probe\n");
> +
> +       hw = ieee80211_alloc_hw(sizeof(struct wcn36xx), &wcn36xx_ops);
> +       if (!hw) {
> +               wcn36xx_err("failed to alloc hw\n");
> +               ret = -ENOMEM;
> +               goto out_err;
> +       }
> +       platform_set_drvdata(pdev, hw);
> +       wcn = hw->priv;
> +       wcn->hw = hw;
> +       wcn->dev = &pdev->dev;
> +       wcn->ctrl_ops = pdev->dev.platform_data;
> +
> +       mutex_init(&wcn->hal_mutex);
> +
> +       if (!wcn->ctrl_ops->get_hw_mac(addr)) {
> +               wcn36xx_info("mac address: %pM\n", addr);
> +               SET_IEEE80211_PERM_ADDR(wcn->hw, addr);
> +       }
> +
> +       ret = wcn36xx_platform_get_resources(wcn, pdev);
> +       if (ret)
> +               goto out_wq;
> +
> +       wcn36xx_init_ieee80211(wcn);
> +       ret = ieee80211_register_hw(wcn->hw);
> +       if (ret)
> +               goto out_unmap;
> +
> +       return 0;
> +
> +out_unmap:
> +       iounmap(wcn->mmio);
> +out_wq:
> +       ieee80211_free_hw(hw);
> +out_err:
> +       return ret;
> +}
> +static int wcn36xx_remove(struct platform_device *pdev)
> +{
> +       struct ieee80211_hw *hw = platform_get_drvdata(pdev);
> +       struct wcn36xx *wcn = hw->priv;
> +       wcn36xx_dbg(WCN36XX_DBG_MAC, "platform remove\n");
> +
> +       mutex_destroy(&wcn->hal_mutex);
> +
> +       ieee80211_unregister_hw(hw);
> +       iounmap(wcn->mmio);
> +       ieee80211_free_hw(hw);
> +
> +       return 0;
> +}
> +static const struct platform_device_id wcn36xx_platform_id_table[] = {
> +       {
> +               .name = "wcn36xx",
> +               .driver_data = 0
> +       },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(platform, wcn36xx_platform_id_table);
> +
> +static struct platform_driver wcn36xx_driver = {
> +       .probe      = wcn36xx_probe,
> +       .remove     = wcn36xx_remove,
> +       .driver         = {
> +               .name   = "wcn36xx",
> +               .owner  = THIS_MODULE,
> +       },
> +       .id_table    = wcn36xx_platform_id_table,
> +};
> +
> +static int __init wcn36xx_init(void)
> +{
> +       platform_driver_register(&wcn36xx_driver);
> +       return 0;
> +}
> +module_init(wcn36xx_init);
> +
> +static void __exit wcn36xx_exit(void)
> +{
> +       platform_driver_unregister(&wcn36xx_driver);
> +}
> +module_exit(wcn36xx_exit);
> +
> +MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_AUTHOR("Eugene Krasnikov k.eugene.e@gmail.com");
> +MODULE_FIRMWARE(WLAN_NV_FILE);
> diff --git a/drivers/net/wireless/ath/wcn36xx/pmc.c b/drivers/net/wireless/ath/wcn36xx/pmc.c
> new file mode 100644
> index 0000000..28b515c
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/pmc.c
> @@ -0,0 +1,62 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include "wcn36xx.h"
> +
> +int wcn36xx_pmc_enter_bmps_state(struct wcn36xx *wcn,
> +                                struct ieee80211_vif *vif)
> +{
> +       int ret = 0;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +       /* TODO: Make sure the TX chain clean */
> +       ret = wcn36xx_smd_enter_bmps(wcn, vif);
> +       if (!ret) {
> +               wcn36xx_dbg(WCN36XX_DBG_PMC, "Entered BMPS\n");
> +               vif_priv->pw_state = WCN36XX_BMPS;
> +       } else {
> +               /*
> +                * One of the reasons why HW will not enter BMPS is because
> +                * driver is trying to enter bmps before first beacon was
> +                * received just after auth complete
> +                */
> +               wcn36xx_err("Can not enter BMPS!\n");
> +       }
> +       return ret;
> +}
> +
> +int wcn36xx_pmc_exit_bmps_state(struct wcn36xx *wcn,
> +                               struct ieee80211_vif *vif)
> +{
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +
> +       if (WCN36XX_BMPS != vif_priv->pw_state) {
> +               wcn36xx_err("Not in BMPS mode, no need to exit from BMPS mode!\n");
> +               return -EINVAL;
> +       }
> +       wcn36xx_smd_exit_bmps(wcn, vif);
> +       vif_priv->pw_state = WCN36XX_FULL_POWER;
> +       return 0;
> +}
> +
> +int wcn36xx_enable_keep_alive_null_packet(struct wcn36xx *wcn,
> +                                         struct ieee80211_vif *vif)
> +{
> +       wcn36xx_dbg(WCN36XX_DBG_PMC, "%s\n", __func__);
> +       return wcn36xx_smd_keep_alive_req(wcn, vif,
> +                                         WCN36XX_HAL_KEEP_ALIVE_NULL_PKT);
> +}
> diff --git a/drivers/net/wireless/ath/wcn36xx/pmc.h b/drivers/net/wireless/ath/wcn36xx/pmc.h
> new file mode 100644
> index 0000000..f72ed68
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/pmc.h
> @@ -0,0 +1,33 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#ifndef _WCN36XX_PMC_H_
> +#define _WCN36XX_PMC_H_
> +
> +struct wcn36xx;
> +
> +enum wcn36xx_power_state {
> +       WCN36XX_FULL_POWER,
> +       WCN36XX_BMPS
> +};
> +
> +int wcn36xx_pmc_enter_bmps_state(struct wcn36xx *wcn,
> +                                struct ieee80211_vif *vif);
> +int wcn36xx_pmc_exit_bmps_state(struct wcn36xx *wcn,
> +                               struct ieee80211_vif *vif);
> +int wcn36xx_enable_keep_alive_null_packet(struct wcn36xx *wcn,
> +                                         struct ieee80211_vif *vif);
> +#endif /* _WCN36XX_PMC_H_ */
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> new file mode 100644
> index 0000000..9a71b95
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -0,0 +1,2121 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/etherdevice.h>
> +#include <linux/firmware.h>
> +#include <linux/bitops.h>
> +#include "smd.h"
> +
> +static int put_cfg_tlv_u32(struct wcn36xx *wcn, size_t *len, u32 id, u32 value)
> +{
> +       struct wcn36xx_hal_cfg *entry;
> +       u32 *val;
> +
> +       if (*len + sizeof(*entry) + sizeof(u32) >= WCN36XX_HAL_BUF_SIZE) {
> +               wcn36xx_err("Not enough room for TLV entry\n");
> +               return -ENOMEM;
> +       }
> +
> +       entry = (struct wcn36xx_hal_cfg *) (wcn->hal_buf + *len);
> +       entry->id = id;
> +       entry->len = sizeof(u32);
> +       entry->pad_bytes = 0;
> +       entry->reserve = 0;
> +
> +       val = (u32 *) (entry + 1);
> +       *val = value;
> +
> +       *len += sizeof(*entry) + sizeof(u32);
> +
> +       return 0;
> +}
> +
> +static void wcn36xx_smd_set_bss_nw_type(struct wcn36xx *wcn,
> +               struct ieee80211_sta *sta,
> +               struct wcn36xx_hal_config_bss_params *bss_params)
> +{
> +       if (IEEE80211_BAND_5GHZ == WCN36XX_BAND(wcn))
> +               bss_params->nw_type = WCN36XX_HAL_11A_NW_TYPE;
> +       else if (sta && sta->ht_cap.ht_supported)
> +               bss_params->nw_type = WCN36XX_HAL_11N_NW_TYPE;
> +       else if (sta && (sta->supp_rates[IEEE80211_BAND_2GHZ] & 0x7f))
> +               bss_params->nw_type = WCN36XX_HAL_11G_NW_TYPE;
> +       else
> +               bss_params->nw_type = WCN36XX_HAL_11B_NW_TYPE;
> +}
> +
> +static void wcn36xx_smd_set_bss_ht_params(struct ieee80211_vif *vif,
> +               struct ieee80211_sta *sta,
> +               struct wcn36xx_hal_config_bss_params *bss_params)
> +{
> +       if (sta && sta->ht_cap.ht_supported) {
> +               unsigned long caps = sta->ht_cap.cap;
> +               bss_params->ht = sta->ht_cap.ht_supported;
> +               bss_params->tx_channel_width_set =
> +                       test_bit(IEEE80211_HT_CAP_SUP_WIDTH_20_40, &caps);
> +               bss_params->lsig_tx_op_protection_full_support =
> +                       test_bit(IEEE80211_HT_CAP_LSIG_TXOP_PROT, &caps);
> +
> +               bss_params->ht_oper_mode = vif->bss_conf.ht_operation_mode;
> +               bss_params->lln_non_gf_coexist =
> +                       !!(vif->bss_conf.ht_operation_mode &
> +                          IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
> +               /* IEEE80211_HT_STBC_PARAM_DUAL_CTS_PROT */
> +               bss_params->dual_cts_protection = 0;
> +               /* IEEE80211_HT_OP_MODE_PROTECTION_20MHZ */
> +               bss_params->ht20_coexist = 0;
> +       }
> +}
> +
> +static void wcn36xx_smd_set_sta_ht_params(struct ieee80211_sta *sta,
> +               struct wcn36xx_hal_config_sta_params *sta_params)
> +{
> +       if (sta->ht_cap.ht_supported) {
> +               unsigned long caps = sta->ht_cap.cap;
> +               sta_params->ht_capable = sta->ht_cap.ht_supported;
> +               sta_params->tx_channel_width_set =
> +                       test_bit(IEEE80211_HT_CAP_SUP_WIDTH_20_40, &caps);
> +               sta_params->lsig_txop_protection =
> +                       test_bit(IEEE80211_HT_CAP_LSIG_TXOP_PROT, &caps);
> +
> +               sta_params->max_ampdu_size = sta->ht_cap.ampdu_factor;
> +               sta_params->max_ampdu_density = sta->ht_cap.ampdu_density;
> +               sta_params->max_amsdu_size =
> +                       test_bit(IEEE80211_HT_CAP_MAX_AMSDU, &caps);
> +               sta_params->sgi_20Mhz =
> +                       test_bit(IEEE80211_HT_CAP_SGI_20, &caps);
> +               sta_params->sgi_40mhz =
> +                       test_bit(IEEE80211_HT_CAP_SGI_40, &caps);
> +               sta_params->green_field_capable =
> +                       test_bit(IEEE80211_HT_CAP_GRN_FLD, &caps);
> +               sta_params->delayed_ba_support =
> +                       test_bit(IEEE80211_HT_CAP_DELAY_BA, &caps);
> +               sta_params->dsss_cck_mode_40mhz =
> +                       test_bit(IEEE80211_HT_CAP_DSSSCCK40, &caps);
> +       }
> +}
> +
> +static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
> +               struct ieee80211_vif *vif,
> +               struct ieee80211_sta *sta,
> +               struct wcn36xx_hal_config_sta_params *sta_params)
> +{
> +       struct wcn36xx_vif *priv_vif = (struct wcn36xx_vif *)vif->drv_priv;
> +       struct wcn36xx_sta *priv_sta = NULL;
> +       if (vif->type == NL80211_IFTYPE_ADHOC ||
> +           vif->type == NL80211_IFTYPE_AP ||
> +           vif->type == NL80211_IFTYPE_MESH_POINT) {
> +               sta_params->type = 1;
> +               sta_params->sta_index = 0xFF;
> +       } else {
> +               sta_params->type = 0;
> +               sta_params->sta_index = 1;
> +       }
> +
> +       sta_params->listen_interval = WCN36XX_LISTEN_INTERVAL(wcn);
> +
> +       /*
> +        * In STA mode ieee80211_sta contains bssid and ieee80211_vif
> +        * contains our mac address. In  AP mode we are bssid so vif
> +        * contains bssid and ieee80211_sta contains mac.
> +        */
> +       if (NL80211_IFTYPE_STATION == vif->type)
> +               memcpy(&sta_params->mac, vif->addr, ETH_ALEN);
> +       else
> +               memcpy(&sta_params->bssid, vif->addr, ETH_ALEN);
> +
> +       sta_params->encrypt_type = priv_vif->encrypt_type;
> +       sta_params->short_preamble_supported =
> +               !(WCN36XX_FLAGS(wcn) &
> +                 IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE);
> +
> +       sta_params->rifs_mode = 0;
> +       sta_params->rmf = 0;
> +       sta_params->action = 0;
> +       sta_params->uapsd = 0;
> +       sta_params->mimo_ps = WCN36XX_HAL_HT_MIMO_PS_STATIC;
> +       sta_params->max_ampdu_duration = 0;
> +       sta_params->bssid_index = priv_vif->bss_index;
> +       sta_params->p2p = 0;
> +
> +       if (sta) {
> +               priv_sta = (struct wcn36xx_sta *)sta->drv_priv;
> +               if (NL80211_IFTYPE_STATION == vif->type)
> +                       memcpy(&sta_params->bssid, sta->addr, ETH_ALEN);
> +               else
> +                       memcpy(&sta_params->mac, sta->addr, ETH_ALEN);
> +               sta_params->wmm_enabled = sta->wme;
> +               sta_params->max_sp_len = sta->max_sp;
> +               sta_params->aid = priv_sta->aid;
> +               wcn36xx_smd_set_sta_ht_params(sta, sta_params);
> +               memcpy(&sta_params->supported_rates, &priv_sta->supported_rates,
> +                       sizeof(priv_sta->supported_rates));
> +       } else {
> +               wcn36xx_set_default_rates(&sta_params->supported_rates);
> +       }
> +}
> +
> +static int wcn36xx_smd_send_and_wait(struct wcn36xx *wcn, size_t len)
> +{
> +       int ret = 0;
> +       wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "HAL >>> ", wcn->hal_buf, len);
> +
> +       init_completion(&wcn->hal_rsp_compl);
> +       ret = wcn->ctrl_ops->tx(wcn->hal_buf, len);
> +       if (ret) {
> +               wcn36xx_err("HAL TX failed\n");
> +               goto out;
> +       }
> +       if (wait_for_completion_timeout(&wcn->hal_rsp_compl,
> +               msecs_to_jiffies(HAL_MSG_TIMEOUT)) <= 0) {
> +               wcn36xx_err("Timeout while waiting SMD response\n");
> +               ret = -ETIME;
> +               goto out;
> +       }
> +out:
> +       return ret;
> +}
> +
> +#define INIT_HAL_MSG(msg_body, type) \
> +       do {                                                            \
> +               memset(&msg_body, 0, sizeof(msg_body));                 \
> +               msg_body.header.msg_type = type;                        \
> +               msg_body.header.msg_version = WCN36XX_HAL_MSG_VERSION0; \
> +               msg_body.header.len = sizeof(msg_body);                 \
> +       } while (0)                                                     \
> +
> +#define PREPARE_HAL_BUF(send_buf, msg_body) \
> +       do {                                                    \
> +               memset(send_buf, 0, msg_body.header.len);       \
> +               memcpy(send_buf, &msg_body, sizeof(msg_body));  \
> +       } while (0)                                             \
> +
> +static int wcn36xx_smd_rsp_status_check(void *buf, size_t len)
> +{
> +       struct wcn36xx_fw_msg_status_rsp *rsp;
> +
> +       if (len < sizeof(struct wcn36xx_hal_msg_header) +
> +           sizeof(struct wcn36xx_fw_msg_status_rsp))
> +               return -EIO;
> +
> +       rsp = (struct wcn36xx_fw_msg_status_rsp *)
> +               (buf + sizeof(struct wcn36xx_hal_msg_header));
> +
> +       if (WCN36XX_FW_MSG_RESULT_SUCCESS != rsp->status)
> +               return rsp->status;
> +
> +       return 0;
> +}
> +
> +int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
> +{
> +       const struct firmware *nv;
> +       struct nv_data *nv_d;
> +       struct wcn36xx_hal_nv_img_download_req_msg msg_body;
> +       int fw_bytes_left;
> +       int ret;
> +       u16 fm_offset = 0;
> +
> +       ret = request_firmware(&nv, WLAN_NV_FILE, wcn->dev);
> +       if (ret) {
> +               wcn36xx_err("Failed to load nv file %s: %d\n",
> +                             WLAN_NV_FILE, ret);
> +               goto out_free_nv;
> +       }
> +
> +       nv_d = (struct nv_data *)nv->data;
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_DOWNLOAD_NV_REQ);
> +
> +       msg_body.header.len += WCN36XX_NV_FRAGMENT_SIZE;
> +
> +       msg_body.frag_number = 0;
> +       /* hal_buf must be protected with  mutex */
> +       mutex_lock(&wcn->hal_mutex);
> +
> +       do {
> +               fw_bytes_left = nv->size - fm_offset - 4;
> +               if (fw_bytes_left > WCN36XX_NV_FRAGMENT_SIZE) {
> +                       msg_body.last_fragment = 0;
> +                       msg_body.nv_img_buffer_size = WCN36XX_NV_FRAGMENT_SIZE;
> +               } else {
> +                       msg_body.last_fragment = 1;
> +                       msg_body.nv_img_buffer_size = fw_bytes_left;
> +
> +                       /* Do not forget update general message len */
> +                       msg_body.header.len = sizeof(msg_body) + fw_bytes_left;
> +
> +               }
> +
> +               /* Add load NV request message header */
> +               memcpy(wcn->hal_buf, &msg_body, sizeof(msg_body));
> +
> +               /* Add NV body itself */
> +               memcpy(wcn->hal_buf + sizeof(msg_body),
> +                      &nv_d->table + fm_offset,
> +                      msg_body.nv_img_buffer_size);
> +
> +               ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +               if (ret)
> +                       goto out_unlock;
> +               ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf,
> +                                                  wcn->hal_rsp_len);
> +               if (ret) {
> +                       wcn36xx_err("hal_load_nv response failed err=%d\n",
> +                                   ret);
> +                       goto out_unlock;
> +               }
> +               msg_body.frag_number++;
> +               fm_offset += WCN36XX_NV_FRAGMENT_SIZE;
> +
> +       } while (msg_body.last_fragment != 1);
> +
> +out_unlock:
> +       mutex_unlock(&wcn->hal_mutex);
> +out_free_nv:
> +       release_firmware(nv);
> +
> +       return ret;
> +}
> +
> +static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
> +{
> +       struct wcn36xx_hal_mac_start_rsp_msg *rsp;
> +
> +       if (len < sizeof(*rsp))
> +               return -EIO;
> +
> +       rsp = (struct wcn36xx_hal_mac_start_rsp_msg *)buf;
> +
> +       if (WCN36XX_FW_MSG_RESULT_SUCCESS != rsp->start_rsp_params.status)
> +               return -EIO;
> +
> +       memcpy(wcn->crm_version, rsp->start_rsp_params.crm_version,
> +              WCN36XX_HAL_VERSION_LENGTH);
> +       memcpy(wcn->wlan_version, rsp->start_rsp_params.wlan_version,
> +              WCN36XX_HAL_VERSION_LENGTH);
> +
> +       /* null terminate the strings, just in case */
> +       wcn->crm_version[WCN36XX_HAL_VERSION_LENGTH] = '\0';
> +       wcn->wlan_version[WCN36XX_HAL_VERSION_LENGTH] = '\0';
> +
> +       wcn->fw_revision = rsp->start_rsp_params.version.revision;
> +       wcn->fw_version = rsp->start_rsp_params.version.version;
> +       wcn->fw_minor = rsp->start_rsp_params.version.minor;
> +       wcn->fw_major = rsp->start_rsp_params.version.major;
> +
> +       wcn36xx_info("firmware WLAN version '%s' and CRM version '%s'\n",
> +                    wcn->wlan_version, wcn->crm_version);
> +
> +       wcn36xx_info("firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
> +                    wcn->fw_major, wcn->fw_minor,
> +                    wcn->fw_version, wcn->fw_revision,
> +                    rsp->start_rsp_params.stations,
> +                    rsp->start_rsp_params.bssids);
> +
> +       return 0;
> +}
> +
> +int wcn36xx_smd_start(struct wcn36xx *wcn)
> +{
> +       struct wcn36xx_hal_mac_start_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_START_REQ);
> +
> +       msg_body.params.type = DRIVER_TYPE_PRODUCTION;
> +       msg_body.params.len = 0;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL, "hal start type %d\n",
> +                   msg_body.params.type);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_start failed\n");
> +               goto out;
> +       }
> +
> +       ret = wcn36xx_smd_start_rsp(wcn, wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_start response failed err=%d\n", ret);
> +               goto out;
> +       }
> +
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_stop(struct wcn36xx *wcn)
> +{
> +       struct wcn36xx_hal_mac_stop_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_STOP_REQ);
> +
> +       msg_body.stop_req_params.reason = HAL_STOP_TYPE_RF_KILL;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_stop failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_stop response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_init_scan(struct wcn36xx *wcn, enum wcn36xx_hal_sys_mode mode)
> +{
> +       struct wcn36xx_hal_init_scan_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_INIT_SCAN_REQ);
> +
> +       msg_body.mode = mode;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL, "hal init scan mode %d\n", msg_body.mode);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_init_scan failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_init_scan response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_start_scan(struct wcn36xx *wcn)
> +{
> +       struct wcn36xx_hal_start_scan_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_START_SCAN_REQ);
> +
> +       msg_body.scan_channel = WCN36XX_HW_CHANNEL(wcn);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL, "hal start scan channel %d\n",
> +                   msg_body.scan_channel);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_start_scan failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_start_scan response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_end_scan(struct wcn36xx *wcn)
> +{
> +       struct wcn36xx_hal_end_scan_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_END_SCAN_REQ);
> +
> +       msg_body.scan_channel = WCN36XX_HW_CHANNEL(wcn);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL, "hal end scan channel %d\n",
> +                   msg_body.scan_channel);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_end_scan failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_end_scan response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_finish_scan(struct wcn36xx *wcn,
> +                           enum wcn36xx_hal_sys_mode mode)
> +{
> +       struct wcn36xx_hal_finish_scan_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_FINISH_SCAN_REQ);
> +
> +       msg_body.mode = mode;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL, "hal finish scan mode %d\n",
> +                   msg_body.mode);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_finish_scan failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_finish_scan response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +static int wcn36xx_smd_switch_channel_rsp(void *buf, size_t len)
> +{
> +       struct wcn36xx_hal_switch_channel_rsp_msg *rsp;
> +       int ret = 0;
> +
> +       ret = wcn36xx_smd_rsp_status_check(buf, len);
> +       if (ret)
> +               return ret;
> +       rsp = (struct wcn36xx_hal_switch_channel_rsp_msg *)buf;
> +       wcn36xx_dbg(WCN36XX_DBG_HAL, "channel switched to: %d, status: %d\n",
> +                   rsp->channel_number, rsp->status);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_switch_channel(struct wcn36xx *wcn,
> +                              struct ieee80211_vif *vif, int ch)
> +{
> +       struct wcn36xx_hal_switch_channel_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_CH_SWITCH_REQ);
> +
> +       msg_body.channel_number = (u8)ch;
> +       msg_body.tx_mgmt_power = 0xbf;
> +       msg_body.max_tx_power = 0xbf;
> +       memcpy(msg_body.self_sta_mac_addr, vif->addr, ETH_ALEN);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_switch_channel failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_switch_channel_rsp(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_switch_channel response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +static int wcn36xx_smd_update_scan_params_rsp(void *buf, size_t len)
> +{
> +       struct wcn36xx_hal_update_scan_params_resp *rsp;
> +
> +       rsp = (struct wcn36xx_hal_update_scan_params_resp *)buf;
> +
> +       /* Remove the PNO version bit */
> +       rsp->status &= (~(WCN36XX_FW_MSG_PNO_VERSION_MASK));
> +
> +       if (WCN36XX_FW_MSG_RESULT_SUCCESS != rsp->status) {
> +               wcn36xx_warn("error response from update scan\n");
> +               return rsp->status;
> +       }
> +
> +       return 0;
> +}
> +
> +int wcn36xx_smd_update_scan_params(struct wcn36xx *wcn)
> +{
> +       struct wcn36xx_hal_update_scan_params_req msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_UPDATE_SCAN_PARAM_REQ);
> +
> +       msg_body.dot11d_enabled = 0;
> +       msg_body.dot11d_resolved = 0;
> +       msg_body.channel_count = 26;
> +       msg_body.active_min_ch_time = 60;
> +       msg_body.active_max_ch_time = 120;
> +       msg_body.passive_min_ch_time = 60;
> +       msg_body.passive_max_ch_time = 110;
> +       msg_body.state = 0;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal update scan params channel_count %d\n",
> +                   msg_body.channel_count);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_update_scan_params failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_update_scan_params_rsp(wcn->hal_buf,
> +                                                wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_update_scan_params response failed err=%d\n",
> +                           ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +static int wcn36xx_smd_add_sta_self_rsp(struct wcn36xx *wcn,
> +                                       struct ieee80211_vif *vif,
> +                                       void *buf,
> +                                       size_t len)
> +{
> +       struct wcn36xx_hal_add_sta_self_rsp_msg *rsp;
> +       struct wcn36xx_vif *priv_vif = (struct wcn36xx_vif *)vif->drv_priv;
> +
> +       if (len < sizeof(*rsp))
> +               return -EINVAL;
> +
> +       rsp = (struct wcn36xx_hal_add_sta_self_rsp_msg *)buf;
> +
> +       if (rsp->status != WCN36XX_FW_MSG_RESULT_SUCCESS) {
> +               wcn36xx_warn("hal add sta self failure: %d\n",
> +                            rsp->status);
> +               return rsp->status;
> +       }
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal add sta self status %d self_sta_index %d dpu_index %d\n",
> +                   rsp->status, rsp->self_sta_index, rsp->dpu_index);
> +
> +       priv_vif->self_sta_index = rsp->self_sta_index;
> +       priv_vif->self_dpu_desc_index = rsp->dpu_index;
> +
> +       return 0;
> +}
> +
> +int wcn36xx_smd_add_sta_self(struct wcn36xx *wcn, struct ieee80211_vif *vif)
> +{
> +       struct wcn36xx_hal_add_sta_self_req msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_ADD_STA_SELF_REQ);
> +
> +       memcpy(&msg_body.self_addr, vif->addr, ETH_ALEN);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal add sta self self_addr %pM status %d\n",
> +                   msg_body.self_addr, msg_body.status);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_add_sta_self failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_add_sta_self_rsp(wcn,
> +                                          vif,
> +                                          wcn->hal_buf,
> +                                          wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_add_sta_self response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_delete_sta_self(struct wcn36xx *wcn, u8 *addr)
> +{
> +       struct wcn36xx_hal_del_sta_self_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_DEL_STA_SELF_REQ);
> +
> +       memcpy(&msg_body.self_addr, addr, ETH_ALEN);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_delete_sta_self failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_delete_sta_self response failed err=%d\n",
> +                           ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_delete_sta(struct wcn36xx *wcn, u8 sta_index)
> +{
> +       struct wcn36xx_hal_delete_sta_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_DELETE_STA_REQ);
> +
> +       msg_body.sta_index = sta_index;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal delete sta sta_index %d\n",
> +                   msg_body.sta_index);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_delete_sta failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_delete_sta response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +static int wcn36xx_smd_join_rsp(void *buf, size_t len)
> +{
> +       struct wcn36xx_hal_join_rsp_msg *rsp;
> +
> +       if (wcn36xx_smd_rsp_status_check(buf, len))
> +               return -EIO;
> +
> +       rsp = (struct wcn36xx_hal_join_rsp_msg *)buf;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal rsp join status %d tx_mgmt_power %d\n",
> +                   rsp->status, rsp->tx_mgmt_power);
> +
> +       return 0;
> +}
> +
> +int wcn36xx_smd_join(struct wcn36xx *wcn, const u8 *bssid, u8 *vif, u8 ch)
> +{
> +       struct wcn36xx_hal_join_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_JOIN_REQ);
> +
> +       memcpy(&msg_body.bssid, bssid, ETH_ALEN);
> +       memcpy(&msg_body.self_sta_mac_addr, vif, ETH_ALEN);
> +       msg_body.channel = ch;
> +
> +       if (conf_is_ht40_minus(&wcn->hw->conf))
> +               msg_body.secondary_channel_offset =
> +                       PHY_DOUBLE_CHANNEL_HIGH_PRIMARY;
> +       else if (conf_is_ht40_plus(&wcn->hw->conf))
> +               msg_body.secondary_channel_offset =
> +                       PHY_DOUBLE_CHANNEL_LOW_PRIMARY;
> +       else
> +               msg_body.secondary_channel_offset =
> +                       PHY_SINGLE_CHANNEL_CENTERED;
> +
> +       msg_body.link_state = WCN36XX_HAL_LINK_PREASSOC_STATE;
> +
> +       msg_body.max_tx_power = 0xbf;
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal join req bssid %pM self_sta_mac_addr %pM channel %d link_state %d\n",
> +                   msg_body.bssid, msg_body.self_sta_mac_addr,
> +                   msg_body.channel, msg_body.link_state);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_join failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_join_rsp(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_join response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_set_link_st(struct wcn36xx *wcn, const u8 *bssid,
> +                           const u8 *sta_mac,
> +                           enum wcn36xx_hal_link_state state)
> +{
> +       struct wcn36xx_hal_set_link_state_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_SET_LINK_ST_REQ);
> +
> +       memcpy(&msg_body.bssid, bssid, ETH_ALEN);
> +       memcpy(&msg_body.self_mac_addr, sta_mac, ETH_ALEN);
> +       msg_body.state = state;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal set link state bssid %pM self_mac_addr %pM state %d\n",
> +                   msg_body.bssid, msg_body.self_mac_addr, msg_body.state);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_set_link_st failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_set_link_st response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +static void wcn36xx_smd_convert_sta_to_v1(struct wcn36xx *wcn,
> +                       const struct wcn36xx_hal_config_sta_params *orig,
> +                       struct wcn36xx_hal_config_sta_params_v1 *v1)
> +{
> +       /* convert orig to v1 format */
> +       memcpy(&v1->bssid, orig->bssid, ETH_ALEN);
> +       memcpy(&v1->mac, orig->mac, ETH_ALEN);
> +       v1->aid = orig->aid;
> +       v1->type = orig->type;
> +       v1->listen_interval = orig->listen_interval;
> +       v1->ht_capable = orig->ht_capable;
> +
> +       v1->max_ampdu_size = orig->max_ampdu_size;
> +       v1->max_ampdu_density = orig->max_ampdu_density;
> +       v1->sgi_40mhz = orig->sgi_40mhz;
> +       v1->sgi_20Mhz = orig->sgi_20Mhz;
> +
> +       memcpy(&v1->supported_rates, &orig->supported_rates,
> +              sizeof(orig->supported_rates));
> +       v1->sta_index = orig->sta_index;
> +}
> +
> +static int wcn36xx_smd_config_sta_rsp(struct wcn36xx *wcn,
> +                                     struct ieee80211_sta *sta,
> +                                     void *buf,
> +                                     size_t len)
> +{
> +       struct wcn36xx_hal_config_sta_rsp_msg *rsp;
> +       struct config_sta_rsp_params *params;
> +       struct wcn36xx_sta *sta_priv = (struct wcn36xx_sta *)sta->drv_priv;
> +
> +       if (len < sizeof(*rsp))
> +               return -EINVAL;
> +
> +       rsp = (struct wcn36xx_hal_config_sta_rsp_msg *)buf;
> +       params = &rsp->params;
> +
> +       if (params->status != WCN36XX_FW_MSG_RESULT_SUCCESS) {
> +               wcn36xx_warn("hal config sta response failure: %d\n",
> +                            params->status);
> +               return -EIO;
> +       }
> +
> +       sta_priv->sta_index = params->sta_index;
> +       sta_priv->dpu_desc_index = params->dpu_index;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal config sta rsp status %d sta_index %d bssid_index %d p2p %d\n",
> +                   params->status, params->sta_index, params->bssid_index,
> +                   params->p2p);
> +
> +       return 0;
> +}
> +
> +static int wcn36xx_smd_config_sta_v1(struct wcn36xx *wcn,
> +                    const struct wcn36xx_hal_config_sta_req_msg *orig)
> +{
> +       struct wcn36xx_hal_config_sta_req_msg_v1 msg_body;
> +       struct wcn36xx_hal_config_sta_params_v1 *sta = &msg_body.sta_params;
> +
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_CONFIG_STA_REQ);
> +
> +       wcn36xx_smd_convert_sta_to_v1(wcn, &orig->sta_params,
> +                                     &msg_body.sta_params);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal config sta v1 action %d sta_index %d bssid_index %d bssid %pM type %d mac %pM aid %d\n",
> +                   sta->action, sta->sta_index, sta->bssid_index,
> +                   sta->bssid, sta->type, sta->mac, sta->aid);
> +
> +       return wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +}
> +
> +int wcn36xx_smd_config_sta(struct wcn36xx *wcn, struct ieee80211_vif *vif,
> +                          struct ieee80211_sta *sta)
> +{
> +       struct wcn36xx_hal_config_sta_req_msg msg;
> +       struct wcn36xx_hal_config_sta_params *sta_params;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg, WCN36XX_HAL_CONFIG_STA_REQ);
> +
> +       sta_params = &msg.sta_params;
> +
> +       wcn36xx_smd_set_sta_params(wcn, vif, sta, sta_params);
> +
> +       if (!wcn36xx_is_fw_version(wcn, 1, 2, 2, 24)) {
> +               ret = wcn36xx_smd_config_sta_v1(wcn, &msg);
> +       } else {
> +               PREPARE_HAL_BUF(wcn->hal_buf, msg);
> +
> +               wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                           "hal config sta action %d sta_index %d bssid_index %d bssid %pM type %d mac %pM aid %d\n",
> +                           sta_params->action, sta_params->sta_index,
> +                           sta_params->bssid_index, sta_params->bssid,
> +                           sta_params->type, sta_params->mac, sta_params->aid);
> +
> +               ret = wcn36xx_smd_send_and_wait(wcn, msg.header.len);
> +       }
> +       if (ret) {
> +               wcn36xx_err("Sending hal_config_sta failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_config_sta_rsp(wcn,
> +                                        sta,
> +                                        wcn->hal_buf,
> +                                        wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_config_sta response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +static int wcn36xx_smd_config_bss_v1(struct wcn36xx *wcn,
> +                       const struct wcn36xx_hal_config_bss_req_msg *orig)
> +{
> +       struct wcn36xx_hal_config_bss_req_msg_v1 msg_body;
> +       struct wcn36xx_hal_config_bss_params_v1 *bss = &msg_body.bss_params;
> +       struct wcn36xx_hal_config_sta_params_v1 *sta = &bss->sta;
> +
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_CONFIG_BSS_REQ);
> +
> +       /* convert orig to v1 */
> +       memcpy(&msg_body.bss_params.bssid,
> +              &orig->bss_params.bssid, ETH_ALEN);
> +       memcpy(&msg_body.bss_params.self_mac_addr,
> +              &orig->bss_params.self_mac_addr, ETH_ALEN);
> +
> +       msg_body.bss_params.bss_type = orig->bss_params.bss_type;
> +       msg_body.bss_params.oper_mode = orig->bss_params.oper_mode;
> +       msg_body.bss_params.nw_type = orig->bss_params.nw_type;
> +
> +       msg_body.bss_params.short_slot_time_supported =
> +               orig->bss_params.short_slot_time_supported;
> +       msg_body.bss_params.lla_coexist = orig->bss_params.lla_coexist;
> +       msg_body.bss_params.llb_coexist = orig->bss_params.llb_coexist;
> +       msg_body.bss_params.llg_coexist = orig->bss_params.llg_coexist;
> +       msg_body.bss_params.ht20_coexist = orig->bss_params.ht20_coexist;
> +       msg_body.bss_params.lln_non_gf_coexist =
> +               orig->bss_params.lln_non_gf_coexist;
> +
> +       msg_body.bss_params.lsig_tx_op_protection_full_support =
> +               orig->bss_params.lsig_tx_op_protection_full_support;
> +       msg_body.bss_params.rifs_mode = orig->bss_params.rifs_mode;
> +       msg_body.bss_params.beacon_interval = orig->bss_params.beacon_interval;
> +       msg_body.bss_params.dtim_period = orig->bss_params.dtim_period;
> +       msg_body.bss_params.tx_channel_width_set =
> +               orig->bss_params.tx_channel_width_set;
> +       msg_body.bss_params.oper_channel = orig->bss_params.oper_channel;
> +       msg_body.bss_params.ext_channel = orig->bss_params.ext_channel;
> +
> +       msg_body.bss_params.reserved = orig->bss_params.reserved;
> +
> +       memcpy(&msg_body.bss_params.ssid,
> +              &orig->bss_params.ssid,
> +              sizeof(orig->bss_params.ssid));
> +
> +       msg_body.bss_params.action = orig->bss_params.action;
> +       msg_body.bss_params.rateset = orig->bss_params.rateset;
> +       msg_body.bss_params.ht = orig->bss_params.ht;
> +       msg_body.bss_params.obss_prot_enabled =
> +               orig->bss_params.obss_prot_enabled;
> +       msg_body.bss_params.rmf = orig->bss_params.rmf;
> +       msg_body.bss_params.ht_oper_mode = orig->bss_params.ht_oper_mode;
> +       msg_body.bss_params.dual_cts_protection =
> +               orig->bss_params.dual_cts_protection;
> +
> +       msg_body.bss_params.max_probe_resp_retry_limit =
> +               orig->bss_params.max_probe_resp_retry_limit;
> +       msg_body.bss_params.hidden_ssid = orig->bss_params.hidden_ssid;
> +       msg_body.bss_params.proxy_probe_resp =
> +               orig->bss_params.proxy_probe_resp;
> +       msg_body.bss_params.edca_params_valid =
> +               orig->bss_params.edca_params_valid;
> +
> +       memcpy(&msg_body.bss_params.acbe,
> +              &orig->bss_params.acbe,
> +              sizeof(orig->bss_params.acbe));
> +       memcpy(&msg_body.bss_params.acbk,
> +              &orig->bss_params.acbk,
> +              sizeof(orig->bss_params.acbk));
> +       memcpy(&msg_body.bss_params.acvi,
> +              &orig->bss_params.acvi,
> +              sizeof(orig->bss_params.acvi));
> +       memcpy(&msg_body.bss_params.acvo,
> +              &orig->bss_params.acvo,
> +              sizeof(orig->bss_params.acvo));
> +
> +       msg_body.bss_params.ext_set_sta_key_param_valid =
> +               orig->bss_params.ext_set_sta_key_param_valid;
> +
> +       memcpy(&msg_body.bss_params.ext_set_sta_key_param,
> +              &orig->bss_params.ext_set_sta_key_param,
> +              sizeof(orig->bss_params.acvo));
> +
> +       msg_body.bss_params.wcn36xx_hal_persona =
> +               orig->bss_params.wcn36xx_hal_persona;
> +       msg_body.bss_params.spectrum_mgt_enable =
> +               orig->bss_params.spectrum_mgt_enable;
> +       msg_body.bss_params.tx_mgmt_power = orig->bss_params.tx_mgmt_power;
> +       msg_body.bss_params.max_tx_power = orig->bss_params.max_tx_power;
> +
> +       wcn36xx_smd_convert_sta_to_v1(wcn, &orig->bss_params.sta,
> +                                     &msg_body.bss_params.sta);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal config bss v1 bssid %pM self_mac_addr %pM bss_type %d oper_mode %d nw_type %d\n",
> +                   bss->bssid, bss->self_mac_addr, bss->bss_type,
> +                   bss->oper_mode, bss->nw_type);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "- sta bssid %pM action %d sta_index %d bssid_index %d aid %d type %d mac %pM\n",
> +                   sta->bssid, sta->action, sta->sta_index,
> +                   sta->bssid_index, sta->aid, sta->type, sta->mac);
> +
> +       return wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +}
> +
> +
> +static int wcn36xx_smd_config_bss_rsp(struct wcn36xx *wcn,
> +                                     struct ieee80211_vif *vif,
> +                                     void *buf,
> +                                     size_t len)
> +{
> +       struct wcn36xx_hal_config_bss_rsp_msg *rsp;
> +       struct wcn36xx_hal_config_bss_rsp_params *params;
> +       struct wcn36xx_vif *priv_vif = (struct wcn36xx_vif *)vif->drv_priv;
> +
> +       if (len < sizeof(*rsp))
> +               return -EINVAL;
> +
> +       rsp = (struct wcn36xx_hal_config_bss_rsp_msg *)buf;
> +       params = &rsp->bss_rsp_params;
> +
> +       if (params->status != WCN36XX_FW_MSG_RESULT_SUCCESS) {
> +               wcn36xx_warn("hal config bss response failure: %d\n",
> +                            params->status);
> +               return -EIO;
> +       }
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal config bss rsp status %d bss_idx %d dpu_desc_index %d"
> +                   " sta_idx %d self_idx %d bcast_idx %d mac %pM"
> +                   " power %d ucast_dpu_signature %d\n",
> +                   params->status, params->bss_index, params->dpu_desc_index,
> +                   params->bss_sta_index, params->bss_self_sta_index,
> +                   params->bss_bcast_sta_idx, params->mac,
> +                   params->tx_mgmt_power, params->ucast_dpu_signature);
> +
> +       priv_vif->bss_index = params->bss_index;
> +
> +       if (priv_vif->sta) {
> +               priv_vif->sta->bss_sta_index =  params->bss_sta_index;
> +               priv_vif->sta->bss_dpu_desc_index = params->dpu_desc_index;
> +       }
> +
> +       priv_vif->ucast_dpu_signature = params->ucast_dpu_signature;
> +
> +       return 0;
> +}
> +
> +int wcn36xx_smd_config_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif,
> +                          struct ieee80211_sta *sta, const u8 *bssid,
> +                          bool update)
> +{
> +       struct wcn36xx_hal_config_bss_req_msg msg;
> +       struct wcn36xx_hal_config_bss_params *bss;
> +       struct wcn36xx_hal_config_sta_params *sta_params;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg, WCN36XX_HAL_CONFIG_BSS_REQ);
> +
> +       bss = &msg.bss_params;
> +       sta_params = &bss->sta;
> +
> +       WARN_ON(is_zero_ether_addr(bssid));
> +
> +       memcpy(&bss->bssid, bssid, ETH_ALEN);
> +
> +       memcpy(bss->self_mac_addr, vif->addr, ETH_ALEN);
> +
> +       if (vif->type == NL80211_IFTYPE_STATION) {
> +               bss->bss_type = WCN36XX_HAL_INFRASTRUCTURE_MODE;
> +
> +               /* STA */
> +               bss->oper_mode = 1;
> +               bss->wcn36xx_hal_persona = WCN36XX_HAL_STA_MODE;
> +       } else if (vif->type == NL80211_IFTYPE_AP) {
> +               bss->bss_type = WCN36XX_HAL_INFRA_AP_MODE;
> +
> +               /* AP */
> +               bss->oper_mode = 0;
> +               bss->wcn36xx_hal_persona = WCN36XX_HAL_STA_SAP_MODE;
> +       } else if (vif->type == NL80211_IFTYPE_ADHOC ||
> +                  vif->type == NL80211_IFTYPE_MESH_POINT) {
> +               bss->bss_type = WCN36XX_HAL_IBSS_MODE;
> +
> +               /* STA */
> +               bss->oper_mode = 1;
> +       } else {
> +               wcn36xx_warn("Unknown type for bss config: %d\n", vif->type);
> +       }
> +
> +       if (vif->type == NL80211_IFTYPE_STATION)
> +               wcn36xx_smd_set_bss_nw_type(wcn, sta, bss);
> +       else
> +               bss->nw_type = WCN36XX_HAL_11N_NW_TYPE;
> +
> +       bss->short_slot_time_supported = vif->bss_conf.use_short_slot;
> +       bss->lla_coexist = 0;
> +       bss->llb_coexist = 0;
> +       bss->llg_coexist = 0;
> +       bss->rifs_mode = 0;
> +       bss->beacon_interval = vif->bss_conf.beacon_int;
> +       bss->dtim_period = vif_priv->dtim_period;
> +
> +       wcn36xx_smd_set_bss_ht_params(vif, sta, bss);
> +
> +       bss->oper_channel = WCN36XX_HW_CHANNEL(wcn);
> +
> +       if (conf_is_ht40_minus(&wcn->hw->conf))
> +               bss->ext_channel = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
> +       else if (conf_is_ht40_plus(&wcn->hw->conf))
> +               bss->ext_channel = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
> +       else
> +               bss->ext_channel = IEEE80211_HT_PARAM_CHA_SEC_NONE;
> +
> +       bss->reserved = 0;
> +       wcn36xx_smd_set_sta_params(wcn, vif, sta, sta_params);
> +
> +       /* wcn->ssid is only valid in AP and IBSS mode */
> +       bss->ssid.length = vif_priv->ssid.length;
> +       memcpy(bss->ssid.ssid, vif_priv->ssid.ssid, vif_priv->ssid.length);
> +
> +       bss->obss_prot_enabled = 0;
> +       bss->rmf = 0;
> +       bss->max_probe_resp_retry_limit = 0;
> +       bss->hidden_ssid = vif->bss_conf.hidden_ssid;
> +       bss->proxy_probe_resp = 0;
> +       bss->edca_params_valid = 0;
> +
> +       /* FIXME: set acbe, acbk, acvi and acvo */
> +
> +       bss->ext_set_sta_key_param_valid = 0;
> +
> +       /* FIXME: set ext_set_sta_key_param */
> +
> +       bss->spectrum_mgt_enable = 0;
> +       bss->tx_mgmt_power = 0;
> +       bss->max_tx_power = WCN36XX_MAX_POWER(wcn);
> +
> +       bss->action = update;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal config bss bssid %pM self_mac_addr %pM bss_type %d oper_mode %d nw_type %d\n",
> +                   bss->bssid, bss->self_mac_addr, bss->bss_type,
> +                   bss->oper_mode, bss->nw_type);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "- sta bssid %pM action %d sta_index %d bssid_index %d aid %d type %d mac %pM\n",
> +                   sta_params->bssid, sta_params->action,
> +                   sta_params->sta_index, sta_params->bssid_index,
> +                   sta_params->aid, sta_params->type,
> +                   sta_params->mac);
> +
> +       if (!wcn36xx_is_fw_version(wcn, 1, 2, 2, 24)) {
> +               ret = wcn36xx_smd_config_bss_v1(wcn, &msg);
> +       } else {
> +               PREPARE_HAL_BUF(wcn->hal_buf, msg);
> +
> +               ret = wcn36xx_smd_send_and_wait(wcn, msg.header.len);
> +       }
> +       if (ret) {
> +               wcn36xx_err("Sending hal_config_bss failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_config_bss_rsp(wcn,
> +                                        vif,
> +                                        wcn->hal_buf,
> +                                        wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_config_bss response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_delete_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif)
> +{
> +       struct wcn36xx_hal_delete_bss_req_msg msg_body;
> +       struct wcn36xx_vif *priv_vif = (struct wcn36xx_vif *)vif->drv_priv;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_DELETE_BSS_REQ);
> +
> +       msg_body.bss_index = priv_vif->bss_index;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL, "hal delete bss %d\n", msg_body.bss_index);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_delete_bss failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_delete_bss response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
> +                           struct sk_buff *skb_beacon, u16 tim_off,
> +                           u16 p2p_off)
> +{
> +       struct wcn36xx_hal_send_beacon_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_SEND_BEACON_REQ);
> +
> +       /* TODO need to find out why this is needed? */
> +       msg_body.beacon_length = skb_beacon->len + 6;
> +
> +       if (BEACON_TEMPLATE_SIZE > msg_body.beacon_length) {
> +               memcpy(&msg_body.beacon, &skb_beacon->len, sizeof(u32));
> +               memcpy(&(msg_body.beacon[4]), skb_beacon->data,
> +                      skb_beacon->len);
> +       } else {
> +               wcn36xx_err("Beacon is to big: beacon size=%d\n",
> +                             msg_body.beacon_length);
> +               return -ENOMEM;
> +       }
> +       memcpy(msg_body.bssid, vif->addr, ETH_ALEN);
> +
> +       /* TODO need to find out why this is needed? */
> +       msg_body.tim_ie_offset = tim_off+4;
> +       msg_body.p2p_ie_offset = p2p_off;
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal send beacon beacon_length %d\n",
> +                   msg_body.beacon_length);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_send_beacon failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_send_beacon response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_update_proberesp_tmpl(struct wcn36xx *wcn,
> +                                     struct ieee80211_vif *vif,
> +                                     struct sk_buff *skb)
> +{
> +       struct wcn36xx_hal_send_probe_resp_req_msg msg;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg, WCN36XX_HAL_UPDATE_PROBE_RSP_TEMPLATE_REQ);
> +
> +       if (skb->len > BEACON_TEMPLATE_SIZE) {
> +               wcn36xx_warn("probe response template is too big: %d\n",
> +                            skb->len);
> +               return -E2BIG;
> +       }
> +
> +       msg.probe_resp_template_len = skb->len;
> +       memcpy(&msg.probe_resp_template, skb->data, skb->len);
> +
> +       memcpy(msg.bssid, vif->addr, ETH_ALEN);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg);
> +
> +       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                   "hal update probe rsp len %d bssid %pM\n",
> +                   msg.probe_resp_template_len, msg.bssid);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_update_proberesp_tmpl failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_update_proberesp_tmpl response failed err=%d\n",
> +                           ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_set_stakey(struct wcn36xx *wcn,
> +                          enum ani_ed_type enc_type,
> +                          u8 keyidx,
> +                          u8 keylen,
> +                          u8 *key,
> +                          u8 sta_index)
> +{
> +       struct wcn36xx_hal_set_sta_key_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_SET_STAKEY_REQ);
> +
> +       msg_body.set_sta_key_params.sta_index = sta_index;
> +       msg_body.set_sta_key_params.enc_type = enc_type;
> +
> +       msg_body.set_sta_key_params.key[0].id = keyidx;
> +       msg_body.set_sta_key_params.key[0].unicast = 1;
> +       msg_body.set_sta_key_params.key[0].direction = WCN36XX_HAL_TX_RX;
> +       msg_body.set_sta_key_params.key[0].pae_role = 0;
> +       msg_body.set_sta_key_params.key[0].length = keylen;
> +       memcpy(msg_body.set_sta_key_params.key[0].key, key, keylen);
> +       msg_body.set_sta_key_params.single_tid_rc = 1;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_set_stakey failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_set_stakey response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_set_bsskey(struct wcn36xx *wcn,
> +                          enum ani_ed_type enc_type,
> +                          u8 keyidx,
> +                          u8 keylen,
> +                          u8 *key)
> +{
> +       struct wcn36xx_hal_set_bss_key_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_SET_BSSKEY_REQ);
> +       msg_body.bss_idx = 0;
> +       msg_body.enc_type = enc_type;
> +       msg_body.num_keys = 1;
> +       msg_body.keys[0].id = keyidx;
> +       msg_body.keys[0].unicast = 0;
> +       msg_body.keys[0].direction = WCN36XX_HAL_RX_ONLY;
> +       msg_body.keys[0].pae_role = 0;
> +       msg_body.keys[0].length = keylen;
> +       memcpy(msg_body.keys[0].key, key, keylen);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_set_bsskey failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_set_bsskey response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_remove_stakey(struct wcn36xx *wcn,
> +                             enum ani_ed_type enc_type,
> +                             u8 keyidx,
> +                             u8 sta_index)
> +{
> +       struct wcn36xx_hal_remove_sta_key_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_RMV_STAKEY_REQ);
> +
> +       msg_body.sta_idx = sta_index;
> +       msg_body.enc_type = enc_type;
> +       msg_body.key_id = keyidx;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_remove_stakey failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_remove_stakey response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_remove_bsskey(struct wcn36xx *wcn,
> +                             enum ani_ed_type enc_type,
> +                             u8 keyidx)
> +{
> +       struct wcn36xx_hal_remove_bss_key_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_RMV_BSSKEY_REQ);
> +       msg_body.bss_idx = 0;
> +       msg_body.enc_type = enc_type;
> +       msg_body.key_id = keyidx;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_remove_bsskey failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_remove_bsskey response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_enter_bmps(struct wcn36xx *wcn, struct ieee80211_vif *vif)
> +{
> +       struct wcn36xx_hal_enter_bmps_req_msg msg_body;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_ENTER_BMPS_REQ);
> +
> +       msg_body.bss_index = vif_priv->bss_index;
> +       msg_body.tbtt = vif->bss_conf.sync_tsf;
> +       msg_body.dtim_period = vif_priv->dtim_period;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_enter_bmps failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_enter_bmps response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_exit_bmps(struct wcn36xx *wcn, struct ieee80211_vif *vif)
> +{
> +       struct wcn36xx_hal_enter_bmps_req_msg msg_body;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_EXIT_BMPS_REQ);
> +
> +       msg_body.bss_index = vif_priv->bss_index;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_exit_bmps failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_exit_bmps response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +int wcn36xx_smd_set_power_params(struct wcn36xx *wcn, bool ignore_dtim)
> +{
> +       struct wcn36xx_hal_set_power_params_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_SET_POWER_PARAMS_REQ);
> +
> +       /*
> +        * When host is down ignore every second dtim
> +        */
> +       if (ignore_dtim) {
> +               msg_body.ignore_dtim = 1;
> +               msg_body.dtim_period = 2;
> +       }
> +       msg_body.listen_interval = WCN36XX_LISTEN_INTERVAL(wcn);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_set_power_params failed\n");
> +               goto out;
> +       }
> +
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +/* Notice: This function should be called after associated, or else it
> + * will be invalid
> + */
> +int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
> +                              struct ieee80211_vif *vif,
> +                              int packet_type)
> +{
> +       struct wcn36xx_hal_keep_alive_req_msg msg_body;
> +       struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_KEEP_ALIVE_REQ);
> +
> +       if (packet_type == WCN36XX_HAL_KEEP_ALIVE_NULL_PKT) {
> +               msg_body.bss_index = vif_priv->bss_index;
> +               msg_body.packet_type = WCN36XX_HAL_KEEP_ALIVE_NULL_PKT;
> +               msg_body.time_period = WCN36XX_KEEP_ALIVE_TIME_PERIOD;
> +       } else if (packet_type == WCN36XX_HAL_KEEP_ALIVE_UNSOLICIT_ARP_RSP) {
> +               /* TODO: it also support ARP response type */
> +       } else {
> +               wcn36xx_warn("unknow keep alive packet type %d\n", packet_type);
> +               return -EINVAL;
> +       }
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_exit_bmps failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_exit_bmps response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_dump_cmd_req(struct wcn36xx *wcn, u32 arg1, u32 arg2,
> +                            u32 arg3, u32 arg4, u32 arg5)
> +{
> +       struct wcn36xx_hal_dump_cmd_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_DUMP_COMMAND_REQ);
> +
> +       msg_body.arg1 = arg1;
> +       msg_body.arg2 = arg2;
> +       msg_body.arg3 = arg3;
> +       msg_body.arg4 = arg4;
> +       msg_body.arg5 = arg5;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_dump_cmd failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_dump_cmd response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +static inline void set_feat_caps(u32 *bitmap,
> +                                enum place_holder_in_cap_bitmap cap)
> +{
> +       int arr_idx, bit_idx;
> +
> +       if (cap < 0 || cap > 127) {
> +               wcn36xx_warn("error cap idx %d\n", cap);
> +               return;
> +       }
> +
> +       arr_idx = cap / 32;
> +       bit_idx = cap % 32;
> +       bitmap[arr_idx] |= (1 << bit_idx);
> +}
> +
> +static inline int get_feat_caps(u32 *bitmap,
> +                               enum place_holder_in_cap_bitmap cap)
> +{
> +       int arr_idx, bit_idx;
> +       int ret = 0;
> +
> +       if (cap < 0 || cap > 127) {
> +               wcn36xx_warn("error cap idx %d\n", cap);
> +               return -EINVAL;
> +       }
> +
> +       arr_idx = cap / 32;
> +       bit_idx = cap % 32;
> +       ret = (bitmap[arr_idx] & (1 << bit_idx)) ? 1 : 0;
> +       return ret;
> +}
> +
> +static inline void clear_feat_caps(u32 *bitmap,
> +                               enum place_holder_in_cap_bitmap cap)
> +{
> +       int arr_idx, bit_idx;
> +
> +       if (cap < 0 || cap > 127) {
> +               wcn36xx_warn("error cap idx %d\n", cap);
> +               return;
> +       }
> +
> +       arr_idx = cap / 32;
> +       bit_idx = cap % 32;
> +       bitmap[arr_idx] &= ~(1 << bit_idx);
> +}
> +
> +int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn)
> +{
> +       struct wcn36xx_hal_feat_caps_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_FEATURE_CAPS_EXCHANGE_REQ);
> +
> +       set_feat_caps(msg_body.feat_caps, STA_POWERSAVE);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_feature_caps_exchange failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_feature_caps_exchange response failed err=%d\n",
> +                           ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
> +               struct ieee80211_sta *sta,
> +               u16 tid,
> +               u16 *ssn,
> +               u8 direction,
> +               u8 sta_index)
> +{
> +       struct wcn36xx_hal_add_ba_session_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_ADD_BA_SESSION_REQ);
> +
> +       msg_body.sta_index = sta_index;
> +       memcpy(&msg_body.mac_addr, sta->addr, ETH_ALEN);
> +       msg_body.dialog_token = 0x10;
> +       msg_body.tid = tid;
> +
> +       /* Immediate BA because Delayed BA is not supported */
> +       msg_body.policy = 1;
> +       msg_body.buffer_size = WCN36XX_AGGR_BUFFER_SIZE;
> +       msg_body.timeout = 0;
> +       if (ssn)
> +               msg_body.ssn = *ssn;
> +       msg_body.direction = direction;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_add_ba_session failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_add_ba_session response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_add_ba(struct wcn36xx *wcn)
> +{
> +       struct wcn36xx_hal_add_ba_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_ADD_BA_REQ);
> +
> +       msg_body.session_id = 0;
> +       msg_body.win_size = WCN36XX_AGGR_BUFFER_SIZE;
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_add_ba failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_add_ba response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 sta_index)
> +{
> +       struct wcn36xx_hal_del_ba_req_msg msg_body;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_DEL_BA_REQ);
> +
> +       msg_body.sta_index = sta_index;
> +       msg_body.tid = tid;
> +       msg_body.direction = 0;
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_del_ba failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_del_ba response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index)
> +{
> +       struct wcn36xx_hal_trigger_ba_req_msg msg_body;
> +       struct wcn36xx_hal_trigget_ba_req_candidate *candidate;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_TRIGGER_BA_REQ);
> +
> +       msg_body.session_id = 0;
> +       msg_body.candidate_cnt = 1;
> +       msg_body.header.len += sizeof(*candidate);
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       candidate = (struct wcn36xx_hal_trigget_ba_req_candidate *)
> +               (wcn->hal_buf + sizeof(msg_body));
> +       candidate->sta_index = sta_index;
> +       candidate->tid_bitmap = 1;
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_trigger_ba failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_trigger_ba response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +
> +static int wcn36xx_smd_tx_compl_ind(struct wcn36xx *wcn, void *buf, size_t len)
> +{
> +       struct wcn36xx_hal_tx_compl_ind_msg *rsp = buf;
> +
> +       if (len != sizeof(*rsp)) {
> +               wcn36xx_warn("Bad TX complete indication\n");
> +               return -EIO;
> +       }
> +
> +       wcn36xx_dxe_tx_ack_ind(wcn, rsp->status);
> +
> +       return 0;
> +}
> +
> +static int wcn36xx_smd_missed_beacon_ind(struct wcn36xx *wcn,
> +                                        void *buf,
> +                                        size_t len)
> +{
> +       struct wcn36xx_hal_missed_beacon_ind_msg *rsp = buf;
> +       struct ieee80211_vif *vif = NULL;
> +       struct wcn36xx_vif *tmp;
> +
> +       /* Old FW does not have bss index */
> +       if (wcn36xx_is_fw_version(wcn, 1, 2, 2, 24)) {
> +               list_for_each_entry(tmp, &wcn->vif_list, list) {
> +                       wcn36xx_dbg(WCN36XX_DBG_HAL, "beacon missed bss_index %d\n",
> +                                   tmp->bss_index);
> +                       vif = container_of((void *)tmp,
> +                                                struct ieee80211_vif,
> +                                                drv_priv);
> +                       ieee80211_connection_loss(vif);
> +                       return 0;
> +               }
> +       }
> +
> +       if (len != sizeof(*rsp)) {
> +               wcn36xx_warn("Corrupted missed beacon indication\n");
> +               return -EIO;
> +       }
> +
> +       list_for_each_entry(tmp, &wcn->vif_list, list) {
> +               if (tmp->bss_index == rsp->bss_index) {
> +                       wcn36xx_dbg(WCN36XX_DBG_HAL, "beacon missed bss_index %d\n",
> +                                   rsp->bss_index);
> +                       vif = container_of((void *)tmp,
> +                                                struct ieee80211_vif,
> +                                                drv_priv);
> +                       ieee80211_connection_loss(vif);
> +                       return 0;
> +               }
> +       }
> +
> +       wcn36xx_warn("BSS index %d not found\n", rsp->bss_index);
> +       return -ENOENT;
> +}
> +
> +static int wcn36xx_smd_delete_sta_context_ind(struct wcn36xx *wcn,
> +                                             void *buf,
> +                                             size_t len)
> +{
> +       struct wcn36xx_hal_delete_sta_context_ind_msg *rsp = buf;
> +       struct wcn36xx_vif *tmp;
> +       struct ieee80211_sta *sta = NULL;
> +
> +       if (len != sizeof(*rsp)) {
> +               wcn36xx_warn("Corrupted delete sta indication\n");
> +               return -EIO;
> +       }
> +
> +       list_for_each_entry(tmp, &wcn->vif_list, list) {
> +               if (sta && (tmp->sta->sta_index == rsp->sta_id)) {
> +                       sta = container_of((void *)tmp->sta,
> +                                                struct ieee80211_sta,
> +                                                drv_priv);
> +                       wcn36xx_dbg(WCN36XX_DBG_HAL,
> +                                   "delete station indication %pM index %d\n",
> +                                   rsp->addr2,
> +                                   rsp->sta_id);
> +                       ieee80211_report_low_ack(sta, 0);
> +                       return 0;
> +               }
> +       }
> +
> +       wcn36xx_warn("STA with addr %pM and index %d not found\n",
> +                    rsp->addr2,
> +                    rsp->sta_id);
> +       return -ENOENT;
> +}
> +
> +int wcn36xx_smd_update_cfg(struct wcn36xx *wcn, u32 cfg_id, u32 value)
> +{
> +       struct wcn36xx_hal_update_cfg_req_msg msg_body, *body;
> +       size_t len;
> +       int ret = 0;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       INIT_HAL_MSG(msg_body, WCN36XX_HAL_UPDATE_CFG_REQ);
> +
> +       PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +       body = (struct wcn36xx_hal_update_cfg_req_msg *) wcn->hal_buf;
> +       len = msg_body.header.len;
> +
> +       put_cfg_tlv_u32(wcn, &len, cfg_id, value);
> +       body->header.len = len;
> +       body->len = len - sizeof(*body);
> +
> +       ret = wcn36xx_smd_send_and_wait(wcn, body->header.len);
> +       if (ret) {
> +               wcn36xx_err("Sending hal_update_cfg failed\n");
> +               goto out;
> +       }
> +       ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +       if (ret) {
> +               wcn36xx_err("hal_update_cfg response failed err=%d\n", ret);
> +               goto out;
> +       }
> +out:
> +       mutex_unlock(&wcn->hal_mutex);
> +       return ret;
> +}
> +static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
> +{
> +       struct wcn36xx_hal_msg_header *msg_header = buf;
> +       struct wcn36xx_hal_ind_msg *msg_ind;
> +       wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "SMD <<< ", buf, len);
> +
> +       switch (msg_header->msg_type) {
> +       case WCN36XX_HAL_START_RSP:
> +       case WCN36XX_HAL_CONFIG_STA_RSP:
> +       case WCN36XX_HAL_CONFIG_BSS_RSP:
> +       case WCN36XX_HAL_ADD_STA_SELF_RSP:
> +       case WCN36XX_HAL_STOP_RSP:
> +       case WCN36XX_HAL_DEL_STA_SELF_RSP:
> +       case WCN36XX_HAL_DELETE_STA_RSP:
> +       case WCN36XX_HAL_INIT_SCAN_RSP:
> +       case WCN36XX_HAL_START_SCAN_RSP:
> +       case WCN36XX_HAL_END_SCAN_RSP:
> +       case WCN36XX_HAL_FINISH_SCAN_RSP:
> +       case WCN36XX_HAL_DOWNLOAD_NV_RSP:
> +       case WCN36XX_HAL_DELETE_BSS_RSP:
> +       case WCN36XX_HAL_SEND_BEACON_RSP:
> +       case WCN36XX_HAL_SET_LINK_ST_RSP:
> +       case WCN36XX_HAL_UPDATE_PROBE_RSP_TEMPLATE_RSP:
> +       case WCN36XX_HAL_SET_BSSKEY_RSP:
> +       case WCN36XX_HAL_SET_STAKEY_RSP:
> +       case WCN36XX_HAL_RMV_STAKEY_RSP:
> +       case WCN36XX_HAL_RMV_BSSKEY_RSP:
> +       case WCN36XX_HAL_ENTER_BMPS_RSP:
> +       case WCN36XX_HAL_SET_POWER_PARAMS_RSP:
> +       case WCN36XX_HAL_EXIT_BMPS_RSP:
> +       case WCN36XX_HAL_KEEP_ALIVE_RSP:
> +       case WCN36XX_HAL_DUMP_COMMAND_RSP:
> +       case WCN36XX_HAL_ADD_BA_SESSION_RSP:
> +       case WCN36XX_HAL_ADD_BA_RSP:
> +       case WCN36XX_HAL_DEL_BA_RSP:
> +       case WCN36XX_HAL_TRIGGER_BA_RSP:
> +       case WCN36XX_HAL_UPDATE_CFG_RSP:
> +       case WCN36XX_HAL_JOIN_RSP:
> +       case WCN36XX_HAL_UPDATE_SCAN_PARAM_RSP:
> +       case WCN36XX_HAL_CH_SWITCH_RSP:
> +       case WCN36XX_HAL_FEATURE_CAPS_EXCHANGE_RSP:
> +               memcpy(wcn->hal_buf, buf, len);
> +               wcn->hal_rsp_len = len;
> +               complete(&wcn->hal_rsp_compl);
> +               break;
> +
> +       case WCN36XX_HAL_OTA_TX_COMPL_IND:
> +       case WCN36XX_HAL_MISSED_BEACON_IND:
> +       case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
> +               mutex_lock(&wcn->hal_ind_mutex);
> +               msg_ind = kmalloc(sizeof(*msg_ind), GFP_KERNEL);
> +               msg_ind->msg_len = len;
> +               msg_ind->msg = kmalloc(len, GFP_KERNEL);
> +               memcpy(msg_ind->msg, buf, len);
> +               list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
> +               queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
> +               wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
> +               mutex_unlock(&wcn->hal_ind_mutex);
> +               break;
> +       default:
> +               wcn36xx_err("SMD_EVENT (%d) not supported\n",
> +                             msg_header->msg_type);
> +       }
> +}
> +static void wcn36xx_ind_smd_work(struct work_struct *work)
> +{
> +       struct wcn36xx *wcn =
> +               container_of(work, struct wcn36xx, hal_ind_work);
> +       struct wcn36xx_hal_msg_header *msg_header;
> +       struct wcn36xx_hal_ind_msg *hal_ind_msg;
> +
> +       mutex_lock(&wcn->hal_ind_mutex);
> +
> +       hal_ind_msg = list_first_entry(&wcn->hal_ind_queue,
> +                                      struct wcn36xx_hal_ind_msg,
> +                                      list);
> +
> +       msg_header = (struct wcn36xx_hal_msg_header *)hal_ind_msg->msg;
> +
> +       switch (msg_header->msg_type) {
> +       case WCN36XX_HAL_OTA_TX_COMPL_IND:
> +               wcn36xx_smd_tx_compl_ind(wcn,
> +                                        hal_ind_msg->msg,
> +                                        hal_ind_msg->msg_len);
> +               break;
> +       case WCN36XX_HAL_MISSED_BEACON_IND:
> +               wcn36xx_smd_missed_beacon_ind(wcn,
> +                                             hal_ind_msg->msg,
> +                                             hal_ind_msg->msg_len);
> +               break;
> +       case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
> +               wcn36xx_smd_delete_sta_context_ind(wcn,
> +                                                  hal_ind_msg->msg,
> +                                                  hal_ind_msg->msg_len);
> +               break;
> +       default:
> +               wcn36xx_err("SMD_EVENT (%d) not supported\n",
> +                             msg_header->msg_type);
> +       }
> +       list_del(wcn->hal_ind_queue.next);
> +       kfree(hal_ind_msg->msg);
> +       kfree(hal_ind_msg);
> +       mutex_unlock(&wcn->hal_ind_mutex);
> +}
> +int wcn36xx_smd_open(struct wcn36xx *wcn)
> +{
> +       int ret = 0;
> +       wcn->hal_ind_wq = create_freezable_workqueue("wcn36xx_smd_ind");
> +       if (!wcn->hal_ind_wq) {
> +               wcn36xx_err("failed to allocate wq\n");
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +       INIT_WORK(&wcn->hal_ind_work, wcn36xx_ind_smd_work);
> +       INIT_LIST_HEAD(&wcn->hal_ind_queue);
> +       mutex_init(&wcn->hal_ind_mutex);
> +
> +       ret = wcn->ctrl_ops->open(wcn, wcn36xx_smd_rsp_process);
> +       if (ret) {
> +               wcn36xx_err("failed to open control channel\n");
> +               goto free_wq;
> +       }
> +
> +       return ret;
> +
> +free_wq:
> +       destroy_workqueue(wcn->hal_ind_wq);
> +out:
> +       return ret;
> +}
> +
> +void wcn36xx_smd_close(struct wcn36xx *wcn)
> +{
> +       wcn->ctrl_ops->close();
> +       destroy_workqueue(wcn->hal_ind_wq);
> +       mutex_destroy(&wcn->hal_ind_mutex);
> +}
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
> new file mode 100644
> index 0000000..e7c3901
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.h
> @@ -0,0 +1,127 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#ifndef _SMD_H_
> +#define _SMD_H_
> +
> +#include "wcn36xx.h"
> +
> +/* Max shared size is 4k but we take less.*/
> +#define WCN36XX_NV_FRAGMENT_SIZE                       3072
> +
> +#define WCN36XX_HAL_BUF_SIZE                           4096
> +
> +#define HAL_MSG_TIMEOUT 200
> +#define WCN36XX_SMSM_WLAN_TX_ENABLE                    0x00000400
> +#define WCN36XX_SMSM_WLAN_TX_RINGS_EMPTY               0x00000200
> +/* The PNO version info be contained in the rsp msg */
> +#define WCN36XX_FW_MSG_PNO_VERSION_MASK                        0x8000
> +
> +enum wcn36xx_fw_msg_result {
> +       WCN36XX_FW_MSG_RESULT_SUCCESS                   = 0,
> +       WCN36XX_FW_MSG_RESULT_SUCCESS_SYNC              = 1,
> +
> +       WCN36XX_FW_MSG_RESULT_MEM_FAIL                  = 5,
> +};
> +
> +/******************************/
> +/* SMD requests and responses */
> +/******************************/
> +struct wcn36xx_fw_msg_status_rsp {
> +       u32     status;
> +} __packed;
> +
> +struct wcn36xx_hal_ind_msg {
> +       struct list_head list;
> +       u8 *msg;
> +       size_t msg_len;
> +};
> +
> +struct wcn36xx;
> +
> +int wcn36xx_smd_open(struct wcn36xx *wcn);
> +void wcn36xx_smd_close(struct wcn36xx *wcn);
> +
> +int wcn36xx_smd_load_nv(struct wcn36xx *wcn);
> +int wcn36xx_smd_start(struct wcn36xx *wcn);
> +int wcn36xx_smd_stop(struct wcn36xx *wcn);
> +int wcn36xx_smd_init_scan(struct wcn36xx *wcn, enum wcn36xx_hal_sys_mode mode);
> +int wcn36xx_smd_start_scan(struct wcn36xx *wcn);
> +int wcn36xx_smd_end_scan(struct wcn36xx *wcn);
> +int wcn36xx_smd_finish_scan(struct wcn36xx *wcn,
> +                           enum wcn36xx_hal_sys_mode mode);
> +int wcn36xx_smd_update_scan_params(struct wcn36xx *wcn);
> +int wcn36xx_smd_add_sta_self(struct wcn36xx *wcn, struct ieee80211_vif *vif);
> +int wcn36xx_smd_delete_sta_self(struct wcn36xx *wcn, u8 *addr);
> +int wcn36xx_smd_delete_sta(struct wcn36xx *wcn, u8 sta_index);
> +int wcn36xx_smd_join(struct wcn36xx *wcn, const u8 *bssid, u8 *vif, u8 ch);
> +int wcn36xx_smd_set_link_st(struct wcn36xx *wcn, const u8 *bssid,
> +                           const u8 *sta_mac,
> +                           enum wcn36xx_hal_link_state state);
> +int wcn36xx_smd_config_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif,
> +                          struct ieee80211_sta *sta, const u8 *bssid,
> +                          bool update);
> +int wcn36xx_smd_delete_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif);
> +int wcn36xx_smd_config_sta(struct wcn36xx *wcn, struct ieee80211_vif *vif,
> +                          struct ieee80211_sta *sta);
> +int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
> +                           struct sk_buff *skb_beacon, u16 tim_off,
> +                           u16 p2p_off);
> +int wcn36xx_smd_switch_channel(struct wcn36xx *wcn,
> +                              struct ieee80211_vif *vif, int ch);
> +int wcn36xx_smd_update_proberesp_tmpl(struct wcn36xx *wcn,
> +                                     struct ieee80211_vif *vif,
> +                                     struct sk_buff *skb);
> +int wcn36xx_smd_set_stakey(struct wcn36xx *wcn,
> +                          enum ani_ed_type enc_type,
> +                          u8 keyidx,
> +                          u8 keylen,
> +                          u8 *key,
> +                          u8 sta_index);
> +int wcn36xx_smd_set_bsskey(struct wcn36xx *wcn,
> +                          enum ani_ed_type enc_type,
> +                          u8 keyidx,
> +                          u8 keylen,
> +                          u8 *key);
> +int wcn36xx_smd_remove_stakey(struct wcn36xx *wcn,
> +                             enum ani_ed_type enc_type,
> +                             u8 keyidx,
> +                             u8 sta_index);
> +int wcn36xx_smd_remove_bsskey(struct wcn36xx *wcn,
> +                             enum ani_ed_type enc_type,
> +                             u8 keyidx);
> +int wcn36xx_smd_enter_bmps(struct wcn36xx *wcn, struct ieee80211_vif *vif);
> +int wcn36xx_smd_exit_bmps(struct wcn36xx *wcn, struct ieee80211_vif *vif);
> +int wcn36xx_smd_set_power_params(struct wcn36xx *wcn, bool ignore_dtim);
> +int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
> +                              struct ieee80211_vif *vif,
> +                              int packet_type);
> +int wcn36xx_smd_dump_cmd_req(struct wcn36xx *wcn, u32 arg1, u32 arg2,
> +                            u32 arg3, u32 arg4, u32 arg5);
> +int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn);
> +
> +int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
> +               struct ieee80211_sta *sta,
> +               u16 tid,
> +               u16 *ssn,
> +               u8 direction,
> +               u8 sta_index);
> +int wcn36xx_smd_add_ba(struct wcn36xx *wcn);
> +int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 sta_index);
> +int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index);
> +
> +int wcn36xx_smd_update_cfg(struct wcn36xx *wcn, u32 cfg_id, u32 value);
> +#endif /* _SMD_H_ */
> diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
> new file mode 100644
> index 0000000..b2b60e3
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
> @@ -0,0 +1,284 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include "txrx.h"
> +
> +static inline int get_rssi0(struct wcn36xx_rx_bd *bd)
> +{
> +       return 100 - ((bd->phy_stat0 >> 24) & 0xff);
> +}
> +
> +int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
> +{
> +       struct ieee80211_rx_status status;
> +       struct ieee80211_hdr *hdr;
> +       struct wcn36xx_rx_bd *bd;
> +       u16 fc, sn;
> +
> +       /*
> +        * All fields must be 0, otherwise it can lead to
> +        * unexpected consequences.
> +        */
> +       memset(&status, 0, sizeof(status));
> +
> +       bd = (struct wcn36xx_rx_bd *)skb->data;
> +       buff_to_be((u32 *)bd, sizeof(*bd)/sizeof(u32));
> +       wcn36xx_dbg_dump(WCN36XX_DBG_RX_DUMP,
> +                        "BD   <<< ", (char *)bd,
> +                        sizeof(struct wcn36xx_rx_bd));
> +
> +       skb_put(skb, bd->pdu.mpdu_header_off + bd->pdu.mpdu_len);
> +       skb_pull(skb, bd->pdu.mpdu_header_off);
> +
> +       status.mactime = 10;
> +       status.freq = WCN36XX_CENTER_FREQ(wcn);
> +       status.band = WCN36XX_BAND(wcn);
> +       status.signal = -get_rssi0(bd);
> +       status.antenna = 1;
> +       status.rate_idx = 1;
> +       status.flag = 0;
> +       status.rx_flags = 0;
> +       status.flag |= RX_FLAG_IV_STRIPPED |
> +                      RX_FLAG_MMIC_STRIPPED |
> +                      RX_FLAG_DECRYPTED;
> +
> +       wcn36xx_dbg(WCN36XX_DBG_RX, "status.flags=%x status->vendor_radiotap_len=%x\n",
> +                   status.flag,  status.vendor_radiotap_len);
> +
> +       memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
> +
> +       hdr = (struct ieee80211_hdr *) skb->data;
> +       fc = __le16_to_cpu(hdr->frame_control);
> +       sn = IEEE80211_SEQ_TO_SN(__le16_to_cpu(hdr->seq_ctrl));
> +
> +       if (ieee80211_is_beacon(hdr->frame_control)) {
> +               wcn36xx_dbg(WCN36XX_DBG_BEACON, "beacon skb %p len %d fc %04x sn %d\n",
> +                           skb, skb->len, fc, sn);
> +               wcn36xx_dbg_dump(WCN36XX_DBG_BEACON_DUMP, "SKB <<< ",
> +                                (char *)skb->data, skb->len);
> +       } else {
> +               wcn36xx_dbg(WCN36XX_DBG_RX, "rx skb %p len %d fc %04x sn %d\n",
> +                           skb, skb->len, fc, sn);
> +               wcn36xx_dbg_dump(WCN36XX_DBG_RX_DUMP, "SKB <<< ",
> +                                (char *)skb->data, skb->len);
> +       }
> +
> +       ieee80211_rx_irqsafe(wcn->hw, skb);
> +
> +       return 0;
> +}
> +
> +static void wcn36xx_set_tx_pdu(struct wcn36xx_tx_bd *bd,
> +                              u32 mpdu_header_len,
> +                              u32 len,
> +                              u16 tid)
> +{
> +       bd->pdu.mpdu_header_len = mpdu_header_len;
> +       bd->pdu.mpdu_header_off = sizeof(*bd);
> +       bd->pdu.mpdu_data_off = bd->pdu.mpdu_header_len +
> +               bd->pdu.mpdu_header_off;
> +       bd->pdu.mpdu_len = len;
> +       bd->pdu.tid = tid;
> +}
> +
> +static inline struct wcn36xx_vif *get_vif_by_addr(struct wcn36xx *wcn,
> +                                                 u8 *addr)
> +{
> +       struct wcn36xx_vif *vif_priv = NULL;
> +       struct ieee80211_vif *vif = NULL;
> +       list_for_each_entry(vif_priv, &wcn->vif_list, list) {
> +                       vif = container_of((void *)vif_priv,
> +                                  struct ieee80211_vif,
> +                                  drv_priv);
> +                       if (memcmp(vif->addr, addr, ETH_ALEN) == 0)
> +                               return vif_priv;
> +       }
> +       wcn36xx_warn("vif %pM not found\n", addr);
> +       return NULL;
> +}
> +static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
> +                               struct wcn36xx *wcn,
> +                               struct wcn36xx_vif **vif_priv,
> +                               struct wcn36xx_sta *sta_priv,
> +                               struct ieee80211_hdr *hdr,
> +                               bool bcast)
> +{
> +       struct ieee80211_vif *vif = NULL;
> +       struct wcn36xx_vif *__vif_priv = NULL;
> +       bd->bd_rate = WCN36XX_BD_RATE_DATA;
> +
> +       /*
> +        * For not unicast frames mac80211 will not set sta pointer so use
> +        * self_sta_index instead.
> +        */
> +       if (sta_priv) {
> +               __vif_priv = sta_priv->vif;
> +               vif = container_of((void *)__vif_priv,
> +                                  struct ieee80211_vif,
> +                                  drv_priv);
> +
> +               if (vif->type == NL80211_IFTYPE_STATION) {
> +                       bd->sta_index = sta_priv->bss_sta_index;
> +                       bd->dpu_desc_idx = sta_priv->bss_dpu_desc_index;
> +               } else if (vif->type == NL80211_IFTYPE_AP ||
> +                          vif->type == NL80211_IFTYPE_ADHOC ||
> +                          vif->type == NL80211_IFTYPE_MESH_POINT) {
> +                       bd->sta_index = sta_priv->sta_index;
> +                       bd->dpu_desc_idx = sta_priv->dpu_desc_index;
> +               }
> +       } else {
> +               __vif_priv = get_vif_by_addr(wcn, hdr->addr2);
> +               bd->sta_index = __vif_priv->self_sta_index;
> +               bd->dpu_desc_idx = __vif_priv->self_dpu_desc_index;
> +       }
> +
> +       bd->dpu_sign = __vif_priv->ucast_dpu_signature;
> +
> +       if (ieee80211_is_nullfunc(hdr->frame_control) ||
> +          (sta_priv && !sta_priv->is_data_encrypted))
> +               bd->dpu_ne = 1;
> +
> +       if (bcast) {
> +               bd->ub = 1;
> +               bd->ack_policy = 1;
> +       }
> +       *vif_priv = __vif_priv;
> +}
> +
> +static void wcn36xx_set_tx_mgmt(struct wcn36xx_tx_bd *bd,
> +                               struct wcn36xx *wcn,
> +                               struct wcn36xx_vif **vif_priv,
> +                               struct ieee80211_hdr *hdr,
> +                               bool bcast)
> +{
> +       struct wcn36xx_vif *__vif_priv =
> +               get_vif_by_addr(wcn, hdr->addr2);
> +       bd->sta_index = __vif_priv->self_sta_index;
> +       bd->dpu_desc_idx = __vif_priv->self_dpu_desc_index;
> +       bd->dpu_ne = 1;
> +
> +       /* default rate for unicast */
> +       if (ieee80211_is_mgmt(hdr->frame_control))
> +               bd->bd_rate = (WCN36XX_BAND(wcn) == IEEE80211_BAND_5GHZ) ?
> +                       WCN36XX_BD_RATE_CTRL :
> +                       WCN36XX_BD_RATE_MGMT;
> +       else if (ieee80211_is_ctl(hdr->frame_control))
> +               bd->bd_rate = WCN36XX_BD_RATE_CTRL;
> +       else
> +               wcn36xx_warn("frame control type unknown\n");
> +
> +       /*
> +        * In joining state trick hardware that probe is sent as
> +        * unicast even if address is broadcast.
> +        */
> +       if (__vif_priv->is_joining &&
> +           ieee80211_is_probe_req(hdr->frame_control))
> +               bcast = false;
> +
> +       if (bcast) {
> +               /* broadcast */
> +               bd->ub = 1;
> +               /* No ack needed not unicast */
> +               bd->ack_policy = 1;
> +               bd->queue_id = WCN36XX_TX_B_WQ_ID;
> +       } else
> +               bd->queue_id = WCN36XX_TX_U_WQ_ID;
> +       *vif_priv = __vif_priv;
> +}
> +
> +int wcn36xx_start_tx(struct wcn36xx *wcn,
> +                    struct wcn36xx_sta *sta_priv,
> +                    struct sk_buff *skb)
> +{
> +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +       struct wcn36xx_vif *vif_priv = NULL;
> +       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +       unsigned long flags;
> +       bool is_low = ieee80211_is_data(hdr->frame_control);
> +       bool bcast = is_broadcast_ether_addr(hdr->addr1) ||
> +               is_multicast_ether_addr(hdr->addr1);
> +       struct wcn36xx_tx_bd *bd = wcn36xx_dxe_get_next_bd(wcn, is_low);
> +
> +       if (!bd) {
> +               /*
> +                * TX DXE are used in pairs. One for the BD and one for the
> +                * actual frame. The BD DXE's has a preallocated buffer while
> +                * the skb ones does not. If this isn't true something is really
> +                * wierd. TODO: Recover from this situation
> +                */
> +
> +               wcn36xx_err("bd address may not be NULL for BD DXE\n");
> +               return -EINVAL;
> +       }
> +
> +       memset(bd, 0, sizeof(*bd));
> +
> +       wcn36xx_dbg(WCN36XX_DBG_TX,
> +                   "tx skb %p len %d fc %04x sn %d %s %s\n",
> +                   skb, skb->len, __le16_to_cpu(hdr->frame_control),
> +                   IEEE80211_SEQ_TO_SN(__le16_to_cpu(hdr->seq_ctrl)),
> +                   is_low ? "low" : "high", bcast ? "bcast" : "ucast");
> +
> +       wcn36xx_dbg_dump(WCN36XX_DBG_TX_DUMP, "", skb->data, skb->len);
> +
> +       bd->dpu_rf = WCN36XX_BMU_WQ_TX;
> +
> +       bd->tx_comp = info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS;
> +       if (bd->tx_comp) {
> +               wcn36xx_dbg(WCN36XX_DBG_DXE, "TX_ACK status requested\n");
> +               spin_lock_irqsave(&wcn->dxe_lock, flags);
> +               if (wcn->tx_ack_skb) {
> +                       spin_unlock_irqrestore(&wcn->dxe_lock, flags);
> +                       wcn36xx_warn("tx_ack_skb already set\n");
> +                       return -EINVAL;
> +               }
> +
> +               wcn->tx_ack_skb = skb;
> +               spin_unlock_irqrestore(&wcn->dxe_lock, flags);
> +
> +               /* Only one at a time is supported by fw. Stop the TX queues
> +                * until the ack status gets back.
> +                *
> +                * TODO: Add watchdog in case FW does not answer
> +                */
> +               ieee80211_stop_queues(wcn->hw);
> +       }
> +
> +       /* Data frames served first*/
> +       if (is_low) {
> +               wcn36xx_set_tx_data(bd, wcn, &vif_priv, sta_priv, hdr, bcast);
> +               wcn36xx_set_tx_pdu(bd,
> +                          ieee80211_is_data_qos(hdr->frame_control) ?
> +                          sizeof(struct ieee80211_qos_hdr) :
> +                          sizeof(struct ieee80211_hdr_3addr),
> +                          skb->len, sta_priv ? sta_priv->tid : 0);
> +       } else {
> +               /* MGMT and CTRL frames are handeld here*/
> +               wcn36xx_set_tx_mgmt(bd, wcn, &vif_priv, hdr, bcast);
> +               wcn36xx_set_tx_pdu(bd,
> +                          ieee80211_is_data_qos(hdr->frame_control) ?
> +                          sizeof(struct ieee80211_qos_hdr) :
> +                          sizeof(struct ieee80211_hdr_3addr),
> +                          skb->len, WCN36XX_TID);
> +       }
> +
> +       buff_to_be((u32 *)bd, sizeof(*bd)/sizeof(u32));
> +       bd->tx_bd_sign = 0xbdbdbdbd;
> +
> +       return wcn36xx_dxe_tx_frame(wcn, vif_priv, skb, is_low);
> +}
> diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.h b/drivers/net/wireless/ath/wcn36xx/txrx.h
> new file mode 100644
> index 0000000..bbfbcf8
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/txrx.h
> @@ -0,0 +1,160 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#ifndef _TXRX_H_
> +#define _TXRX_H_
> +
> +#include <linux/etherdevice.h>
> +#include "wcn36xx.h"
> +
> +/* TODO describe all properties */
> +#define WCN36XX_802_11_HEADER_LEN      24
> +#define WCN36XX_BMU_WQ_TX              25
> +#define WCN36XX_TID                    7
> +/* broadcast wq ID */
> +#define WCN36XX_TX_B_WQ_ID             0xA
> +#define WCN36XX_TX_U_WQ_ID             0x9
> +/* bd_rate */
> +#define WCN36XX_BD_RATE_DATA 0
> +#define WCN36XX_BD_RATE_MGMT 2
> +#define WCN36XX_BD_RATE_CTRL 3
> +
> +struct wcn36xx_pdu {
> +       u32     dpu_fb:8;
> +       u32     adu_fb:8;
> +       u32     pdu_id:16;
> +
> +       /* 0x04*/
> +       u32     tail_pdu_idx:16;
> +       u32     head_pdu_idx:16;
> +
> +       /* 0x08*/
> +       u32     pdu_count:7;
> +       u32     mpdu_data_off:9;
> +       u32     mpdu_header_off:8;
> +       u32     mpdu_header_len:8;
> +
> +       /* 0x0c*/
> +       u32     reserved4:8;
> +       u32     tid:4;
> +       u32     reserved3:4;
> +       u32     mpdu_len:16;
> +};
> +
> +struct wcn36xx_rx_bd {
> +       u32     bdt:2;
> +       u32     ft:1;
> +       u32     dpu_ne:1;
> +       u32     rx_key_id:3;
> +       u32     ub:1;
> +       u32     rmf:1;
> +       u32     uma_bypass:1;
> +       u32     csr11:1;
> +       u32     reserved0:1;
> +       u32     scan_learn:1;
> +       u32     rx_ch:4;
> +       u32     rtsf:1;
> +       u32     bsf:1;
> +       u32     a2hf:1;
> +       u32     st_auf:1;
> +       u32     dpu_sign:3;
> +       u32     dpu_rf:8;
> +
> +       struct wcn36xx_pdu pdu;
> +
> +       /* 0x14*/
> +       u32     addr3:8;
> +       u32     addr2:8;
> +       u32     addr1:8;
> +       u32     dpu_desc_idx:8;
> +
> +       /* 0x18*/
> +       u32     rxp_flags:23;
> +       u32     rate_id:9;
> +
> +       u32     phy_stat0;
> +       u32     phy_stat1;
> +
> +       /* 0x24 */
> +       u32     rx_times;
> +
> +       u32     pmi_cmd[6];
> +
> +       /* 0x40 */
> +       u32     reserved7:4;
> +       u32     reorder_slot_id:6;
> +       u32     reorder_fwd_id:6;
> +       u32     reserved6:12;
> +       u32     reorder_code:4;
> +
> +       /* 0x44 */
> +       u32     exp_seq_num:12;
> +       u32     cur_seq_num:12;
> +       u32     fr_type_subtype:8;
> +
> +       /* 0x48 */
> +       u32     msdu_size:16;
> +       u32     sub_fr_id:4;
> +       u32     proc_order:4;
> +       u32     reserved9:4;
> +       u32     aef:1;
> +       u32     lsf:1;
> +       u32     esf:1;
> +       u32     asf:1;
> +};
> +
> +struct wcn36xx_tx_bd {
> +       u32     bdt:2;
> +       u32     ft:1;
> +       u32     dpu_ne:1;
> +       u32     fw_tx_comp:1;
> +       u32     tx_comp:1;
> +       u32     reserved1:1;
> +       u32     ub:1;
> +       u32     rmf:1;
> +       u32     reserved0:12;
> +       u32     dpu_sign:3;
> +       u32     dpu_rf:8;
> +
> +       struct wcn36xx_pdu pdu;
> +
> +       /* 0x14*/
> +       u32     reserved5:7;
> +       u32     queue_id:5;
> +       u32     bd_rate:2;
> +       u32     ack_policy:2;
> +       u32     sta_index:8;
> +       u32     dpu_desc_idx:8;
> +
> +       u32     tx_bd_sign;
> +       u32     reserved6;
> +       u32     dxe_start_time;
> +       u32     dxe_end_time;
> +
> +       /*u32   tcp_udp_start_off:10;
> +       u32     header_cks:16;
> +       u32     reserved7:6;*/
> +};
> +
> +struct wcn36xx_sta;
> +struct wcn36xx;
> +
> +int  wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb);
> +int wcn36xx_start_tx(struct wcn36xx *wcn,
> +                    struct wcn36xx_sta *sta_priv,
> +                    struct sk_buff *skb);
> +
> +#endif /* _TXRX_H_ */
> diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> new file mode 100644
> index 0000000..97a5f18
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> @@ -0,0 +1,238 @@
> +/*
> + * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
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
> +
> +#ifndef _WCN36XX_H_
> +#define _WCN36XX_H_
> +
> +#include <linux/completion.h>
> +#include <linux/printk.h>
> +#include <linux/spinlock.h>
> +#include <net/mac80211.h>
> +
> +#include "hal.h"
> +#include "smd.h"
> +#include "txrx.h"
> +#include "dxe.h"
> +#include "pmc.h"
> +#include "debug.h"
> +
> +#define WLAN_NV_FILE               "wlan/prima/WCNSS_qcom_wlan_nv.bin"
> +#define WCN36XX_AGGR_BUFFER_SIZE 64
> +
> +extern unsigned int debug_mask;
> +
> +enum wcn36xx_debug_mask {
> +       WCN36XX_DBG_DXE         = 0x00000001,
> +       WCN36XX_DBG_DXE_DUMP    = 0x00000002,
> +       WCN36XX_DBG_SMD         = 0x00000004,
> +       WCN36XX_DBG_SMD_DUMP    = 0x00000008,
> +       WCN36XX_DBG_RX          = 0x00000010,
> +       WCN36XX_DBG_RX_DUMP     = 0x00000020,
> +       WCN36XX_DBG_TX          = 0x00000040,
> +       WCN36XX_DBG_TX_DUMP     = 0x00000080,
> +       WCN36XX_DBG_HAL         = 0x00000100,
> +       WCN36XX_DBG_HAL_DUMP    = 0x00000200,
> +       WCN36XX_DBG_MAC         = 0x00000400,
> +       WCN36XX_DBG_BEACON      = 0x00000800,
> +       WCN36XX_DBG_BEACON_DUMP = 0x00001000,
> +       WCN36XX_DBG_PMC         = 0x00002000,
> +       WCN36XX_DBG_PMC_DUMP    = 0x00004000,
> +       WCN36XX_DBG_ANY         = 0xffffffff,
> +};
> +
> +#define wcn36xx_err(fmt, arg...)                               \
> +       printk(KERN_ERR pr_fmt("ERROR " fmt), ##arg);
> +
> +#define wcn36xx_warn(fmt, arg...)                              \
> +       printk(KERN_WARNING pr_fmt("WARNING " fmt), ##arg)
> +
> +#define wcn36xx_info(fmt, arg...)              \
> +       printk(KERN_INFO pr_fmt(fmt), ##arg)
> +
> +#define wcn36xx_dbg(mask, fmt, arg...) do {                    \
> +       if (debug_mask & mask)                                  \
> +               printk(KERN_DEBUG pr_fmt(fmt), ##arg);  \
> +} while (0)
> +
> +#define wcn36xx_dbg_dump(mask, prefix_str, buf, len) do {      \
> +       if (debug_mask & mask)                                  \
> +               print_hex_dump(KERN_DEBUG, pr_fmt(prefix_str),  \
> +                              DUMP_PREFIX_OFFSET, 32, 1,       \
> +                              buf, len, false);                \
> +} while (0)
> +
> +#define WCN36XX_HW_CHANNEL(__wcn) (__wcn->hw->conf.chandef.chan->hw_value)
> +#define WCN36XX_BAND(__wcn) (__wcn->hw->conf.chandef.chan->band)
> +#define WCN36XX_CENTER_FREQ(__wcn) (__wcn->hw->conf.chandef.chan->center_freq)
> +#define WCN36XX_LISTEN_INTERVAL(__wcn) (__wcn->hw->conf.listen_interval)
> +#define WCN36XX_FLAGS(__wcn) (__wcn->hw->flags)
> +#define WCN36XX_MAX_POWER(__wcn) (__wcn->hw->conf.chandef.chan->max_power)
> +
> +static inline void buff_to_be(u32 *buf, size_t len)
> +{
> +       int i;
> +       for (i = 0; i < len; i++)
> +               buf[i] = cpu_to_be32(buf[i]);
> +}
> +
> +struct nv_data {
> +       int     is_valid;
> +       u8      table;
> +};
> +
> +/* Interface for platform control path
> + *
> + * @open: hook must be called when wcn36xx wants to open control channel.
> + * @tx: sends a buffer.
> + */
> +struct wcn36xx_platform_ctrl_ops {
> +       int (*open)(void *drv_priv, void *rsp_cb);
> +       void (*close)(void);
> +       int (*tx)(char *buf, size_t len);
> +       int (*get_hw_mac)(u8 *addr);
> +       int (*smsm_change_state)(u32 clear_mask, u32 set_mask);
> +};
> +
> +/**
> + * struct wcn36xx_vif - holds VIF related fields
> + *
> + * @bss_index: bss_index is initially set to 0xFF. bss_index is received from
> + * HW after first config_bss call and must be used in delete_bss and
> + * enter/exit_bmps.
> + */
> +struct wcn36xx_vif {
> +       struct list_head list;
> +       struct wcn36xx_sta *sta;
> +       u8 dtim_period;
> +       enum ani_ed_type encrypt_type;
> +       bool is_joining;
> +       struct wcn36xx_hal_mac_ssid ssid;
> +
> +       /* Power management */
> +       enum wcn36xx_power_state pw_state;
> +
> +       u8 bss_index;
> +       u8 ucast_dpu_signature;
> +       /* Returned from WCN36XX_HAL_ADD_STA_SELF_RSP */
> +       u8 self_sta_index;
> +       u8 self_dpu_desc_index;
> +};
> +
> +/**
> + * struct wcn36xx_sta - holds STA related fields
> + *
> + * @tid: traffic ID that is used during AMPDU and in TX BD.
> + * @sta_index: STA index is returned from HW after config_sta call and is
> + * used in both SMD channel and TX BD.
> + * @dpu_desc_index: DPU descriptor index is returned from HW after config_sta
> + * call and is used in TX BD.
> + * @bss_sta_index: STA index is returned from HW after config_bss call and is
> + * used in both SMD channel and TX BD. See table bellow when it is used.
> + * @bss_dpu_desc_index: DPU descriptor index is returned from HW after
> + * config_bss call and is used in TX BD.
> + * ______________________________________________
> + * |             |     STA     |       AP      |
> + * |______________|_____________|_______________|
> + * |    TX BD     |bss_sta_index|   sta_index   |
> + * |______________|_____________|_______________|
> + * |all SMD calls |bss_sta_index|   sta_index  |
> + * |______________|_____________|_______________|
> + * |smd_delete_sta|  sta_index  |   sta_index  |
> + * |______________|_____________|_______________|
> + */
> +struct wcn36xx_sta {
> +       struct wcn36xx_vif *vif;
> +       u16 aid;
> +       u16 tid;
> +       u8 sta_index;
> +       u8 dpu_desc_index;
> +       u8 bss_sta_index;
> +       u8 bss_dpu_desc_index;
> +       bool is_data_encrypted;
> +       /* Rates */
> +       struct wcn36xx_hal_supported_rates supported_rates;
> +};
> +struct wcn36xx_dxe_ch;
> +struct wcn36xx {
> +       struct ieee80211_hw     *hw;
> +       struct device           *dev;
> +       struct list_head        vif_list;
> +
> +       u8                      fw_revision;
> +       u8                      fw_version;
> +       u8                      fw_minor;
> +       u8                      fw_major;
> +
> +       /* extra byte for the NULL termination */
> +       u8                      crm_version[WCN36XX_HAL_VERSION_LENGTH + 1];
> +       u8                      wlan_version[WCN36XX_HAL_VERSION_LENGTH + 1];
> +
> +       /* IRQs */
> +       int                     tx_irq;
> +       int                     rx_irq;
> +       void __iomem            *mmio;
> +
> +       struct wcn36xx_platform_ctrl_ops *ctrl_ops;
> +       /*
> +        * smd_buf must be protected with smd_mutex to garantee
> +        * that all messages are sent one after another
> +        */
> +       u8                      *hal_buf;
> +       size_t                  hal_rsp_len;
> +       struct mutex            hal_mutex;
> +       struct completion       hal_rsp_compl;
> +       struct workqueue_struct *hal_ind_wq;
> +       struct work_struct      hal_ind_work;
> +       struct mutex            hal_ind_mutex;
> +       struct list_head        hal_ind_queue;
> +
> +       /* DXE channels */
> +       struct wcn36xx_dxe_ch   dxe_tx_l_ch;    /* TX low */
> +       struct wcn36xx_dxe_ch   dxe_tx_h_ch;    /* TX high */
> +       struct wcn36xx_dxe_ch   dxe_rx_l_ch;    /* RX low */
> +       struct wcn36xx_dxe_ch   dxe_rx_h_ch;    /* RX high */
> +
> +       /* For synchronization of DXE resources from BH, IRQ and WQ contexts */
> +       spinlock_t      dxe_lock;
> +       bool                    queues_stopped;
> +
> +       /* Memory pools */
> +       struct wcn36xx_dxe_mem_pool mgmt_mem_pool;
> +       struct wcn36xx_dxe_mem_pool data_mem_pool;
> +
> +       struct sk_buff          *tx_ack_skb;
> +
> +#ifdef CONFIG_WCN36XX_DEBUGFS
> +       /* Debug file system entry */
> +       struct wcn36xx_dfs_entry    dfs;
> +#endif /* CONFIG_WCN36XX_DEBUGFS */
> +
> +};
> +
> +static inline bool wcn36xx_is_fw_version(struct wcn36xx *wcn,
> +                                        u8 major,
> +                                        u8 minor,
> +                                        u8 version,
> +                                        u8 revision)
> +{
> +       return (wcn->fw_major == major &&
> +               wcn->fw_minor == minor &&
> +               wcn->fw_version == version &&
> +               wcn->fw_revision == revision);
> +}
> +void wcn36xx_set_default_rates(struct wcn36xx_hal_supported_rates *rates);
> +
> +#endif /* _WCN36XX_H_ */
> --
> 1.8.1.2
>



-- 
Best regards,
Eugene
