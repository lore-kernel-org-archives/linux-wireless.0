Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23818 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab2EVA50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 20:57:26 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Message-ID: <20410.58433.115014.351622@gargle.gargle.HOWL> (sfid-20120522_025730_814116_B8A6FD24)
Date: Tue, 22 May 2012 06:26:33 +0530
To: Gary Morain <gmorain@chromium.org>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, <pstew@chromium.org>
Subject: [PATCH] CHROMIUMOS: mac80211: Increase retry attempts for nullfunc probes
In-Reply-To: <CADfcX6pjFEWyxd5o-t7yPdr+6MkB+7ZvQ-TgAe1A894h7C5vTw@mail.gmail.com>
References: <20120521190547.3E23A8061C@gary-pc2.mtv.corp.google.com>
	<1337628372.11626.0.camel@jlt3.sipsolutions.net>
	<CADfcX6r=GuQh2kdC_OEX9fvfGjWXeGwFKGTfFWs-88nqgGNF_Q@mail.gmail.com>
	<CADfcX6pjFEWyxd5o-t7yPdr+6MkB+7ZvQ-TgAe1A894h7C5vTw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gary Morain wrote:
> Scenario:
> 1.  Client connects to a managed AP.
> 2.  Client goes off-channel to scan for APs.
> 3.  AP goes off-channel to scan for rogue APs.  The client misses any
> signaling the AP may have sent.
> 4.  The client returns to its home channel before the AP does.
> 5.  The client immediately probes the AP with a nullfunc.
> (ieee80211_mlme_notify_scan_completed()).
> 6.  The AP does not respond to the nullfunc because it is off-channel.
> 7.  The client retries the nullfunc, which also does not get an ACK, and the
> client disconnects from the AP (ieee80211_sta_work).
> 
> It's worth noticing that the client never detects beacon loss because the AP
> is not off-channel long enough to miss sending multiple beacons.

If this is with ath9k, there is a much more fundamental issue - the HW beacon
timers are never re-programmed with the correct values, which can be done only
after a TSF sync.

The sequence is like this:

* ath9k associates to an AP
* A scan is started on the station side.
* The HW is reset as part of the scan.
* The scan completes.
* ath9k sets the BSSID and configures beacon timers - but,
  without waiting for the HW TSF sync, so the timers
  end up being programmed incorrectly.

This is with wireless-testing.

Sujith
