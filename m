Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbYDJOlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 10:41:36 -0400
Message-Id: <20080410134828.712275000@sipsolutions.net> (sfid-20080410_154211_742080_B60A3701)
References: <20080410134810.629048000@sipsolutions.net>
Date: Thu, 10 Apr 2008 15:48:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@freedesktop.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: [RFC 2/3] rcu: allow functions to declare they need RCU locking
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Often enough, subsystems have a lookup function that goes from some
sort of key to an RCU-protected structure. They can then declare the
function as such:

struct mystruct *get_mystruct(...) __requires_rcu;

and sparse will automatically be able to check that the function is
invoked under rcu_read_lock().

Not-yet-signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/rcupdate.h |    4 ++++
 1 file changed, 4 insertions(+)

--- everything.orig/include/linux/rcupdate.h	2008-04-10 15:36:18.000000000 +0200
+++ everything/include/linux/rcupdate.h	2008-04-10 15:36:43.000000000 +0200
@@ -65,6 +65,10 @@ struct rcu_head {
        (ptr)->next = NULL; (ptr)->func = NULL; \
 } while (0)
 
+
+#define __requires_rcu		__requires(RCU)
+#define __macro_requires_rcu	__macro_requires(RCU)
+
 /**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
  *

-- 

