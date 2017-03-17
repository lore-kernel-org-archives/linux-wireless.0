Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35807 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbdCQI3w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 04:29:52 -0400
Received: by mail-qk0-f178.google.com with SMTP id v127so58839063qkb.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Mar 2017 01:29:51 -0700 (PDT)
Subject: Re: [RFT] brcmfmac: add support to move wiphy instance into network
 namespace
To: Mark Asselstine <mark.asselstine@windriver.com>
References: <1489528312-28304-1-git-send-email-arend.vanspriel@broadcom.com>
 <124157392.J1GrpqVLd5@yow-masselst-lx1>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <910c8775-a012-2d9b-e9fe-5a86a73b89ca@broadcom.com> (sfid-20170317_092959_218547_27DE04F7)
Date: Fri, 17 Mar 2017 09:21:28 +0100
MIME-Version: 1.0
In-Reply-To: <124157392.J1GrpqVLd5@yow-masselst-lx1>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-3-2017 22:51, Mark Asselstine wrote:
> On Tuesday, March 14, 2017 9:51:52 PM EDT Arend van Spriel wrote:
>> To support network namespace the driver must assure all created
>> network interfaces are in the same namespace as the wiphy instance.
>>
>> Reported-by: Mark Asselstine <mark.asselstine@windriver.com>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>> Hi Mark,
>>
>> Please check this patch. I can not say I am an expert when it comes
>> to using namespaces. So let me know if it works and I can change
>> Reported-by into Tested-by.
> 
> Seems to pass the tests I threw at it. Seems happy with namespaces.

Thanks. Will queue it for submission and add Tested-by: tag.

Regards,
Arend

> Mark
> 
>>
>> Regards,
>> Arend
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ++-
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 5 ++++-
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c index
>> 3856de6..e0d65df 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> @@ -6450,7 +6450,8 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy,
>> struct brcmf_if *ifp) BIT(NL80211_BSS_SELECT_ATTR_BAND_PREF) |
>>  				    BIT(NL80211_BSS_SELECT_ATTR_RSSI_ADJUST);
>>
>> -	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
>> +	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
>> +			WIPHY_FLAG_PS_ON_BY_DEFAULT |
>>  			WIPHY_FLAG_OFFCHAN_TX |
>>  			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
>>  	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS))
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c index
>> 22b4883..74ede27 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> @@ -463,6 +463,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
>>  int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
>>  {
>>  	struct brcmf_pub *drvr = ifp->drvr;
>> +	struct wiphy *wiphy;
>>  	struct net_device *ndev;
>>  	s32 err;
>>
>> @@ -476,8 +477,10 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool
>> rtnl_locked) ndev->needed_headroom += drvr->hdrlen;
>>  	ndev->ethtool_ops = &brcmf_ethtool_ops;
>>
>> -	/* set the mac address */
>> +	/* set the mac address & netns */
>>  	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
>> +	wiphy = cfg_to_wiphy(drvr->config);
>> +	dev_net_set(ndev, wiphy_net(wiphy));
>>
>>  	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
>>  	INIT_WORK(&ifp->ndoffload_work, _brcmf_update_ndtable);
> 
> 
