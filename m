Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from leit.jelmoni.net ([78.46.129.73]:36293 "EHLO leit.jelmoni.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334Ab3INUjQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Sep 2013 16:39:16 -0400
Received: from localhost (localhost.jelmoni.net [127.0.0.1])
	by leit.jelmoni.net (Postfix) with ESMTP id DDCD980D2
	for <linux-wireless@vger.kernel.org>; Sat, 14 Sep 2013 22:39:13 +0200 (CEST)
Received: from leit.jelmoni.net ([127.0.0.1])
	by localhost (leit.jelmoni.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O66RHIzVNGY2 for <linux-wireless@vger.kernel.org>;
	Sat, 14 Sep 2013 22:39:13 +0200 (CEST)
Received: from laptop-beat.swiss-wireless.com.ar (host194.190-229-210.telecom.net.ar [190.229.210.194])
	(Authenticated sender: genauth@swiss-wireless.com.ar)
	by leit.jelmoni.net (Postfix) with ESMTPSA id DFACA80D1
	for <linux-wireless@vger.kernel.org>; Sat, 14 Sep 2013 22:39:11 +0200 (CEST)
Message-ID: <5234C956.4010307@swiss-wireless.com.ar> (sfid-20130914_223930_357276_501E2EEE)
Date: Sat, 14 Sep 2013 17:38:46 -0300
From: Beat Meier <mbe_shop@swiss-wireless.com.ar>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: mac80211 and kernel 3.8.13 1/2 speed as with madwifi and kernel 2.6.23
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I'm trying to use again mac driver instead of old madwifi driver for
atheros cards.
I have following problem.
On Clients using mac80211 (wpa_supplicant) it's just fine but if you use
it with hostapd you have about 1/2 speed
as with madwifi. Problem could be also kernel<->wireless driver issue.
With madwifi I'm using an old kernel 2.6.23 (voyage-0.5 distribution)
and with mac80211 a new kernel 3.8.13 (voyage-0.9.1)

Example:
5.5km 5.8GHz link 2xAlix board, 2xWLM54AGP23 card, 2x Hyperlink 27dbi
grids, wireless card speed set to 24M
to get max. signal on this cards...
Signal on both sites is -60

With madwifi driver on both site you get 12.8Mbps/14.5Mbps download/upload
madwifi driver on server, mac80211 on client you still get 13.4/13.8Mbps
BUT if you use mac80211 on ap master mode with hostap you get only
7Mbps/5.5Mbps.
Tried all 4 constellation (old/new, new/old, new/new and old/old) and
the issue is only
if the hostapt is running with new kernel/mac80211

Same stuff on other links with other cards like CM9.

What I have seen is that with madwifi driver the cpu is 90-100% cpu
usage with ksoftirqd
with mac80211 not...
Could this be a kernel interrupt issue? Are there several policies which
changed with kernel?

Anyone having same issue?

Greetings and thanks
