Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56369 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1FQHy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 03:54:29 -0400
Received: by ywe9 with SMTP id 9so1150867ywe.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 00:54:28 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 Jun 2011 09:54:28 +0200
Message-ID: <BANLkTi=AP7JKfuL3K+GzB_GhOw=hYmEGpg@mail.gmail.com> (sfid-20110617_095433_689090_CE4CE1FA)
Subject: disagrees about version of symbol
From: Thomas Novin <thomas@xyz.pp.se>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I was going to test the brcm80211 driver to replace the wl driver on
my gfs laptop to support a BCM4727 chip.

After doing scripts/driver-select, choosing that driver, make, make
install, make unload and them modprobe brcm80211 I get this:

Jun 17 09:43:41 jennie-laptop kernel: [ 5418.213586] cfg80211: Calling
CRDA to update world regulatory domain
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.223361] cfg80211: World
regulatory domain updated:
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.223367] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.223375] cfg80211:
(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.223382] cfg80211:
(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.223389] cfg80211:
(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.223395] cfg80211:
(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.223401] cfg80211:
(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.241140] brcm80211: module
is from the staging directory, the quality is unknown, you have been
warned.
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.241989] brcm80211:
disagrees about version of symbol ieee80211_free_hw
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.241992] brcm80211:
Unknown symbol ieee80211_free_hw (err -22)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.242128] brcm80211:
disagrees about version of symbol ieee80211_alloc_hw
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.242130] brcm80211:
Unknown symbol ieee80211_alloc_hw (err -22)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.242230] brcm80211:
disagrees about version of symbol regulatory_hint
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.242232] brcm80211:
Unknown symbol regulatory_hint (err -22)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.242316] brcm80211:
disagrees about version of symbol ieee80211_register_hw
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.242318] brcm80211:
Unknown symbol ieee80211_register_hw (err -22)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.242508] brcm80211:
disagrees about version of symbol ieee80211_tx_status_irqsafe
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.242510] brcm80211:
Unknown symbol ieee80211_tx_status_irqsafe (err -22)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.243162] brcm80211:
disagrees about version of symbol ieee80211_wake_queues
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.243164] brcm80211:
Unknown symbol ieee80211_wake_queues (err -22)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.243388] brcm80211:
disagrees about version of symbol ieee80211_stop_queues
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.243390] brcm80211:
Unknown symbol ieee80211_stop_queues (err -22)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.243541] brcm80211:
disagrees about version of symbol ieee80211_unregister_hw
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.243542] brcm80211:
Unknown symbol ieee80211_unregister_hw (err -22)
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.243812] brcm80211:
disagrees about version of symbol ieee80211_rx_irqsafe
Jun 17 09:43:41 jennie-laptop kernel: [ 5418.243814] brcm80211:
Unknown symbol ieee80211_rx_irqsafe (err -22)

If I do modinfo on brcm80211, cfg80211 and mac80211 they are all my
updated versions. What is wrong here?

Rgds//Thomas
