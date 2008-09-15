Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:40920 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbYIOMQN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 08:16:13 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 143BF41739
	for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 14:16:13 +0200 (CEST)
From: Helmut Schaa <hschaa@suse.de>
To: linux-wireless@vger.kernel.org
Subject: More thoughts about roaming ...
Date: Mon, 15 Sep 2008 14:16:06 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200809151416.07552.hschaa@suse.de> (sfid-20080915_141617_495623_6940B46A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

As a result of the thread "Pondering: how to improve mac80211 roaming ..."
I thought a bit more about that topic. Here is a quick suggestion for a first
version:

* Enhance mac80211 software scan to interrupt the current scan and switch
  back to the operating channel every once in a while (only if at least one STA
  interface is associated) => background scan.

* Enhance mac80211 to check the signal quality frequently (or any other
  indicator like beacon misses) and decide when the signal quality is too low.
  Indicate that to the user space.

* wpa_supplicant (or any other user space application) gets notified about
  the low signal quality and triggers a scan in order to find a better AP.
  wpa_supplicant already chooses the AP with the best signal strength.

The reason behind not triggering the scan directly from mac80211 is that the
supplicant (or any other user space application) might know more about the
current environment and could for example trigger a scan restricted to specific
channels (in the future) which should speed up the scan. Hence let the user
space decide what to do with a low signal.

However the detection of when the signal quality is low should still be done in
mac80211 or the driver as some cards seem to have the needed functionality
implemented in firmware (e.g. missed beacon interrupt).

I'll send some proof-of-concept patches in a few minutes which implement
background scanning in software and the user space indication. I've tested them
a bit already and they work quite well with an iwl4965.

Helmut
