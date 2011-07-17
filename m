Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54428 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab1GQLMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 07:12:53 -0400
Subject: Re: [PATCH v2 03/23] ath6kl: add cfg80211.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, joe@perches.com,
	devel@linuxdriverproject.org, gregkh@suse.de, error27@gmail.com
In-Reply-To: <20110717102106.18367.62814.stgit@localhost6.localdomain6> (sfid-20110717_122119_953813_F3D94E8A)
References: <20110717101844.18367.44984.stgit@localhost6.localdomain6>
	 <20110717102106.18367.62814.stgit@localhost6.localdomain6>
	 (sfid-20110717_122119_953813_F3D94E8A)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jul 2011 13:12:41 +0200
Message-ID: <1310901161.4542.8.camel@jlt3.sipsolutions.net> (sfid-20110717_131302_698127_D74C5A8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-07-17 at 13:21 +0300, Kalle Valo wrote:

> +static int ath6kl_set_auth_type(struct ath6kl *ar,
> +				enum nl80211_auth_type auth_type)
> +{

> +	default:
> +		ar->dot11_auth_mode = OPEN_AUTH;

are you sure you want that?

> +	if (!sme->ssid_len || sme->ssid_len > IEEE80211_MAX_SSID_LEN) {
> +		ath6kl_err("%s: ssid invalid\n", __func__);
> +		return -EINVAL;
> +	}

I don't mind the code here -- but it's not going to happen anyway :)

> +	if (down_interruptible(&ar->sem)) {
> +		ath6kl_err("%s: busy, couldn't get access\n", __func__);
> +		return -ERESTARTSYS;
> +	}

Hmm, will that really work? I don't think netlink has any -ERESTARTSYS
handling so this would go to userspace which isn't supposed to happen,
better make it -EBUSY. Besides, no point in restarting something that
continually fails right?

> +	if (down_interruptible(&ar->sem)) {
> +		ath6kl_err("%s: busy, couldn't get access\n", __func__);
> +		return -ERESTARTSYS;
> +	}

same here (disconnect) and maybe other places

> +	/*
> +	 * TODO: Update target to include 802.11 mac header while sending
> +	 * bss info. Target removes 802.11 mac header while sending the bss
> +	 * info to host, cfg80211 needs it, for time being just filling the
> +	 * da, sa and bssid fields alone.
> +	 */
> +	mgmt = (struct ieee80211_mgmt *)ieeemgmtbuf;
> +	memset(mgmt->da, 0xff, ETH_ALEN);	/*broadcast addr */
> +	memcpy(mgmt->sa, ni->ni_macaddr, ETH_ALEN);
> +	memcpy(mgmt->bssid, ni->ni_macaddr, ETH_ALEN);
> +	memcpy(ieeemgmtbuf + offsetof(struct ieee80211_mgmt, u),
> +	       ni->ni_buf, ni->ni_framelen);
> +
> +	freq = cie->ie_chan;
> +	channel = ieee80211_get_channel(wiphy, freq);
> +	signal = ni->ni_snr * 100;
> +
> +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
> +		   "%s: bssid %pM ch %d freq %d size %d\n", __func__,
> +		   mgmt->bssid, channel->hw_value, freq, size);
> +	cfg80211_inform_bss_frame(wiphy, channel, mgmt,
> +				  size, signal, GFP_KERNEL);

What's with the comment and all the frame creation code; what's wrong
with cfg80211_inform_bss() instead of _frame()?

> +static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
> +				   u8 key_index, bool pairwise,
> +				   const u8 *mac_addr,
> +				   struct key_params *params)
> +{

...

> +	if (!mac_addr || is_broadcast_ether_addr(mac_addr))
> +		key_usage = GROUP_USAGE;
> +	else
> +		key_usage = PAIRWISE_USAGE;

Isn't that covered by the pairwise argument?

> +static int ath6kl_cfg80211_set_default_mgmt_key(struct wiphy *wiphy,
> +						struct net_device *ndev,
> +						u8 key_index)
> +{
> +	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
> +
> +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: index %d\n", __func__, key_index);
> +
> +	if (!test_bit(WMI_READY, &ar->flag)) {
> +		ath6kl_err("%s: wmi is not ready\n", __func__);
> +		return -EIO;
> +	}
> +
> +	if (ar->wlan_state == WLAN_DISABLED) {
> +		ath6kl_err("%s: wlan disabled\n", __func__);
> +		return -EIO;
> +	}
> +
> +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: not supported\n", __func__);
> +	return -ENOTSUPP;
> +}

This is completely pointless -- remove the entire function.

> +/*
> + * The type nl80211_tx_power_setting replaces the following
> + * data type from 2.6.36 onwards
> +*/

??

> +static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
> +					struct net_device *ndev,
> +					enum nl80211_iftype type, u32 *flags,
> +					struct vif_params *params)
> +{
> +	struct ath6kl *ar = ath6kl_priv(ndev);
> +	struct wireless_dev *wdev = ar->wdev;
> +
> +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type %u\n", __func__, type);
> +
> +	if (!test_bit(WMI_READY, &ar->flag)) {
> +		ath6kl_err("%s: wmi is not ready\n", __func__);
> +		return -EIO;
> +	}
> +
> +	if (ar->wlan_state == WLAN_DISABLED) {
> +		ath6kl_err("%s: wlan disabled\n", __func__);
> +		return -EIO;
> +	}
> +
> +	switch (type) {
> +	case NL80211_IFTYPE_STATION:
> +		ar->next_mode = INFRA_NETWORK;
> +		break;
> +	case NL80211_IFTYPE_ADHOC:
> +		ar->next_mode = ADHOC_NETWORK;
> +		break;
> +	default:
> +		ath6kl_err("%s: invalid type %u\n", __func__, type);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	wdev->iftype = type;

We kinda expect it to have taken effect by the time you return from this
function -- it doesn't quite look like it will?

> +	if (!ibss_param->ssid_len
> +	    || IEEE80211_MAX_SSID_LEN < ibss_param->ssid_len) {
> +		ath6kl_err("%s: ssid invalid\n", __func__);
> +		return -EINVAL;
> +	}

Like above -- won't happen. You can trust cfg80211 ;-)

> +	ar->ssid_len = ibss_param->ssid_len;
> +	memcpy(ar->ssid, ibss_param->ssid, ar->ssid_len);
> +
> +	if (ibss_param->channel)
> +		ar->ch_hint = ibss_param->channel->center_freq;
> +
> +	if (ibss_param->channel_fixed) {
> +		/*
> +		 * TODO: channel_fixed: The channel should be fixed, do not
> +		 * search for IBSSs to join on other channels. Target
> +		 * firmware does not support this feature, needs to be
> +		 * updated.
> +		 */
> +	}

return an error?

johannes

