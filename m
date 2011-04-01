Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45407 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab1DAKjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:39:13 -0400
Received: by bwz15 with SMTP id 15so2412165bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 03:39:12 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: hostapd & mac80211: too many probe responses
Date: Fri, 1 Apr 2011 12:37:21 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104011237.21983.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've just noticed that hostapd + mac80211 + rt2x00 produces way too many
probe responses when setup as multi bssid AP.

The reason seems to be that mac80211 receives a broadcast probe req and
drops it to the monitor interface for each vif (hence X times). And hostapd
will process each received broadcast probe req on all vifs as well (hence X
times again). Resulting in X*X probe responses instead of just X.

This can eat up quite some airtime as the probe reponses are sent at 1Mpbs.

IMO to fix this issue mac80211 should send a broadcast probe req only once
to the monitor interface. However, I don't have a good idea how to do that
right now :)

Thanks,
Helmut
