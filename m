Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f204.google.com ([209.85.211.204]:57608 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab0FNW0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 18:26:35 -0400
Received: by ywh42 with SMTP id 42so4064208ywh.15
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 15:26:34 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 Jun 2010 15:18:56 -0700
Message-ID: <AANLkTileP2BMsZUsA-NigDcmVcAmXn6KNw0R1vMzSgYw@mail.gmail.com>
Subject: radiotap rate no longer supported in mac80211?
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to support per-packet setting of rate on a packet injection
via the radiotap header.  In an earlier version of mac80211 (around
2.6.26), there was code in __ieee80211_parse_tx_radiotap (in
net/mac80211/tx.c) to support the use of the the rate element from the
radiotap header.  In current versions of wireless-testing, most of the
code here has been removed and only the flags are parsed.

I want to return the IEEE80211_RADIOTAP_RATE portion of this function
in order to support this.  So the questions:
1. Why were all fields other than IEEE80211_RADIOTAP_FLAGS removed?
2. Would it be OK for me to prepare and submit a patch to restore the
rate functionality?

Thanks,
- Steve
