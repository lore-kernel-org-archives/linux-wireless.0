Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:32880 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab0BQVEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 16:04:06 -0500
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id 2B72DC7F3A
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 23:04:03 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 17B151C6398
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 23:04:01 +0200 (EET)
Subject: [RFC PATCH 0/3] mac80211: nullfunc connection monitor
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 17 Feb 2010 23:04:01 +0200
Message-ID: <20100217210202.30634.69236.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been thinking about using nullfunc frames in connection monitor
with hw which have IEEE80211_HW_REPORTS_TX_ACK_STATUS. Here are my
current patches based on the idea. They have received minimal testing
and there's still some work to do.

But I would like to get comments what people think about this. Might
this create some kind of IOP problems, for example?

I also added a new hw flag to be able to offload connection monitoring
to the hardware.

TODO:

o send qos nullfunc when using wmm

---

Kalle Valo (3):
      mac80211: refactor nullfunc status handling to a separate function
      mac80211: use nullfunc in connection monitor
      mac80211: add support connection monitor in hardware


 include/net/mac80211.h     |    1 +
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   40 +++++++++++++++++----
 net/mac80211/status.c      |   84 +++++++++++++++++++++++++++++++++++++-------
 4 files changed, 106 insertions(+), 20 deletions(-)

