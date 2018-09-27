Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87293C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 13:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3867221533
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 13:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3867221533
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbeI0UJN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 16:09:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbeI0UJM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 16:09:12 -0400
Received: from smtp.corp.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59CEB315009E;
        Thu, 27 Sep 2018 13:50:51 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9116CB7E96;
        Thu, 27 Sep 2018 13:50:50 +0000 (UTC)
Date:   Thu, 27 Sep 2018 15:50:48 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org, pkshih@realtek.com,
        tehuang@realtek.com
Subject: Re: [PATCH 01/12] rtwlan: main files
Message-ID: <20180927135040.GA4712@redhat.com>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.27
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 27 Sep 2018 13:50:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Below is some more detailed review of first patch (with mostly
nitpicks).

On Fri, Sep 21, 2018 at 02:03:56PM +0800, yhchuang@realtek.com wrote:
> +static void rtw_ops_tx(struct ieee80211_hw *hw,
> +		       struct ieee80211_tx_control *control,
> +		       struct sk_buff *skb)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_tx_pkt_info pkt_info;
> +
> +	if (!rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
> +		goto out;
> +
> +	memset(&pkt_info, 0, sizeof(pkt_info));
> +	rtw_tx_pkt_info_update(rtwdev, &pkt_info, control, skb);
> +	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
> +		goto out;
> +
> +	return;
> +
> +out:
> +	dev_kfree_skb_any(skb);
This can be simplified by just do kfree after if ().
   
> +static int rtw_ops_add_interface(struct ieee80211_hw *hw,
> +				 struct ieee80211_vif *vif)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
> +	enum rtw_net_type net_type;
> +	u32 config = 0;
> +	u8 port = 0;
<snip>
> +	list_add(&rtwvif->list, &rtwdev->vif_list);
How rtwdev->vif_list is protected agains concurent access ?

> +	INIT_LIST_HEAD(&rtwvif->sta_list);
> +
> +	rtwvif->conf = &rtw_vif_port[port];
port is always 0, this either should be fixes or max interfaces for
STA should be set to 1 (temporally).
 
> +static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif,
> +				     struct ieee80211_bss_conf *conf,
> +				     u32 changed)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
> +	u32 config = 0;
> +
> +	if (changed & BSS_CHANGED_ASSOC) {
> +		struct rtw_sta_info *ap;
> +		struct rtw_chip_info *chip = rtwdev->chip;
> +		enum rtw_net_type net_type;
> +
> +		ap = list_first_entry(&rtwvif->sta_list,
> +				      struct rtw_sta_info, list);
How rtlwvif->sta_list is protected against concurrent access ? 

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
> +
> +static int rtw_ops_sta_add(struct ieee80211_hw *hw,
> +			   struct ieee80211_vif *vif,
> +			   struct ieee80211_sta *sta)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
> +	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
> +
> +	si->mac_id = rtw_acquire_macid(rtwdev);
<snip>
> +
> +static int rtw_ops_sta_remove(struct ieee80211_hw *hw,
> +			      struct ieee80211_vif *vif,
> +			      struct ieee80211_sta *sta)
> +{
> +	struct rtw_dev *rtwdev = hw->priv;
> +	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
> +
> +	rtw_release_macid(rtwdev, si->mac_id);
I'm not sure if mac80211 can not add one STA and remove another one
STA at the same time. This need to be verified.

> +static struct ieee80211_iface_limit rtw_5port_limits[] = {
> +	{ .max = 1, .types = BIT(NL80211_IFTYPE_AP) |
> +			     BIT(NL80211_IFTYPE_ADHOC) |
> +			     BIT(NL80211_IFTYPE_MESH_POINT), },
> +	{ .max = 5, .types = BIT(NL80211_IFTYPE_STATION), },
<snip>
> +static struct ieee80211_iface_combination rtw_5port_if_combs[] = {
> +	{
> +		.limits = rtw_5port_limits,
> +		.n_limits = ARRAY_SIZE(rtw_5port_limits),
> +		.max_interfaces = 5,
> +		.num_different_channels = 1,
> +	},
Here: change to max interfaces to 1 or fix port in add/remove interface.

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
> +
> +	/* check if we can enter lps */
> +	rtw_lps_enter_check(rtwdev);
> +
> +	/* reset tx/rx statictics */
> +	rtwdev->stats.tx_unicast = 0;
> +	rtwdev->stats.rx_unicast = 0;
> +	rtwdev->stats.tx_cnt = 0;
> +	rtwdev->stats.rx_cnt = 0;
> +	list_for_each_entry(rtwvif, &rtwdev->vif_list, list) {
> +		rtwvif->stats.tx_unicast = 0;
> +		rtwvif->stats.rx_unicast = 0;
> +		rtwvif->stats.tx_cnt = 0;
> +		rtwvif->stats.rx_cnt = 0;
If we just nulify statistics here, what is the point to provide them ?
I can not see code where we read those stats. Perhaps code
that use them will be added, so this possibly is fine.

> +	hal->current_channel = center_chan;
Not used anywhere.

> +static int rtw_load_firmware(struct rtw_dev *rtwdev, const char *fw_name)
> +{
> +	struct rtw_fw_state *fw = &rtwdev->fw;
> +	const struct firmware *firmware;
> +	int ret;
> +
> +	ret = request_firmware(&firmware, fw_name, rtwdev->dev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to request firmware\n");
> +		return ret;
> +	}
> +
> +	fw->firmware = firmware;
> +	fw->data = firmware->data;
> +	fw->size = firmware->size;
Seems not needed, we can use fw->firmware->{data,size}
since fw->firwware is not released till chip de-init.

> +#define BIT_LEN_MASK_32(__bitlen) (0xFFFFFFFF >> (32 - (__bitlen)))
> +#define BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)                          \
> +	(BIT_LEN_MASK_32(__bitlen) << (__bitoffset))
> +#define LE_P4BYTE_TO_HOST_4BYTE(__start) (le32_to_cpu(*((__le32 *)(__start))))
> +#define LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen)               \
> +	(LE_P4BYTE_TO_HOST_4BYTE(__start) &                                    \
> +	 (~BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)))
> +#define LE_BITS_TO_4BYTE(__start, __bitoffset, __bitlen)                       \
> +	((LE_P4BYTE_TO_HOST_4BYTE(__start) >> (__bitoffset)) &                 \
> +	 BIT_LEN_MASK_32(__bitlen))
> +#define SET_BITS_TO_LE_4BYTE(__start, __bitoffset, __bitlen, __value)          \
> +	do {                                                                   \
> +		*((__le32 *)(__start)) = \
> +		cpu_to_le32( \
> +		LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen) |     \
> +		((((u32)__value) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset))\
> +		);                                                             \
> +	} while (0)
I think this should be somehow cleaned up or replaced by something sane.

> +struct rtw_sta_info {
> +	struct list_head list;
> +
> +	struct ieee80211_sta *sta;
> +	struct ieee80211_vif *vif;
> +
> +	struct ewma_rssi avg_rssi;
> +	u8 rssi_level;
> +
> +	u8 mac_id;
> +	u8 rate_id;
> +	enum rtw_bandwidth bw_mode;

Can we talk with different STA using different bandwidh ? I think this
is configures channel property and bw_mode is the same for all
connected stations.
 
> +struct rtw_table {
> +	const void *data;
> +	const u32 size;
> +	void (*parse)(struct rtw_dev *rtwdev, const struct rtw_table *tbl);
> +	void (*do_cfg)(struct rtw_dev *rtwdev, const struct rtw_table *tbl,
> +		       u32 addr, u32 data);
> +	enum rtw_rf_path rf_path;
> +};
> +
> +static inline void rtw_load_table(struct rtw_dev *rtwdev,
> +				  const struct rtw_table *tbl)
> +{
> +	(*tbl->parse)(rtwdev, tbl);
> +}

This interface of loading/processing tables of data looks very strange.
I don't think is incorrect, but seems to be somewhat not necessary
complicated. I'll try provide more detailed comment about that when
review other files.

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

This seems to not to be that simple and depend on frame type and
interface type. See ieee80211_get_bssid().

> +#define BIT_SET_RXGCK_VHT_FIFOTHR(x, v)                                        \
> +	(BIT_CLEAR_RXGCK_VHT_FIFOTHR(x) | BIT_RXGCK_VHT_FIFOTHR(v))
> +
> +#define BIT_SHIFT_RXGCK_HT_FIFOTHR 24
> +#define BIT_MASK_RXGCK_HT_FIFOTHR 0x3
> +#define BIT_RXGCK_HT_FIFOTHR(x)                                                \
> +	(((x) & BIT_MASK_RXGCK_HT_FIFOTHR) << BIT_SHIFT_RXGCK_HT_FIFOTHR)
> +#define BITS_RXGCK_HT_FIFOTHR                                                  \
> +	(BIT_MASK_RXGCK_HT_FIFOTHR << BIT_SHIFT_RXGCK_HT_FIFOTHR)
> +#define BIT_CLEAR_RXGCK_HT_FIFOTHR(x) ((x) & (~BITS_RXGCK_HT_FIFOTHR))
> +#define BIT_GET_RXGCK_HT_FIFOTHR(x)                                            \
> +	(((x) >> BIT_SHIFT_RXGCK_HT_FIFOTHR) & BIT_MASK_RXGCK_HT_FIFOTHR)
> +#define BIT_SET_RXGCK_HT_FIFOTHR(x, v)                                         \
> +	(BIT_CLEAR_RXGCK_HT_FIFOTHR(x) | BIT_RXGCK_HT_FIFOTHR(v))
> +
> +#define BIT_SHIFT_RXGCK_OFDM_FIFOTHR 22
> +#define BIT_MASK_RXGCK_OFDM_FIFOTHR 0x3
> +#define BIT_RXGCK_OFDM_FIFOTHR(x)                                              \
> +	(((x) & BIT_MASK_RXGCK_OFDM_FIFOTHR) << BIT_SHIFT_RXGCK_OFDM_FIFOTHR)
> +#define BITS_RXGCK_OFDM_FIFOTHR                                                \
> +	(BIT_MASK_RXGCK_OFDM_FIFOTHR << BIT_SHIFT_RXGCK_OFDM_FIFOTHR)
> +#define BIT_CLEAR_RXGCK_OFDM_FIFOTHR(x) ((x) & (~BITS_RXGCK_OFDM_FIFOTHR))
> +#define BIT_GET_RXGCK_OFDM_FIFOTHR(x)                                          \
> +	(((x) >> BIT_SHIFT_RXGCK_OFDM_FIFOTHR) & BIT_MASK_RXGCK_OFDM_FIFOTHR)
> +#define BIT_SET_RXGCK_OFDM_FIFOTHR(x, v)                                       \
> +	(BIT_CLEAR_RXGCK_OFDM_FIFOTHR(x) | BIT_RXGCK_OFDM_FIFOTHR(v))

Lot of not used defines.

Regards
Stanislaw
