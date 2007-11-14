Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:61194 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763157AbXKNS6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 13:58:35 -0500
Received: by rn-out-0102.google.com with SMTP id s46so457547rnb
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 10:58:34 -0800 (PST)
Message-ID: <43e72e890711141058l722015d0x6a214f2754ad2e4a@mail.gmail.com> (sfid-20071114_185912_897140_898A4283)
Date: Wed, 14 Nov 2007 13:58:30 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Subject: Linux wireless 802.11n progress
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to start grouping information about Linux 802.11n support.
Work is underway on integrating 802.11n support onto mac80211 now
thanks to Intel's efforts. Besides that we will still then need
specific driver support. Unfortunately most hardware requires reverse
engineering efforts at the moment. In review it seems our best options
for support for Linux so far seems to be Intel and Ralink as the
vendor has provided support. Kudos to them!!! Let me review some
options we have, I'll post this on the wiki after recompiling some
more information. If you can help fill in the gaps that'd be greatly
appreciated.

---------------------

Requires reverse engineering efforts:

* Atheros

I believe we can get the card at least to work in compatibility mode
with a bit of effort in ath5k. Nick told he had some EEPROM info but
the baseband MAC is completely different and I think the radios are
too. The 802.11n specific stuff will be a challenge though as we'd
need to figure out how to enable 802.11n on MadWifi first. Support for
802.11n with MadWifi may come in the future. It seems the HAL already
may have support for it. MadWifi's net80211 stack doesn't seem to yet
have High Throughput support but FreeBSD's net80211 stack does seem to
have it though. It may be worth to just try to move cook up a new
driver to use the HAL with mac80211 now that we know what the HAL may
be doing more. Whatever will help us reverse engineer more.

I have a PCI AR5416 and will poke at it. Hardware can be readily found
- D-Link DWA-552 worked for us. This is a PCI card. Not sure what
other form factors this comes in.

* Broadcom - not sure how common this hardware is, not sure what form
factors these come in, and not sure what the driver progress is.

* Airgo

Driver: http://git.sipsolutions.net/agnx.git
Specs: http://airgo.wdwconsulting.net/mymoin
Devices: Beklin F5d8010, Netgear wgm511, wgm124, linksys wrt54gx,
Netgear Wpnt511

agnx driver can TX/RX for AGN100 devices for PCI devices. Cardbus card
not working for some reason. We'll try to help with this driver.

Cardbus card:

http://www.zipzoomfly.com/jsp/ProductDetail.jsp?ProductCode=251852

You can pull out AGN100 MiniPCI cards from these APs:

http://www.google.com/products?q=linksys+WRT54GX&btnG=Search+Products
http://www.google.com/products?q=BELKIN+F5d8230&btnG=Search+Products

If you want to try to add AGN300 support you can try getting this AP
and pulling its card out:

http://www.google.com/products?q=WPNT511&btnG=Search&show=dd

------------------

Vendor supported drivers:

Intel:

iwl4965 - Kudos to Intel for their support!!! Work is on the way to
integrate proper 802.11n work with mac80211. This is perhaps our best
supported device. I am only aware of PCI-express cards and PCI Express
Half Mini Card form factor. I don't think there are any miniPCI cards
out there.

* Ralink

I'd like to give Ralink kudos for their support for Linux. Thank you
Ralink!!! They have provided a vendor GPL driver which needs to get
ported to mac80211. This driver now needs to be ported to mac80211 but
rt2x00 guys have been busy on focusing more on the stability of
current rt2x00 drivers. The driver effort could use some help. It
should be integrated with the rest of the rt2x00 driver effort if
possible. MiniPCI cards are mostly only found on the laptops already
shipped. You can also try to get some through Martin's minipci.biz.
Other form factors I think exist are Cardbus and PCI. Not too sure
what other form factors are available.

Other possible devices Ralink devices which may work with this driver
(not confirmed):

http://www.greennet.ca/shop/product_info.php?ref=3&currency=USD&products_id=15517

Vendor driver: http://www.ralinktech.com.tw/data/drivers/2007_0821_RT2860_Linux_STA_v1.3.0.0.tgz

Ralink 802.11n (RT2770F) also is shipped with the cool Asus
motherboard that has Splashtop:

http://www.phoronix.com/scan.php?page=article&item=869&num=5

-------------

Not too sure what's up with these vendors. Anyone have any information?

* Realtek

I can't find anything.

* Marvel

All I have found is that they do have 802.11n solutions (TopDog):

http://www.marvell.com/products/wireless/topdog.jsp

* Conexant:

The best I can find is that they are "developing 802.11n solutions for
high-performance, embedded applications":

http://www.conexant.com/products/entry.jsp?id=30

and "Conexant tells Light Reading it integrated Atheros's 802.11n
technology into its own VDSL2-gateway chips four months ago. It's just
that Conexant never formally announced this."

http://www.lightreading.com/document.asp?doc_id=130123

If any of you have further information about other vendors or any of
the above please provide some details.

  Luis
