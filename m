Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:9997 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbYFVWYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 18:24:11 -0400
Received: by ug-out-1314.google.com with SMTP id h2so384707ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 15:24:10 -0700 (PDT)
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: mac80211: workqueue & RTNL lock
Date: Mon, 23 Jun 2008 00:42:41 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806230042.41219.IvDoorn@gmail.com> (sfid-20080623_002416_378490_D9252AF0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am currently looking at a rt2x00 regression in 2.6.26-rcX
	http://bugzilla.kernel.org/process_bug.cgi

This regression is  caused by a circular locking problem
(see http://bugzilla.kernel.org/attachment.cgi?id=16581)

The problem seems be caused by rt2x00 using ieee80211_iterate_active_interfaces()
within the workqueue as provided by mac80211. But this will trigger the
circular dependency when 'ifdown' is called. If I am not mistaken,
'ifdown' will grab the rtnl lock and ieee80211_stop() is called.
That function calls flush_workqueue() which cannot succeed because it will wait
on a thread that is also trying to grab the rtnl lock.

Possible solution would be making rt2x00 use its own workqueue, but
that will cause similar problems since it can't use flush either it could however
use flags to prevent ieee80211_iterate_active_interfaces() being called.

However it does mean that a solution for the mac80211 workqueue also has to
be found, since rt2x00 isn't the only use of the mac80211 workqueue,
but currently is the only one who uses it in combination with
ieee80211_iterate_active_interfaces().
And apparently those 2 cannot be combined. :S

Ivo
