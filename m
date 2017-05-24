Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38239 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031593AbdEXWnu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 18:43:50 -0400
Date: Thu, 25 May 2017 08:43:46 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WPA and WPA2
Message-ID: <20170524224346.GD2319@eros> (sfid-20170525_004354_631141_07E1FC0B)
References: <20170524072750.GI8158@eros>
 <20170524073459.GJ8158@eros>
 <1495644240.12939.3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495644240.12939.3.camel@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 24, 2017 at 11:44:00AM -0500, Dan Williams wrote:
> On Wed, 2017-05-24 at 17:34 +1000, Tobin C. Harding wrote:
> > On Wed, May 24, 2017 at 05:27:50PM +1000, Tobin C. Harding wrote:
> > > Hi,
> > > 
> > > I am attempting to rewrite the ks7010 WEXT driver
> > > (drivers/staging/ks7010)
> > > to use the CFG80211 API.
> > > 
> > > I am reading 802.11 Wireless Networks - Matthew S. Gast for
> > > reference.
> > > 
> > > I have some confusion regarding WEP/WPA/WPA2/RSN, ciphers, keys and
> > > ie's?
> > > 
> > > As I understand, first there was WEP. Next we got a marketing term
> > > WPA
> > > which referred to 802.11i (which specified the protocols TKIP and
> > > CCMP, and also RSN).
> > > 
> > > WEP vs WPA
> > > ----------
> > > 
> > > To add to my confusion the ks7010 code seemingly mixes up the use
> > > of
> > > WEP keys and WPA keys, to set both the WEP and the WPA keys the
> > > driver
> > > uses the same MIB requests? Yet throughout the code WEP keys and
> > > WPA
> > > keys are stored in separate structures (and treated differently).
> > 
> > Oh, I just got why there is only one MIB request type - there are
> > only
> > one set of keys used by the target
> > 
> > 	DOT11_WEP_DEFAULT_KEY_VALUE1	= 0x13020101,
> > 	DOT11_WEP_DEFAULT_KEY_VALUE2	= 0x13020102,
> > 	DOT11_WEP_DEFAULT_KEY_VALUE3	= 0x13020103,
> > 	DOT11_WEP_DEFAULT_KEY_VALUE4	= 0x13020104,
> > 
> > removing 'WEP' from the defines removes the confusion here :)
> 
> I could be entirely wrong, but it looks like the driver really just
> defines 4 "keys" which can be used for anything.

Thank you very much for taking the time to look at the driver, I
really appreciate it.

> For WEP, they are the 4 WEP key indexes.
> 
> For RSN, they are 1 = PMK, 2 = GMK, 3 = GMK2, 4 seems unused.
> 
> Because WEXT is pretty convoluted, I woudn't necessarily try to
> translate what eg ks_wlan_set_encode_ext() is doing directly to
> cfg80211, but to understand how the firmware interface works and then
> just write the cfg80211 code to the firmware interface.

That's a good idea.

thanks,
Tobin.
