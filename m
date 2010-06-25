Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:53328 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab0FYHdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 03:33:08 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id o5P7X6Zu002457
	for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 00:33:06 -0700
Received: from iwn3 (iwn3.prod.google.com [10.241.68.67])
	by wpaz24.hot.corp.google.com with ESMTP id o5P7WO7b028080
	for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 00:33:05 -0700
Received: by iwn3 with SMTP id 3so3130075iwn.41
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 00:33:05 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 25 Jun 2010 00:33:04 -0700
Message-ID: <AANLkTilhbYTH2gKJsvqDaMzLG2cIt2tNV-GW-X0K3pNJ@mail.gmail.com>
Subject: [PATCH] mac80211: auth retries if AP sends temporary deauth
From: Paul Stewart <pstew@google.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks.

If a STA gets sent a DEAUTH from an AP it is actively trying to
authenticate to, mac80211 currently shoots itself in the foot by
letting  ieee80211_sta_rx_mgmt() clean up state for the connection
(removing an entry from authtry_bsses[] in wireless/mlme.c),
but the retry loop contiinues, leading to a kernel warning but no
connection.

An AP is allowed by the spec to return DEAUTH as a result of a
temporary failure, one of which is "you are already authenticated
-- what are you talking about?"

The scenario I've been running into works like this: we try to auth
to an AP that still has state about us (we may have shut down
uncleanly without sending a DEAUTH).  So we send the AUTH, the server
replies with the DEAUTH above.  At this point we have a stalemate
-- the state for the AP is gone, but the STA retry mechanism is still
actively repeating AUTH attempts.  In fact, the "try 2" AUTH
succeeds, and the AP sends a successful AUTH response, but we don't
have the state anymore and cfg80211_send_rx_auth bombs out
with the "WARN(!done)" because the authtry_bsses entry was
deleted when we processed the DEAUTH. Therefore we don't proceed
to the association phase, and when the upper level decides to retry
with a directed probe and AUTH, the AP replies "you are already
authenticated", since from its perspective the STA has AUTHed
successfully on the previous attempt and so the cycle goes on.

There are two possible solutions that I thought of. One is that if
we get a DEAUTH as a response to an AUTH, we can not only drop
the bss state, but also kill the retry process. This slows down
the overall retry process since in most cases we need to do a
scan again as well, but then we don't perform a pointless second
(or third) AUTH. The second way is to recognize that we got
a DEAUTH while we wer AUTHing and suppress further processing,
letting the retry process continue as it has before.

The patch attached below goes the route of the latter approach.
It turns out to be a very small change. As an extension, I suppose
one could delve into the REASON code and determine whether the
failure is likely to be temporary, and choose from the above two
approaches. I considered that a bigger change, and didn't want
to go that far. Since the retry count is so small, I believe
ignoring the DEAUTH does very limited harm (hopefully it does,
because whether we like it or not, that is the current behavior).

--
Paul

--- a/compat-wireless/net/mac80211/work.c
+++ b/compat-wireless/net/mac80211/work.c
@@ -1030,6 +1030,23 @@ ieee80211_rx_result
ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 			skb_queue_tail(&local->work_skb_queue, skb);
 			ieee80211_queue_work(&local->hw, &local->work_work);
 			return RX_QUEUED;
+		case IEEE80211_STYPE_DEAUTH:
+			/*
+			 * If we get sent a DEAUTH while we are
+			 * actively trying to authenticate to this
+			 * station, we shoot ourselves in the foot if
+			 * we fall through using RX_CONTINUE and allow
+			 * the bss context to disappear
+			 * (ieee80211_sta_rx_mgmt()).  This is
+			 * especially true if the reason for the
+			 * DEAUTH was a negative but temporary direct
+			 * response to an AUTH attempt. Let the retry
+			 * mechanism run its course instead.
+			 */
+			if (wk->type == IEEE80211_WORK_AUTH) {
+				return RX_DROP_MONITOR;
+			}
+			break;
 		}
 	}
