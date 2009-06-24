Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19035 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbZFXP2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 11:28:48 -0400
Date: Wed, 24 Jun 2009 17:30:52 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 01/11] cfg80211: connect/disconnect API
Message-ID: <20090624153048.GA11241@sortiz.org>
References: <20090624120745.239294066@sipsolutions.net> <20090624120808.469913150@sipsolutions.net>
MIME-Version: 1.0
In-Reply-To: <20090624120808.469913150@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, Jun 24, 2009 at 05:07:46AM -0700, Johannes Berg wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> This patch introduces the cfg80211 connect/disconnect API.
> The goal here is to run the AUTH and ASSOC steps in one call.
> This is needed for some fullmac cards that run both steps
> directly from the target, after the host driver sends a
> connect command.
With this API, we should now be able to support the iwconfig key restricted
stuff, with a patch like that:

---
 net/wireless/wext-compat.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: iwm-2.6/net/wireless/wext-compat.c
===================================================================
--- iwm-2.6.orig/net/wireless/wext-compat.c	2009-06-24 17:25:37.000000000 +0200
+++ iwm-2.6/net/wireless/wext-compat.c	2009-06-24 17:25:41.000000000 +0200
@@ -555,6 +555,11 @@ int cfg80211_wext_siwencode(struct net_d
 		return err;
 	}
 
+	if (erq->flags & IW_ENCODE_RESTRICTED)
+		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_SHARED_KEY;
+	else
+		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_OPEN_SYSTEM;
+
 	memset(&params, 0, sizeof(params));
 	params.key = keybuf;
 	params.key_len = erq->length;



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

