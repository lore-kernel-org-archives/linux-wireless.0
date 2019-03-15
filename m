Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E09C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 08:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0BC3218AC
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 08:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfCOI2R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:28:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57964 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728564AbfCOI2R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 04:28:17 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h4iCL-0004vE-NE; Fri, 15 Mar 2019 09:28:13 +0100
Message-ID: <5f31d5172ae4b6d985ad363f3b467b9831bf4820.camel@sipsolutions.net>
Subject: Re: [PATCH v8 01/14] rtw88: main files
From:   Johannes Berg <johannes@sipsolutions.net>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
        sgruszka@redhat.com, pkshih@realtek.com, tehuang@realtek.com,
        briannorris@chromium.org, Larry.Finger@lwfinger.net
Date:   Fri, 15 Mar 2019 09:28:12 +0100
In-Reply-To: <1552450443-351-2-git-send-email-yhchuang@realtek.com>
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
         <1552450443-351-2-git-send-email-yhchuang@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-03-13 at 12:13 +0800, yhchuang@realtek.com wrote:
> 
> +static int rtw_ops_config(struct ieee80211_hw *hw, u32 changed)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	int ret = 0;
> +
> +	mutex_lock(&rtwdev->mutex);
> +
> +	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
> +		if (hw->conf.flags & IEEE80211_CONF_IDLE) {
> +			rtw_enter_ips(rtwdev);
> +		} else {
> +			ret = rtw_leave_ips(rtwdev);
> +			if (ret) {
> +				rtw_err(rtwdev, "failed to leave idle state\n");
> +				goto out;
> +			}
> +		}
> +	}
> +
> +	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
> +		rtw_set_channel(rtwdev);


It's clearly your decision, but you're probably better off supporting
the modern channel context APIs, even if (at this time) you only support
a single channel.

The settings and methods here that apply to the "whole hardware" are
mostly obsolete as far as mac80211 is concerned.

Now, I also don't recommend you change that now, and it's clearly not a
requirement for an in-tree driver, but something to think about.

> +static int rtw_ops_add_interface(struct ieee80211_hw *hw,
> +				 struct ieee80211_vif *vif)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
> +	enum rtw_net_type net_type;
> +	u32 config = 0;
> +	u8 port = 0;
> +
> +	rtwvif->port = port;
> +	rtwvif->vif = vif;
> +	rtwvif->stats.tx_unicast = 0;
> +	rtwvif->stats.rx_unicast = 0;
> +	rtwvif->stats.tx_cnt = 0;
> +	rtwvif->stats.rx_cnt = 0;
> +	rtwvif->in_lps = false;
> +	rtwvif->conf = &rtw_vif_port[port];

That's a bit weird, port is always 0. But I guess it's some kind of
preparation for future multi-interface changes (and then you probably
want the channel contexts too?)

> +	rtw_info(rtwdev, "start vif %pM on port %d\n", vif->addr, rtwvif->port);

I'm not convinced that warrants an "info" level trace, but YMMV.

> +	rtw_info(rtwdev, "stop vif %pM on port %d\n", vif->addr, rtwvif->port);

dito

> +static int rtw_ops_sta_add(struct ieee80211_hw *hw,
> +			   struct ieee80211_vif *vif,
> +			   struct ieee80211_sta *sta)

Also, here, I'd consider using sta-state API, it tells you more. Here
it's even less important though since from mac80211's POV it's exactly
the same (it only ever calls sta_state) but the driver with
sta_add/sta_remove gets a filtered view thereof.

> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
> +	int ret = 0;
> +
> +	mutex_lock(&rtwdev->mutex);
> +
> +	si->mac_id = rtw_acquire_macid(rtwdev);

I note you don't handle any kinds of firmware restart scenarios here. I
guess eventually you'd want to?

> +static void rtw_watch_dog_work(struct work_struct *work)

Hm, is that really a "watchdog" in the usual sense?

It seems more like some sort of "periodic work" like the LPS stuff
below, or whatever the PHY dynamic thing is - but not a "watchdog" in
the sense of checking that things are still OK?

Anyway, just a nit about semantics.

(I was looking for FW restart handling here or so)

> +	/* power on MAC before firmware downloaded */
> +	ret = rtw_mac_power_on(rtwdev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to power on mac\n");
> +		goto err;
> +	}
> +
> +	wait_for_completion(&fw->completion);

Maybe I'm misreading the code, but does this every do anything? It
looked like you only get here after the callback.

> +	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->watch_dog_work,
> +				     RTW_WATCH_DOG_DELAY_TIME);

Consider using at least round_jiffies_relative() - this is expensive
from a power consumption POV already and doesn't look like it needs
perfect timing.

> +static int rtw_chip_efuse_enable(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_fw_state *fw = &rtwdev->fw;
> +	int ret;
> +
> +	ret = rtw_hci_setup(rtwdev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to setup hci\n");
> +		goto err;
> +	}
> +
> +	ret = rtw_mac_power_on(rtwdev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to power on mac\n");
> +		goto err;
> +	}
> +
> +	rtw_write8(rtwdev, REG_C2HEVT, C2H_HW_FEATURE_DUMP);
> +
> +	wait_for_completion(&fw->completion);

same here?

It sort of looked like you don't even need the completion, but I may not
be understanding the full flow.

Typically the flow would be

probe -> load firmware -> firmware callback -> continue work

but I haven't checked in detail if it's different here. If it is though,
why should it be? You can't really do anything without firmware?

> +++ b/drivers/net/wireless/realtek/rtw88/main.h

This file is a bit confusing. On the one hand, you have things like:


> +#define RTW_WATCH_DOG_DELAY_TIME	round_jiffies_relative(HZ * 2)

(ohh. you did use round_jiffies_relative!)

> +extern unsigned int rtw_debug_mask;
> +extern const struct ieee80211_ops rtw_ops;
> +extern struct rtw_chip_info rtw8822b_hw_spec;
> +extern struct rtw_chip_info rtw8822c_hw_spec;

This which are very clearly driver specific.

On the other hand you have:

> +enum rtw_bandwidth {
> +	RTW_CHANNEL_WIDTH_20	= 0,
> +	RTW_CHANNEL_WIDTH_40	= 1,
> +	RTW_CHANNEL_WIDTH_80	= 2,
> +	RTW_CHANNEL_WIDTH_160	= 3,
> +	RTW_CHANNEL_WIDTH_80_80	= 4,
> +	RTW_CHANNEL_WIDTH_5	= 5,
> +	RTW_CHANNEL_WIDTH_10	= 6,
> +};
> +
> +enum rtw_net_type {
> +	RTW_NET_NO_LINK		= 0,
> +	RTW_NET_AD_HOC		= 1,
> +	RTW_NET_MGD_LINKED	= 2,
> +	RTW_NET_AP_MODE		= 3,
> +};
> +
> +enum rtw_rf_type {
> +	RF_1T1R			= 0,
> +	RF_1T2R			= 1,
> +	RF_2T2R			= 2,
> +	RF_2T3R			= 3,
> +	RF_2T4R			= 4,
> +	RF_3T3R			= 5,
> +	RF_3T4R			= 6,
> +	RF_4T4R			= 7,
> +	RF_TYPE_MAX,
> +};

And lots of other things like that which look like some kind of device
API (firmware, hardware, OTP, ...)

IMHO it'd be cleaner to separate that into different files.

Again, for example:

> +enum rtw_regulatory_domains {
> +	RTW_REGD_FCC	= 0,
> +	RTW_REGD_MKK	= 1,
> +	RTW_REGD_ETSI	= 2,
> +	RTW_REGD_WW	= 3,
> +
> +	RTW_REGD_MAX
> +};

Must be hardware API otherwise you wouldn't really care about the exact
values, I guess?

> +enum rtw_flags {
> +	RTW_FLAG_RUNNING,
> +	RTW_FLAG_FW_RUNNING,
> +	RTW_FLAG_SCANNING,
> +	RTW_FLAG_INACTIVE_PS,
> +	RTW_FLAG_LEISURE_PS,
> +	RTW_FLAG_DIG_DISABLE,
> +
> +	NUM_OF_RTW_FLAGS,
> +};

Where this is clearly pure driver but everything is completely
intermingled.

It's not a huge problem, but ...

> +/* the power index is represented by differences, which cck-1s & ht40-1s are
> + * the base values, so for 1s's differences, there are only ht20 & ofdm
> + */
> +struct rtw_2g_1s_pwr_idx_diff {
> +#ifdef __LITTLE_ENDIAN
> +	s8 ofdm:4;
> +	s8 bw20:4;
> +#else
> +	s8 bw20:4;
> +	s8 ofdm:4;
> +#endif
> +} __packed;

Again, clearly something with the device, otherwise you wouldn't go to
the effort of doing correct-endian-bitfields :-)

(Which I wouldn't really recommend anyway ... but that's another story)

> +#define rtw_iterate_vifs(rtwdev, iterator, data)                               \
> +	ieee80211_iterate_active_interfaces(rtwdev->hw,                        \
> +			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
> +#define rtw_iterate_vifs_atomic(rtwdev, iterator, data)                        \
> +	ieee80211_iterate_active_interfaces_atomic(rtwdev->hw,                 \
> +			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
> +#define rtw_iterate_stas_atomic(rtwdev, iterator, data)                        \
> +	ieee80211_iterate_stations_atomic(rtwdev->hw, iterator, data)

Why not make those inlines?

> +static inline u8 *get_hdr_bssid(struct ieee80211_hdr *hdr)
> +{
> +	__le16 fc = hdr->frame_control;
> +	u8 *bssid;
> +
> +	if (ieee80211_has_tods(fc))
> +		bssid = hdr->addr1;
> +	else if (ieee80211_has_fromds(fc))
> +		bssid = hdr->addr2;
> +	else
> +		bssid = hdr->addr3;
> +
> +	return bssid;
> +}


This is kinda incomplete, perhaps we should export ieee80211_get_bssid()
instead?

Anyway, none of that really seems like blocking issues.

joahnnes

