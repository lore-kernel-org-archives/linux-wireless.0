Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57227
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbXDFW2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 18:28:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: mac80211 debugfs compile failure
Date: Sat, 7 Apr 2007 00:28:01 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200704070028.02143.mb@bu3sch.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just got the following when pulling linville's tree
into mine.

net/mac80211/debugfs.c: In function =E2=80=98stats_wme_rx_queue_read=E2=
=80=99:
net/mac80211/debugfs.c:266: error: =E2=80=98struct ieee80211_local=E2=80=
=99 has no member named =E2=80=98wme_rx_queue=E2=80=99
net/mac80211/debugfs.c: In function =E2=80=98stats_wme_tx_queue_read=E2=
=80=99:
net/mac80211/debugfs.c:286: error: =E2=80=98struct ieee80211_local=E2=80=
=99 has no member named =E2=80=98wme_tx_queue=E2=80=99
make[2]: *** [net/mac80211/debugfs.o] Error 1
make[1]: *** [net/mac80211] Error 2
make: *** [net] Error 2

Seems like some ifdefs missing or something. Does a patch exist?

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
