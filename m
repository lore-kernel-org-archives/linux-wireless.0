Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45270
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422676AbXBUQvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 11:51:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 17:51:27 +0100
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702211702.47410.IvDoorn@gmail.com> <200702211737.33996.mb@bu3sch.de> <200702211744.24034.IvDoorn@gmail.com>
In-Reply-To: <200702211744.24034.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702211751.27245.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 February 2007 17:44, Ivo van Doorn wrote:
> On Wednesday 21 February 2007 17:37, Michael Buesch wrote:
> > On Wednesday 21 February 2007 17:02, Ivo van Doorn wrote:
> > > Let broadcom use the antenna_tx field for hardware configuration.
> > > I did not check if the device is also capable of RX antenna selection,
> > > but current implementation only suggested support for the TX antenna.
> > > 
> > > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > > 
> > > ---
> > > 
> > > diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
> > > index cdce227..580ea33 100644
> > > --- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
> > > +++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
> > > @@ -2609,7 +2609,7 @@ static int bcm43xx_dev_config(struct ieee80211_hw *hw,
> > >  	int antenna = -1;
> > >  	int err = 0;
> > >  
> > > -	switch (conf->antenna_sel) {
> > > +	switch (conf->antenna_sel_tx) {
> > 
> > Nope, this is conf->antenna_sel_rx
> > ;)
> 
> On further inspection not even that. :P
> The outcome of that switch is stored in the antenna variable, which is used with
> 
> 	bcm43xx_mgmtframe_txantenna(dev, antenna);
> 	bcm43xx_set_rx_antenna(dev, antenna);
> 
> So I guess that needs to be fixed to create a switch statement for
> the RX antenna and one for the TX antenna?

Ah, yeah. I didn't have the complete code for this in my head. :)

I'd rather like to have a helper function
int bcm43xx_antenna_from_ieee80211(u8 antenna)
which includes the switch statement and use it twice in the
config callback. Wanna do that?

-- 
Greetings Michael.
