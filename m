Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52449 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0FHIrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 04:47:18 -0400
Subject: Re: [RFC PATCHv2] mac80211: Fix circular locking dependency in ARP
 filter handling
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>
In-Reply-To: <1275984236.3706.45.camel@jlt3.sipsolutions.net>
References: <1275978299-18237-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1275984236.3706.45.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 11:46:57 +0300
Message-ID: <1275986817.5277.31574.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-08 at 10:03 +0200, ext Johannes Berg wrote:
> On Tue, 2010-06-08 at 09:24 +0300, Juuso Oikarinen wrote:
> 
> > @@ -161,10 +161,20 @@ enum ieee80211_bss_change {
> >  	BSS_CHANGED_BEACON_ENABLED	= 1<<9,
> >  	BSS_CHANGED_CQM			= 1<<10,
> >  	BSS_CHANGED_IBSS		= 1<<11,
> > +#ifdef CONFIG_INET
> > +	BSS_CHANGED_ARP_ADDR_LIST	= 1<<12,
> > +#endif
> 
> Ick, don't do that, all drivers would end up littered with ifdefs.
>  
> > @@ -220,6 +235,10 @@ struct ieee80211_bss_conf {
> >  	s32 cqm_rssi_thold;
> >  	u32 cqm_rssi_hyst;
> >  	enum nl80211_channel_type channel_type;
> > +#ifdef CONFIG_INET
> > +	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
> > +	u8 arp_addr_cnt;
> > +#endifs
> 
> same here.
> 
> > @@ -851,6 +851,10 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
> >  	    sdata->vif.bss_conf.cqm_rssi_thold)
> >  		bss_info_changed |= BSS_CHANGED_CQM;
> >  
> > +#ifdef CONFIG_INET
> > +	bss_info_changed |= BSS_CHANGED_ARP_ADDR_LIST;
> > +#endif
> > +
> 
> I don't see why you can't set that unconditionally here either, it'll
> just be an empty list always.

I was about to send the patch without the ifdefs, but was unsure about
the policy here so I decided to add at the at the last minute.

Our testing guy found a bug too - the condition for the max number of
IP's is wrong, it will take at most 3 addresses currently.

> Otherwise looks pretty good.

As you say it looks OK, I'll remove the above #ifdef's, fix that one bug
(and others if/when our tester dude finds more) and resubmit. 

-Juuso

> johannes
> 


