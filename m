Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44467 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0JBMgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 08:36:43 -0400
Received: by ewy23 with SMTP id 23so1487130ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 05:36:41 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 2 Oct 2010 13:36:41 +0100
Message-ID: <AANLkTin5zuxUY9ySYKrT9qD6cgV7eb7UhCjDYFzTUTeU@mail.gmail.com>
Subject: OLPC XO-1 rfkill driver design
From: Daniel Drake <dsd@laptop.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I will be working on getting an OLPC XO-1 rfkill driver upstream and
am looking for input on the basic design of the driver.

The XO-specific embedded controller provides a command which cuts
power to the wlan chip (a Marvell USB8388 that is powered by the
libertas driver), causing it to fall off the USB bus entirely, and
another command to turn it on again.

The embedded controller is obviously not hotpluggable and there can
only ever be 1 in a system.

The actual rfkilling is dead simple:

static int olpc_rfkill_set_block(void *data, bool blocked)
{
	unsigned char cmd;

	if (blocked)
		cmd = EC_WLAN_ENTER_RESET;
	else
		cmd = EC_WLAN_LEAVE_RESET;

	return olpc_ec_cmd(cmd, NULL, 0, NULL, 0);
}

olpc_ec_cmd() is provided by already-upstream arch/x86/kernel/olpc.c

My question is: what should the basic form of the rfkill driver be?
I have three possible designs in mind:

A)
A module where the module_init logic is as follows:
 1. Check that we're running on OLPC XO-1 (using the functions
provided by CONFIG_OLPC olpc.c)
 2. Call rfkill_alloc()

or

B)
A module where module_init registers a platform driver
arch/x86/kernel/olpc.c  calls platform_device_register() and
platform_add_devices() on XO-1
This causes probe to be called within the rfkill driver which calls
rfkill_alloc()

or

(C)
A module where module_init registers a platform driver, checks that
we're running on OLPC XO-1, then calls platform_device_register() and
platform_add_devices()
This causes probe to be called which calls rfkill_alloc()


(B) seems to follow closest what is described in
Documentation/driver-model/platform.txt, but (I think) it has the
disadvantage that it can't become a modular driver, since
arch/x86/kernel/olpc.c would always attempt to probe the platform
device early during boot, and the module wouldn't be available to be
loaded til later.

(C) doesn't have the same problem, but goes against the platform.txt
documentation which says that the platform setup code should be the
thing that registers the presence device

(A) is really simple


My instinct is to go for (A), but I can't find any other drivers that
follow the same structure -- even though they could do. Perhaps
there's a reason that I'm missing...

Thoughts?

cheers,
Daniel
