Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4599C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E09D20841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:10:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E09D20841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbeJHVWU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:22:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56336 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbeJHVWU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:22:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9WEh-0007oA-WE; Mon, 08 Oct 2018 16:10:16 +0200
Message-ID: <1539007805.3687.47.camel@sipsolutions.net>
Subject: Re: [RFC v3 01/12] rtw88: main files
From:   Johannes Berg <johannes@sipsolutions.net>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Date:   Mon, 08 Oct 2018 16:10:05 +0200
In-Reply-To: <1538565659-29530-2-git-send-email-yhchuang@realtek.com> (sfid-20181003_132152_136031_D3015842)
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
         <1538565659-29530-2-git-send-email-yhchuang@realtek.com>
         (sfid-20181003_132152_136031_D3015842)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-03 at 19:20 +0800, yhchuang@realtek.com wrote:
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

You really should consider supporting channel contexts - it's the far
more modern API and likely gives you more control even if you support
only a single channel.

> +static struct rtw_vif_port rtw_vif_port[] = {
> +	[0] = {
> +		.mac_addr	= {.addr = 0x0610},
> +		.bssid		= {.addr = 0x0618},
> +		.net_type	= {.addr = 0x0100, .mask = 0x30000},
> +		.aid		= {.addr = 0x06a8, .mask = 0x7ff},
> +	},

err, what's all this?

Anyway, you really cannot make this static - again, multiple devices
might get plugged in.

> +	list_add_rcu(&rtwvif->list, &rtwdev->vif_list);

I don't see a reason for you to maintain your own list, you can always
iterate mac80211's list if you really need to?

> +	switch (vif->type) {
> +	case NL80211_IFTYPE_AP:
> +	case NL80211_IFTYPE_MESH_POINT:
> +		net_type = RTW_NET_AP_MODE;
> +		break;
> +	case NL80211_IFTYPE_ADHOC:
> +		net_type = RTW_NET_AD_HOC;
> +		break;
> +	default:
> +		net_type = RTW_NET_NO_LINK;

you might to add STATION and then fail in the default case?

> +static void rtw_ops_remove_interface(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
> +	u32 config = 0;
> +
> +	rtw_info(rtwdev, "stop vif %pM on port %d", vif->addr, rtwvif->port);
> +
> +	mutex_lock(&rtwdev->mutex);
> +
> +	eth_zero_addr(rtwvif->mac_addr);
> +	config |= PORT_SET_MAC_ADDR;
> +	rtwvif->net_type = RTW_NET_NO_LINK;
> +	config |= PORT_SET_NET_TYPE;
> +	rtw_vif_port_config(rtwdev, rtwvif, config);
> +
> +	list_del_rcu(&rtwvif->list);
> +	synchronize_rcu();

That synchronize_rcu() is *really* expensive, you should probably use
mac80211's list iteration to avoid it.

> +static void rtw_ops_configure_filter(struct ieee80211_hw *hw,
> +				     unsigned int changed_flags,
> +				     unsigned int *new_flags,
> +				     u64 multicast)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +
> +	*new_flags &= (FIF_ALLMULTI | FIF_OTHER_BSS | FIF_FCSFAIL |
> +		       FIF_BCN_PRBRESP_PROMISC);

nit: not much need for those parentheses

> +static u8 rtw_acquire_macid(struct rtw_dev *rtwdev)
> +{
> +	u8 i;
> +
> +	for (i = 0; i < RTW_MAX_MAC_ID_NUM; i++) {
> +		if (!rtwdev->macid_used[i]) {
> +			rtwdev->macid_used[i] = true;
> +			return i;
> +		}
> +	}
> +
> +	return i;
> +}
> +
> +static void rtw_release_macid(struct rtw_dev *rtwdev, u8 mac_id)
> +{
> +	rtwdev->macid_used[mac_id] = false;
> +}

This would be way simpler (and use much less memory) with a bitmap and
find_first_zero_bit().

> +static int rtw_ops_sta_add(struct ieee80211_hw *hw,
> +			   struct ieee80211_vif *vif,
> +			   struct ieee80211_sta *sta)

You might want to use sta_state() instead of sta_add(), it's likely the
better API.

> +	si->sta = sta;
> +	si->vif = vif;
> +	si->init_ra_lv = 1;
> +	ewma_rssi_init(&si->avg_rssi);

What's this for that mac80211 doesn't do already?

> +	rtw_update_sta_info(rtwdev, si);
> +	rtw_fw_media_status_report(rtwdev, si->mac_id, true);
> +
> +	list_add_tail_rcu(&si->list, &rtwvif->sta_list);

Again, you shouldn't need to keep your own list in the driver, mac80211
does all that bookkeeping for you.

> +static int rtw_ops_sta_remove(struct ieee80211_hw *hw,
> +			      struct ieee80211_vif *vif,
> +			      struct ieee80211_sta *sta)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
> +
> +	mutex_lock(&rtwdev->mutex);
> +
> +	rtw_release_macid(rtwdev, si->mac_id);
> +	rtw_fw_media_status_report(rtwdev, si->mac_id, false);
> +
> +	list_del_rcu(&si->list);
> +	synchronize_rcu();

This synchronize_rcu() will hurt your roaming performance.

> +	switch (key->cipher) {
> +	case WLAN_CIPHER_SUITE_WEP40:
> +		hw_key_type = RTW_CAM_WEP40;
> +		break;
> +	case WLAN_CIPHER_SUITE_WEP104:
> +		hw_key_type = RTW_CAM_WEP104;
> +		break;
> +	case WLAN_CIPHER_SUITE_TKIP:
> +		hw_key_type = RTW_CAM_TKIP;
> +		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
> +		break;
> +	case WLAN_CIPHER_SUITE_CCMP:
> +		hw_key_type = RTW_CAM_AES;
> +		key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
> +		break;
> +	default:
> +		return -ENOTSUPP;
> +	}

This will provoke error messages to be printed for e.g. CMAC keys, or do
you really not support protected management frames? If you were to pick
"-EOPNOTSUPP" then no errors would be printed.

> +	mutex_lock(&rtwdev->mutex);
> +
> +	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
> +		hw_key_idx = rtw_sec_get_free_cam(sec);
> +	} else {
> +		/* multiple interfaces? */
> +		hw_key_idx = key->keyidx;
> +	}

Indeed, good question :-)


> +};
> +
> +static struct ieee80211_rate rtw_ratetable_2g[] = {
> +	{.bitrate = 10, .hw_value = 0x00,},
> +	{.bitrate = 20, .hw_value = 0x01,},
> +	{.bitrate = 55, .hw_value = 0x02,},
> +	{.bitrate = 110, .hw_value = 0x03,},
> +	{.bitrate = 60, .hw_value = 0x04,},
> +	{.bitrate = 90, .hw_value = 0x05,},
> +	{.bitrate = 120, .hw_value = 0x06,},
> +	{.bitrate = 180, .hw_value = 0x07,},
> +	{.bitrate = 240, .hw_value = 0x08,},
> +	{.bitrate = 360, .hw_value = 0x09,},
> +	{.bitrate = 480, .hw_value = 0x0a,},
> +	{.bitrate = 540, .hw_value = 0x0b,},
> +};
> +
> +static struct ieee80211_rate rtw_ratetable_5g[] = {
> +	{.bitrate = 60, .hw_value = 0x04,},
> +	{.bitrate = 90, .hw_value = 0x05,},
> +	{.bitrate = 120, .hw_value = 0x06,},
> +	{.bitrate = 180, .hw_value = 0x07,},
> +	{.bitrate = 240, .hw_value = 0x08,},
> +	{.bitrate = 360, .hw_value = 0x09,},
> +	{.bitrate = 480, .hw_value = 0x0a,},
> +	{.bitrate = 540, .hw_value = 0x0b,},
> +};

The 5G one is the same as the 2G one without the first 4 entries, so you
could do rtw_ratetable_2g+4 to avoid duplicating the data.

> +static struct ieee80211_supported_band rtw_band_2ghz = {
> +	.band = NL80211_BAND_2GHZ,
> +
> +	.channels = rtw_channeltable_2g,
> +	.n_channels = ARRAY_SIZE(rtw_channeltable_2g),
> +
> +	.bitrates = rtw_ratetable_2g,
> +	.n_bitrates = ARRAY_SIZE(rtw_ratetable_2g),
> +
> +	.ht_cap = {0},
> +	.vht_cap = {0},
> +};

I see no reason to init the ht/vht cap?

> +static struct ieee80211_supported_band rtw_band_5ghz = {
> +	.band = NL80211_BAND_5GHZ,
> +
> +	.channels = rtw_channeltable_5g,
> +	.n_channels = ARRAY_SIZE(rtw_channeltable_5g),
> +
> +	.bitrates = rtw_ratetable_5g,
> +	.n_bitrates = ARRAY_SIZE(rtw_ratetable_5g),
> +
> +	.ht_cap = {0},
> +	.vht_cap = {0},
> +};

dito

> +static void rtw_watch_dog_work(struct work_struct *work)
> +{
> +	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
> +					      watch_dog_work.work);
> +	struct rtw_vif *rtwvif;
> +
> +	if (!rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
> +		return;
> +
> +	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->watch_dog_work,
> +				     RTW_WATCH_DOG_DELAY_TIME);

You're aware of the power cost of waking up every 2 seconds? That's a
really bad idea, in general, at the very least you should use a more
power efficient scheduling here to combine with other wakeups
(round_jiffies_relative, or so).

> +	/* check if we can enter lps */
> +	rtw_lps_enter_check(rtwdev);
> +
> +	/* reset tx/rx statictics */
> +	rtwdev->stats.tx_unicast = 0;
> +	rtwdev->stats.rx_unicast = 0;
> +	rtwdev->stats.tx_cnt = 0;
> +	rtwdev->stats.rx_cnt = 0;
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(rtwvif, &rtwdev->vif_list, list) {
> +		rtwvif->stats.tx_unicast = 0;
> +		rtwvif->stats.rx_unicast = 0;
> +		rtwvif->stats.tx_cnt = 0;
> +		rtwvif->stats.rx_cnt = 0;
> +	}
> +	rcu_read_unlock();

???

why should statistics be reset evyer 2 seconds?

> +
> +	switch (bw_cap) {
> +	case EFUSE_HW_CAP_IGNORE:
> +	case EFUSE_HW_CAP_SUPP_BW80:
> +		bw |= BIT(RTW_CHANNEL_WIDTH_80);
> +	/* fall through */
> +	case EFUSE_HW_CAP_SUPP_BW40:
> +		bw |= BIT(RTW_CHANNEL_WIDTH_40);
> +	/* fall through */

I'd probably indent the comments by one more tab (to be where the
"break" would be), but that's really a style nit.

> +	case WIRELESS_OFDM | WIRELESS_HT:

Btw ... you have all this HT stuff and 40/80 MHz but no HT/VHT
capabilities?

> +static void rtw_init_ht_cap(struct rtw_dev *rtwdev,
> +			    struct ieee80211_sta_ht_cap *ht_cap)
> +{

Oh... ok.

> +static void rtw_set_supported_band(struct ieee80211_hw *hw,
> +				   struct rtw_chip_info *chip)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct ieee80211_supported_band *sband;
> +
> +	if (chip->band & RTW_BAND_2G) {
> +		sband = kmalloc(sizeof(*sband), GFP_KERNEL);
> +		memcpy(sband, &rtw_band_2ghz, sizeof(rtw_band_2ghz));

error check, kmemdup, make rtw_band_2ghz const.

> +	if (chip->band & RTW_BAND_5G) {
> +		sband = kmalloc(sizeof(*sband), GFP_KERNEL);
> +		memcpy(sband, &rtw_band_5ghz, sizeof(rtw_band_5ghz));

dito

> +	if (chip->band & RTW_BAND_2G)
> +		kfree(hw->wiphy->bands[NL80211_BAND_2GHZ]);
> +	if (chip->band & RTW_BAND_5G)
> +		kfree(hw->wiphy->bands[NL80211_BAND_5GHZ]);

Don't really need the if in both cases, kfree(NULL) is fine.

> +static int rtw_load_firmware(struct rtw_dev *rtwdev, const char *fw_name)
> +{
> +	struct rtw_fw_state *fw = &rtwdev->fw;
> +	const struct firmware *firmware;
> +	int ret;
> +
> +	ret = request_firmware(&firmware, fw_name, rtwdev->dev);

You should use request_firmware_nowait(), otherwise you can stall the
boot if your driver is built-in (or lives in initramfs?).

> +EXPORT_SYMBOL(rtw_core_init);

You could also remove the exports if you put the pci.c into the same
module. Dunno, maybe it's some sort of future-proofing, but if you're
going to have one module with *everything* except for ~1.2k LOC PCI, it
seems hardly worth it (especially since it's only useful if you load
both anyway)

> +	ieee80211_hw_set(hw, MFP_CAPABLE);

so you do have MFP - I guess you should test it and check for spurious
hardware crypto messages

> +#define LE_BITS_CLEARED_TO_4BYTE(addr, offset, len)				\
> +	(le32_to_cpu(*(__le32 *)(addr)) & (~GENMASK(offset + len - 1, offset)))
> +#define LE_BITS_TO_4BYTE(addr, offset, len)					\
> +	((le32_to_cpu(*((__le32 *)(addr))) >> (offset)) & GENMASK(len - 1, 0))
> +#define SET_BITS_TO_LE_4BYTE(addr, offset, len, val)				\
> +	do {									\
> +		*((__le32 *)(addr)) =						\
> +		cpu_to_le32(							\
> +		LE_BITS_CLEARED_TO_4BYTE(addr, offset, len) |			\
> +		((((u32)val) & GENMASK(len - 1, 0)) << (offset))		\
> +		);								\
> +	} while (0)

Seems like that likely has alignment issues again.

> +struct rtw_2g_1s_pwr_idx_diff {
> +#ifdef __LITTLE_ENDIAN
> +	s8 ofdm:4;
> +	s8 bw20:4;
> +#else
> +	s8 bw20:4;
> +	s8 ofdm:4;
> +#endif

You have this a lot, but IMHO it's generally not a good idea to try to
use bitfields when you actually need accurate bit layout for hardware.

Take a look at include/linux/bitfield.h for an alternative.

> +struct rtw_cam_entry {
> +	bool used;
> +	bool valid;
> +	bool group;
> +	u8 addr[ETH_ALEN];
> +	u8 hw_key_type;
> +	struct ieee80211_key_conf *key;
> +};

I'd also argue you should split hardware/firmware API things (like much
of this file) from driver-implementation things (like this and more
below) - it makes the driver easier to maintain since one can then leave
the hardware/firmware things pretty much alone for the most part. Or, if
that changes, just has to look there. The separation is good.

> +struct rtw_sec_desc {
> +	/* search strategy */
> +	bool default_key_search;

Incidental nit: that seems a bit strange, that's not a "strategy enum"
or so?

> +	/* protected by rcu */
> +	struct list_head sta_list;

RCU doesn't protect a list by itself - you need to say "protected by xyz
mutex, readers can use RCU" or so.

> +#include "hci.h"

Uh, I think it's more customary to put includes at the top of the file,
and if you can't that's probably a sign you haven't split things up
well.

> +static inline struct rtw_sta_info *get_hdr_sta(struct rtw_dev *rtwdev,
> +					       struct ieee80211_vif *vif,
> +					       struct ieee80211_hdr *hdr)
> +{
> +	struct rtw_vif *rtwvif;
> +	struct rtw_sta_info *si;
> +	struct rtw_sta_info *target = NULL;
> +
> +	rcu_read_lock();
> +	if (vif) {
> +		rtwvif = (struct rtw_vif *)vif->drv_priv;
> +		list_for_each_entry(si, &rtwvif->sta_list, list) {
> +			if (ether_addr_equal(si->sta->addr, hdr->addr2)) {
> +				target = si;
> +				break;
> +			}
> +		}
> +	} else {
> +		list_for_each_entry_rcu(rtwvif, &rtwdev->vif_list, list) {
> +			list_for_each_entry(si, &rtwvif->sta_list, list) {
> +				if (ether_addr_equal(si->sta->addr, hdr->addr2)) {
> +					target = si;
> +					break;
> +				}
> +			}
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return target;
> +}

Seems a bit large for an inline?

johannes
