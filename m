Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43064 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbaBTHbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:31:06 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v3 3/6] cfg80211: Enable GO operation on additional
 channels
Date: Thu, 20 Feb 2014 07:31:01 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A033383E32@HASMSX106.ger.corp.intel.com> (sfid-20140220_083111_384032_CE1D6E3B)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-4-git-send-email-ilan.peer@intel.com>
 <20140218233852.GC14296@garbanzo.do-not-panic.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A0333823B5@HASMSX106.ger.corp.intel.com>
 <20140219154747.GG14296@garbanzo.do-not-panic.com>
In-Reply-To: <20140219154747.GG14296@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Wed, Feb 19, 2014 at 02:52:13PM +0000, Peer, Ilan wrote:
> > > Ilan, also extend the above with language similar to the one I
> > > provided on the cellular base station hints if you ended up adding a
> device feature capability.
> > >
> >
> > You mean specify that this option is enabled, drivers can still use
> > the device specific flags to disable this?
> 
> Yeap! In particular its important to make it clear that enabling this option isn't
> enough to get enable this feature, this option will only be usable on device
> drivers that have support for this feature.
> 

Great :) already added it in the previous patch set. 

> > > > +
> > > > +		if (!other_chan)
> > > > +			continue;
> > > > +
> > > > +		if (chan == other_chan)
> > > > +			return true;
> > >
> > > This seems to me to indicate that we have allowed here daisy
> > > chaining / trust on another GO who also trusted its AP. That is, we
> > > are leaving it up to the kernel for the above few lines of code to
> > > check if the STA was associated to an AP that had DFS support. How
> > > do we know the AP the STA was associated to was not another GO that
> > > ran through this permissive check? Is the FCC happy with that?
> > >
> >
> > This verification should be done by user space, i.e., if the station
> > is a legacy client associated to a GO, then wpa_supplicant should not
> > allow the GO_CONCURRENT relaxation. In addition, a GO instantiated on
> > channel based on this relaxation should not allow connection from
> > legacy clients ... again this should be enforced by user space. System
> > wise this should adhere to the FCC expectations and prevent daisy
> > chaining.
> 
> Wow this is a hugely important piece of information, please toss it into the
> documentation both kconfig and wiki (once accepted upstream). As for
> references to userspace you can mention supplicant (wpa_supplicant).
> 

Sure.

> > > Also to be clear, you check for IEEE80211_CHAN_GO_CONCURRENT only
> on
> > > the caller's channel, not the STA's device, is that OK ? Lets
> > > consider the case case of two different types of interfaces on the
> > > same system. I am aware of at least one 802.11 AP company selling
> > > devices with one 802.11 vendor as the AP and another as the STA. I
> > > don't consider this rare anymore now, as such please think about
> > > this case as well.
> >
> > The property is of the channel so this should suffice. Overall, I
> > think that the FCC definition rules are centered on the UNII bands, so
> > the rules mandated for a given channel in a specific channel should
> > also hold to other channels in the same UNII band. Ultimately, I would
> > expect all channels in the same UNII band to share the same settings.
> 
> OK.
> 
> > The iteration in this case is over all the interfaces of the same
> > registered device
> 
> This feature seems limited then. Can this be extended to relay on the
> information from any other registered device? I suspect folks may soon
> enter bug reports for this otherwise. That carefulness here seems to be an
> implementation preference, but is it a hard requirement? If not then please
> considering revising all registered devices.
> 

I think that this might be problematic in cases where the HW/FW has additional enforcement for GO concurrent cases, and thus will not allow to instantiate a GO although there is a station connection on another device. Eventually, it really comes to the question of can one device rely on another device for regulatory compliance?

Need to think about this option and take it with our regulatory people. For now I would prefer to stay with this limitation. 

Thanks,

Ilan.

