Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:2667 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYCMIva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 04:51:30 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: convert GET_LOG to a direct command
Date: Thu, 13 Mar 2008 09:48:36 +0100
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803130948.36528.hs4233@mail.mn-solutions.de> (sfid-20080313_085135_117602_FB294047)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now uses __lbs_cmd() to get the "log" (it's actually more a
snapshot of various counters, not a sequential log).

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

----

While looking here, I saw that that there is an imbalance on
populating priv->logmsg (via lbs_get_log() and it's usage.

lbs_get_log() is called twice:

* in assoc.c after a successful association
* in wext.c, lbs_get_wireless_stats()

however, priv->logmsg is only used once:

* in wext.c, lbs_get_wireless_stats(), to populate
  priv->wstats.discard.*

However, the usage in wext.c happens BEFORE the call to 
lbs_get_log(), so lbs_get_wireless_stats() actually works with 
old data. This seems strange ...

Does anybody know if this was intended behavior?  If not, I'd 
kill the calls to lbs_get_log() in assoc.c and move the other 
one to line 882 of wext.c.
