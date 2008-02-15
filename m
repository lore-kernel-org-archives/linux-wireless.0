Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:62831 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbYBOUMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 15:12:02 -0500
Message-ID: <47B5EDE5.50208@gentoo.org> (sfid-20080215_201208_639111_1A4551EC)
Date: Fri, 15 Feb 2008 19:54:13 +0000
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: cs010101@gmail.com
CC: linux-wireless@vger.kernel.org
Subject: Re: how do I fix for 802.11a in zd1211rw? and please recommand products
 for 802.11a
References: <002001c86ffa$6921f780$020aa8c0@39fb6b6b6f434b3>
In-Reply-To: <002001c86ffa$6921f780$020aa8c0@39fb6b6b6f434b3>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

=B1=E8=BF=B5=C8=AF wrote:
> last time, I tested 3com pci card (atheros) and now testing zd1211b.
> the general product name is AG-760A.(usb dongle)
> (only for using 802.11a ad-hoc)
>=20
> I took a look at the source : zd_mac.c , zd_usb.c, etc...
> In these files, I could see the "/* FIXME for 802.11a*/ comment block=
=2E so,
> I changed 2GHZ to 5GHZ and 24GHZ to 52GHZ etc..(also with productid)

It's not quite as easy as that. In order to support 802.11a you need to=
=20
add the AL7230B RF programming code from the vendor driver, with=20
mac80211 semantics added. That's not a simple task either, but if you=20
want to give it a go, you can download the vendor driver from=20
http://zd1211.wiki.sourceforge.net/VendorDriver

You also need a AL7230B-based ZD1211B device, which I'm assuming you=20
have. Other RFs don't do 802.11a

Daniel
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
