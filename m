Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:43620 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab2EGFOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 01:14:35 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SRGHK-0005jI-5P
	for linux-wireless@vger.kernel.org; Mon, 07 May 2012 07:14:34 +0200
Received: from localhost ([::1]:41840 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SRGHK-0003zT-1f
	for linux-wireless@vger.kernel.org; Mon, 07 May 2012 07:14:34 +0200
Received: from [195.4.92.22] (port=59523 helo=12.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SRGEa-0003Yf-FB
	for linux-wireless@vger.kernel.org; Mon, 07 May 2012 07:11:44 +0200
Received: from [2002:4fde:1e5:2:5054:ff:feb8:40bd] (port=48708 helo=mail.maya.org)
	by 12.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SRGEa-00032S-05
	for linux-wireless@vger.kernel.org; Mon, 07 May 2012 07:11:44 +0200
Message-ID: <4FA75983.9040003@01019freenet.de> (sfid-20120507_071439_281155_215096E7)
Date: Mon, 07 May 2012 07:11:31 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [rt2800pci (AP) - ath9k] 802.11w: broken aggregation handling?
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I switched on 802.11w on my AP (rt2860) in hostapd with ieee80211w=1 and
in wpa_supplicant with ieee80211w=2 (ath9k). key_mgmt is WPA-EAP (TLS) /
CCMP for both pairwise and group.

On both machines, compat-wireless-2012-04-26 (or
compat-wireless-3.4-rc3) is running.

Directly after authorization, dhcp is started and therefore the opening
of the BA session is started by the AP but times out because of no
answer of the supplicant:

AP:
[63010.267285] Open BA session requested for 48:5d:60:33:aa:11 tid 0
[63010.279073] activated addBA response timer on tid 0
[63011.280107] addBA response timer expired on tid 0
[63011.280134] Tx BA session stop requested for 48:5d:60:33:aa:11 tid 0
[63011.289149] Stopping Tx BA session for 48:5d:60:33:aa:11 tid 0

[63013.270550] Open BA session requested for 48:5d:60:33:aa:11 tid 0
[63013.285059] activated addBA response timer on tid 0
[63014.288104] addBA response timer expired on tid 0
[63014.288130] Tx BA session stop requested for 48:5d:60:33:aa:11 tid 0
[63014.301131] Stopping Tx BA session for 48:5d:60:33:aa:11 tid 0



The ath9k supplicant gets the BA session request, but times out, too:

[75492.707613] Open BA session requested for ec:2c:69:57:01:dd tid 0
[75492.718195] activated addBA response timer on tid 0
[75493.719577] addBA response timer expired on tid 0
[75493.719633] Tx BA session stop requested for ec:2c:69:57:01:dd tid 0
[75493.728655] Stopping Tx BA session for ec:2c:69:57:01:dd tid 0

[75495.709051] Open BA session requested for ec:2c:69:57:01:dd tid 0
[75495.720317] activated addBA response timer on tid 0
[75496.721801] addBA response timer expired on tid 0
[75496.721825] Tx BA session stop requested for ec:2c:69:57:01:dd tid 0
[75496.730775] Stopping Tx BA session for ec:2c:69:57:01:dd tid 0

[75496.731299] Open BA session requested for ec:2c:69:57:01:dd tid 0
[75496.743795] activated addBA response timer on tid 0
[75497.745162] addBA response timer expired on tid 0
[75497.745198] Tx BA session stop requested for ec:2c:69:57:01:dd tid 0
[75497.754246] Stopping Tx BA session for ec:2c:69:57:01:dd tid 0

[75497.754775] Open BA session requested for ec:2c:69:57:01:dd tid 0
[75497.755097] Open BA session requested for ec:2c:69:57:01:dd tid 0
[75497.755102] BA request denied - session is not idle on tid 0


I can see in the air trace, that the supplicant seems to answer fine to
the BA request of the AP, but the AP seems not to understand the package.



It looks like this (AP), if it's working fine (w/o 802.11n):
[62405.350620] Open BA session requested for 48:5d:60:33:aa:11 tid 0
[62405.364062] activated addBA response timer on tid 0
[62405.365389] Rx A-MPDU request on tid 0 result 0
[62405.365644] switched off addBA timer for tid 0
[62405.365648] Aggregation is on for tid 0




The deauth request from wpa_supplicant -> AP isn't recognized on the AP,
too.



Any idea?

Thanks,
kind regards,
Andreas
