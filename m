Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:51121 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZGaN4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 09:56:20 -0400
Received: by fxm17 with SMTP id 17so1382697fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 06:56:18 -0700 (PDT)
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249047576.29587.76.camel@johannes.local>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1249024097.7653.6.camel@maxim-laptop>
	 <1249026181.29587.14.camel@johannes.local>
	 <1249046380.6418.6.camel@maxim-laptop>
	 <1249047576.29587.76.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 16:56:11 +0300
Message-Id: <1249048571.32395.6.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 15:39 +0200, Johannes Berg wrote:
> On Fri, 2009-07-31 at 16:19 +0300, Maxim Levitsky wrote:
> 
> > First patch makes the probe requests be retried (and with it and only
> > it, my connection is very stable, it never retries more that 3 times,
> > and I set max retries to 5)
> > 
> > Second patch, trivial one bumps up the timeouts (30 for ping, and 1/2
> > for response, so device won't send out frames too often)
> 
> Thank you!
> 
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index ee83125..38ef7f2 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -31,6 +31,7 @@
> >  #define IEEE80211_AUTH_MAX_TRIES 3
> >  #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
> >  #define IEEE80211_ASSOC_MAX_TRIES 3
> > +#define IEEE80211_ASSOC_RETRIES 5
> 
> I'd prefer that be named PROBE_TRIES or something like that?
Fine

> 
> > @@ -1209,6 +1210,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
> >  	ieee80211_recalc_ps(sdata->local, -1);
> >  	mutex_unlock(&sdata->local->iflist_mtx);
> >  
> > +	sdata->u.mgd.probe_miss_count = 0;
> >  	ssid = ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
> >  	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
> >  				 ssid + 2, ssid[1], NULL, 0);
> 
> That appears to be in the wrong place. Shouldn't that be in the
> _set_associated function? Otherwise you're always setting it to 0 before
> sending the probe?
I thought about this too, but I think this is the right place.
ieee80211_mgd_probe_ap is called to start a probe on an AP, it will
ignore following calls till ether AP responds or we reconnect.
What I did is not to fail after first timeout, but resend the assoc
request once more, thus this function won't be called again.

> 
> > @@ -2072,17 +2074,36 @@ static void ieee80211_sta_work(struct work_struct *work)
> >  	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
> >  			    IEEE80211_STA_CONNECTION_POLL) &&
> >  	    ifmgd->associated) {
> > +
> > +		u8 bssid[ETH_ALEN];
> 
> drop that empty line please
no problem
> 
> > +		const u8 *ssid;
> > +
> > +		memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
> > +
> >  		if (time_is_after_jiffies(ifmgd->probe_timeout))
> >  			run_again(ifmgd, ifmgd->probe_timeout);
> > -		else {
> > -			u8 bssid[ETH_ALEN];
> > +
> > +		else if (ifmgd->probe_miss_count < IEEE80211_ASSOC_RETRIES) {
> > +
> > +			printk(KERN_DEBUG "No probe response from AP %pM"
> 
> and that one too
same here
> 
> > +				" after %dms, try %d\n", bssid,
> > +				(1000 * IEEE80211_PROBE_WAIT)/HZ,
> > +				(int)ifmgd->probe_miss_count);
> > +
> > +			ifmgd->probe_miss_count++;
> > +			ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
> > +			run_again(ifmgd, ifmgd->probe_timeout);
> > +
> > +			ssid = ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
> > +			ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
> > +				ssid + 2, ssid[1], NULL, 0);
> > +		} else {
> 
> Shouldn't this just call _probe_ap() again? After you move the setting
> to 0 out of it, that is?
No, first of all I tried it :-). It takes the ifmgd->mtx first of all,
and besides this way it is more logical, ieee80211_mgd_probe_ap is
called once per AP ping, and here we continue it.
Since I have copied these 3 lines from ieee80211_mgd_probe_ap I have no
objection to put them in a new function.

> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > 
> > Do a poll every 30 seconds, and wait for response half a second
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> > 
> >  net/mac80211/mlme.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index 38ef7f2..a8ab40c 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -42,13 +42,13 @@
> >   * Time the connection can be idle before we probe
> >   * it to see if we can still talk to the AP.
> >   */
> > -#define IEEE80211_CONNECTION_IDLE_TIME	(2 * HZ)
> > +#define IEEE80211_CONNECTION_IDLE_TIME	(30 * HZ)
> >  /*
> >   * Time we wait for a probe response after sending
> >   * a probe request because of beacon loss or for
> >   * checking the connection still works.
> >   */
> > -#define IEEE80211_PROBE_WAIT		(HZ / 5)
> > +#define IEEE80211_PROBE_WAIT		(HZ / 2)
> 
> 
> Fine with me.
> 
> johannes

Best regards,
	Maxim Levitsky

