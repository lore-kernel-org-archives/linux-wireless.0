Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2KMTxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 14:53:40 -0500
Message-ID: <1352836449.9466.24.camel@jlt4.sipsolutions.net> (sfid-20121113_205344_245883_DDC7FE63)
Subject: Re: [PATCH v7 1/2] wireless: Driver for 60GHz card wil6210
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 13 Nov 2012 20:54:09 +0100
In-Reply-To: <1352809427-29682-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352809427-29682-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alright so I looked at this a little bit.


> +static int wil_cfg80211_set_txpower(struct wiphy *wiphy,

> +static int wil_cfg80211_get_txpower(struct wiphy *wiphy, int *dbm)

> +static int wil_cfg80211_mgmt_tx(struct wiphy *wiphy,
> +				struct wireless_dev *wdev,
> +				struct ieee80211_channel *chan, bool offchan,
> +				enum nl80211_channel_type channel_type,
> +				bool channel_type_valid, unsigned int wait,
> +				const u8 *buf, size_t len, bool no_cck,
> +				bool dont_wait_for_ack,	u64 *cookie)

> +static void wil_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
> +					     struct wireless_dev *wdev,
> +					     u16 frame_type, bool reg)

Don't implement things you don't support.

> +static int wil_cfg80211_start_ap(struct wiphy *wiphy,
> +				 struct net_device *ndev,
> +				 struct cfg80211_ap_settings *info)
> +{
> +	int rc = 0;
> +	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
> +	struct ieee80211_channel *channel = info->channel;
> +
> +	if (!channel) {
> +		wil_err(wil, "No channel???\n");
> +		return -EINVAL;
> +	}
> +
> +	rc = wmi_set_ssid(wil, info->ssid_len, info->ssid);
> +	if (rc)
> +		return rc;
> +
> +	rc = wmi_set_channel(wil, channel->hw_value);
> +	if (rc)
> +		return rc;
> +
> +	/* TODO: complete implementation */
> +
> +	return 0;

Again, this doesn't seem right? How would it work?

> +static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
> +				      struct net_device *ndev,
> +				      struct cfg80211_beacon_data *beacon)
> +{
> +	return 0;

Really?

> +static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
> +				struct net_device *ndev)


> +static int wil_cfg80211_del_station(struct wiphy *wiphy,
> +				    struct net_device *ndev,
> +				    u8 *mac)

> +static int wil_cfg80211_change_station(struct wiphy *wiphy,
> +				       struct net_device *ndev,
> +				       u8 *mac,
> +				       struct station_parameters *params)

So obviously don't implement AP mode yet...

> +static int wil_cfg80211_probe_client(struct wiphy *wiphy,
> +				     struct net_device *dev,
> +				     const u8 *peer, u64 *cookie)

> +static int wil_cfg80211_set_pmksa(struct wiphy *wiphy,
> +				  struct net_device *netdev,
> +				  struct cfg80211_pmksa *pmksa)

> +static int wil_cfg80211_del_pmksa(struct wiphy *wiphy,
> +				  struct net_device *netdev,
> +				  struct cfg80211_pmksa *pmksa)

> +static int wil_cfg80211_flush_pmksa(struct wiphy *wiphy,
> +				    struct net_device *netdev)

Again, don't implement things you don't support.

And never ever just "return 0", pretending that you actually did
something.

> +static int wil_cfg80211_add_key(struct wiphy *wiphy,
> +				struct net_device *ndev,
> +				u8 key_index, bool pairwise,
> +				const u8 *mac_addr,
> +				struct key_params *params)
> +{
> +	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
> +
> +	/* group key is not used */
> +	if (!pairwise)
> +		return 0;

Return an error then?

> +	return wmi_add_cipher_key(wil, key_index, mac_addr,
> +				  params->key_len, params->key);
> +}
> +
> +static int wil_cfg80211_del_key(struct wiphy *wiphy,
> +				struct net_device *ndev,
> +				u8 key_index, bool pairwise,
> +				const u8 *mac_addr)
> +{
> +	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
> +
> +	/* group key is not used */
> +	if (!pairwise)
> +		return 0;


Ditto

> +static int wil_cfg80211_get_key(struct wiphy *wiphy,
> +				struct net_device *ndev,
> +				u8 key_index, bool pairwise,
> +				const u8 *mac_addr, void *cookie,
> +				void (*callback) (void *cookie,
> +						  struct key_params *))
> +{
> +	return -ENOENT;

No need to implement this then?

> +static int wil_cfg80211_set_default_key(struct wiphy *wiphy,
> +					struct net_device *ndev,
> +					u8 key_index, bool unicast,
> +					bool multicast)
> +{
> +	return 0;

Ok this is possibly the only case where I could think you might need to
implement it and do nothing, although it does seem strange too.


> +	wil->fw_code_blob.data = (void * __force)wil->csr + 0x40000;
> +	wil->fw_code_blob.size = 0x40000;
> +	wil_debugfs_create_ioblob("blob_fw_code", S_IRUGO, dbg,
> +				  &wil->fw_code_blob);
> +
> +	wil->fw_data_blob.data = (void * __force)wil->csr + 0x80000;
> +	wil->fw_data_blob.size = 0x8000;
> +	wil_debugfs_create_ioblob("blob_fw_data", S_IRUGO, dbg,
> +				  &wil->fw_data_blob);

This seems a bit strange, why export the blobs that came from the
filesystem to start with (request_firmware)?


> +static int __wil_up(struct wil6210_priv *wil)
> +{

> +	/* Apply profile in the following order: */
> +	/* SSID and channel for the AP */
> +	switch (wdev->iftype) {
> +	case NL80211_IFTYPE_AP:
> +	case NL80211_IFTYPE_P2P_GO:
> +		if (wil->ssid_len == 0) {
> +			wil_err(wil, "SSID not set\n");
> +			return -EINVAL;
> +		}
> +		wmi_set_ssid(wil, wil->ssid_len, wil->ssid);
> +		if (wil->channel)
> +			wmi_set_channel(wil, wil->channel->hw_value);
> +		break;

I don't think so? The interface shouldn't come up with any
configuration, that's what start_ap() is used for.

It also seems too early:

> +	/* MAC address - pre-requisite for other commands */
> +	wmi_set_mac_address(wil, ndev->dev_addr);
> +
> +	/* Set up beaconing if required. */
> +	rc = wmi_set_bcon(wil, bi, wmi_nettype);
> +	if (rc)
> +		return rc;

That also should be in start_ap(). Maybe that's the TODO there.

> +static int use_msi = 1;
> +module_param(use_msi, int, S_IRUGO);
> +MODULE_PARM_DESC(use_msi,
> +		 " Use MSI interrupt: "
> +		 "0 - don't, 1 - (default) - single, or 3");

"or 3"?

> +	rc = wil6210_sysfs_init(wil);
> +	if (rc)
> +		goto if_remove;
> +	/* rollback to sysfs_fini */

Do you really need sysfs in the driver?

> @@ -0,0 +1,134 @@

> +/* attribute: SSID */
> +/* attribute: bf */
> +/* attribute: secure_pcp */

None of this looks like it belongs into sysfs, I think you should remove
sysfs from this entirely.

> +	if (rtap_include_phy_info) {
> +		rtap_vendor->rtap.rthdr.it_present |= cpu_to_le32(1 <<
> +				IEEE80211_RADIOTAP_VENDOR_NAMESPACE);
> +		/* OUI for Wilocity 04:ce:14 */
> +		rtap_vendor->vendor_oui[0] = 0x04;
> +		rtap_vendor->vendor_oui[1] = 0xce;
> +		rtap_vendor->vendor_oui[2] = 0x14;
> +		rtap_vendor->vendor_ns = 1;

woot, cool! :-)
Finally somebody using vendor namespaces


> +int wmi_tx_eapol(struct wil6210_priv *wil, struct sk_buff *skb)

Why is EAPOL special?

johannes

