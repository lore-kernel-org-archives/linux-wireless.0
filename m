Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:51345 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdCQMoA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 08:44:00 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT] brcmfmac: add support to move wiphy instance into network namespace
Date: Fri, 17 Mar 2017 08:43:52 -0400
Message-ID: <10023407.Rx0XN2k1RN@yow-masselst-lx1> (sfid-20170317_134403_789980_8C6BC670)
In-Reply-To: <012ec28b-ff56-5a65-848f-0a66919ad00e@broadcom.com>
References: <1489528312-28304-1-git-send-email-arend.vanspriel@broadcom.com> <0343e3c9-baf8-f3b1-8c37-c8b0864bd7e5@broadcom.com> <012ec28b-ff56-5a65-848f-0a66919ad00e@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, March 17, 2017 10:30:24 AM EDT Arend Van Spriel wrote:
> On 17-3-2017 10:06, Arend Van Spriel wrote:
> > On 16-3-2017 22:51, Mark Asselstine wrote:
> >> On Tuesday, March 14, 2017 9:51:52 PM EDT Arend van Spriel wrote:
> >>> To support network namespace the driver must assure all created
> >>> network interfaces are in the same namespace as the wiphy instance.
> >>> 
> >>> Reported-by: Mark Asselstine <mark.asselstine@windriver.com>
> >>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> >>> ---
> >>> Hi Mark,
> >>> 
> >>> Please check this patch. I can not say I am an expert when it comes
> >>> to using namespaces. So let me know if it works and I can change
> >>> Reported-by into Tested-by.
> >> 
> >> Seems to pass the tests I threw at it. Seems happy with namespaces.
> > 
> > I tested it myself and noticed something unexpected. Upon changing from
> > &init_net to brcm-wifi the wdev id has changed from 0x1 to 0x2 (see
> > below) and upon going from brcm-wifi to &init_net both interface change
> > their wdev id.
> 
> Hi Johannes,
> 
> Seems we get a NETDEV_REGISTER notification when changing to other
> namespace thus increasing the struct wireless_dev::identifier.
> 
> # insmod brcmfmac
> [253715.650567] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
> Feb 28 2017 12:44:14 version 7.112.21 (TOB) (r588403) FWID 01-3439bdc5
> [253715.669388] brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166
> code (0x30 0x30)
> [253715.698289] ieee80211 phy0: wdev id changed: 0 -> 1
> [253715.704032] brcmfmac 0000:02:00.0 wlan3: renamed from wlan0
> [253715.732362] systemd-udevd[21461]: renamed network interface wlan0 to
> wlan3
> [253715.779859] IPv6: ADDRCONF(NETDEV_UP): wlan3: link is not ready
> [253721.326349] IPv6: ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
> # iw phy0 set netns 21499
> [253788.877846] ieee80211 phy0: wdev id changed: 1 -> 2
> [253788.886710] brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166
> code (0x30 0x30)
> 
> I guess this is intended behavior?

I had thought this was intended behavior as well but I see that a patch is 
already prepped and tested to make this not happen. At any rate it wasn't 
appearing to affect my usecase.

Mark

> 
> Regards,
> Arend
> 
> > Regards,
> > Arend
> > 
> >      Terminal 1                 Terminal 2
> >      -------------------------- ---------------------------------
> >      # ip netns add brcm-wifi
> >      
> >                                 # iw dev
> >                                 phy#0
> >                                 
> >                                         Interface wlan3
> >                                         
> >                                                 ifindex 11
> >                                                 wdev 0x1
> >      
> >      # ip netns exec brcm-wifi bash
> >      # iw dev
> >      # echo $$
> >      20337
> >      
> >                                 # iw phy0 set netns 20337
> >      
> >      # iw dev
> >      phy#0
> >      
> >         Interface wlan3
> >         
> >                 ifindex 11
> >                 *wdev 0x2*
> >      
> >      # iw phy0 interface add wl3.ap type __ap
> >      # iw dev
> >      phy#0
> >      
> >         Interface wl3.ap
> >         
> >                 ifindex 2
> >                 wdev 0x3
> >         
> >         Interface wlan3
> >         
> >                 ifindex 11
> >                 wdev 0x2
> >                 
> >                                 # iw dev
> >      
> >      # iw phy0 set netns 1
> >      # iw dev
> >      
> >                                 # iw dev
> >                                 phy#0
> >                                 
> >                                         Interface wl3.ap
> >                                         
> >                                                 ifindex 12
> >                                                 *wdev 0x5*
> >                                         
> >                                         Interface wlan3
> >                                         
> >                                                 ifindex 11
> >                                                 *wdev 0x4*
> >> 
> >> Mark
> >> 
> >>> Regards,
> >>> Arend
> >>> ---
> >>> 
> >>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ++-
> >>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 5 ++++-
> >>>  2 files changed, 6 insertions(+), 2 deletions(-)
> >>> 
> >>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> >>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c index
> >>> 3856de6..e0d65df 100644
> >>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> >>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> >>> @@ -6450,7 +6450,8 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy,
> >>> struct brcmf_if *ifp) BIT(NL80211_BSS_SELECT_ATTR_BAND_PREF) |
> >>> 
> >>>  				    BIT(NL80211_BSS_SELECT_ATTR_RSSI_ADJUST);
> >>> 
> >>> -	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
> >>> +	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
> >>> +			WIPHY_FLAG_PS_ON_BY_DEFAULT |
> >>> 
> >>>  			WIPHY_FLAG_OFFCHAN_TX |
> >>>  			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
> >>>  	
> >>>  	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS))
> >>> 
> >>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> >>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c index
> >>> 22b4883..74ede27 100644
> >>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> >>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> >>> @@ -463,6 +463,7 @@ static int brcmf_netdev_open(struct net_device
> >>> *ndev)
> >>> 
> >>>  int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
> >>>  {
> >>>  
> >>>  	struct brcmf_pub *drvr = ifp->drvr;
> >>> 
> >>> +	struct wiphy *wiphy;
> >>> 
> >>>  	struct net_device *ndev;
> >>>  	s32 err;
> >>> 
> >>> @@ -476,8 +477,10 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool
> >>> rtnl_locked) ndev->needed_headroom += drvr->hdrlen;
> >>> 
> >>>  	ndev->ethtool_ops = &brcmf_ethtool_ops;
> >>> 
> >>> -	/* set the mac address */
> >>> +	/* set the mac address & netns */
> >>> 
> >>>  	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
> >>> 
> >>> +	wiphy = cfg_to_wiphy(drvr->config);
> >>> +	dev_net_set(ndev, wiphy_net(wiphy));
> >>> 
> >>>  	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
> >>>  	INIT_WORK(&ifp->ndoffload_work, _brcmf_update_ndtable);
