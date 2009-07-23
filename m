Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34632 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752221AbZGWBYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 21:24:34 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: AR5523 driver - old Atheros USB
Date: Thu, 23 Jul 2009 03:24:30 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <43e72e890907211209p5142047cjf821bc536c012f24@mail.gmail.com> <20090721214219.GA25392@lst.de> <43e72e890907211703y72ffe8cdv88ba9e3c59d1b76@mail.gmail.com>
In-Reply-To: <43e72e890907211703y72ffe8cdv88ba9e3c59d1b76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200907230324.35735.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thursday 23 July 2009, Luis R. Rodriguez wrote:
> On Tue, Jul 21, 2009 at 2:42 PM, Christoph Hellwig<hch@lst.de> wrote:
> > On Tue, Jul 21, 2009 at 02:24:36PM -0700, Luis R. Rodriguez wrote:
> >> >> Hey Chris, was curious if you still had lying around the driver you
> >> >> had worked on for the old Atheros 802.11 USB device. Dan asked about
> >> >> it, seems he bought one. We at least now have specs for it and can
> >> >> provide them to interested developers. Since Dan brought this device
> >> >> up figured I'd check to see if you still had it to see if you still
> >> >> had the code and might be willing to let someone try to give a shot at
> >> >> finishing it up for inclusion. Perhaps staging?
> >> >
> >> > The code has been at http://verein.lst.de/~hch/ar5523.tgz.
> >>
> >> Sweet. How functional is this? Does it TX/RX?
> >
> > It's been quite some time.  IIRC it does TX, but can't actually see
> > any packets on RX (filter issue or something).
> 
> Sorry for the large cross post, just seeing if someone is interested
> in working on a wireless driver. The task would be to try to get
> AR5523 USB driver up to speed with mac80211 from wireless-testing and
> giving it a shot to fix remaining issues?
> 
> It seems to have compiled last for 2.6.23.

The following patch (no backwards compatibility) allows ar5523 to work on 
kernel 2.6.25, while I've started to look into the API changes required 
for 2.6.26 that isn't finished yet.

> If you're interested please remove all lists and only leave
> linux-wireless on the reply.

As long as ar5523 hasn't caught up with current wireless-testing HEAD, I'm
going to work on an out of tree version available here

	http://svn.berlios.de/svnroot/repos/fullstory/ar5523/trunk/
	svn://svn.berlios.de/fullstory/ar5523/trunk/

This contains only the *unchanged* driver files[1] required for ar5523, 
neither usb_probe.c (which only seems improve debugging), nor the required
device firmware uath-ar5523.bin. For the time being I intend to keep 
necessary changes in a separate quilt patch queue, to retain the copyright 
information for each change and to allow basic bisecting.

	http://svn.berlios.de/svnroot/repos/fullstory/ar5523/trunk/debian/patches/

For now, all of my changes concentrate on making ar5523 compatible with 
current wireless-testing, I haven't started with actually debugging the
driver yet.

Unfortunately I cannot make any promises regarding the potential time scale
of this porting, how far it'll get or if it will succeed at all, but I'd 
like to make a start and share the initial changes nevertheless. Hopefully 
this starts a broader effort to get this driver usable and eventually 
merged.

As the question about which devices are covered by ar5523 has already been
asked, I post the current annotated USB ID table for the driver[2] below.

static struct usb_device_id ar5523_id_table[] = {
	AR5523_DEVICE_UG(0x168c, 0x0001),	/* Atheros / AR5523 */
	AR5523_DEVICE_UG(0x0cf3, 0x0001),	/* Atheros2 / AR5523_1 */
	AR5523_DEVICE_UG(0x0cf3, 0x0003),	/* Atheros2 / AR5523_2 */
	AR5523_DEVICE_UX(0x0cf3, 0x0005),	/* Atheros2 / AR5523_3 */
	AR5523_DEVICE_UG(0x0d8e, 0x7801),	/* Conceptronic / AR5523_1 */
	AR5523_DEVICE_UX(0x0d8e, 0x7811),	/* Conceptronic / AR5523_2 */
	AR5523_DEVICE_UX(0x2001, 0x3a00),	/* Dlink / DWLAG132 */
	AR5523_DEVICE_UG(0x2001, 0x3a02),	/* Dlink / DWLG132 */
	AR5523_DEVICE_UX(0x2001, 0x3a04),	/* Dlink / DWLAG122 */
	AR5523_DEVICE_UG(0x1690, 0x0712),	/* Gigaset / AR5523 */
	AR5523_DEVICE_UG(0x1690, 0x0710),	/* Gigaset / SMCWUSBTG */
	AR5523_DEVICE_UG(0x16ab, 0x7801),	/* Globalsun / AR5523_1 */
	AR5523_DEVICE_UX(0x16ab, 0x7811),	/* Globalsun / AR5523_2 */
	AR5523_DEVICE_UX(0x0846, 0x4300),	/* Netgear / WG111U */
	AR5523_DEVICE_UG(0x0846, 0x4250),	/* Netgear / WG111T */
	AR5523_DEVICE_UG(0x0846, 0x5f00),	/* Netgear / WPN111 */
	AR5523_DEVICE_UG(0x157e, 0x3006),	/* Umedia / AR5523_1 */
	AR5523_DEVICE_UX(0x157e, 0x3205),	/* Umedia / AR5523_2 */
	AR5523_DEVICE_UG(0x157e, 0x3006),	/* Umedia / TEW444UBEU */
	AR5523_DEVICE_UG(0x1435, 0x0826),	/* Wistronneweb / AR5523_1 */
	AR5523_DEVICE_UX(0x1435, 0x0828),	/* Wistronneweb / AR5523_2 */
	AR5523_DEVICE_UG(0x0cde, 0x0012),	/* Zcom / AR5523 */
	AR5523_DEVICE_UG(0x1385, 0x4250),	/* Netgear3 / WG111T (2) */
	{ }
};
MODULE_DEVICE_TABLE(usb, ar5523_id_table);

ar5523 is also known as ar5005UG (802.11b/g) or ar5006UX (802.11a/b/g), as
such the hardware[3] supports 54 MBit/s operations within the 2.4 GHz band 
(ar5006UX variants also in 5 GHz) and offers WPA support. 

Regards
	Stefan Lippers-Hollmann

[1]	Please ignore the initial Debian packaging under debian/, it just helps
	me with testing on obsolete kernels in order to forward port the driver.
[2]	http://svn.berlios.de/svnroot/repos/fullstory/ar5523/trunk/ar5523.c
[3]	http://www.atheros.com/pt/AR5005UG.htm
	http://www.atheros.com/pt/AR5005UX.htm

-- 

For compatibilioty with kernel 2.6.25, apply the equivalent of:

#commit 32bfd35d4b63bd63de4bb0d791ef049c3c868726
#Author: Johannes Berg <johannes@sipsolutions.net>
#Date:   Wed Dec 19 01:31:26 2007 +0100
#
#    mac80211: dont use interface indices in drivers
#
#    This patch gets rid of the if_id stuff where possible in favour of
#    a new per-virtual-interface structure "struct ieee80211_vif". This
#    structure is located at the end of the per-interface structure and
#    contains a variable length driver-use data area.
#
#    This has two advantages:
#     * removes the need to look up interfaces by if_id, this is better
#       for working with network namespaces and performance
#     * allows drivers to store and retrieve per-interface data without
#       having to allocate own lists/hash tables
#
#    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
#    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Changes-licensed-under: ISC
Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

--- a/ar5523.c
+++ b/ar5523.c
@@ -966,7 +966,8 @@ static int ar5523_config(struct ieee8021
 	return 0;
 }
 
-static int ar5523_config_interface(struct ieee80211_hw *hw, int if_id,
+static int ar5523_config_interface(struct ieee80211_hw *hw,
+		struct ieee80211_vif *vif,
 		struct ieee80211_if_conf *ifconf)
 {
 	struct ar5523 *ar = hw->priv;
