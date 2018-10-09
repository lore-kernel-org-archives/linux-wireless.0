Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848EDC64EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52AF92089D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:26:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52AF92089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbeJIPlm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 11:41:42 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48612 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbeJIPlm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 11:41:42 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9nKx-0007kT-M1; Tue, 09 Oct 2018 10:25:51 +0200
Message-ID: <1539073540.3687.99.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation
 device
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Cody Schuffelen <schuffelen@google.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Date:   Tue, 09 Oct 2018 10:25:40 +0200
In-Reply-To: <20181004195906.201895-1-schuffelen@google.com> (sfid-20181004_220026_241767_96C715D6)
References: <20181004195906.201895-1-schuffelen@google.com>
         (sfid-20181004_220026_241767_96C715D6)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-10-04 at 12:59 -0700, Cody Schuffelen wrote:
> 
> I wasn't completely clear on whether I should change the title (net-next
> to mac80211-next) so I left it as is for v3 to try to keep the patchwork
> series together.

You can/should change it - patchwork doesn't really track this at all
anyway.

> The driver is also now a bool instead of a tristate to use __ro_after_init.

Hmm? Why would that be required? __ro_after_init works fine in modules?

> +static struct ieee80211_rate bitrates_2ghz[] = {
> +	{ .bitrate = 10 },
> +	{ .bitrate = 20 },
> +	{ .bitrate = 55 },
> +	{ .bitrate = 60 },
> +	{ .bitrate = 110 },
> +	{ .bitrate = 120 },
> +	{ .bitrate = 240 },
> +};

Come to think of it, the typical order here would be 1,2,5.5,11,6,12,24
(6<->11), due to the ordering in the probe request frame I guess.

I'm not sure it matters though.

> +static struct ieee80211_supported_band band_2ghz = {

These can be const, I think?

> +/** Assigned at module init. Guaranteed locally-administered and unicast. */

I think you should avoid ** - it's the kernel-doc marker.

> +static u8 fake_router_bssid[ETH_ALEN] __ro_after_init = {};

If this is the reason for not allowing it to be a module then you don't
need  to disallow the module case.

> +static int virt_wifi_scan(struct wiphy *wiphy,
> +			  struct cfg80211_scan_request *request)
> +{
> +	struct virt_wifi_priv *priv = wiphy_priv(wiphy);
> +
> +	wiphy_debug(wiphy, "scan\n");
> +
> +	if (priv->scan_request || priv->being_deleted)
> +		return -EBUSY;
> +
> +	priv->scan_request = request;
> +	schedule_delayed_work(&priv->scan_result, HZ * 2);
> +
> +	return 0;
> +}
> +
> +static void virt_wifi_scan_result(struct work_struct *work)
> +{
> +	const union {
> +		struct {
> +			u8 tag;
> +			u8 len;
> +			u8 ssid[8];
> +		} __packed parts;
> +		u8 data[10];
> +	} ssid = { .parts = {
> +		.tag = WLAN_EID_SSID, .len = 8, .ssid = "VirtWifi" }
> +	};

Not sure I see much value in the union, but I don't think it matters
much.
(You could just cast below - (void *)&ssid, sizeof(ssid))

> +	rtnl_lock();
> +	if (priv->scan_request) {
> +		cfg80211_scan_done(priv->scan_request, &scan_info);
> +		priv->scan_request = NULL;
> +	}
> +	rtnl_unlock();

Do you need the rtnl for the priv->scan_request locking?

> +static int virt_wifi_get_station(struct wiphy *wiphy,
> +				 struct net_device *dev,
> +				 const u8 *mac,
> +				 struct station_info *sinfo)
> +{
> [...]
> +	sinfo->tx_packets = 1;
> +	sinfo->tx_failed = 0;
> +	sinfo->signal = -60;

I think Sergey pointed out the -60 elsewhere - need to check here too,
and maybe set in some place that you actually report dBm/mBm.

Also, I think you should only report something here if actually
connected - Sergey pointed this out on the dump station but it applies
here too.

> +static void free_netdev_and_wiphy(struct net_device *dev)
> +{
> +	struct virt_wifi_netdev_priv *priv = netdev_priv(dev);
> +	struct virt_wifi_priv *w_priv;
> +
> +	flush_work(&priv->register_wiphy_work);
> +	if (dev->ieee80211_ptr && !IS_ERR(dev->ieee80211_ptr)) {
> +		w_priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
> +		w_priv->being_deleted = true;
> +		flush_delayed_work(&w_priv->scan_result);
> +		flush_delayed_work(&w_priv->connect);
> +		flush_delayed_work(&w_priv->disconnect);

this is called from

> +static void virt_wifi_setup(struct net_device *dev)
> +{
> +	ether_setup(dev);
> +	dev->netdev_ops = &virt_wifi_ops;
> +	dev->priv_destructor = free_netdev_and_wiphy;
> +}

the destructor, but I believe the destructor is invoked with the RTNL
held. As such, this will deadlock (and lockdep should complain - at
least in current kernel versions) when it's actually running when you
flush it, since you flush something that's (potentially) waiting to
acquire the RTNL, but you are holding the RTNL here and so neither side
can make progress.

> +	/* The newlink callback is invoked while holding the rtnl lock, but
> +	 * register_wiphy wants to claim the rtnl lock itself.
> +	 */
> +	schedule_work(&priv->register_wiphy_work);

Maybe we should fix/change that?

johannes
