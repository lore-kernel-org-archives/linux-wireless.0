Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1227 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab0GQTgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jul 2010 15:36:04 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
Subject: [PATCH/RFC 0/3] ath5k: add driver tracepoints
Date: Sat, 17 Jul 2010 15:35:33 -0400
Message-Id: <1279395336-856-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds some tracepoints for reset and tx/rx, with an
eye toward replacing some of the debug printks we have today.
Stolen form iwlwifi is the idea of logging entire packets so
we can generate pcap files from the traces, via something like:

    $ mkdir -p ~/.trace-cmd/plugins
    $ cd ~/.trace-cmd/plugins
    $ wget 'http://bobcopeland.com/srcs/ath5k_trace.py'
    $ trace-cmd record -e mac80211 -e ath5k sleep 500
    $ trace-cmd report | less
    $ wireshark /tmp/pcap.out

I quite like the result, but I'd be interested to hear others'
opinions on the approach.  Right now I think these tracepoints
will be useful in seeing causes of excessive resets, and debugging
queue hangs.


