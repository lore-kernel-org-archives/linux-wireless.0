Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:55846 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab1I2IhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 04:37:13 -0400
Date: Thu, 29 Sep 2011 10:37:06 +0200 (CEST)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Boris Presman <boris.presman@ti.com>,
	Assaf Azulay <assaf@ti.com>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Arun Venkataraman <arunvenk@qca.qualcomm.com>
Message-ID: <1125417094.1836.1317285426615.JavaMail.root@idefix> (sfid-20110929_103720_075387_765563F8)
In-Reply-To: <CAB=NE6U6qmYbvHPTWGTqOdXtuxbKYbUzZXNiE6POOX9QZNRWAg@mail.gmail.com>
Subject: Re: Regulatory revamp status
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the update.

To me it looks not reasonable to mix in between the two approaches: either we assume countrycodes use the same DFS region for all channels, or each channel/band needs to have its own. Otherwise I feel that a DFS region bitmap would give a semi-flexible compromise that might end up being insufficient to represent some fancy countrycodes.


Zefir

----- Original Message -----
> From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
> To: "Zefir Kurtisi" <zefir.kurtisi@neratec.com>, "Michael Green" <green@qca.qualcomm.com>, "David Quan"
> <dquan@qca.qualcomm.com>, "Kevin Hayes" <hayes@qca.qualcomm.com>, "Arun Venkataraman" <arunvenk@qca.qualcomm.com>
> Cc: "linux-wireless" <linux-wireless@vger.kernel.org>, "Boris Presman" <boris.presman@ti.com>, "Assaf Azulay"
> <assaf@ti.com>
> Sent: Wednesday, 28 September, 2011 9:52:15 PM
> Subject: Re: Regulatory revamp status
> On Wed, Sep 28, 2011 at 8:45 AM, Zefir Kurtisi
> <zefir.kurtisi@neratec.com> wrote:
> > Hello Luis,
> >
> > I am referring to your announcement for a regulatory revamp at the
> > LinuxWireless
> > summit in Vancouver and the patches to add DFS information to CRDA
> > you
> > proposed quite some time ago in [1].
> >
> > For the integration of DFS that is currently being worked out by TI,
> > we will need to have
> > the DFS regulatory domain for the selected countrycode available --
> > that basically was
> > implemented with the named patch set.
> 
> Yup, there was one pending item on that and it was to determine
> whether or not a country can have different DFS regions for different
> frequency bands. If this is true this also implies that a country can
> have multiple DFS regions. I have found one country in our internal
> regulatory updates which maps Bulgaria to different DFS regions and
> have asked our regulatory folks about this. This seems odd to me and
> I'd prefer to stick to one DFS region entirely for one country, but if
> in the future we forsee DFS regions to be band specific this may
> complicate things and we should address this now. Can you tell me if
> at TI you have no multiple DFS regions for one country ? Do you guys
> have Bulgaria mapping to one DFS region?
> 
> > Could you please give some info on the status of the regulatory
> > revamp and particularly if
> > the proposed DFS information will be part of it?
> 
> You should consider DFS integration into wireless-regdb as independent
> of the regulatory revamp given that we have 16 bits we can use to
> extend wireless-regdb for any future capabilities without having to
> restructure the format of the file to require a different version of
> crda. So DFS can be added as-is today. Updates below on the regulatory
> revamp though and DFS.
> 
> I'm chugging along the regulatory revamp slowly given the questions
> that come up with it require consulting with several different people.
> The latest piece I reviewed was TPC and for that it seems we already
> take into account the 3 dB difference into account into
> wireless-regdb, however this can be further optimized if TPC is
> implemented -- but implementing TPC is device specific in that the TPC
> reports and how you use them can vary depending on the device. When
> you send TPC report requests will also vary. In short I've latest
> determined to stick to what we have today and assume we'll always be
> reducing the 3 dB in power built-in already into the wireless-regdb
> power for each country where needed. This assumes no proper TPC
> implementation. It would still be nice to know when a band requires
> TPC though to enable vendors to implement TPC and reduce power not by
> 3 dB but by whatever metrics they come up with. Given that 3 dB seems
> to be the only required change we likely could stick to that as the
> assumed max value and just require a TPC flag, and if the band has
> this flag allow the driver / stack / etc to add 3 dB more to power if
> it implements TPC. The only problem with this is we'd assume alway a
> static 3 dB. Another possibility is to use a u8 value here to
> represent the deducted tx power, instead of a bit value for a flag.
> 
> Technically speaking we can support both DFS and TPC in the current
> file format for wireless-regdb, we have 16 bits left, we could leave
> u8 for DFS region as a bitmask (left to determine about the multiple
> DFS regions) and u8 for the tx power adaptation for TPC. Thoughts?
> 
> > One detail that came up in the discussion to
> > your patches was whether DFS regulatory domains are constant for a
> > countrycode or might
> > differ between bands. Has this been clarified meanwhile?
> 
> Not yet! I've asked for input a while ago and today as well. What do
> you guys think?
> 
> Luis
