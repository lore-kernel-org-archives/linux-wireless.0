Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35280 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbdCQJHM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 05:07:12 -0400
Received: by mail-qt0-f182.google.com with SMTP id x35so57476026qtc.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Mar 2017 02:07:03 -0700 (PDT)
Subject: Re: [RFT] brcmfmac: add support to move wiphy instance into network
 namespace
To: Mark Asselstine <mark.asselstine@windriver.com>
References: <1489528312-28304-1-git-send-email-arend.vanspriel@broadcom.com>
 <124157392.J1GrpqVLd5@yow-masselst-lx1>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0343e3c9-baf8-f3b1-8c37-c8b0864bd7e5@broadcom.com> (sfid-20170317_100717_613617_6EF24888)
Date: Fri, 17 Mar 2017 10:06:59 +0100
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

I tested it myself and noticed something unexpected. Upon changing from
&init_net to brcm-wifi the wdev id has changed from 0x1 to 0x2 (see
below) and upon going from brcm-wifi to &init_net both interface change
their wdev id.

Regards,
Arend

     Terminal 1                 Terminal 2
     -------------------------- ---------------------------------
     # ip netns add brcm-wifi
                                # iw dev
                                phy#0
                                        Interface wlan3
                                                ifindex 11
                                                wdev 0x1
     # ip netns exec brcm-wifi bash
     # iw dev
     # echo $$
     20337
                                # iw phy0 set netns 20337
     # iw dev
     phy#0
        Interface wlan3
                ifindex 11
                *wdev 0x2*
     # iw phy0 interface add wl3.ap type __ap
     # iw dev
     phy#0
        Interface wl3.ap
                ifindex 2
                wdev 0x3
        Interface wlan3
                ifindex 11
                wdev 0x2
                                # iw dev
     # iw phy0 set netns 1
     # iw dev
                                # iw dev
                                phy#0
                                        Interface wl3.ap
                                                ifindex 12
                                                *wdev 0x5*
                                        Interface wlan3
                                                ifindex 11
                                                *wdev 0x4*

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
