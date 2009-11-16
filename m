Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nexus.dynaweb.hu ([195.70.37.87]:57256 "EHLO nexus.dynaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbZKPTwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 14:52:12 -0500
Received: from localhost (localhost [127.0.0.1])
	by nexus.dynaweb.hu (Postfix) with ESMTP id B322843390
	for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2009 20:43:35 +0100 (CET)
Received: from nexus.dynaweb.hu ([127.0.0.1])
	by localhost (nexus.dynaweb.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I5uS00UoEbWV for <linux-wireless@vger.kernel.org>;
	Mon, 16 Nov 2009 20:43:34 +0100 (CET)
Received: from raketa.ipn.dynaweb.hu (catv-80-99-36-176.catv.broadband.hu [80.99.36.176])
	by nexus.dynaweb.hu (Postfix) with ESMTPSA id C5E3542D50
	for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2009 20:43:33 +0100 (CET)
Date: Mon, 16 Nov 2009 20:43:33 +0100
From: RUMI Szabolcs <rumi_ml@rtfm.hu>
To: linux-wireless@vger.kernel.org
Subject: Strange issue with ath5k AP mode
Message-Id: <20091116204333.bbe4abe0.rumi_ml@rtfm.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I've detected a rather strange issue with ath5k AP mode.

Setup:

We've got two WiFi-capable mobile phones in the household,
one is an iPhone 3G and the other is a Samsung GT-S8000 Jét.
We have several computers (iwl2100, ath5k) which work quite well
with the ath5k AP (apart from achieving rather low throughput
with the ath5k client). The AP is an i686-based PC server with
an ath5k card and runs a 2.6.31-rc6-wl (wireless-testing-git)
kernel with an uptime of 78 days right now. The wlan0 iface
uptime was about the same as the kernel.

Symptoms:

The iPhone did manage to detect all WiFi networks in the
vicinity, it could detect but it was unable to join my ath5k-based
network. I triple checked every setting so I'm sure there was no
problem with those. 

The S8000 Jét has always (apparenty) aborted it's WiFi search
operation instantly reporting that it could not find any WiFi
network although I do know that there are many of them in the
vicinity. I'm not used to bother the AP server too often so at
first I thought the phone may be faulty, until I tried searching
for WiFi networks on the street away from home and voilá, suddenly
it has found lots of networks.

Then I had the idea to shut down the ath5k wlan0 interface at
home and see what happens. After doing that the S8000 Jét was
able to search for and find all nearby WiFi networks instantly!

Then I started wlan0 again. From then on the iPhone was able to
associate and DHCP QUERY on the ath5k network. The Jét can also
detect it now but still cannot associate. Unfortunately it's
software is ridiculously stupid at some places and this includes
WiFi connection management so it might be a problem with the phone
that I still cannot connect. I'm still working on that.

Anyway, I thought an ath5k AP blocking a client from seeing any
other WiFi network is strange enough to report here...

Regards,
Sab
