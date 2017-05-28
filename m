Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56209 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750830AbdE1Vaa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 May 2017 17:30:30 -0400
Date: Mon, 29 May 2017 07:30:25 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: WPA and WPA2
Message-ID: <20170528213025.GA4233@eros> (sfid-20170528_233409_473910_375CBE08)
References: <20170524072750.GI8158@eros>
 <20170524073459.GJ8158@eros>
 <1495644240.12939.3.camel@redhat.com>
 <1495649200.20833.1.camel@sipsolutions.net>
 <20170524224014.GC2319@eros>
 <1495734353.12839.2.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495734353.12839.2.camel@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 25, 2017 at 12:45:53PM -0500, Dan Williams wrote:
> On Thu, 2017-05-25 at 08:40 +1000, Tobin C. Harding wrote:
> > On Wed, May 24, 2017 at 08:06:40PM +0200, Johannes Berg wrote:
> > > Just a small correction:
> > > 
> > > On Wed, 2017-05-24 at 11:44 -0500, Dan Williams wrote:
> > > > 
> > > > For RSN, they are 1 = PMK, 2 = GMK, 3 = GMK2, 4 seems unused.
> > > 
> > > PTK and GTK, and in theory you could have more than two GTKs but
> > > that's
> > > not usually done.
> > 
> > Excuse my ignorance but why do you say PTK and GTK here? Who
> > generates
> > the transient keys, hardware, firmware or software? Is this device
> > specific or is there a *normal* way?
> > 
> > From the nomenclature in the WEXT driver I thought the driver
> > supplied the
> > master keys to the firmware and transient keys were generated at the
> > firmware layer or lower.
> 
> Usually the supplicant supplies only the PTK/GTK to the driver at the
> right times (like during the 4-way handshake).  It looks like the
> driver only refers to PMK/GMK when using the rx_seq[] bits, while the
> actual WPA keys are probably the PTK/GTK.
> 
> While it's not the best example, see
> drivers/net/wireless/marvell/libertas/cfg.c and lbs_cfg_connect() and
> lbs_cfg_add_key().  That should translate fairly well to the ks7010
> driver.  The important parts you'll get from nl80211 are
> add_key/del_key and set_default_key.  The connect hook gets called
> first to tell the driver to start the auth/assoc process to a given AP,
>  and that's where you'd set up the general stuff like whether or not
> you'll use WEP or WPA, what the SSID/BSSID are, whether PSK or
> EAPOL/802.1x, rates, etc.  Then after that you'll get the add_key hook
> that actually sends the real keys to the driver when the supplicant has
> calculated them.
> 
> 
> Dan

Awesome, thanks Dan
