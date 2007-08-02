Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:38724 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757525AbXHBR0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 13:26:08 -0400
Message-ID: <46B213A3.1040700@lwfinger.net>
Date: Thu, 02 Aug 2007 12:25:55 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Erik Mouw <mouw@nl.linux.org>
CC: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/10] Port of bcm43xx from softmac to mac80211
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <200708021807.20649.mb@bu3sch.de> <20070802164548.GF13704@gateway.home>
In-Reply-To: <20070802164548.GF13704@gateway.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Mouw wrote:
> On Thu, Aug 02, 2007 at 06:07:20PM +0200, Michael Buesch wrote:
>> On Thursday 02 August 2007, Larry Finger wrote:
>>> Driver bcm43xx is being ported from using SoftMAC to mac80211. For rewiew,
>>> this series of patches is being prepared; however, the final patch will be
>>> a single entity so that compilation during bisection will not break.
> 
> [...]
> 
>> I don't really want to review 10 huge patches that replace
>> X by Y. If the code works, fine. Go for it. You get my ACK, if it works
>> on the hardware where it matters. ;)
> 
> It might be a good idea to have two drivers for the same hardware so
> it's easier to figure out if something broke or not. My linksys bcm4318
> cardbus card works nice with 2.6.22 and I wouldn't like to lose that
> functionality.
> 
> 
> Just my 0.02 EUR,

It turns out that the new port works as well as the current driver, has the ability to adjust the 
transmit rate depending on conditions, and is free of the locking bugs of SoftMAC. There are, of 
course, bugs in mac80211, but at least they will be fixed. There is very little maintenance on SoftMAC.

There will still be 2 drivers as Michael's version with V4 firmware will still be in the development 
tree, and it will be merged to mainstream when ready. As his version will not support 802.11b-only 
devices (no support in that firmware), this port will then be gutted of 802.11g devices. I can 
assure you that this will not happen until the V4 driver functions at least as well as bcm43xx does now.

Larry
