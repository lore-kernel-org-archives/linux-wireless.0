Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:43242 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1LaOIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Dec 2011 09:08:01 -0500
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RgzLa-0008Oy-AS
	for linux-wireless@vger.kernel.org; Sat, 31 Dec 2011 14:51:42 +0100
Received: from localhost ([::1]:53939 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RgzLa-0007v9-6e
	for linux-wireless@vger.kernel.org; Sat, 31 Dec 2011 14:51:42 +0100
Received: from [195.4.92.12] (port=43484 helo=2.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RgzJE-0007FC-Th
	for linux-wireless@vger.kernel.org; Sat, 31 Dec 2011 14:49:16 +0100
Received: from p4fde00ee.dip0.t-ipconnect.de ([79.222.0.238]:39435 helo=mail.maya.org)
	by 2.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RgzJE-0004VD-Hq
	for linux-wireless@vger.kernel.org; Sat, 31 Dec 2011 14:49:16 +0100
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id pBVDnBRw003636
	for <linux-wireless@vger.kernel.org>; Sat, 31 Dec 2011 14:49:11 +0100
Message-ID: <4EFF12D9.3010602@01019freenet.de> (sfid-20111231_150826_391382_8B3357FB)
Date: Sat, 31 Dec 2011 14:49:13 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I tested compat-wireless-3.2-rc6-3 with kernel 3.1 and a rt2860 device
running in AP mode (80211.n - 40 MHz). During

netperf -t TCP_STREAM -H ap

the data stream mostly stalls (-> the device receives data) after a few
seconds and never comes up any more. The connection is completely death.
I have to restart wpa_supplicant to get it working again.



I tried to isolate the problem the following way:

1. Running compat-wireless-3.2-rc6-3 with the rt2x00 level from
compat-wireless-3.1.1-1. The problem didn't gone.

2. Running compat-wireless-3.1.1-1 with the rt2x00 based changes in
compat-wireless-3.2-rc6-3. I can't see the problem any more.


That's why I think, that the problem must be outside the rt2x00 changes.
But there are many changes outside :-).


So far, I removed the following patches from compat-wireless-3.2-rc6-3:

mac80211: fix race between the AGG SM and the Tx data path
mac80211: don't stop a single aggregation session twice
mac80211: uAPSD - fix IEEE80211_FCTL_MOREDATA bit setting
mac80211: fix race condition caused by late addBA response

But they seem not to be the culprit.


I tried to remove these patches, too, but this wasn't possible:

mac80211: don't stop a single aggregation session twice
mac80211: fix another race in aggregation start



Does anybody has an idea, which patch could have raised this problem?



Kind regards,
Andreas Hartmann
