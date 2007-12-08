Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40347 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750991AbXLHLVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:21:50 -0500
Subject: [RFC][PATCH 0/4] mac80211: rate control rework
From: Mattias Nissler <mattias.nissler@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 12:21:46 +0100
Message-Id: <1197112906.7472.48.camel@localhost> (sfid-20071208_112159_239303_8B2441B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set does some general maintenance at the rate control front,
adds the PID algorithm, makes it the default and removes the old simple
algorihtm. Note that it is WIP, I'm sending it to get comments and to
sync my PID work with Stefano.

Other things I plan to do but not yet in the patches are:
* Change the get_rate() interface to remove the local pointer (can be
obtained from the netdev)
* track wich packets actually use a rate assigned by the rate control
(maybe add a flag to tx control) and only pass them pack to the rate
control for evaluation. Or at least give the rate control tx_status()
the information whether the frame was sent with a rate obtained from the
rate control algo.

Mattias

