Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:53764 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaFKXFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 19:05:22 -0400
Date: Thu, 12 Jun 2014 02:05:13 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Linux 3.15: WLAN regression on WRL54GL/B43?
Message-ID: <20140611230513.GC913@drone.musicnaut.iki.fi> (sfid-20140612_010529_423149_E4C9E927)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While testing the final 3.15, I noticed that "iwlist wlan0 scanning"
cannot find anything on my WRT54GL router anymore:

	# iwlist wlan0 scanning
	wlan0     No scan results

I bisected this to:

	3afc2167f60a327a2c1e1e2600ef209a3c2b75b7 is the first bad commit
	commit 3afc2167f60a327a2c1e1e2600ef209a3c2b75b7
	Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
	Date:   Tue Mar 4 16:50:13 2014 +0200

	    cfg80211/mac80211: ignore signal if the frame was heard on wrong channel

Test case: I simply test it after the boot as follows:

	modprobe b43
	ifconfig wlan0 up
	iwlist wlan0 scanning

Any ideas?

A.
