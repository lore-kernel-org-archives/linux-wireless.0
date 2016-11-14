Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57318 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752739AbcKNJwF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 04:52:05 -0500
Message-ID: <1479117120.9766.8.camel@sipsolutions.net> (sfid-20161114_105337_718940_200FBE98)
Subject: Re: [PATCH V3] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org
Cc: btherthala@quantenna.com, hwang@quantenna.com,
        smaksimenko@quantenna.com, dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Mon, 14 Nov 2016 10:52:00 +0100
In-Reply-To: <1478700000-11624-2-git-send-email-igor.mitsyanko.os@quantenna.com>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
         <1478700000-11624-2-git-send-email-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
> @@ -0,0 +1,23 @@
> +config QTNFMAC
> +	tristate "Quantenna WiFi FullMAC WLAN driver"
> +	default n

No need to state that default explicitly, but it also doesn't really
matter.

> +	  it as a module, it will be called qtnfmac_pearl_pcie.ko.


Where did the "pearl" come from? You didn't mention that in the commit
log.

Also, are you planning to add any other things to this soon? It seems
to me that perhaps the PCIe option should be the only one that's user-
visible, selecting the other one internally?

> +	struct qtnf_bus_ops *bus_ops;

You should make that const and actually make all instances const, it's
better for security :)

> +/* Supported crypto cipher suits to be advertised to cfg80211 */
> +static const u32 qtnf_cipher_suites[] = {
> +	WLAN_CIPHER_SUITE_TKIP,
> +	WLAN_CIPHER_SUITE_CCMP,
> +	WLAN_CIPHER_SUITE_AES_CMAC,
> +};

I'm surprised - no WEP? No CMAC and GCMP/GMAC?


> +static int
> +qtnf_change_virtual_intf(struct wiphy *wiphy,
> +			 struct net_device *dev,
> +			 enum nl80211_iftype type, u32 *flags,
> +			 struct vif_params *params)
> +{
> +	struct qtnf_vif *vif;
> +	u8 *mac_addr;
> +
> +	vif = qtnf_netdev_get_priv(dev);
> +
> +	if (params)
> +		mac_addr = params->macaddr;
> +	else
> +		mac_addr = NULL;
> +
> +	if (qtnf_cmd_send_change_intf_type(vif, type, mac_addr)) {
> +		pr_err("failed to change interface type\n");
> +		return -EFAULT;

Maybe -EIO would be better.

> +struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
> +					   const char *name,
> +					   unsigned char
> name_assign_type,
> +					   enum nl80211_iftype type,
> +					   u32 *flags,
> +					   struct vif_params
> *params)
> +{
> +	struct qtnf_wmac *mac;
> +	struct qtnf_vif *vif;
> +	u8 *mac_addr = NULL;
> +
> +	mac = wiphy_priv(wiphy);
> +
> +	if (!mac)
> +		return ERR_PTR(-EFAULT);
> +
> +	switch (type) {
> +	case NL80211_IFTYPE_STATION:
> +	case NL80211_IFTYPE_AP:
> +		vif = qtnf_get_free_vif(mac);
> +		if (!vif) {
> +			pr_err("could not get free private
> structure\n");
> +			return ERR_PTR(-EFAULT);
> +		}

This is probably fairly natural to do, and it's not the first driver to
do this (brcmfmac also does), but some users may assume that they can
add interfaces as much as they want, until they bring them up (netdev
open).

It's probably worth having a discussion about this behaviour difference
- not necessarily in the context of this driver submission though.

> +	if (qtnf_cmd_send_add_intf(vif, type, mac_addr)) {
> +		vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
> +		pr_err("failed to send add_intf command\n");
> +		return ERR_PTR(-EFAULT);

I can't really tell, does this leak "vif"?

OK I need to find another way to review this patch now, it's too big
for my email client to work responsively...

johannes
