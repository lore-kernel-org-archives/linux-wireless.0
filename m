Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33947 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754323AbdBGTNL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 14:13:11 -0500
Received: by mail-wm0-f68.google.com with SMTP id c85so30097344wmi.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2017 11:12:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com>
References: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com>
From: Steve deRosier <derosier@gmail.com>
Date: Tue, 7 Feb 2017 11:12:06 -0800
Message-ID: <CALLGbRLXa5m+eRhZpvWKyXkemB0qAkB=eoQKwns-vP29+izV+Q@mail.gmail.com> (sfid-20170207_201327_937977_3885F9BF)
Subject: Re: [PATCH v9] Add new mac80211 driver mwlwifi.
To: David Lin <dlin@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Chor Teck Law <ctlaw@marvell.com>,
        James Lin <jamesl@marvell.com>, Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

First off, I wanted to say thank-you for your work and effort in trying
to get mwlwifi upstream. My comments are in-line with my general notes
afterwards.

On Tue, Dec 20, 2016 at 8:11 PM, David Lin <dlin@marvell.com> wrote:

> diff --git a/drivers/net/wireless/marvell/mwlwifi/debugfs.h b/drivers/net/wireless/marvell/mwlwifi/debugfs.h
> new file mode 100644
> index 0000000..b4c3eb3
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwlwifi/debugfs.h
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (C) 2006-2016, Marvell International Ltd.
> + *
> + * This software file (the "File") is distributed by Marvell International
> + * Ltd. under the terms of the GNU General Public License Version 2, June 1991
> + * (the "License").  You may use, redistribute and/or modify this File in
> + * accordance with the terms and conditions of the License, a copy of which
> + * is available by writing to the Free Software Foundation, Inc.
> + *
> + * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
> + * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
> + * this warranty disclaimer.
> + */
> +
> +/* Description:  This file defines debug fs related functions. */
> +
> +#ifndef _MWL_DEBUGFS_H_
> +#define _MWL_DEBUGFS_H_
> +
> +void mwl_debugfs_init(struct ieee80211_hw *hw);
> +void mwl_debugfs_remove(struct ieee80211_hw *hw);
> +

You should guard these so they define to empty functions if CONFIG_DEBUG_FS
isn't enabled so they can be used by a caller without explicit guards.

> diff --git a/drivers/net/wireless/marvell/mwlwifi/dev.h b/drivers/net/wireless/marvell/mwlwifi/dev.h
> new file mode 100644
> index 0000000..c7b10ac
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwlwifi/dev.h
...
> +struct mwl_ampdu_stream {
> + struct ieee80211_sta *sta;
> + u8 tid;
> + u8 state;
> + u8 idx;
> +};
> +
> +#ifdef CONFIG_DEBUG_FS
> +#define MAC_REG_ADDR_PCI(offset)      ((priv->iobase1 + 0xA000) + (offset))
> +
> +#define MWL_ACCESS_MAC                1
> +#define MWL_ACCESS_RF                 2
> +#define MWL_ACCESS_BBP                3
> +#define MWL_ACCESS_CAU                4
> +#define MWL_ACCESS_ADDR0              5
> +#define MWL_ACCESS_ADDR1              6
> +#define MWL_ACCESS_ADDR               7
> +#endif

OK, I get that you're only using the above in the debugfs functions, but
as for generic register access functions, these would be valid no matter if
CONFIG_DEBUG_FS is defined. Having the guard here just seems to complicate
things.


> +
> +struct mwl_priv {
> + struct ieee80211_hw *hw;
> + struct firmware *fw_ucode;
> + bool fw_device_pwrtbl;
> + bool forbidden_setting;
> + bool regulatory_set;
> + u32 fw_region_code;
> + char fw_alpha2[2];
> + u8 number_of_channels;
> + struct mwl_device_pwr_tbl device_pwr_tbl[SYSADPT_MAX_NUM_CHANNELS];
> + int chip_type;
> +
> + struct device_node *dt_node;
> + struct device_node *pwr_node;
> + bool disable_2g;
> + bool disable_5g;
> + int antenna_tx;
> + int antenna_rx;
> +
> + struct mwl_tx_pwr_tbl tx_pwr_tbl[SYSADPT_MAX_NUM_CHANNELS];
> + bool cdd;
> + u16 txantenna2;
> + u8 powinited;
> + u16 max_tx_pow[SYSADPT_TX_POWER_LEVEL_TOTAL]; /* max tx power (dBm) */
> + u16 target_powers[SYSADPT_TX_POWER_LEVEL_TOTAL]; /* target powers   */
> +
> + struct pci_dev *pdev;
> + struct device *dev;
> + void __iomem *iobase0; /* MEM Base Address Register 0  */
> + void __iomem *iobase1; /* MEM Base Address Register 1  */
> + u32 next_bar_num;
> +
> + struct mutex fwcmd_mutex;    /* for firmware command         */
> + unsigned short *pcmd_buf;    /* pointer to CmdBuf (virtual)  */
> + dma_addr_t pphys_cmd_buf;    /* pointer to CmdBuf (physical) */
> + bool in_send_cmd;
> +
> + int irq;
> + struct mwl_hw_data hw_data;  /* Adapter HW specific info     */
> +
> + /* various descriptor data */
> + /* for tx descriptor data  */
> + spinlock_t tx_desc_lock ____cacheline_aligned_in_smp;
> + struct mwl_desc_data desc_data[SYSADPT_NUM_OF_DESC_DATA];
> + struct sk_buff_head txq[SYSADPT_NUM_OF_DESC_DATA];
> + struct sk_buff_head delay_q;
> + /* number of descriptors owned by fw at any one time */
> + int fw_desc_cnt[SYSADPT_NUM_OF_DESC_DATA];
> +
> + struct tasklet_struct tx_task;
> + struct tasklet_struct tx_done_task;
> + struct tasklet_struct rx_task;
> + struct tasklet_struct qe_task;
> + int txq_limit;
> + bool is_tx_done_schedule;
> + int recv_limit;
> + bool is_rx_schedule;
> + bool is_qe_schedule;
> + u32 qe_trigger_num;
> + unsigned long qe_trigger_time;
> +
> + struct timer_list period_timer;
> +
> + s8 noise;                    /* Most recently reported noise in dBm */
> + struct ieee80211_supported_band band_24;
> + struct ieee80211_channel channels_24[BAND_24_CHANNEL_NUM];
> + struct ieee80211_rate rates_24[BAND_24_RATE_NUM];
> + struct ieee80211_supported_band band_50;
> + struct ieee80211_channel channels_50[BAND_50_CHANNEL_NUM];
> + struct ieee80211_rate rates_50[BAND_50_RATE_NUM];
> +
> + u32 ap_macids_supported;
> + u32 sta_macids_supported;
> + u32 macids_used;
> + u32 running_bsses;           /* bitmap of running BSSes      */
> +
> + struct {
> + spinlock_t vif_lock;         /* for private interface info  */
> + struct list_head vif_list;   /* List of interfaces.         */
> + } ____cacheline_aligned_in_smp;
> +
> + struct {
> + spinlock_t sta_lock;         /* for private sta info        */
> + struct list_head sta_list;   /* List of stations            */
> + } ____cacheline_aligned_in_smp;
> +
> + bool radio_on;
> + bool radio_short_preamble;
> + bool wmm_enabled;
> + struct ieee80211_tx_queue_params wmm_params[SYSADPT_TX_WMM_QUEUES];
> +
> + /* ampdu stream information */
> + /* for ampdu stream */
> + struct {
> + spinlock_t stream_lock;      /* for BA stream               */
> + struct mwl_ampdu_stream ampdu[SYSADPT_TX_AMPDU_QUEUES];
> + } ____cacheline_aligned_in_smp;
> + struct work_struct watchdog_ba_handle;
> +
> + bool csa_active;
> + struct work_struct chnl_switch_handle;
> + enum nl80211_dfs_regions dfs_region;
> + u16 dfs_chirp_count_min;
> + u16 dfs_chirp_time_interval;
> + u16 dfs_pw_filter;
> + u16 dfs_min_num_radar;
> + u16 dfs_min_pri_count;
> +
> + struct thermal_cooling_device *cdev;
> + u32 throttle_state;
> + u32 quiet_period;
> + int temperature;
> +
> +#ifdef CONFIG_DEBUG_FS
> + struct dentry *debugfs_phy;
> + u32 reg_type;
> + u32 reg_offset;
> + u32 reg_value;
> + int tx_desc_num;
> +#endif

We're saving a few bytes here at the cost of some complexity. I could go
either way, but I hate when priv structures mutate.


> +/* Defined in mac80211.c. */
> +extern const struct ieee80211_ops mwl_mac80211_ops;

Does this need to be in dev.h?



> diff --git a/drivers/net/wireless/marvell/mwlwifi/fwcmd.c b/drivers/net/wireless/marvell/mwlwifi/fwcmd.c
> new file mode 100644
> index 0000000..9c3ccf9
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwlwifi/fwcmd.c
> @@ -0,0 +1,2837 @@
> +/*
> + * Copyright (C) 2006-2016, Marvell International Ltd.
> + *
> + * This software file (the "File") is distributed by Marvell International
> + * Ltd. under the terms of the GNU General Public License Version 2, June 1991
> + * (the "License").  You may use, redistribute and/or modify this File in
> + * accordance with the terms and conditions of the License, a copy of which
> + * is available by writing to the Free Software Foundation, Inc.
> + *
> + * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
> + * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
> + * this warranty disclaimer.
> + */
> +
> +/* Description:  This file implements firmware host command related
> + * functions.
> + */
> +
> +#include <linux/etherdevice.h>
> +
> +#include "sysadpt.h"
> +#include "dev.h"
> +#include "fwcmd.h"
> +#include "hostcmd.h"
> +
> +#define MAX_WAIT_FW_COMPLETE_ITERATIONS         2000
> +#define MAX_WAIT_GET_HW_SPECS_ITERATONS         3
> +
> +struct cmd_header {
> + __le16 command;
> + __le16 len;
> +} __packed;
> +
> +static bool mwl_fwcmd_chk_adapter(struct mwl_priv *priv)
> +{
> + u32 regval;
> +
> + regval = readl(priv->iobase1 + MACREG_REG_INT_CODE);

Couldn't the above be one line?


> +
> +static int mwl_fwcmd_get_tx_powers(struct mwl_priv *priv, u16 *powlist, u16 ch,
> +   u16 band, u16 width, u16 sub_ch)
> +{
> + struct hostcmd_cmd_802_11_tx_power *pcmd;
> + int i;
> +
> + pcmd = (struct hostcmd_cmd_802_11_tx_power *)&priv->pcmd_buf[0];

Often happens, so I probably won't catch them all, but this could likewise
be done in one line. Then again... line length issues, so 50/50 on that.


> +
> +static u8 mwl_fwcmd_get_80m_pri_chnl(u8 channel)
> +{
> + u8 act_primary = ACT_PRIMARY_CHAN_0;
> +
> + switch (channel) {
> + case 36:
> + act_primary = ACT_PRIMARY_CHAN_0;
> + break;
> + case 40:
> + act_primary = ACT_PRIMARY_CHAN_1;
> + break;
> + case 44:
> + act_primary = ACT_PRIMARY_CHAN_2;
> + break;
> + case 48:
> + act_primary = ACT_PRIMARY_CHAN_3;
> + break;
> + case 52:
> + act_primary = ACT_PRIMARY_CHAN_0;
> + break;
> + case 56:
> + act_primary = ACT_PRIMARY_CHAN_1;
> + break;
> + case 60:
> + act_primary = ACT_PRIMARY_CHAN_2;
> + break;
> + case 64:
> + act_primary = ACT_PRIMARY_CHAN_3;
> + break;
> + case 100:
> + act_primary = ACT_PRIMARY_CHAN_0;
> + break;
> + case 104:
> + act_primary = ACT_PRIMARY_CHAN_1;
> + break;
> + case 108:
> + act_primary = ACT_PRIMARY_CHAN_2;
> + break;
> + case 112:
> + act_primary = ACT_PRIMARY_CHAN_3;
> + break;
> + case 116:
> + act_primary = ACT_PRIMARY_CHAN_0;
> + break;
> + case 120:
> + act_primary = ACT_PRIMARY_CHAN_1;
> + break;
> + case 124:
> + act_primary = ACT_PRIMARY_CHAN_2;
> + break;
> + case 128:
> + act_primary = ACT_PRIMARY_CHAN_3;
> + break;
> + case 132:
> + act_primary = ACT_PRIMARY_CHAN_0;
> + break;
> + case 136:
> + act_primary = ACT_PRIMARY_CHAN_1;
> + break;
> + case 140:
> + act_primary = ACT_PRIMARY_CHAN_2;
> + break;
> + case 144:
> + act_primary = ACT_PRIMARY_CHAN_3;
> + break;
> + case 149:
> + act_primary = ACT_PRIMARY_CHAN_0;
> + break;
> + case 153:
> + act_primary = ACT_PRIMARY_CHAN_1;
> + break;
> + case 157:
> + act_primary = ACT_PRIMARY_CHAN_2;
> + break;
> + case 161:
> + act_primary = ACT_PRIMARY_CHAN_3;
> + break;
> + }
> +
> + return act_primary;
> +}
> +

Ignorance speaking here perhaps, but the above looks like something that
nearly every driver would need to deal with. Isn't there a helper function
in mac80211 or some better way to do this than explicitly doing a switch
logic lookup?

> +int mwl_fwcmd_set_new_stn_add(struct ieee80211_hw *hw,
> +      struct ieee80211_vif *vif,
> +      struct ieee80211_sta *sta)
> +{
> + struct mwl_priv *priv = hw->priv;
> + struct mwl_vif *mwl_vif;
> + struct hostcmd_cmd_set_new_stn *pcmd;
> + u32 rates;
> +
> + mwl_vif = mwl_dev_get_vif(vif);
> +
> + pcmd = (struct hostcmd_cmd_set_new_stn *)&priv->pcmd_buf[0];
> +
> + mutex_lock(&priv->fwcmd_mutex);
> +
> + memset(pcmd, 0x00, sizeof(*pcmd));
> + pcmd->cmd_hdr.cmd = cpu_to_le16(HOSTCMD_CMD_SET_NEW_STN);
> + pcmd->cmd_hdr.len = cpu_to_le16(sizeof(*pcmd));
> + pcmd->cmd_hdr.macid = mwl_vif->macid;
> +
> + pcmd->action = cpu_to_le16(HOSTCMD_ACT_STA_ACTION_ADD);
> + if (vif->type == NL80211_IFTYPE_STATION) {
> + pcmd->aid = 0;
> + pcmd->stn_id = 0;
> + } else {
> + pcmd->aid = cpu_to_le16(sta->aid);
> + pcmd->stn_id = cpu_to_le16(sta->aid);
> + }
> + ether_addr_copy(pcmd->mac_addr, sta->addr);
> +
> + if (hw->conf.chandef.chan->band == NL80211_BAND_2GHZ)
> + rates = sta->supp_rates[NL80211_BAND_2GHZ];
> + else
> + rates = sta->supp_rates[NL80211_BAND_5GHZ] << 5;
> + pcmd->peer_info.legacy_rate_bitmap = cpu_to_le32(rates);
> +
> + if (sta->ht_cap.ht_supported) {
> + pcmd->peer_info.ht_rates[0] = sta->ht_cap.mcs.rx_mask[0];
> + pcmd->peer_info.ht_rates[1] = sta->ht_cap.mcs.rx_mask[1];
> + pcmd->peer_info.ht_rates[2] = sta->ht_cap.mcs.rx_mask[2];
> + pcmd->peer_info.ht_rates[3] = sta->ht_cap.mcs.rx_mask[3];
> + pcmd->peer_info.ht_cap_info = cpu_to_le16(sta->ht_cap.cap);
> + pcmd->peer_info.mac_ht_param_info =
> + (sta->ht_cap.ampdu_factor & 3) |
> + ((sta->ht_cap.ampdu_density & 7) << 2);
> + }
> +
> + if (sta->vht_cap.vht_supported) {
> + pcmd->peer_info.vht_max_rx_mcs =
> + cpu_to_le32(*((u32 *)
> + &sta->vht_cap.vht_mcs.rx_mcs_map));
> + pcmd->peer_info.vht_cap = cpu_to_le32(sta->vht_cap.cap);
> + pcmd->peer_info.vht_rx_channel_width = sta->bandwidth;
> + }
> +
> + pcmd->is_qos_sta = sta->wme;
> + pcmd->qos_info = ((sta->uapsd_queues << 4) | (sta->max_sp << 1));
> +
> + if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_NEW_STN)) {
> + mutex_unlock(&priv->fwcmd_mutex);
> + wiphy_err(hw->wiphy, "failed execution\n");
> + return -EIO;
> + }
> +
> + if (vif->type == NL80211_IFTYPE_STATION) {
> + ether_addr_copy(pcmd->mac_addr, mwl_vif->sta_mac);
> +
> + if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_NEW_STN)) {
> + mutex_unlock(&priv->fwcmd_mutex);
> + wiphy_err(hw->wiphy, "failed execution\n");
> + return -EIO;
> + }
> + }

OK, time to ask. Why are we telling the firmware that we're connected to
ourselves? I would presume the firmware already knows our MAC address.

I noticed this originally because there's a nasty bug with
recycling the command buffer (for sdio, it's not relevant for this driver)
and in doing experiments I noticed that throughput significantly increases
in STA mode if we just leave out the entire clause.

In briefly examining the firmware source I see no reason to do this, but
there's a hidden chunk and I don't know what the hardware itself does with
the MAC table.

So, why is it necessary?


> +int mwl_fwcmd_set_new_stn_del(struct ieee80211_hw *hw,
> +      struct ieee80211_vif *vif, u8 *addr)
> +{
> + struct mwl_priv *priv = hw->priv;
> + struct mwl_vif *mwl_vif;
> + struct hostcmd_cmd_set_new_stn *pcmd;
> +
> + mwl_vif = mwl_dev_get_vif(vif);
> +
> + pcmd = (struct hostcmd_cmd_set_new_stn *)&priv->pcmd_buf[0];
> +
> + mutex_lock(&priv->fwcmd_mutex);
> +
> + memset(pcmd, 0x00, sizeof(*pcmd));
> + pcmd->cmd_hdr.cmd = cpu_to_le16(HOSTCMD_CMD_SET_NEW_STN);
> + pcmd->cmd_hdr.len = cpu_to_le16(sizeof(*pcmd));
> + pcmd->cmd_hdr.macid = mwl_vif->macid;
> +
> + pcmd->action = cpu_to_le16(HOSTCMD_ACT_STA_ACTION_REMOVE);
> + ether_addr_copy(pcmd->mac_addr, addr);
> +
> + if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_NEW_STN)) {
> + mutex_unlock(&priv->fwcmd_mutex);
> + wiphy_err(hw->wiphy, "failed execution\n");
> + return -EIO;
> + }
> +
> + if (vif->type == NL80211_IFTYPE_STATION) {
> + ether_addr_copy(pcmd->mac_addr, mwl_vif->sta_mac);
> +
> + if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_NEW_STN)) {
> + mutex_unlock(&priv->fwcmd_mutex);
> + wiphy_err(hw->wiphy, "failed execution\n");
> + return -EIO;
> + }
> + }
> +

Ditto.

> diff --git a/drivers/net/wireless/marvell/mwlwifi/fwdl.c b/drivers/net/wireless/marvell/mwlwifi/fwdl.c
> new file mode 100644
> index 0000000..f4d5fa1
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwlwifi/fwdl.c
...
> +
> +static void mwl_fwdl_trig_pcicmd(struct mwl_priv *priv)
> +{
> + writel(priv->pphys_cmd_buf, priv->iobase1 + MACREG_REG_GEN_PTR);
> +
> + writel(0x00, priv->iobase1 + MACREG_REG_INT_CODE);
> +
> + writel(MACREG_H2ARIC_BIT_DOOR_BELL,
> +       priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
> +}
> +
> +static void mwl_fwdl_trig_pcicmd_bootcode(struct mwl_priv *priv)
> +{
> + writel(priv->pphys_cmd_buf, priv->iobase1 + MACREG_REG_GEN_PTR);
> +
> + writel(0x00, priv->iobase1 + MACREG_REG_INT_CODE);
> +
> + writel(MACREG_H2ARIC_BIT_DOOR_BELL,
> +       priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
> +}
> +

Unless I'm mistaken the above two functions are 100% identical. In my version
I collapsed them to a single one and it works fine.

> +int mwl_fwdl_download_firmware(struct ieee80211_hw *hw)
> +{
...
> +
> + while (size_fw_downloaded < fw->size) {
> + len = readl(priv->iobase1 + 0xc40);
> +
> + if (!len)
> + break;
> +
> + /* this copies the next chunk of fw binary to be delivered */
> + memcpy((char *)&priv->pcmd_buf[0],
> +       (fw->data + size_fw_downloaded), len);
> +
> + /* this function writes pdata to c10, then write 2 to c18 */
> + mwl_fwdl_trig_pcicmd_bootcode(priv);
> +
> + /* this is arbitrary per your platform; we use 0xffff */
> + curr_iteration = FW_MAX_NUM_CHECKS;
> +
> + /* NOTE: the following back to back checks on C1C is time
> + * sensitive, hence may need to be tweaked dependent on host
> + * processor. Time for SC2 to go from the write of event 2 to
> + * C1C == 2 is ~1300 nSec. Hence the checkings on host has to
> + * consider how efficient your code can be to meet this timing,
> + * or you can alternatively tweak this routines to fit your
> + * platform
> + */
> + do {
> + int_code = readl(priv->iobase1 + 0xc1c);
> + if (int_code != 0)
> + break;
> + cond_resched();
> + curr_iteration--;
> + } while (curr_iteration);
> +

There's something fishy with the above. Having to "tweak" driver timing based
on platform is a huge red flag. There's got to be something better than the
above.


> diff --git a/drivers/net/wireless/marvell/mwlwifi/mac80211.c b/drivers/net/wireless/marvell/mwlwifi/mac80211.c
...
> +static int mwl_mac80211_config(struct ieee80211_hw *hw,
> +       u32 changed)
> +{
> + struct ieee80211_conf *conf = &hw->conf;
> + int rc;
> +
> + wiphy_debug(hw->wiphy, "change: 0x%x\n", changed);
> +
> + if (conf->flags & IEEE80211_CONF_IDLE)
> + rc = mwl_fwcmd_radio_disable(hw);
> + else
> + rc = mwl_fwcmd_radio_enable(hw);
> +
> + if (rc)
> + goto out;
> +
> + if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
> + int rate = 0;
> +
> + if (conf->chandef.chan->band == NL80211_BAND_2GHZ) {

Causes compile warning. Should be IEEE80211_BAND_2GHZ.


> + mwl_fwcmd_set_apmode(hw, AP_MODE_2_4GHZ_11AC_MIXED);
> + mwl_fwcmd_set_linkadapt_cs_mode(hw,
> + LINK_CS_STATE_CONSERV);
> + rate = mwl_rates_24[0].hw_value;
> + } else if (conf->chandef.chan->band == NL80211_BAND_5GHZ) {

Causes compile warning. Should be IEEE80211_BAND_5GHZ.

> +static void mwl_mac80211_bss_info_changed_ap(struct ieee80211_hw *hw,
> +     struct ieee80211_vif *vif,
> +     struct ieee80211_bss_conf *info,
> +     u32 changed)
> +{
> + if (changed & BSS_CHANGED_ERP_PREAMBLE)
> + mwl_fwcmd_set_radio_preamble(hw,
> +     vif->bss_conf.use_short_preamble);
> +
> + if (changed & BSS_CHANGED_BASIC_RATES) {
> + int idx;
> + int rate;
> +
> + /* Use lowest supported basic rate for multicasts
> + * and management frames (such as probe responses --
> + * beacons will always go out at 1 Mb/s).
> + */
> + idx = ffs(vif->bss_conf.basic_rates);
> + if (idx)
> + idx--;
> +
> + if (hw->conf.chandef.chan->band == NL80211_BAND_2GHZ)

Causes compile warning. Should be IEEE80211_BAND_2GHZ.


> diff --git a/drivers/net/wireless/marvell/mwlwifi/main.c b/drivers/net/wireless/marvell/mwlwifi/main.c
> new file mode 100644
...
> +#include <linux/module.h>
> +#ifdef CONFIG_OF
> +#include <linux/of.h>
> +#endif

Isn't of.h internally guarded?

> +
> +#include "sysadpt.h"
> +#include "dev.h"
> +#include "fwdl.h"
> +#include "fwcmd.h"
> +#include "tx.h"
> +#include "rx.h"
> +#include "isr.h"
> +#include "thermal.h"
> +#ifdef CONFIG_DEBUG_FS
> +#include "debugfs.h"
> +#endif

Your debugfs.h should be internally guarded. More later...

> +
> +#define MWL_DESC         "Marvell 802.11ac Wireless Network Driver"
> +#define MWL_DEV_NAME     "Marvell 802.11ac Adapter"
> +
> +#define FILE_PATH_LEN    64
> +#define CMD_BUF_SIZE     0x4000
> +
> +static struct pci_device_id mwl_pci_id_tbl[] = {
> + { PCI_VDEVICE(MARVELL, 0x2a55), .driver_data = MWL8864, },
> + { PCI_VDEVICE(MARVELL, 0x2b38), .driver_data = MWL8897, },
> + { },
> +};
> +
> +static struct mwl_chip_info mwl_chip_tbl[] = {
> + [MWL8864] = {
> + .part_name = "88W8864",
> + .fw_image = "mwlwifi/88W8864.bin",
> + .antenna_tx = ANTENNA_TX_4_AUTO,
> + .antenna_rx = ANTENNA_RX_4_AUTO,
> + },
> + [MWL8897] = {
> + .part_name = "88W8897",
> + .fw_image = "mwlwifi/88W8897.bin",
> + .antenna_tx = ANTENNA_TX_2,
> + .antenna_rx = ANTENNA_RX_2,
> + },
> +};
> +
> +static const struct ieee80211_channel mwl_channels_24[] = {
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2412, .hw_value = 1, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2417, .hw_value = 2, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2422, .hw_value = 3, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2427, .hw_value = 4, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2432, .hw_value = 5, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2437, .hw_value = 6, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2442, .hw_value = 7, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2447, .hw_value = 8, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2452, .hw_value = 9, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2457, .hw_value = 10, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2462, .hw_value = 11, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2467, .hw_value = 12, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2472, .hw_value = 13, },
> + { .band = NL80211_BAND_2GHZ, .center_freq = 2484, .hw_value = 14, },
> +};
> +

So, interesting thing... there's 62 uses of NL80211_BAND_x in this driver, but
only the few spots I mentioned cause warnings. I notice in the most recent
internal drop you've changed the above to IEEE80211_BAND_2GHZ. I wonder if that
is what should be done everywhere?

> +static const struct ieee80211_rate mwl_rates_24[] = {
> + { .bitrate = 10, .hw_value = 2, },
> + { .bitrate = 20, .hw_value = 4, },
> + { .bitrate = 55, .hw_value = 11, },
> + { .bitrate = 110, .hw_value = 22, },
> + { .bitrate = 220, .hw_value = 44, },
> + { .bitrate = 60, .hw_value = 12, },
> + { .bitrate = 90, .hw_value = 18, },
> + { .bitrate = 120, .hw_value = 24, },
> + { .bitrate = 180, .hw_value = 36, },
> + { .bitrate = 240, .hw_value = 48, },
> + { .bitrate = 360, .hw_value = 72, },
> + { .bitrate = 480, .hw_value = 96, },
> + { .bitrate = 540, .hw_value = 108, },
> +};
> +
> +static const struct ieee80211_channel mwl_channels_50[] = {
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5180, .hw_value = 36, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5200, .hw_value = 40, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5220, .hw_value = 44, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5240, .hw_value = 48, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5260, .hw_value = 52, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5280, .hw_value = 56, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5300, .hw_value = 60, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5320, .hw_value = 64, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5500, .hw_value = 100, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5520, .hw_value = 104, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5540, .hw_value = 108, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5560, .hw_value = 112, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5580, .hw_value = 116, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5600, .hw_value = 120, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5620, .hw_value = 124, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5640, .hw_value = 128, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5660, .hw_value = 132, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5680, .hw_value = 136, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5700, .hw_value = 140, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5720, .hw_value = 144, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5745, .hw_value = 149, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5765, .hw_value = 153, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5785, .hw_value = 157, },
> + { .band = NL80211_BAND_5GHZ, .center_freq = 5805, .hw_value = 161, },
> +};

Ditto.

...
> +
> +static void mwl_process_of_dts(struct mwl_priv *priv)
> +{
> +#ifdef CONFIG_OF

So a more common idiom in the drivers is:
  #ifdef CONFIG_OF
  define process of_dts function {}
  #else
  define EMPTY of_dts function {}
  #endif

I guess it's the same effect either way. I don't much care as long as
mwl_process_of_dts() can be called without guards, which it can. But I
thought I should mention it incase anyone else cares. And this is not
consistent with how you have done the same thing for CONFIG_DEBUG_FS

> + struct property *prop;
> + u32 prop_value;
> +
> + priv->dt_node =
> + of_find_node_by_name(pci_bus_to_OF_node(priv->pdev->bus),
> +     "mwlwifi");
> + if (!priv->dt_node)
> + return;
> +
> + /* look for all matching property names */
> + for_each_property_of_node(priv->dt_node, prop) {
> + if (strcmp(prop->name, "marvell,2ghz") == 0)
> + priv->disable_2g = true;
> + if (strcmp(prop->name, "marvell,5ghz") == 0)
> + priv->disable_5g = true;
> + if (strcmp(prop->name, "marvell,chainmask") == 0) {
> + prop_value = be32_to_cpu(*((__be32 *)prop->value));
> + if (prop_value == 2)
> + priv->antenna_tx = ANTENNA_TX_2;
> +
> + prop_value = be32_to_cpu(*((__be32 *)
> + (prop->value + 4)));
> + if (prop_value == 2)
> + priv->antenna_rx = ANTENNA_RX_2;
> + }
> + }
> +
> + priv->pwr_node = of_find_node_by_name(priv->dt_node,
> +      "marvell,powertable");
> +#endif
> +}

AFAICT, there's no documentation for these DT bindings. The mwlwifi node
and the marvell,powertable both need full documentation in
Documentation/devicetree/bindings/... .

Frankly I have a feeling I'm going to need these DT nodes and I'd like to not
have to guess-and-check based on the code.

...

> +static int mwl_wl_init(struct mwl_priv *priv)
> +{
> + struct ieee80211_hw *hw;
> + int rc;
> + int i;
> +
> + hw = priv->hw;
> +
> + hw->extra_tx_headroom = SYSADPT_MIN_BYTES_HEADROOM;
> + hw->queues = SYSADPT_TX_WMM_QUEUES;
> +
> + /* Set rssi values to dBm */
> + ieee80211_hw_set(hw, SIGNAL_DBM);
> + ieee80211_hw_set(hw, HAS_RATE_CONTROL);
> +
> + /* Ask mac80211 not to trigger PS mode
> + * based on PM bit of incoming frames.
> + */
> + ieee80211_hw_set(hw, AP_LINK_PS);
> +
> + ieee80211_hw_set(hw, SUPPORTS_PER_STA_GTK);
> + ieee80211_hw_set(hw, MFP_CAPABLE);
> +
> + hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
> + hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
> +
> + hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
> +
> + hw->vif_data_size = sizeof(struct mwl_vif);
> + hw->sta_data_size = sizeof(struct mwl_sta);
> +
> + priv->ap_macids_supported = 0x0000ffff;
> + priv->sta_macids_supported = 0x00010000;

How about we document what these magic numbers are? A nice named constant
at least would be nice.

> +static int mwl_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
...
> + wiphy_info(priv->hw->wiphy, "%s TX antennas, %s RX antennas\n",
> +   (priv->antenna_tx == ANTENNA_TX_4_AUTO) ? "4" : "2",
> +   (priv->antenna_rx == ANTENNA_RX_4_AUTO) ? "4" : "2");
> +
> +#ifdef CONFIG_DEBUG_FS
> + mwl_debugfs_init(hw);

The guards should be internal to mwl_debugfs_init() so we don't have to
guard it when we call it. Much like mwl_process_of_dts() is able to be called
and compiles out if CONFIG_OF isn't defined, mwl_debugfs_init() should have
the guards internal to debugfs.h/debugfs.c and we shouldn't need to worry
about it when we call it.

> +static void mwl_remove(struct pci_dev *pdev)
> +{
> + struct ieee80211_hw *hw = pci_get_drvdata(pdev);
> + struct mwl_priv *priv;
> +
> + if (!hw)
> + return;
> +
> + priv = hw->priv;
> +
> + mwl_wl_deinit(priv);
> + pci_set_drvdata(pdev, NULL);
> + ieee80211_free_hw(hw);
> + pci_disable_device(pdev);
> +
> +#ifdef CONFIG_DEBUG_FS
> + mwl_debugfs_remove(hw);
> +#endif

As previously commented on.

> +++ b/drivers/net/wireless/marvell/mwlwifi/thermal.c
...
> +static SENSOR_DEVICE_ATTR(temp1_input, 0444, mwl_thermal_show_temp,
> +  NULL, 0);
> +

Should use S_IRUGO instead of numeric 0444.

OK, that's it for specifics. I know a number of them are just nits.

A few general comments:

* I saw it it quite a bit, but didn't comment on it every time: there's
many places where a variable declaration can be combined with its
initial assignment.

* I happen to concur with Johannes' comments regarding the IEs and
your beacon processing. This is a significant issue, with potential for big
bugs down the road. At the very least, it's a maintenance headache.

>From my perspective, I'd consider it a firmware bug if there's no way
around it. Is the firmware going to strip the IEs that hostapd happens
to add to the beacons? Is there some "passthrough" or some other way
that it can be reconciled?

I strongly suspect there's better ways to handle it, even without
changing the firmware, but I haven't yet taken a look to see if there is.

In any case, while there's stuff I wouldn't mind seeing changed, I rather
see it go in sooner rather than later so I and others can contribute
on top of it, instead of waiting to see it "perfect" first.

Please add my reviewed-by.  If we're waiting on a v10,
do you have an ETA?

Thanks,
- Steve
