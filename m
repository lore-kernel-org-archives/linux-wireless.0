Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21141 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946219AbXBIIdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 03:33:38 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, marvell8385-devel@linuxtogo.org,
	frankh@marvell.com, rchokshi@marvell.com
Subject: How to start with a Marvell driver (non-USB, non-OLPC)
Date: Fri, 9 Feb 2007 08:58:26 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702090858.26294.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all !

This mail is an attempt to get some feedback about the way we 
should go :-)   "We" are several people interested in 802.11bg 
cards in Compact-Flash format with an Marvell 8385 (AFAIK) chip. 
See the list of people at 
http://projects.linuxtogo.org/projects/marvell8385/   A driver 
for this cards would be quite nice for PDAs and other embedded 
Linux systems.



Two months ago I sent an e-mail to Marvell for support, or at 
least to put me in contact with the product manager. There was 
no response. Maybe they don't care for sales.

However, Marvell released a GPL driver for the OLPC project, 
which is now in Linux mainline. This driver is for a different 
chip (8388 AFAIK), a different firmware (with Mesh capability) 
and a different host interface (USB). During the last month the 
libertas driver got rid of more and more code that applied to 
non-8388, non-USB, non-mesh-firmware versions of the Libertas 
chip set family. Those cleanups made the in-kernel libertas 
driver more and more unusable for the cards that I have in mind. 
They did not only clean up, they also added their specific stuff 
for their mesh solution.

I think the biggest problem here is the firmware. The OLPC people 
have a special firmware for their USB dongle, which is not used 
in other chips, so a driver that has been heavily adapted to 
this firmware isn't easy to mangle to a different firmware.

Fortunately, because of the involvement of Marvell into the OLPC 
project, they posted in a public mailing list reference 
documenentation about their firmware !  :-)



So, what I (and several other people, see want to take the OLPC 
driver, get rid of the USB stuff, add in back stuff that is 
needed for CF-Card, add mangle and treat this until we get 
something that is working.





Now, linux-2.6.20 still has Softmac. Some projects, like the 
bcm43xx, are very lively in the softwac area. d80211 is supposed 
to come into the kernel since months. I guess it's an endless 
task?  Will it ever arive?  What 80211 version should we use if 
our aim is inclusion in the stock kernel?  We don't plan, like 
so many other project, divide our working time into a year-long 
maintainance of two 80211 versions.
