Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0049.outbound.protection.outlook.com ([104.47.34.49]:4560
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751263AbcKPQvG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 11:51:06 -0500
Subject: Re: [PATCH V3] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: <linux-wireless@vger.kernel.org>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478700000-11624-2-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1479117120.9766.8.camel@sipsolutions.net>
 <62102ba6-cae0-f00d-f989-3f2e9ea43d9b@quantenna.com>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <c6655668-f433-c784-0098-a94a61874e43@quantenna.com> (sfid-20161116_175111_132947_47E19850)
Date: Wed, 16 Nov 2016 19:50:56 +0300
MIME-Version: 1.0
In-Reply-To: <62102ba6-cae0-f00d-f989-3f2e9ea43d9b@quantenna.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending because previous attempt was rejected by vger.kernel.org

On 11/16/2016 06:04 PM, IgorMitsyanko wrote:
> On 11/14/2016 12:52 PM, Johannes Berg wrote:
>>> +++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
>>> @@ -0,0 +1,23 @@
>>> +config QTNFMAC
>>> +	tristate "Quantenna WiFi FullMAC WLAN driver"
>>> +	default n
>> No need to state that default explicitly, but it also doesn't really
>> matter.
>>
>>> +	  it as a module, it will be called qtnfmac_pearl_pcie.ko.
>> Where did the "pearl" come from? You didn't mention that in the commit
>> log.
>
> Module name was changed to address future support for another device. 
> And I forgot to modify commit message accordingly.
>
>> Also, are you planning to add any other things to this soon? It seems
>> to me that perhaps the PCIe option should be the only one that's user-
>> visible, selecting the other one internally?
>
> Yes, I think it actually makes sense; another option is useless 
> without PCIe anyway.
>
>>> +	struct qtnf_bus_ops *bus_ops;
>> You should make that const and actually make all instances const, it's
>> better for security :)
>
> Ok, will review this and add const where possible.
>
>>> +/* Supported crypto cipher suits to be advertised to cfg80211 */
>>> +static const u32 qtnf_cipher_suites[] = {
>>> +	WLAN_CIPHER_SUITE_TKIP,
>>> +	WLAN_CIPHER_SUITE_CCMP,
>>> +	WLAN_CIPHER_SUITE_AES_CMAC,
>>> +};
>> I'm surprised - no WEP? No CMAC and GCMP/GMAC?
>
> For now we only advertise suits that we actually verified; HW supports 
> CCMP/GCMP-128/256 which we plan to enable in followup patches.
> For WEP support, company decision was to drop WEP support from SW 
> altogether since it does not provide security anyway, and we can reuse 
> HW resources to support more clients instead.
>
>>
>>> +static int
>>> +qtnf_change_virtual_intf(struct wiphy *wiphy,
>>> +			 struct net_device *dev,
>>> +			 enum nl80211_iftype type, u32 *flags,
>>> +			 struct vif_params *params)
>>> +{
>>> +	struct qtnf_vif *vif;
>>> +	u8 *mac_addr;
>>> +
>>> +	vif = qtnf_netdev_get_priv(dev);
>>> +
>>> +	if (params)
>>> +		mac_addr = params->macaddr;
>>> +	else
>>> +		mac_addr = NULL;
>>> +
>>> +	if (qtnf_cmd_send_change_intf_type(vif, type, mac_addr)) {
>>> +		pr_err("failed to change interface type\n");
>>> +		return -EFAULT;
>> Maybe -EIO would be better.
>
> Ok
>
>>> +struct wireless_dev *qtnf_add_virtual_intf(struct wiphy *wiphy,
>>> +					   const char *name,
>>> +					   unsigned char
>>> name_assign_type,
>>> +					   enum nl80211_iftype type,
>>> +					   u32 *flags,
>>> +					   struct vif_params
>>> *params)
>>> +{
>>> +	struct qtnf_wmac *mac;
>>> +	struct qtnf_vif *vif;
>>> +	u8 *mac_addr = NULL;
>>> +
>>> +	mac = wiphy_priv(wiphy);
>>> +
>>> +	if (!mac)
>>> +		return ERR_PTR(-EFAULT);
>>> +
>>> +	switch (type) {
>>> +	case NL80211_IFTYPE_STATION:
>>> +	case NL80211_IFTYPE_AP:
>>> +		vif = qtnf_get_free_vif(mac);
>>> +		if (!vif) {
>>> +			pr_err("could not get free private
>>> structure\n");
>>> +			return ERR_PTR(-EFAULT);
>>> +		}
>> This is probably fairly natural to do, and it's not the first driver to
>> do this (brcmfmac also does), but some users may assume that they can
>> add interfaces as much as they want, until they bring them up (netdev
>> open).
>>
>> It's probably worth having a discussion about this behaviour difference
>> - not necessarily in the context of this driver submission though.
>
> Do you mean that default is to allow to dynamically allocate resources 
> (add_interface) for as much interfaces as memory allows, but only use 
> (allow to open) a limited number of them? This seems like unnecessary 
> complication, I can see only one relevant comment in documentation to 
> "struct ieee80211_iface_combination" that does not clarify what should 
> be the behavior:
>
>      * @max_interfaces: maximum number of interfaces in total allowed
>     in this
>      *    group
>
>
>>> +	if (qtnf_cmd_send_add_intf(vif, type, mac_addr)) {
>>> +		vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
>>> +		pr_err("failed to send add_intf command\n");
>>> +		return ERR_PTR(-EFAULT);
>> I can't really tell, does this leak "vif"?
>
> It frees "vif" in driver by setting "iftype = 
> NL80211_IFTYPE_UNSPECIFIED", but does not free it on device side in 
> case further operations fail! Will fix.
>
>> OK I need to find another way to review this patch now, it's too big
>> for my email client to work responsively...
>>
>> johannes
>>
>
