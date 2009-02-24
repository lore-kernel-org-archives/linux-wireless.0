Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:51977 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbZBXHF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 02:05:57 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>,
	"'John W. Linville'" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: RE: SIOCGIWSCAN-race
Date: Tue, 24 Feb 2009 06:55:39 +0100
Message-ID: <385AA299C8A542839E1BCA8302900524@gotws1589> (sfid-20090224_080559_249393_11FE66F6)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1235440092.4455.40.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Mon, 2009-02-23 at 16:11 -0500, John W. Linville wrote:
> > On Sat, Feb 21, 2009 at 08:33:06AM +0100, Lars Ericsson wrote:
> > > Hi Johannes,
> > > 
> > > I have discovered and patched a race in the scanning function since a
couple
> > > of releases.
> > > To day I checked the current Linux git and the problem is still there.
> > > 
> > > The problem is the sequence of events when the scan result is reported
back.
> > > The wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL); 
> > > is called before ieee80211_hw_config(local);
> > > 
> > > ieee80211_hw_config(local) will trig the wpa_supplicant to select an
AP. 
> > > That may happen before the ieee80211_hw_config() is executed since the
> > > wpa_supplicant
> > > generated actions is executed by an other thread (wpa_supplicant).
> > > 
> > > The result is that:
> > > - wpa_supplicant setup for an association to an ap using correct
channel.
> > > - ieee80211_hw_config() reset the channel to the value before the SCAN
started.
> > > - the association request will be sent out using the wrong channel.
> > > 
> > > 
> > > Attached you will find the patch for 2.6.27. 
> > > It is not a perfect patch since the code is duplicated but it works :)
> > 
> > Looks like the patch would need to be reworked -- the code in 2.6.29
> > and later is different.  
> 
> and the new code with cfg80211 is even more different ;)
> 

OK, I have not moved in to the 'cfg80211' world, yet.
Johannes; do you create the patch for this ?
 
> > Also, any reason we can't just move the
> > wireless_send_event() down to done:?
> 
> seems fine

Perfect, is it to late for 2.6.29 ?

Lars

> > Still, this doesn't feel quite right.  Shouldn't we be able to queue
> > the userland-driven channel change until after the scan completes?
> 
> ?
> we do that, well, we set it here:
>         local->sw_scanning = false;
>         ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> 
> but we claim to be on the user requested channel at all times, so that
> should be ok
> 
> johannes
> 
> > John
> > 
> > diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> > index f5c7c33..8c13a91 100644
> > --- a/net/mac80211/scan.c
> > +++ b/net/mac80211/scan.c
> > @@ -437,15 +437,6 @@ void ieee80211_scan_completed(struct 
> ieee80211_hw *hw)
> >  	local->last_scan_completed = jiffies;
> >  	memset(&wrqu, 0, sizeof(wrqu));
> >  
> > -	/*
> > -	 * local->scan_sdata could have been NULLed by the interface
> > -	 * down code in case we were scanning on an interface that is
> > -	 * being taken down.
> > -	 */
> > -	sdata = local->scan_sdata;
> > -	if (sdata)
> > -		wireless_send_event(sdata->dev, SIOCGIWSCAN, 
> &wrqu, NULL);
> > -
> >  	if (local->hw_scanning) {
> >  		local->hw_scanning = false;
> >  		/*
> > @@ -486,6 +477,15 @@ void ieee80211_scan_completed(struct 
> ieee80211_hw *hw)
> >  	rcu_read_unlock();
> >  
> >   done:
> > +	/*
> > +	 * local->scan_sdata could have been NULLed by the interface
> > +	 * down code in case we were scanning on an interface that is
> > +	 * being taken down.
> > +	 */
> > +	sdata = local->scan_sdata;
> > +	if (sdata)
> > +		wireless_send_event(sdata->dev, SIOCGIWSCAN, 
> &wrqu, NULL);
> > +
> >  	ieee80211_mlme_notify_scan_completed(local);
> >  	ieee80211_mesh_notify_scan_completed(local);
> >  }
> > 
> 

