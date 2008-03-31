Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5997 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbYCaXWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 19:22:33 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: problem with iwl4965 and kernel 2.6.24.4
Date: Mon, 31 Mar 2008 16:20:22 -0700
Message-ID: <D936D925018D154694D8A362EEB08920040FA488@orsmsx416.amr.corp.intel.com> (sfid-20080401_002256_848312_CAA66D54)
In-Reply-To: <183c1cc10803311502u1ae78f5cme9e05f0100c4a10f@mail.gmail.com>
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com> <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com> <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com> <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com> <183c1cc10803262027k4c40386v767b2f9c79945deb@mail.gmail.com> <183c1cc10803270741r66896d88q15614af05a4142e6@mail.gmail.com> <D936D925018D154694D8A362EEB08920040BC0B8@orsmsx416.amr.corp.intel.com> <183c1cc10803301935p16647709u837f3fb3377c687d@mail.gmail.com> <D936D925018D154694D8A362EEB08920040FA1C9@orsmsx416.amr.corp.intel.com> <183c1cc10803311502u1ae78f5cme9e05f0100c4a10f@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John Goulah" <jgoulah@gmail.com>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, March 31, 2008 3:02 PM, John Goulah  wrote:

> I have to use both.  I have to use iwconfig to pick my essid and
> access point, and I use wpa_supplicant to setup the encryption tunnel.
> Then I dhclient the IP address.    In previous wireless experience,
> once I've set the essid , it automatically associates to the access
> point (at least I can see that the MAC address is defined when I run
> iwconfig).  That does not happen with this driver- only "Not
> Associated" or "Invalid". Unfortunately debug for these cases isn't
> spitting any info.  I've been setting my access point mac address
> specifically with "iwconfig wlan0 ap <MAC>"   -before- running
> wpa_supplicant since I thought I had to be associated before running
> wpa_supplicant but it sounds like you are saying otherwise, so I'll
> try that tonight and then submit my findings in a bug.   If something
> I've said sounds completely wrong let me know.

It should not be necessary to use both iwconfig and wpa_supplicant.
wpa_supplicant will take care of the association for you. 

You will need to bring the interface up (ifconfig wlan0 up) before you
run wpa_supplicant.

If you run into issues, please also send wpa_supplicant's configuration
and debug log.

Thanks

Reinette
