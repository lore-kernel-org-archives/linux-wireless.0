Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webbox1416.server-home.net ([77.236.96.61]:47791 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706Ab1HWLcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 07:32:14 -0400
Message-ID: <4E538FBC.5070801@systec-electronic.com> (sfid-20110823_133217_102326_3615A61D)
Date: Tue, 23 Aug 2011 13:32:12 +0200
From: =?ISO-8859-15?Q?Daniel_Kr=FCger?=
	<daniel.krueger@systec-electronic.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, geryk@ti.com
Cc: Alexander.Stein@systec-electronic.com
Subject: Multiple instances of WL1271
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gery,

we plan to solder up to 4 WL1271 chips on our board (It will be the 
ready-to-use chip from LSR).

After a short look into the driver source code from the vanilla Linux 
kernel, we saw that the driver is not fully capable to handle multiple 
instances.

One critical issue we found are the wl12xx_set_platform_data and 
wl12xx_get_platform_data function calls. They configure the IRQ for the 
WLAN chip.

I think every WL1271 should get a separate IRQ (i.e. interrupt capable 
GPIO line). Does anyone has an idea how to configure the IRQ 
independently for each WL1271 chip? Especially on a X86 platform where 
there is no board specific configuration like on an embedded ARM target.

Another issue: every chip needs a specific NVS file (which holds the MAC 
address plus some other chip-specific settings). Currently, there is 
only one NVS file in the whole system. But it should be very easy to add 
some kind of instance number to the NVS file name to have a separate 
file for each chip.

Are there any other known issues when there are multiple WL1271 chips in 
one system?

Any help is appreciated.

cu,
   Daniel

-- 
SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Telefon  : +49 (0) 3661 6279 0
Fax      : +49 (0) 3661 6279 99
Email    : daniel.krueger@systec-electronic.com
Internet : http://www.systec-electronic.com

Managing Director   : Dipl.-Phys. Siegmar Schmidt
Commercial registry : Amtsgericht Jena, HRB 205563
