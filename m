Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758092AbYCSTnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:22 -0400
Subject: Re: [RFC] libertas: change quality calculation
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1205941097.4169.23.camel@localhost.localdomain>
References: <200803181510.52726.hs4233@mail.mn-solutions.de>
	 <1205937928.26119.29.camel@localhost.localdomain>
	 <200803191625.39210.hs4233@mail.mn-solutions.de>
	 <1205941097.4169.23.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Wed, 19 Mar 2008 11:41:54 -0400
Message-Id: <1205941314.4169.31.camel@localhost.localdomain> (sfid-20080319_194521_612042_8846E04E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-19 at 11:38 -0400, Dan Williams wrote:
> On Wed, 2008-03-19 at 16:25 +0100, Holger Schurig wrote:
> > > > I also found that the average noise floor is -86 dBm, not
> > > > -96 dBm. So I changed this constant. Maybe this is wrong,
> > > > what values do your cards report?
> > >
> > > When possible, we should use a window-ed average of the cards
> > > reported noise from beacons or received frames instead of a
> > > constant, that's a further improvement though.
> >=20
> > The changed value of MRVDRV_NF_DEFAULT_SCAN_VALUE is only used to=20
> > magically conjure the missing noise value for scan results, see=20
> > my other mail about this.
> >=20
> > Okay, it's also used in the case of a failed GET_RSSI command :-)
> >=20
> > > Well, when we had the (badly) averaged array values in there,
> > > the noise floor was available to the scan reporting.
> >=20
> > Something might have been available for scan reporting, but if=20
> > this "something" made sense is a different question. See my=20
> > other mail :-)
> >=20
> > > There are tables to map RSSI -> dBm for each part which should
> > > be in the firmware spec or seen in the driver code.
> >=20
> > I didn't see such a table so far, where is it?
>=20
> See section 7.3 of the 5.1 spec:
>=20
> 7.3         RSSI and Noise Floor Support
> The firmware supports the reporting of RSSI and Noise Floor values:
> =E2=80=A2   RSSI can be derived by adding Noise Floor to SNR value
> =E2=80=A2   Noise Floor is returned in each received packet through t=
he NF field
> in the Rx Descriptor (dBm).
> =E2=80=A2   Signal Quality is determined by RSSI and SNR.
>=20
> Section 3.1 as well (Receive Packet Descriptor):
>=20
> "RSSI should be calculated in the driver as a summation of the SNR an=
d
> NF"
>=20
> So Marvell doesn't really provide a table, but we'll have to do some
> investigation here.  The RSSI is almost always a random value defined=
 by
> the manufacturer [1] or in dBm.  We're not 100% sure what Marvell is
> using here, but some investigation will show whether the value is
> actually in dBm or in some other units.  A quick check of the RSSI
> reported by the current BSS in scan results versus the output of
> GET_RSSI might show something interesting.

=46or further information, see something like:

http://www.wildpackets.com/elements/whitepapers/Converting_Signal_Stren=
gth.pdf

Dan

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
