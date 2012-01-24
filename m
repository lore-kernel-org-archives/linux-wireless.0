Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:46301 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab2AXSV2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 13:21:28 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rpkzm-0003y2-IV
	for linux-wireless@vger.kernel.org; Tue, 24 Jan 2012 19:21:26 +0100
Received: from localhost ([::1]:38060 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rpkzm-00039H-Hf
	for linux-wireless@vger.kernel.org; Tue, 24 Jan 2012 19:21:26 +0100
Received: from [195.4.92.20] (port=60314 helo=10.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rpkxa-0001fG-KJ
	for linux-wireless@vger.kernel.org; Tue, 24 Jan 2012 19:19:10 +0100
Received: from [2002:4fde:916:2:5054:ff:feb8:40bd] (port=41329 helo=mail.maya.org)
	by 10.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Rpkxa-0005is-2z
	for linux-wireless@vger.kernel.org; Tue, 24 Jan 2012 19:19:10 +0100
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id q0OIJ6LO003820
	for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 19:19:06 +0100
Message-ID: <4F1EF618.6080108@01019freenet.de> (sfid-20120124_192132_058502_4936A439)
Date: Tue, 24 Jan 2012 19:19:04 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k get's completely knocked out by rt3572 device
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

During a test, I detected, that a ath9k device get's completely knocked
out by a rt3572 based usb device.

The situation:
Two different notebooks, one with ath9k (ar9285 pci chipset), another
with Linksys WUSB600N rt3572 based chipset. They are physically located
side by side - one on the left hand side, the other on the right hand
side - or vice versa.

Both are connected at the same time to the same AP (802.11n / 40MHz /
2,4 GHz / ch 1 / WPA2 / CCMP).

Now the test starts:

- ath9k device starts with netperf, rt3572 doesn't send any data. This
works as expected.

- Next step: start netperf on the rt3572-based device parallel. What I
expect: the bandwith is getting halved now.
But this expectation was wrong. After about 10 s, the ath9k device was
completely knocked out, there could be even seen network errors with
netperf.


- If netperf on the rt3572 device was started first and afterwards on
ath9k, ath9k doesn't even start working.


- At the moment of stopping netperf on rt3572, the ath9k device
instantly started sending / receiving data again as expected.


The environment:

- STA ath9k:     notebook built in, ar9285 pci, linux 3.2.1, 64bit, smp

- STA rt5572sta: Linksys WUSB600N, Ralink rt3572 usb chip, linux
		 2.6.37.6, 32bit single core

- AP rt2800pci:  Linksys WMP600N, Ralink rt2860 pci, linux 3.1.4,
		 64 bit, smp, compat-wireless 3.3-rc1-2 with resent
		 patches


Does anybody has an idea what could cause this situation? Or is this normal?


Kind regards,
Andreas
