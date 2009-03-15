Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:61242 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZCONpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 09:45:08 -0400
Received: by ewy25 with SMTP id 25so3152562ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2009 06:45:03 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Antonio Marques <froz@icix.org>
Subject: Re: rt2x00 mesh support
Date: Sun, 15 Mar 2009 14:45:01 +0100
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <467E98EC-F5B1-4D79-914E-35E021125E37@icix.org> <594B4EB2-FE87-4756-B016-C83083EF415B@icix.org>
In-Reply-To: <594B4EB2-FE87-4756-B016-C83083EF415B@icix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903151445.01344.IvDoorn@gmail.com> (sfid-20090315_144513_647691_2C69D3BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 15 March 2009, Antonio Marques wrote:
> Upon further investigation, beaconing does not work after configuring
> an interface in mesh point mode but running 'iwlist mesh scan'
> triggers something in the driver that enables beaconing.
> After executing this command beacons are generated and correctly
> received at other nodes.

Thats odd, but very interesting :)
Could you enable debugfs and CONFIG_RT2X00_LIB_DEBUGFS and
use the script from http://kernel.org/pub/linux/kernel/people/ivd/tools=
/rt2x00_regdump.sh
to create a register dump before running 'iwlist mesh scan' and afterwa=
rds.
(So basically when beaconing is broken and when it is working).

Thanks,

Ivo

> This behaviour is present using both rt73usb and rt2500pci based card=
s.
> Once beaconing is triggered the interface works as expected and mesh
> peer links are automatically established. I assume this is a bug in =20
> the rt2x00
> driver. Is there anything I can do to help debug this problem?
>=20
> Thanks,
> Antonio Marques
>=20
> On Jan 24, 2009, at 11:40 , Ant=F3nio Marques wrote:
> > Ok. I didn't realize the driver was broken and the issue wasn't =20
> > specific
> > to mesh support. I hope the driver maintainers can solve this soon.
> >
> > Thanks,
> > Antonio Marques
> >
> > On Jan 23, 2009, at 19:02 , Andrey Yurovsky wrote:
> >> Hi Antonio.  As I understand it, beaconing is currently broken in
> >> rt2x00 (it used to work in the past).  This means that, until the
> >> device can send beacons again, it won't be able to do mesh (or AP =
or
> >> IBSS).  However the commit in question at least sets up the driver=
 to
> >> support mesh as soon as beaconing works again.
> >>
> >> On Fri, Jan 23, 2009 at 10:58 AM, Antonio Marques <froz@icix.org> =
=20
> >> wrote:
> >>> Hi,
> >>>
> >>> I have been trying to setup a mesh network using the 802.11s =20
> >>> stack, but
> >>> unfortunately the only hardware that I have readily available are=
 =20
> >>> rt2x00
> >>> usb dongles and an ath5k mini-pci card. Since support for rt2x00
> >>> driver is listed on o11s.org as being in development, what is the=
 =20
> >>> current
> >>> status
> >>> of mesh support for this driver?
> >>>
> >>> I see recent commit activity such as
> >>> fdc26201323eb8ba543ac5624f8d71e55b6f7352,
> >>> "rt2x00: Add mesh support" but I am still unable to establish mes=
h =20
> >>> links
> >>> using
> >>> rt2x00 devices. An rt2x00 device can see the ath5k device =20
> >>> according to
> >>> 'iw dev mesh station dump', but the link state never changes to =20
> >>> ESTAB.
> >>>
> >>> Thanks,
> >>> Antonio Marques
> >>>
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-=20
> >>> wireless" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> >>>
> >
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
