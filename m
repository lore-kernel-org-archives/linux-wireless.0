Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45246 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbZDVR3S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 13:29:18 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1240393523.21978.1.camel@johannes.local>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23) <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869) <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
	 <1240348792.17388.46.camel@johannes.local>
	 <1240385542.3404.5.camel@localhost.localdomain>
	 <1240391029.20308.1.camel@johannes.local>
	 <1240391541.10072.2.camel@localhost.localdomain>
	 <1240393523.21978.1.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 10:35:23 -0700
Message-Id: <1240421723.29805.32.camel@rc-desk> (sfid-20090422_192944_288138_760737B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, 2009-04-22 at 02:45 -0700, Johannes Berg wrote:
> Hi,
> 
> > > > CTRL-EVENT-SCAN-RESULTS 
> > > > Trying to authenticate with 00:23:ab:xx:xx:xx (SSID='Guest' freq=2412 MHz)
> > > > Trying to associate with 00:23:ab:xx:xx:xx (SSID='Guest' freq=2412 MHz)
> > > > Associated with 00:23:ab:xx:xx:xx
> > > > CTRL-EVENT-CONNECTED - Connection to 00:23:ab:xx:xx:xx completed (auth) [id=2 id_str=]
> > > > CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> > > > l2_packet_receive - recvfrom: Network is down
> > > > Failed to initiate AP scan.
> > > > Failed to initiate AP scan.
> > > > ^CCTRL-EVENT-TERMINATING - signal 2 received
> > > > 
> > > > So starting wpa_supplicant does its job fine, then running dhclient I
> > > > end up in the disconnect and network down and after that scanning fails.
> > > 
> > > ???
> > > 
> > > And the below kernel message is all yo uget?
> > 
> > Yes, I am as puzzled as you are and can't make any sense out of it. It
> > seems that something is going horribly wrong here somewhere. I just
> > don't have any clue where.
> 
> I just don't see anything in the kernel that would ever set the
> interface down, as indicated there.
> 
> > > > WARNING: at net/wireless/nl80211.c:205 nl80211_send_wiphy+0x4b/0x988
> 
> > > >  [<ffffffffa0055e04>] nl80211_send_wiphy+0x4b/0x988 [cfg80211]
> > > 
> > > What tree are you using? This warning totally confuses me -- there's no
> > > code to produce it! It was a spurious warning Luis added some time ago,
> > > we removed right away again and now it's haunting us.
> > 
> > This is the iwlwifi tree based on wireless-testing. It should be
> > re-based, but maybe an old patch is still stuck in it. Remember that I
> > am using the nl80211 driver of wpa_supplicant.
> 
> Indeed:
> 
> $ git diff iwlwifi-2.6/master..wireless-testing/master net/wireless
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index ebda7c5..97bb5c8 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -202,8 +202,6 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
>         int i;
>         u16 ifmodes = dev->wiphy.interface_modes;
>  
> -       assert_cfg80211_lock();
> -
>         hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY);
>         if (!hdr)
>                 return -1;
> 

I have no idea how this was missed during a merge ... it is fixed now.

Reinette


