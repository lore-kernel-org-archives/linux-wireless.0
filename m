Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44521 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab1JRWNA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 18:13:00 -0400
Received: by bkbzt19 with SMTP id zt19so1293726bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 15:12:59 -0700 (PDT)
MIME-Version: 1.0
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 19 Oct 2011 00:12:44 +0200
Message-ID: <CA+XVXffT6pq0bKZrVmrYDqustkTFt_ot99BPK_Q5JmXU3wE0iQ@mail.gmail.com> (sfid-20111019_001304_997341_0E59E271)
Subject: lockdep in mac80211
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://pastebin.com/qX3SLy2H

This appears to be a legitimate lockdep (when trying to re-connect to
an AP whose password I just changed).
These take the locks in reverse order:

ieee80211_work_work() -> ieee80211_authenticate() (Inlined in the
lockdep print).
ieee80211_sta_rx_queued_mgmt() -> ieee80211_rx_mgmt_disassoc()

I don't know the state machine well enough and it's getting kind of
late here. I'll probably have time to take a closer look in a couple
of days (unless Johannes finds this one trivial).

Arik
