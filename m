Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:41107 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbZJ3Vtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:49:51 -0400
Received: by fg-out-1718.google.com with SMTP id d23so484fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 14:49:55 -0700 (PDT)
Subject: [PATH 0/2] Make driver_nl80211 really work
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 23:49:51 +0200
Message-ID: <1256939391.31271.11.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I seem to find proper fixes for problem with driver_nl80211.
Despite workaround in wpa_supplicant that sends deauth when auth command
fails, this driver still doesn't work.

Problem is that scanning is not allowed in authenticated but not
associated state. I was told that this is feature, but afterwards I
understood that it is legal for wpa_supplicant not to use deauthenticate
command.

In the other hand mac80211 holds a work list of things todo that include
pings, associations, authentications, etc...

Following the code it seems that this list is set to hold forever
entries that belong to associated but not authenticated access points.
For example ieee80211_mgd_deauth will fail if this condition isn't true.

So I modified __ieee80211_start_scan to work even if work list isn't
empty but all entries are idle.

As for second problem, the lack of ability to do authentication to
access point twice, I modified nl80211 by 'roughly' removing the check
for this condition, treating new request as if ap was never
authenticated. This seems to work very well.


Best regards,
Maxim Levitsky

