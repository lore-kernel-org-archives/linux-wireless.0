Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:33236 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349AbXDNSKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 14:10:00 -0400
Message-ID: <46211955.4080006@lwfinger.net>
Date: Sat, 14 Apr 2007 13:11:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] mac80211 and drivers: Improve wireless statistics
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In wireless statistics reporting, three quantities related to the signal are reported: "qual" 
(linear with the signal), "level" (logarithmic), and "noise". In mac80211 and the drivers that use 
it, the first two have a mixture of internal names for those quantities. To reduce confusion, this 
series of patches make the internal names match the entity that is being kept.

So that any bisection of the source will always result in code that will compile, the patches are 
divided as follows:

1/4: The new names are added to the appropriate struct definitions in mac80211.
2/4: The mac80211 routines are modified to use the new names.
3/4: The drivers that use mac80211 are modified.
4/4: The old names are removed from the struct definitions.

These changes assume the prior application of patches "[PATCH] mac80211: remove redundant rssi 
information in scan results" by Michael Wu and "[PATCH] mac80211: Report correct wireless 
statistics" by Larry Finger.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
