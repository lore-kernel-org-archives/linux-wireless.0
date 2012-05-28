Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62995 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2E1LTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:35 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC] multi-channel work
Date: Mon, 28 May 2012 13:18:48 +0200
Message-ID: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com> (sfid-20120528_131944_163029_852AE452)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I've done another patchset aimed at multi-channel operation. This one
is mostly cfg80211 related.

The patchset clarifies channel handling by cfg80211. As I understand
we want to treat monitor interface as a special case. Monitor
interface can be used as a passive way to sniff data on other
interfaces. Monitor may have a channel set - this should be only
possible when there are no other interfaces running. Otherwise we
can't easily do channels accounting (with regard to interface
combinations). In other words the virtual monitor interface concept is
copied from mac80211 to cfg80211 itself making the whole thing more
consitent in my opinion.

The patchset also introduces num_different_channel checks. It hasn't
been thoroughly tested yet.

This work is based upon your patches on channel API changes.


--
Pozdrawiam / Best regards,
Michal Kazior.

