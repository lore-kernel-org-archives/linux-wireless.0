Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4668 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbZLEAaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 19:30:13 -0500
From: "Howard Harte" <hharte@broadcom.com>
To: =?iso-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5polish@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Greg KH" <greg@kroah.com>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	"Henry Ptasinski" <henryp@broadcom.com>
Date: Fri, 4 Dec 2009 16:30:03 -0800
Subject: RE: Broadcom Android bcm4329 open driver
Message-ID: <4F34EB345A846E42B8D432EA578382CC1058921986@SJEXCHCCR01.corp.ad.broadcom.com>
References: <43e72e890912031544j7cb8bffav1c1c7d016e740175@mail.gmail.com>
 <14b026160912040010k5dda243bra0abd9be4e275918@mail.gmail.com>
In-Reply-To: <14b026160912040010k5dda243bra0abd9be4e275918@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The drivers posted to the Android GIT repository are for the Broadcom embedded WLAN/BT combo chips.  Currently, these include BCM4325 and BCM4329.  They are similar, but have slightly different drivers.  These are not WLAN NIC chips like those found in many laptops/netbooks today.  Instead, they do have their own CPU that handles the WLAN details.  The references to PCI in the driver are for the "Broadcom SDIO Stack" that has been deprecated for Linux in favor of the SD/MMC stack, and for the SPI-mode driver, which used a PCI to SPI controller card.

While this driver is currently used for Android, there is nothing that precludes its use on non-Android flavors of Linux.

-Howard



-----Original Message-----
From: Rafa³ Mi³ecki [mailto:zajec5polish@gmail.com] 
Sent: Friday, December 04, 2009 12:10 AM
To: Luis R. Rodriguez
Cc: linux-wireless; Greg KH; Howard Harte; bcm43xx-dev; Henry Ptasinski
Subject: Re: Broadcom Android bcm4329 open driver

2009/12/4 Luis R. Rodriguez <mcgrof@gmail.com>:
> In case you haven't seen this yet, Broadcom has an open (!) driver on 
> the Android git tree with support for SDIO/SPI for  bcm4329.
>
> http://tinyurl.com/broadcom-android-bcm4329
>
> The commit log entry dated 2009-10-29 states:
>
> Linux WLAN driver for BCM4329 - Low-Power 802.11n with Bluetooth(R) 
> 2.1+ EDR and FM (Tx and Rx)

This driver was already noticed in January:
http://lists.berlios.de/pipermail/bcm43xx-dev/2009-January/thread.html#5066
See Thomas's response for details about driver:
http://lists.berlios.de/pipermail/bcm43xx-dev/2009-January/005072.html

So that device controlled by SDIO has it's own CPU which cares of wireless. As you noticed there is also SPI but is this used anywhere except Android devices? Driver seems to check PCI buses just to find SPI.

--
Rafa³


