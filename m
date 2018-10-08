Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EBAC65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57F9520858
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:57:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57F9520858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbeJHWJb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 18:09:31 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56806 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbeJHWJb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 18:09:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9WyH-00005G-Rn; Mon, 08 Oct 2018 16:57:22 +0200
Message-ID: <1539010630.3687.86.camel@sipsolutions.net>
Subject: Re: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Mon, 08 Oct 2018 16:57:10 +0200
In-Reply-To: <1537957525-11467-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180926_122625_015616_502D99E2)
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-13-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122625_015616_502D99E2)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 15:55 +0530, Ajay Singh wrote:
> 
> +#define NO_ENCRYPT		0
> +#define ENCRYPT_ENABLED		BIT(0)
> +#define WEP			BIT(1)
> +#define WEP_EXTENDED		BIT(2)
> +#define WPA			BIT(3)
> +#define WPA2			BIT(4)
> +#define AES			BIT(5)
> +#define TKIP			BIT(6)
> +
> +#define FRAME_TYPE_ID			0
> +#define ACTION_CAT_ID			24
> +#define ACTION_SUBTYPE_ID		25
> +#define P2P_PUB_ACTION_SUBTYPE		30
> +
> +#define ACTION_FRAME			0xd0
> +#define GO_INTENT_ATTR_ID		0x04
> +#define CHANLIST_ATTR_ID		0x0b
> +#define OPERCHAN_ATTR_ID		0x11
> +#define PUB_ACTION_ATTR_ID		0x04
> +#define P2PELEM_ATTR_ID			0xdd
> +
> +#define GO_NEG_REQ			0x00
> +#define GO_NEG_RSP			0x01
> +#define GO_NEG_CONF			0x02
> +#define P2P_INV_REQ			0x03
> +#define P2P_INV_RSP			0x04
> +#define PUBLIC_ACT_VENDORSPEC		0x09
> +#define GAS_INITIAL_REQ			0x0a
> +#define GAS_INITIAL_RSP			0x0b
> +
> +#define INVALID_CHANNEL			0
> +
> +#define nl80211_SCAN_RESULT_EXPIRE	(3 * HZ)

???

I mentioned namespacing, but you can't steal a different one :-)

> +#define AGING_TIME	(9 * 1000)
> +#define DURING_IP_TIME_OUT	15000

Not clear what the units are - should be using HZ?

> +static void clear_shadow_scan(struct wilc_priv *priv)
> +{
> +	int i;
> +
> +	for (i = 0; i < priv->scanned_cnt; i++) {
> +		kfree(priv->scanned_shadow[i].ies);
> +		priv->scanned_shadow[i].ies = NULL;
> +
> +		kfree(priv->scanned_shadow[i].join_params);
> +		priv->scanned_shadow[i].join_params = NULL;
> +	}
> +	priv->scanned_cnt = 0;
> +}

This seems unlikely to be a good idea - why keep things around in the
driver?

> +static u32 get_rssi_avg(struct network_info *network_info)
> +{
> +	u8 i;
> +	int rssi_v = 0;
> +	u8 num_rssi = (network_info->rssi_history.full) ?
> +		       NUM_RSSI : (network_info->rssi_history.index);
> +
> +	for (i = 0; i < num_rssi; i++)
> +		rssi_v += network_info->rssi_history.samples[i];
> +
> +	rssi_v /= num_rssi;
> +	return rssi_v;
> +}

Why do you need a "real" average rather than EWMA which we have helpers
for?

> +static void refresh_scan(struct wilc_priv *priv, bool direct_scan)
> +{
> +	struct wiphy *wiphy = priv->dev->ieee80211_ptr->wiphy;
> +	int i;
> +
> +	for (i = 0; i < priv->scanned_cnt; i++) {
> +		struct network_info *network_info;
> +		s32 freq;
> +		struct ieee80211_channel *channel;
> +		int rssi;
> +		struct cfg80211_bss *bss;
> +
> +		network_info = &priv->scanned_shadow[i];
> +
> +		if (!memcmp("DIRECT-", network_info->ssid, 7) && !direct_scan)
> +			continue;

Err, no? Don't do that? What's the point?

I don't know what you need the shadow stuff for, but you should remove
it anyway, and use the cfg80211 functionality instead. If not
sufficient, propose patches to improve it?

> +			if (memcmp("DIRECT-", network_info->ssid, 7))
> +				return;

same here

> +static int cancel_remain_on_channel(struct wiphy *wiphy,
> +				    struct wireless_dev *wdev,
> +				    u64 cookie)
> +{
> +	struct wilc_priv *priv = wiphy_priv(wiphy);
> +	struct wilc_vif *vif = netdev_priv(priv->dev);
> +
> +	return wilc_listen_state_expired(vif,
> +			priv->remain_on_ch_params.listen_session_id);
> +}

You really should be using the cookie.

> +static int mgmt_tx(struct wiphy *wiphy,
> +		   struct wireless_dev *wdev,
> +		   struct cfg80211_mgmt_tx_params *params,
> +		   u64 *cookie)
> +{
> +	struct ieee80211_channel *chan = params->chan;
> +	unsigned int wait = params->wait;
> +	const u8 *buf = params->buf;
> +	size_t len = params->len;
> +	const struct ieee80211_mgmt *mgmt;
> +	struct p2p_mgmt_data *mgmt_tx;
> +	struct wilc_priv *priv = wiphy_priv(wiphy);
> +	struct host_if_drv *wfi_drv = priv->hif_drv;
> +	struct wilc_vif *vif = netdev_priv(wdev->netdev);
> +	u32 buf_len = len + sizeof(p2p_vendor_spec) + sizeof(priv->p2p.local_random);
> +	int ret = 0;
> +
> +	*cookie = (unsigned long)buf;

Don't use pointers for the cookie, it leaks valuable data about KASLR.

> +static int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
> +{
> +	return 0;
> +}

Uh, not a good idea. Well, a good idea would be to actually support it,
but not to pretend to.

> +static struct wireless_dev *wilc_wfi_cfg_alloc(void)
> +{
> +	struct wireless_dev *wdev;
> +
> +	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
> +	if (!wdev)
> +		goto out;
> +
> +	wdev->wiphy = wiphy_new(&wilc_cfg80211_ops, sizeof(struct wilc_priv));
> +	if (!wdev->wiphy)
> +		goto free_mem;
> +
> +	wilc_band_2ghz.ht_cap.ht_supported = 1;
> +	wilc_band_2ghz.ht_cap.cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
> +	wilc_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
> +	wilc_band_2ghz.ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K;
> +	wilc_band_2ghz.ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;

This kind of static variable use is weird ... you're just initializing
to constant values?

If that's really the case then just put that into the initializer, if
not you need to kmemdup() to have this per device.

johannes
