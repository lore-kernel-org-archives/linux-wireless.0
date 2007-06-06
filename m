Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbXFFEOt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2007 00:14:49 -0400
Subject: Re: RFC: Regulatory info in mac80211
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez Gonzalez <inaky.perez-gonzalez@intel.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Matt Norwood <norwood@softwarefreedom.org>
In-Reply-To: <43e72e890706051635s4c1d0a70p7e334edd8c6b3a38@mail.gmail.com>
References: <4665CCE7.5090409@lwfinger.net>
	 <43e72e890706051635s4c1d0a70p7e334edd8c6b3a38@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 00:18:45 -0400
Message-Id: <1181103525.18061.25.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-06-05 at 19:35 -0400, Luis R. Rodriguez wrote:
> On 6/5/07, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > Given the recent discussions of regulatory/geographic domain compliance (or lack thereof) in
> > mac80211, and the fact that the software is mainlined in 2.6.22, it seems a good time to start
> > planning for full implementation of regulatory information in mac80211.
> 
> Since we have a new userspace and driver API underway as well I think
> we should instead focus on an overall regulatory framework for all
> types of wireless devices and not just mac80211. Although some devices
> do provide regulatory enforcement through firmware extending the
> driver API to do an additional check for consistency amongst all
> devices seems like a good idea.

I'd like to echo the above.  I've got an interest in a few fullmac
drivers (airo, atmel, libertas) that have various bits of regulatory
info in the driver in static tables.  If we can push that out somewhere
that's a lot easier to update when regulations change, that's a huge
bonus and removes duplicated code.  So let's try to get something that
the fullmac drivers can plug into at some level too, even if it's just
"give me allowed power and channel values for France" or something like
that.  For example:

libertas: contains region and channel power mappings for 802.11d in
liberas/11d.c and libertas/main.c, and a pile of code to deal with
802.11d

atmel: contains channel tables and regulatory domain information,
validates channel changes

Maybe roll these sort of utility functions into "lib80211" that both
fullmac and mac80211 drivers can depend on.  And have various functions
to convert between channel, frequency, and band, etc, that every driver
seems to reimplement.

We should also have some mechanism (likely though nl80211/cfg80211) that
allows domain changes if the driver and firmware support it, or return
errors if you're not allowed to change the domain.

Dan


> > Roughly a year ago, I worked on such a scheme for ieee80211, but put the project on hold when I
> > learned that ieee80211 and ieee80211_softmac, which is used by my driver of interest, would be
> > replaced by mac80211. The project was far from complete; however, a number of individuals responded
> > to my RFC's and suggested the following (the netdev archives should contain the E-mails):
> 
> I had started my own implementation as I noticed a few of the flaws
> (and some more) you mention bellow:
> 
> http://kernel.org/pub/linux/kernel/people/mcgrof/patch-02-ieee80211_regdomains.diff
> 
> There is still some flaws to this but I am confident this is the right
> direction. Let me see if I can address some of the points you make
> with respect to this implementation and with the overall architectural
> view I have of this now.
> 
> > 1. The regulatory information is too dynamic to be placed in the kernel.
> 
> ACK, at least some defaults can still be provided.
> 
> > 2. The regulatory database should be in an ASCII file for easy updating. This database should be
> > read by a userspace daemon that reformats the information and supplies it to mac80211 upon demand.
> 
> Again -- I think we should think of an overall regulatory agent for
> all wireless drivers, not just mac80211. But I do agree the main db
> should be available in userspace and an interface provided for
> updating the regulatory agent. The way I was going about this with my
> implementation was to let userspace update ieee802111_regdomains
> module through nl80211.
> 
> > 3. There should be some sort of checking to verify that the database has not been hacked to modify
> > transmission power, etc. in an illegal manner. Obviously, no foolproof means of enforcing this does
> > not exist; however, we should prevent the crudest form of modifications.
> 
> This is the hairy part (hey Alan :)). For devices that have additional
> hardware checks in firmware we're OK as even if the user does try to
> go out of regulatory compliance they won't be able to, that is unless
> they change their regulatory domain and can do so with the device. For
> these type of devices it means we should be able to get vendor support
> (example is Intel). For devices where all regulatory enforcement is
> expected to be done through the driver I think best effort should be
> enough for in-kernel drivers.
> 
> I think perhaps the best suggestion for best effort right now was some
> sort signing for a set of possible registers and have the microcode
> verify this. Not too sure on all the details of the idea, this was
> Alan's idea, Alan -- can you elaborate a bit on how this would work
> exactly?
> 
> Previously a concern for vendors over if whether if regulatory
> compliance is enforced in firmware or the driver was that it seemed
> that if it implemented in firmware you can get away with FCC part 15
> rules certification. But it seems that a new clarification by the FCC
> on SDR rules seems to indicate that even if its done in firmware you
> need to certify your device under SDR rules (someone correct me if
> this seems wrong):
> 
> http://hraunfoss.fcc.gov/edocs_public/attachmatch/FCC-07-66A1.pdf
> 
> We're not concerned over certification but vendors are and we get some
> vendor support when our implementations might allow them to get SDR
> certification. Here is what the clarification says about security
> measures with respect to regulatory compliance under SDR rules:
> 
> "A system that is wholly dependent on open source elements will have a
> high burden to demonstrate that it is sufficiently secure to warrant
> authorization as a software defined radio."
> 
> And that's all they say about that.
> 
> > 4. The database should incorporate the parameters needed for 802.11a, 802.11b/g/n, 802.11d, and 802.11h.
> 
> ACK on 802.11d, I added a bit of that. Can you elaborate a bit more on
> what you mean by incorporating parameters needed for 802.11bg or n.
> Then AFAICT 802.11h only applies to 802.11a, someone correct me if I'm
> wrong.
> 
> > 5. There should be a scheme for translating country codes based on the outdated table 105 in
> > Corrigendum 1 for 802.11b. This is the basis for the EEPROM data in the ZD1211 hardware.
> 
> Ah so that's where the mappings for to several regdomain numbers for
> several devices came from (prism54, zydas, atheros)! Hm, some vendors
> (Atheros) defined a rest set of values and I always wondered where
> they got them from if they came up with them on their own. I figured
> they would use iso3166-1 number mapping for specific countries but
> nope.
> 
> > Note, this
> > scheme is far too limited to be the only one available. If the translation code is needed for more
> > than one driver, it should be placed in mac80211.
> 
> In my implementation I dealt with this shortcoming by just adopting
> our own numbering scheme (the one on table 105) and letting the driver
> either embrace this as default or provide their own mapping to ours.
> See ieee80211_regulatory_map in my implementation.
> 
> > 6. In case of errors such as the user daemon not running, database corruption, an illegal region
> > code from the driver, etc., mac80211 should set a default set of parameters that are legal
> > everywhere, and log a suitable error message.
> 
> I wanted this to work too unfortunately I found that there is no world
> decent acceptable regulatory domain. We'd have to allow only 802.11b
> only and only allow a couple of channels IIRC. We could just ignore
> this and increase the size of this to allow a few 802.11a channels as
> well. See my add_regdomain_world().
> 
> > 7. ??
> 
> A few other things I added to my implementation:
> 
> * Break regulatory domains into supporting bands, not modes
> specifically. Example of bands:
> 
> - ISM 2.4 GHz Band
> - UNII-1 Band (5150 - 5250 MHz)
> - UNII-2 Band (5250 - 5350 MHz)
> - UNII-3 Band (5725 - 5825 MHz)
> 
> Then within each band add a list of subbands. For each subband allow
> of type 'set' or 'range'
> 
> * For power restrictions have max_eirp_indoor and max_eirp_outdoor,
> let user tell us where we are, assume indoor.
> 
> * Add environment capability for subbands (indoor, outdoor)
> 
> > To begin such an undertaking, the following steps need to be done:
> >
> > 1. Decide what information is required. These data include, but are not limited to, the band, the
> > maximum E.I.R.P. in dBm, whether the data are for indoors/outdoors/both, an indication regarding the
> > use of active vs passive scans, allowed protocols, etc. I don't know enough about 802.11h to know
> > what data will be required.
> 
> I've dealt with all this except for the active/passive scan stuff.
> Besides using mac80211's ieee80211_regulatory_map() as documentation
> for this not sure where else to find more information on it.
> 
> > 2. Accumulate the necessary regulatory data for the world. I found a source for such information.
> > Although its price (2500 euro) was a significant problem, the NDA that went with it was a show
> > stopper. The diversity of regulations is much greater than I expected. Although, I had only
> > collected data on roughly half the countries in the ISO 3166 country codes, I had found 12 distinct
> > sets of rules for the 2.4 GHz band and 17 sets in the 5 GHz bands, without any 802.11h information.
> 
> My source for this information has been standard cisco PDF docs lying
> around and the Atheros openhal -- this is pretty outdated though. If
> we put this in userland and XML'ize it we can let people patch at
> will.
> 
> > 3. Decide on how to store this information within mac80211.
> 
> I think cfg80211 should essentially have the current
> ieee80211_regdomain and then have cfg80211 do all the necessary checks
> which switching channels or trying to switch power.
> 
> > 4. Decide on the structure of the ASCII database and the means of communication between the daemon
> > and the kernel.
> 
> Here's some ideas:
> 
> * Kernel adopts default "world" regdomain supported by the kernel
> * User logs in, uses network-manager/wpa_supplicant/foo-app to select
> regdomain bar
> * Userspace app talks to the kernel via nl80211 to update
> ieee80211_regdomain db with regdomain data collected from userspace
> for regdomain bar.
> * Userspace app talks to the kernel via nl80211 to update cfg80211 to
> switch to regdomain in its config
> 
> > 5. Prepare the data file and code the userspace and kernel components.
> >
> > 6. Other....
> >
> > I welcome your comments.
> 
> Besides having cfg80211 speak regulatory domains another idea is to
> have a central frequency broker in the kernel so that besides just
> working as a frequency broker for 802.11 regulatory compliance it can
> also enhance interoperability between the different supported radio
> types -- 802.11, bluetooth, ultrawideband (and any other that is added
> to the kernel). This idea is still under development:
> 
> http://linuxwireless.org/en/developers/FrequencyBroker
> 
>   Luis
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

