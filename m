Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34680 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751Ab2CLWcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 18:32:31 -0400
Received: by bkcik5 with SMTP id ik5so3024049bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 15:32:29 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
Date: Mon, 12 Mar 2012 23:32:16 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4F5E7031.4000401@candelatech.com>
In-Reply-To: <4F5E7031.4000401@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201203122332.16325.chunkeey@googlemail.com> (sfid-20120312_233245_048112_668CF82C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, March 12, 2012 10:52:49 PM Ben Greear wrote:
> It seems we bought a Lenovo laptop that has a BIOS lock where it will only
> support certain wifi NICs based on the pci-id.  It came with an Intel
> NIC, so at least that ID must work...
> 
> One way around this might be to over-write the pci-id of an Atheros NIC
> in it's non-volatile storage to make it look like an Intel, at least until
> the kernel boots.
> 
> Then maybe add some sort of ugly code to force the Atheros driver
> to manage this Intel pci-id (and probably disable the same pci-id in
> the Intel driver).
> 
> Has anyone tried doing anything like this?  Any suggestions for a cleaner
> way to go about this?
Been down this road before. First an old X41 Tablet and more recently a HP
dv6 laptop.

I think if you manage to reprogram the cards pciids then you are more than
halfway there. Because theoretically, you can get away with adding the fake
intel id to ath9k through sysfs: 

echo "8086 dead" > /sys/bus/pci/drivers/ath9k/new_id
[for more information, take a look at the new_id sysfs interface]
(Of course, you'll have to get rid of the intel driver first)

That said, in both cases I risked flashing a modded bios. So whitelists are
no longer a problem. 

PS: AFAIK [Maybe some QCA dev can verify this]: all AR9300+ have OTP ROMs
for the pciids. So you might want to get an older AR9280 for your laptop.
