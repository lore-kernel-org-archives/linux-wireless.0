Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:48724 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3JJVH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 17:07:58 -0400
Received: by mail-qe0-f54.google.com with SMTP id 1so2530072qec.41
        for <linux-wireless@vger.kernel.org>; Thu, 10 Oct 2013 14:07:57 -0700 (PDT)
Message-ID: <52571723.5020000@lwfinger.net> (sfid-20131010_230801_423254_D7DCC67D)
Date: Thu, 10 Oct 2013 16:07:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Regression in commit 0d528d8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 0d528d8 by Felix Fietkau, entitled "mac80211: improve the rate control 
API", causes the rtlwifi-family of drivers to be unable to connect to an 802.11g 
network. A bisection led to this commit, which was confirmed by reversing the patch.

The drivers can connect to a 802.11n networks, which is why the problem has gone 
undetected from kernel 3.10 till now.

These drivers use the rate-control mechanism in their firmware. I suspect that 
this is causing the problem. What actions do the drivers need to take that were 
not required before this patch?

Larry

