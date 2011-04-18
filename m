Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48216 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1DRVSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 17:18:06 -0400
Received: by qyg14 with SMTP id 14so3272325qyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 14:18:06 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Apr 2011 16:18:05 -0500
Message-ID: <BANLkTimvT-9mSQ8n1zyDYpioxJEv=Kc7Jg@mail.gmail.com>
Subject: Mesh broken
From: Qasim Javed <qasimj@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, devel@lists.open80211s.org
Cc: Javier Cardona <javier@cozybit.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

We have a 6 node mesh setup, with one node acting as a mesh portal.
All the nodes are in direct range of each other, so every node has 5
peer links. The node that acts as a mesh portal has another laptop
connected to it via an Ethernet cable which runs an iperf TCP server.
Every mesh node runs an iperf TCP client where the transmit data rate
is limited to about 500Kbps.

When we run the iperf client on all the mesh nodes while using
compat-wireless from 18th Jan, 2011, things seem to work fine. There
is rarely a connection loss. However, the peak data rate at the laptop
which is connected to the mesh portal (via Ethernet) goes much higher
than the expected 3Mbps (6*500Kbps).

When we use compat-wireless from 28th March, 2011, and repeat the
above experiment again, the results we get are quite disappointing.
The TCP connections from all 6 nodes constantly break. Also, if only
one mesh node is communicating with the laptop connected to the mesh
portal, the connection does not break. If using the same
compat-wireless, we force the max plinks to 1 (one) at each node, the
TCP connections do not break. Everything works fine.

If we use compat-wireless from 31st march, 2011, the mesh nodes are
not even able to establish plinks with each other.

"iw dev mesh station dump"

returns nothing.

Switching to compat-wireless from 14th April, 2011 results in plinks
alternating between LISTEN and OPN_SNT states. The displayed beacon
signal strength (in station dump) is very low (close to -80dbm).

Infrastructure mode works fine.

Can anyone please elaborate on what could be happening here?

Thanks,
-Qasim
