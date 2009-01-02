Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxm.seznam.cz ([77.75.72.45]:38545 "EHLO mxm.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031AbZABMIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 07:08:52 -0500
Cc: =?us-ascii?Q?Michael=20Green?= <Michael.Green@Atheros.com>,
	linux-wireless@vger.kernel.org,
	=?us-ascii?Q?Luis=20R=2E=20Rodriguez?= <mcgrof@gmail.com>
In-Reply-To: <15B47C78534E094AA9A41F58FB8D74F3D777A7B566@SC1EXMB-MBCL.global.atheros.com>
Date: Fri, 02 Jan 2009 13:08:35 +0100 (CET)
To: linville@tuxdriver.com
From: =?iso-8859-2?Q?Carlos=20Lau=E9?= <CarlosL@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20wireless=2Dregdb=3A=20Update=20regulatory=20rules=20for=20Czech=20Republic=20=28CZ=29=20on=205GHz?=
Mime-Version: 1.0
Message-Id: <595.1121-30784-123553691-1230898115@seznam.cz> (sfid-20090102_130909_809975_F9B6E190)
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Sorry for my late reply.

On the Czech regulatory's website, they have a page deliberately speaki=
ng about usage of 5.725-5.850GHz frequencies.=20
 "V oblasti 5 GHz je mo=C5=BEn=C3=BD provoz podle VO-R/12/08.2005-34 a =
VO-R/10/03.2007-4 v p=C3=A1smu 5,15=E2=80=935,35 GHz (pouze uvnit=C5=99=
 budov), v p=C3=A1smu 5,470=E2=80=935,725 GHz (standard IEEE 802.11a) a=
 s mal=C3=BDm v=C3=BDkonem (25 mW e.i.r.p.) t=C3=A9=C5=BE v p=C3=A1smu =
5,725=E2=80=935,875 GHz.".=20
The last part means "with small output power (25mW e.i.r.p.) also in th=
e 5,725=E2=80=935,875 GHz frequency range."
 On the VO-R/10/03.2007-4 they also state that those frequencies are IS=
M, but maximum allowed e.i.r.p. is 25mW.=20

I don't know if tthis is compliant with EN301 893 or other EU laws.

So for now we should let those dubious frequencies off the table.
Also, let's do not penalize ourselves by 3dB, I've noted that, for othe=
r EU countries, the power limit is the highest allowed (Thanks Luis for=
 explaining what  "TPC compliant" means).=20

I'm sending the patch in the next e-mail.

Carlos

> ------------ P=C5=AFvodn=C3=AD zpr=C3=A1va ------------
> Od: Michael Green <Michael.Green@Atheros.com>
> P=C5=99edm=C4=9Bt: RE: wireless-regdb: Update regulatory rules for Cz=
ech Republic (CZ) on
> 5GHz
> Datum: 04.12.2008 22:27:26
> ----------------------------------------
> Thanks Luis,
>=20
> The VO_R_10_03_2007_4.pdf shows 5.725-5.850 (and also 2.4-2.483) unde=
r SRD rules
> (Short range device) like for wireless microphones, radio control toy=
s and
> similar. That's why the tx limit is 25mW EIRP.  You will see similar =
in many
> other European and global frequency tables.   This is not used for WL=
AN
> operation.  Some non-European countries do have ISM band (5.725-5.850=
) included
> in their frequency table. Although not specifically for WLAN use, we =
do in those
> cases enable this upper band for possible use by APs, since the power=
 limits are
> usually 1W or more.  But trust me, for Europe in this band, we should=
 not enable
> this band for any 802.11 product type. This is already reflected in t=
he CRDA
> tables for all the countries. So nothing new here.
>=20
>=20
> The VO_R_12_08_2005_34.pdf doc clearly shows the WLAN rules in the ta=
ble that
> you referred.  These match up to the usual rules frequency table publ=
ished by
> other EU countries and the limits follow the EN301 893 spec.  It's al=
l good.=20
> The channel settings for this country should be same as used for all =
the other
> European countries (i.e. 5.15-5.35 & 5.47-5.725 with DFS/TPC).
>=20
> The tx power levels are worth discussing more.  Even though the Europ=
ean
> countries are harmonized on EN301 893 which enforces 200mW EIRP in 5.=
15-5.35 and
> 1W EIRP in 5.470-5.725, vendors must not blindly set new hardware to =
transmit at
> these upper limits.
>=20
> Each board design must undergo conformance testing to the applicable =
RF
> conformance spec (in this case 301 893) at which time the vendor will=
 discover
> that various other tests in the conformance spec will limit the achie=
vable
> compliant tx power for that design and it's associated antennas (i.e.=
 power
> spectral density, spurious emissions, etc.  So using 200mW and 1W EIR=
P in code
> may be fine as an upper limit, fail safe, users of the code / hardwar=
e
> developers must be educated to ensure awareness that there is no univ=
ersal
> "compliant tx power" that you can assign for a country that applies t=
o all the
> different hardware out there.
>=20
> Michael Green
> Atheros Communications, Inc.
> mgreen@atheros.com
> Desk:   +1-781-400-1491
> Mobile: +1-508-380-4921
>=20
> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com]
> Sent: Thursday, December 04, 2008 3:52 PM
> To: Michael Green
> Cc: Johannes Berg; John W. Linville; Carlos Lau=C3=A9
> Subject: Re: wireless-regdb: Update regulatory rules for Czech Republ=
ic (CZ) on
> 5GHz
>=20
> On Thu, Dec 4, 2008 at 12:42 PM, Michael Green <Michael.Green@atheros=
=2Ecom>
> wrote:
> >
> > Thanks,
> >
> > a) Can someone pls email me the pdf's. I had no success trying to r=
etrieve
> from the regulator's site.
> >
> > b) I am glad to give opinion once I read the original docs.  But fo=
r now, some
> initial thoughts...
> >
> > By "automatic output power regulation" I believe you refer to what =
the
> standards call TPC (transmit power control).  For European and most o=
ther
> regions that include TPC in their rules, it is now basically a  hand =
waving at
> enforcing a true TPC feature. For Europe compliance any vendor who sh=
ows in the
> lab that the client device is capable of being set to lower tx levels=
 (even
> manually be end user), then device is considered compliant, even thou=
gh, the
> shipping product may never actually be set as such by end user.  So i=
n effect,
> no one really penalizes themselves the 3dB when testing against the t=
x power
> limit in the European specs.
> >
> > And use of 5.725-5.850 by 802.11 devices for Czech Rep. sounds dubi=
ous to me.=20
> So I look forward to seeing the docs.
> >
> > So please let me read the Czech spec you mention and I can compare =
against the
> EN301 893 which is the true pan-European conformance spec which is ge=
nerally the
> target we use for compliance in 5GHz.   Thanks for your patience.
>=20
> Michael, I've downloaded and attached them to this e-mail. They are i=
n CZ though
> so they are all jiberish to me. I'm also CC'ing the person who sent t=
he patch,
> as this conversation would probably be more productive with him invol=
ved.
>=20
>   Luis
>=20
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
