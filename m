Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:46478 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZEaVNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 17:13:44 -0400
Received: by fxm12 with SMTP id 12so5429803fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 14:13:44 -0700 (PDT)
Subject: Re: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243803253.5417.12.camel@maxim-laptop>
References: <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	 <1242256950.3241.13.camel@maxim-laptop>
	 <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
	 <1242258469.3241.19.camel@maxim-laptop>
	 <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com>
	 <b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com>
	 <1242742647.23110.10.camel@ibm172> <1242951611.5206.9.camel@maxim-laptop>
	 <43e72e890905211736i3dfaf7d5q78d511eac0fbca1e@mail.gmail.com>
	 <1242986902.5544.8.camel@maxim-laptop>
	 <20090531062217.GB23972@bombadil.infradead.org>
	 <1243774031.5741.5.camel@maxim-laptop>
	 <1243803253.5417.12.camel@maxim-laptop>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 00:13:40 +0300
Message-Id: <1243804420.13018.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-05-31 at 23:54 +0300, Maxim Levitsky wrote:
> On Sun, 2009-05-31 at 15:47 +0300, Maxim Levitsky wrote:
> > On Sun, 2009-05-31 at 02:22 -0400, Luis R. Rodriguez wrote:
> > > On Fri, May 22, 2009 at 01:08:22PM +0300, Maxim Levitsky wrote:
> > > > I am talking about 
> > > > 
> > > > BUG_ON(!country_ie_regdomain);
> > > > in net/wireless/reg.c
> > > 
> > > Please try this patch and leave a window open with this running:
> > > 
> > > iw event
> > > 
> > > Please be sure to grab iw from git, not sure if the reg events
> > > have all gone into an official release yet. What I'm looking for
> > > is whether or not a previous 11d setting was already processed
> > > or if the !country_ie_regdomain condition happens from the first
> > > 11d processing.
> > > 
> > >   Luis
> > > 
> > > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > > index f87ac1d..1b60dfc 100644
> > > --- a/net/wireless/reg.c
> > > +++ b/net/wireless/reg.c
> > > @@ -2171,7 +2171,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
> > >  	 * the country IE rd with what CRDA believes that country should have
> > >  	 */
> > >  
> > > -	BUG_ON(!country_ie_regdomain);
> > > +	if (WARN_ON(!country_ie_regdomain)) {
> > > +		kfree(rd);
> > > +		rd = NULL;
> > > +		return -EINVAL;
> > > +	}
> > >  	BUG_ON(rd == country_ie_regdomain);
> > >  
> > >  	/*
> > > @@ -2268,6 +2272,8 @@ int regulatory_init(void)
> > >  	if (IS_ERR(reg_pdev))
> > >  		return PTR_ERR(reg_pdev);
> > >  
> > > +	country_ie_regdomain = NULL;
> > > +
> > >  	spin_lock_init(&reg_requests_lock);
> > >  	spin_lock_init(&reg_pending_beacons_lock);
> > >  
> > 
> > 
> > I'll test this today.
> > I have iw from git.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> Here it is:
> 
> 
> > wlan0 (phy #0): assoc 00:1b:9e:d8:77:02 -> 00:1b:77:f1:7c:29 status: 0: Successful
> > wlan0 (phy #0): disassoc 00:1b:77:f1:7c:29 -> 00:1b:9e:d8:77:02 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS
> > wlan0 (phy #0): scan finished
> > wlan0 (phy #0): auth 00:23:4d:3c:80:27 -> 00:1b:77:f1:7c:29 status: 0: Successful
> > wlan0 (phy #0): assoc 00:23:4d:3c:80:27 -> 00:1b:77:f1:7c:29 status: 0: Successful
> > phy #0: regulatory domain change: intersection used due to a request made by a country IE on phy0
> > 
> dmesg attached (I use nvidia drivers)
> 
> 
> 
> On top of that there are few more very bold bugs in ath5k AP mode:
> 
> 
> 1 - beacons are send only after I start hostapd twise (kill it, and
> start again)
> 
> 2 - ath5k makes kernel panic, reliably after few times hostapd have
> started, I didn't yet captured the output.
> I remember to see panics with ad-hoc as well. 
> I mean blinking leds on keyboard.
> 
> 3 - couldn't transfer any frames between AP and client, only association
> works.
> 
> I have started the hostapd, associated the clent (using link-local
> feature of NM) assigned both ap and client an ip address (ifconfig wlan0
> 10.1.0.1/24 on AP, and ifconfig wlan0 10.1.0.2/24 on client ) and yet
> even I couldn't receive even a arp reply from AP, and vise versa.
> 
> I use hostapd and wpa_supplicant frm latest git.

4 - transfers freeze very often, now I understand that this isn't
related to transfer speed or anything like that, just if the device is
on moderate load (1.1 Mbytes/s transfer via AP to my main notebook) will
play dead every 5 minutes or so. Even running 'iwlist scan', which
supposed to reset phy, doesn't help.

(This isn't related to AP mode)


You have the documentation, maybe you can look what is wrong?



Best regards,
	Maxim Levitsky



