Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:45468 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2ECRSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 13:18:12 -0400
Date: Thu, 03 May 2012 13:17:07 -0400 (EDT)
Message-Id: <20120503.131707.112550136096227430.davem@davemloft.net> (sfid-20120503_191817_480181_706C3A77)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2012-05-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120503.130516.1008806127286088740.davem@davemloft.net>
References: <20120503152206.GL9285@tuxdriver.com>
	<20120503.130516.1008806127286088740.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Miller <davem@davemloft.net>
Date: Thu, 03 May 2012 13:05:16 -0400 (EDT)

> Pulled, thanks John.

Actually, I un-pulled.  The bluetooth guys are sending crap code
formatting again.

>From 74e05692c9599866d5c8743764544cf77cd1af87 Mon Sep 17 00:00:00 2001
From: Andre Guedes <andre.guedes@openbossa.org>
Date: Tue, 6 Mar 2012 19:37:06 -0300
Subject: [PATCH 007/160] Bluetooth: Check FINDING state in interleaved
 discovery

In order to do interleaved discovery we should be in DISCOVERY_
FINDING state. Otherwise, discovery should be stopped.

Signed-off-by: Andre Guedes <andre.guedes@openbossa.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
 ...
-		if (hdev->discovery.type == DISCOV_TYPE_INTERLEAVED) {
+		if (hdev->discovery.type == DISCOV_TYPE_INTERLEAVED &&
+				hdev->discovery.state == DISCOVERY_FINDING) {

Really, we went through this a million times very recently and I'm
not pulling anything into my tree that has garbage like this in it.

Sorry.
