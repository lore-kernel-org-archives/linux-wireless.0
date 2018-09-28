Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C15C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 03:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57FB9216C4
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 03:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57FB9216C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbeI1Jmk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 05:42:40 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:52506 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbeI1Jmk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 05:42:40 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w8S3KloH010903, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w8S3KloH010903
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Fri, 28 Sep 2018 11:20:47 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Fri, 28 Sep
 2018 11:20:46 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: RE: [PATCH 01/12] rtwlan: main files
Thread-Topic: [PATCH 01/12] rtwlan: main files
Thread-Index: AQHUVmkc7fXueOv/LUWUMOOpXqM0maUFAMQw
Date:   Fri, 28 Sep 2018 03:20:45 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
In-Reply-To: <20180927135040.GA4712@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw,

Thanks a lot to point them some, some of them I have not even noticed!

> -----Original Message-----
> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> Sent: Thursday, September 27, 2018 9:51 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net;
> linux-wireless@vger.kernel.org; Pkshih; Andy Huang
> Subject: Re: [PATCH 01/12] rtwlan: main files
> 
> Hi,
> 
> Below is some more detailed review of first patch (with mostly
> nitpicks).
> 
> On Fri, Sep 21, 2018 at 02:03:56PM +0800, yhchuang@realtek.com wrote:
> > +static void rtw_ops_tx(struct ieee80211_hw *hw,
> > +		       struct ieee80211_tx_control *control,
> > +		       struct sk_buff *skb)
> > +{
> > +	struct rtw_dev *rtwdev = hw->priv;
> > +	struct rtw_tx_pkt_info pkt_info;
> > +
> > +	if (!rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
> > +		goto out;
> > +
> > +	memset(&pkt_info, 0, sizeof(pkt_info));
> > +	rtw_tx_pkt_info_update(rtwdev, &pkt_info, control, skb);
> > +	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
> > +		goto out;
> > +
> > +	return;
> > +
> > +out:
> > +	dev_kfree_skb_any(skb);
> This can be simplified by just do kfree after if ().


OK, will replace them with ieee80211_free_txskb


> > +static int rtw_ops_add_interface(struct ieee80211_hw *hw,
> > +				 struct ieee80211_vif *vif)
> > +{
> > +	struct rtw_dev *rtwdev = hw->priv;
> > +	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
> > +	enum rtw_net_type net_type;
> > +	u32 config = 0;
> > +	u8 port = 0;
> <snip>
> > +	list_add(&rtwvif->list, &rtwdev->vif_list);
> How rtwdev->vif_list is protected agains concurent access ?
> 
> > +	INIT_LIST_HEAD(&rtwvif->sta_list);
> > +
> > +	rtwvif->conf = &rtw_vif_port[port];
> port is always 0, this either should be fixes or max interfaces for
> STA should be set to 1 (temporally).
> 
> > +static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
> > +				     struct ieee80211_vif *vif,
> > +				     struct ieee80211_bss_conf *conf,
> > +				     u32 changed)
> > +{
> > +	struct rtw_dev *rtwdev = hw->priv;
> > +	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
> > +	u32 config = 0;
> > +
> > +	if (changed & BSS_CHANGED_ASSOC) {
> > +		struct rtw_sta_info *ap;
> > +		struct rtw_chip_info *chip = rtwdev->chip;
> > +		enum rtw_net_type net_type;
> > +
> > +		ap = list_first_entry(&rtwvif->sta_list,
> > +				      struct rtw_sta_info, list);
> How rtlwvif->sta_list is protected against concurrent access ?


Have not noticed so far, cause not we can only support on vif.

And only STA mode is tested, should first modify the iface_conbination.
Then modify them back again if we submit patches support concurrents

I think that vif_list & sta_list could be protected by a single mutex that
protects concurrent access against mac80211 callbacks, and further add
some rcu locks to protect sta_info. You have some suggestions?


> 
> > +static u8 rtw_acquire_macid(struct rtw_dev *rtwdev)
> > +{
> > +	u8 i;
> > +
> > +	for (i = 0; i < RTW_MAX_MAC_ID_NUM; i++) {
> > +		if (!rtwdev->macid_used[i]) {
> > +			rtwdev->macid_used[i] = true;
> > +			return i;
> > +		}
> > +	}
> > +
> > +	return i;
> > +}
> > +
> > +static void rtw_release_macid(struct rtw_dev *rtwdev, u8 mac_id)
> > +{
> > +	rtwdev->macid_used[mac_id] = false;
> > +}
> > +
> > +static int rtw_ops_sta_add(struct ieee80211_hw *hw,
> > +			   struct ieee80211_vif *vif,
> > +			   struct ieee80211_sta *sta)
> > +{
> > +	struct rtw_dev *rtwdev = hw->priv;
> > +	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
> > +	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
> > +
> > +	si->mac_id = rtw_acquire_macid(rtwdev);
> <snip>
> > +
> > +static int rtw_ops_sta_remove(struct ieee80211_hw *hw,
> > +			      struct ieee80211_vif *vif,
> > +			      struct ieee80211_sta *sta)
> > +{
> > +	struct rtw_dev *rtwdev = hw->priv;
> > +	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
> > +
> > +	rtw_release_macid(rtwdev, si->mac_id);
> I'm not sure if mac80211 can not add one STA and remove another one
> STA at the same time. This need to be verified.


I think mac80211 will do it "if the vif is different", but under the same vif,
mac80211 will protect it with "sdata->wdev.mtx". Not sure if I am right.


> 
> > +static struct ieee80211_iface_limit rtw_5port_limits[] = {
> > +	{ .max = 1, .types = BIT(NL80211_IFTYPE_AP) |
> > +			     BIT(NL80211_IFTYPE_ADHOC) |
> > +			     BIT(NL80211_IFTYPE_MESH_POINT), },
> > +	{ .max = 5, .types = BIT(NL80211_IFTYPE_STATION), },
> <snip>
> > +static struct ieee80211_iface_combination rtw_5port_if_combs[] = {
> > +	{
> > +		.limits = rtw_5port_limits,
> > +		.n_limits = ARRAY_SIZE(rtw_5port_limits),
> > +		.max_interfaces = 5,
> > +		.num_different_channels = 1,
> > +	},
> Here: change to max interfaces to 1 or fix port in add/remove interface.


OK


> > +static void rtw_watch_dog_work(struct work_struct *work)
> > +{
> > +	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
> > +					      watch_dog_work.work);
> > +	struct rtw_vif *rtwvif;
> > +
> > +	if (!rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
> > +		return;
> > +
> > +	ieee80211_queue_delayed_work(rtwdev->hw,
> &rtwdev->watch_dog_work,
> > +				     RTW_WATCH_DOG_DELAY_TIME);
> > +
> > +	/* check if we can enter lps */
> > +	rtw_lps_enter_check(rtwdev);
> > +
> > +	/* reset tx/rx statictics */
> > +	rtwdev->stats.tx_unicast = 0;
> > +	rtwdev->stats.rx_unicast = 0;
> > +	rtwdev->stats.tx_cnt = 0;
> > +	rtwdev->stats.rx_cnt = 0;
> > +	list_for_each_entry(rtwvif, &rtwdev->vif_list, list) {
> > +		rtwvif->stats.tx_unicast = 0;
> > +		rtwvif->stats.rx_unicast = 0;
> > +		rtwvif->stats.tx_cnt = 0;
> > +		rtwvif->stats.rx_cnt = 0;
> If we just nulify statistics here, what is the point to provide them ?
> I can not see code where we read those stats. Perhaps code
> that use them will be added, so this possibly is fine.


Yeah the will be used.


> > +	hal->current_channel = center_chan;
> Not used anywhere.


Will be used in set channel, but missed that in this patch


> > +static int rtw_load_firmware(struct rtw_dev *rtwdev, const char
> *fw_name)
> > +{
> > +	struct rtw_fw_state *fw = &rtwdev->fw;
> > +	const struct firmware *firmware;
> > +	int ret;
> > +
> > +	ret = request_firmware(&firmware, fw_name, rtwdev->dev);
> > +	if (ret) {
> > +		rtw_err(rtwdev, "failed to request firmware\n");
> > +		return ret;
> > +	}
> > +
> > +	fw->firmware = firmware;
> > +	fw->data = firmware->data;
> > +	fw->size = firmware->size;
> Seems not needed, we can use fw->firmware->{data,size}
> since fw->firwware is not released till chip de-init.


OK


> > +#define BIT_LEN_MASK_32(__bitlen) (0xFFFFFFFF >> (32 - (__bitlen)))
> > +#define BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)
> \
> > +	(BIT_LEN_MASK_32(__bitlen) << (__bitoffset))
> > +#define LE_P4BYTE_TO_HOST_4BYTE(__start) (le32_to_cpu(*((__le32
> *)(__start))))
> > +#define LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen)
> \
> > +	(LE_P4BYTE_TO_HOST_4BYTE(__start) &
> \
> > +	 (~BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)))
> > +#define LE_BITS_TO_4BYTE(__start, __bitoffset, __bitlen)
> \
> > +	((LE_P4BYTE_TO_HOST_4BYTE(__start) >> (__bitoffset)) &
> \
> > +	 BIT_LEN_MASK_32(__bitlen))
> > +#define SET_BITS_TO_LE_4BYTE(__start, __bitoffset, __bitlen, __value)
> \
> > +	do
> {
>     \
> > +		*((__le32 *)(__start)) = \
> > +		cpu_to_le32( \
> > +		LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen) |     \
> > +		((((u32)__value) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset))\
> > +		);
> \
> > +	} while (0)
> I think this should be somehow cleaned up or replaced by something sane.


Larry replied you, and that is exactly what I wanted to ask.


> > +struct rtw_sta_info {
> > +	struct list_head list;
> > +
> > +	struct ieee80211_sta *sta;
> > +	struct ieee80211_vif *vif;
> > +
> > +	struct ewma_rssi avg_rssi;
> > +	u8 rssi_level;
> > +
> > +	u8 mac_id;
> > +	u8 rate_id;
> > +	enum rtw_bandwidth bw_mode;
> 
> Can we talk with different STA using different bandwidh ? I think this
> is configures channel property and bw_mode is the same for all
> connected stations.


Yes, we can. If we have TDLS peer in STA mode or in AP mode, we could have
different bw_mode, by the sta_info mac80211 passed to us, and that sta_info is
checked by mac80211 based on the capabilities (IE) of the peer.


> > +struct rtw_table {
> > +	const void *data;
> > +	const u32 size;
> > +	void (*parse)(struct rtw_dev *rtwdev, const struct rtw_table *tbl);
> > +	void (*do_cfg)(struct rtw_dev *rtwdev, const struct rtw_table *tbl,
> > +		       u32 addr, u32 data);
> > +	enum rtw_rf_path rf_path;
> > +};
> > +
> > +static inline void rtw_load_table(struct rtw_dev *rtwdev,
> > +				  const struct rtw_table *tbl)
> > +{
> > +	(*tbl->parse)(rtwdev, tbl);
> > +}
> 
> This interface of loading/processing tables of data looks very strange.
> I don't think is incorrect, but seems to be somewhat not necessary
> complicated. I'll try provide more detailed comment about that when
> review other files.


OK, but I think this is needed, our tables have different forms ....


> > +static inline u8 *get_hdr_bssid(struct ieee80211_hdr *hdr)
> > +{
> > +	__le16 fc = hdr->frame_control;
> > +	u8 *bssid;
> > +
> > +	if (ieee80211_has_tods(fc))
> > +		bssid = hdr->addr1;
> > +	else if (ieee80211_has_fromds(fc))
> > +		bssid = hdr->addr2;
> > +	else
> > +		bssid = hdr->addr3;
> > +
> > +	return bssid;
> 
> This seems to not to be that simple and depend on frame type and
> interface type. See ieee80211_get_bssid().


OK, thanks.



> > +#define BIT_SET_RXGCK_VHT_FIFOTHR(x, v)
> \
> > +	(BIT_CLEAR_RXGCK_VHT_FIFOTHR(x) | BIT_RXGCK_VHT_FIFOTHR(v))
> > +
> > +#define BIT_SHIFT_RXGCK_HT_FIFOTHR 24
> > +#define BIT_MASK_RXGCK_HT_FIFOTHR 0x3
> > +#define BIT_RXGCK_HT_FIFOTHR(x)
> \
> > +	(((x) & BIT_MASK_RXGCK_HT_FIFOTHR) <<
> BIT_SHIFT_RXGCK_HT_FIFOTHR)
> > +#define BITS_RXGCK_HT_FIFOTHR
> \
> > +	(BIT_MASK_RXGCK_HT_FIFOTHR << BIT_SHIFT_RXGCK_HT_FIFOTHR)
> > +#define BIT_CLEAR_RXGCK_HT_FIFOTHR(x) ((x) &
> (~BITS_RXGCK_HT_FIFOTHR))
> > +#define BIT_GET_RXGCK_HT_FIFOTHR(x)
> \
> > +	(((x) >> BIT_SHIFT_RXGCK_HT_FIFOTHR) &
> BIT_MASK_RXGCK_HT_FIFOTHR)
> > +#define BIT_SET_RXGCK_HT_FIFOTHR(x, v)
> \
> > +	(BIT_CLEAR_RXGCK_HT_FIFOTHR(x) | BIT_RXGCK_HT_FIFOTHR(v))
> > +
> > +#define BIT_SHIFT_RXGCK_OFDM_FIFOTHR 22
> > +#define BIT_MASK_RXGCK_OFDM_FIFOTHR 0x3
> > +#define BIT_RXGCK_OFDM_FIFOTHR(x)
> \
> > +	(((x) & BIT_MASK_RXGCK_OFDM_FIFOTHR) <<
> BIT_SHIFT_RXGCK_OFDM_FIFOTHR)
> > +#define BITS_RXGCK_OFDM_FIFOTHR
> \
> > +	(BIT_MASK_RXGCK_OFDM_FIFOTHR <<
> BIT_SHIFT_RXGCK_OFDM_FIFOTHR)
> > +#define BIT_CLEAR_RXGCK_OFDM_FIFOTHR(x) ((x) &
> (~BITS_RXGCK_OFDM_FIFOTHR))
> > +#define BIT_GET_RXGCK_OFDM_FIFOTHR(x)
> \
> > +	(((x) >> BIT_SHIFT_RXGCK_OFDM_FIFOTHR) &
> BIT_MASK_RXGCK_OFDM_FIFOTHR)
> > +#define BIT_SET_RXGCK_OFDM_FIFOTHR(x, v)
> \
> > +	(BIT_CLEAR_RXGCK_OFDM_FIFOTHR(x) | BIT_RXGCK_OFDM_FIFOTHR(v))
> 
> Lot of not used defines.


Will remove them.


> Regards
> Stanislaw
> 
> ------Please consider the environment before printing this e-mail.


Anyway, appreciate your review and suggestion

Yan-Hsuan Chuang
