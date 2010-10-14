Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:27838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0JNWnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 18:43:03 -0400
Received: from hpaq3.eem.corp.google.com (hpaq3.eem.corp.google.com [172.25.149.3])
	by smtp-out.google.com with ESMTP id o9EMh1fE030857
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 15:43:01 -0700
Received: from iwn8 (iwn8.prod.google.com [10.241.68.72])
	by hpaq3.eem.corp.google.com with ESMTP id o9EMg12d030550
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 15:43:00 -0700
Received: by iwn8 with SMTP id 8so157776iwn.27
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 15:42:59 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Oct 2010 15:42:59 -0700
Message-ID: <AANLkTimyBonZEm8+M_16uBss+-3f_2UMgCQiYAFwjKBi@mail.gmail.com>
Subject: [PATCH 0/2] Add transmit rate CQM monitoring to mac80211
From: Paul Stewart <pstew@google.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've made another pass at things responding to much of the great input
Johannes has given.  I've removed the silly ancient locking in
nl80211, redone the workqueue to go under mlme which has the advantage
of not requiring an interface walk every time.  I've also documented
the bit rate a bit better, used a caching table (could do a completely
static one if that is preferred -- 64 bytes isn't that much), and
fixed a small bug with legacy rates being reported incorrectly.  I
also merged the mac80211 bits and cfg80211 bits so that there are only
two patches, which should have them compilable (second dependent on
the first).

I did a test run on a constant walk around a floor of my building
under the conditions:

   * wpa_supplicant using bgscan_learn (using only rssi to trigger
roaming -- unmodified from the perspective of this new change)
   * ath9k using ath9k_rate_control
   * Youtube running constantly (plenty of TCP ack traffic).
   * Walked round plenty of metal building features, so RSSI varied
significantly
   * Test lasted 360 seconds.
   * RSSI monitoring was triggered 21 times (again, due only to RSSI)
   * Scan triggered 10 times, roughly every 36 seconds on average.

In total, the calculate routine was called 755 times, averaging about
2 times a second.  The notifier on the other hand was called 57 times.
 I don't think that load is excessive, for user-space applications
that elect to pull this information.  I'll throttle it down if folks
would like, but I have not done so yet.
