Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:10632 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZBIGJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 01:09:50 -0500
Received: by wa-out-1112.google.com with SMTP id v33so841774wah.21
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2009 22:09:49 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 8 Feb 2009 23:09:49 -0700
Message-ID: <f9d2a5e10902082209h33afe4dey4930f23c3f178bc8@mail.gmail.com> (sfid-20090209_070954_624518_B124C56E)
Subject: ath5k LEDs on Acer Ferrari 5000 laptop
From: Russ Dill <russ.dill@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>,
	Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an Acer Ferrari 5000 laptop with an ath5k wireless chipset. It
has an LED built into the rfkill switch on the front of the laptop. I
testing various settings within the ath5k driver an the led is on pin
1 (sc->led_pin = 1) and it is active high (sc->led_on).

07:00.0 Ethernet controller: Atheros Communications Inc. AR242x
802.11abg Wireless PCI Express Adapter (rev 01)
	Subsystem: AMBIT Microsystem Corp. Device 0422
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at b0200000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: ath5k
	Kernel modules: ath5k, ath_pci

07:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x
802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
	Subsystem: AMBIT Microsystem Corp. Device [1468:0422]

So its an AMBIT subvendor ID, which conflicts with the "emachines
notebooks with AMBIT subsystem" led assignment which selects all AMBIT
subvendor ID machines. Firstly, how would I best go about adding this
quirk, and second, the code references rx and tx LEDs, but there is
only one LED on the laptop and its meant to be an rfkill LED. I can go
and echo rfkill0 to both trigger files in /sys, but it seems like
there should be a better way.
