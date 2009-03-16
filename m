Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-160-52.gdrpmi.dsl-w.verizon.net ([71.115.160.52]:56483
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZCPXDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 19:03:32 -0400
Message-ID: <49BEDABB.9090909@erley.org> (sfid-20090317_000334_970186_3E7572ED)
Date: Mon, 16 Mar 2009 19:03:23 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Andrey Yurovsky <andrey@cozybit.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rfc] Implement ath9k mesh point operation
References: <49BED464.2010904@erley.org> <45e8e6c40903161557u18133705q9e0c036c8f5367b1@mail.gmail.com>
In-Reply-To: <45e8e6c40903161557u18133705q9e0c036c8f5367b1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Yurovsky wrote:
> Hi Pat,
> 
> On Mon, Mar 16, 2009 at 3:36 PM, Pat Erley <pat-lkml@erley.org> wrote:
>> Currently, you need to trigger a scan on the mesh point interface to
>> enable beaconing.  This is the same behavior the ath5k, rt2500usb and
>> rt61pci drivers exhibit.  Is this a mac80211 design flaw, or something
>> in all of these drivers?
> 
> Are you really seeing this behavior on ath5k?  I have never seen that
> happen, if it's new then it's a regression.  rt2x00 does have this
> problem at this time.
> 
>   -Andrey

Yep, here's my lspci output and relevant dmesg messages when I load ath5k:

Atheros Communications Inc. AR5212/AR5213 Multiprotocol MAC/baseband processor (rev 01)

ath5k 0000:02:0a.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
ath5k 0000:02:0a.0: registered as 'phy5'
phy5: Selected rate control algorithm 'minstrel'
ath5k phy5: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy5: RF5112B multiband radio found (0x36)
udev: renamed network interface wlan1 to wlan3

(yes, phy5, I have a ton of wireless stuff plugged into this dev system)

and here's the procedure I use:

iw dev wlan3 del
iw phy phy5 interface add mp0 type mp mesh_id FooBarMesh
ifconfig mp0 10.0.0.5 netmask 255.255.255.0 up
(tshark on rtl8187 shows no beaconing)
iw dev mp0 scan trigger
(tshark on rtl8187 now shows beaconing)

Out of all the devices I have, only b43 seems to beacon before a scan.  Is
there a chance I need to wait like 45 seconds for beaconing to start on ath5k
like how ibss mode tries to find a peer already broadcasting before it enables
beacons?

Pat Erley
