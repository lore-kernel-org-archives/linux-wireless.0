Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43267 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaCIVnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 17:43:24 -0400
Received: by mail-qc0-f173.google.com with SMTP id r5so6938446qcx.32
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2014 14:43:23 -0700 (PDT)
Message-ID: <531CE079.9050304@gmail.com> (sfid-20140309_224327_203115_30694526)
Date: Sun, 09 Mar 2014 14:43:21 -0700
From: Bryan Batten <bryanbatten@gmail.com>
Reply-To: BryanBatten@gmail.com
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC} mac80211: optimize rate control initialization
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This proposed patch changes the rate control initialization sources to 
reduce the number of files to be modified when a new rate control 
scheme is added to the kernel. Reducing the scope of needed source 
changes should enhance the Linux kernel as a vehicle for expanding 
802.11 rate control capabilities by making the addition of new schemes 
easier.

Affected files are net/mac80211/rate.h and net/mac80211/main.c.

Adding an additional rate control scheme currently requires not only 
adding the new rate control source code to the kernel, but also 
modifying net/mac80211/rate.h to define initialization and exit 
functions for the new scheme, and net/mac80211/main.c to add additional 
initialization and exit calls to the added functions. This patch 
removes the need to modify main.c when new rate control schemes are 
added. It makes a one time modification to main.c and changes rate.h so 
that any future rate control schemes added to mac80211 only require 
changes to rate.h, leaving the source for main.c unchanged.

The basic idea is to push the all the calls to specific rate control 
initialization and exit functions down into rate.h, using generic rate 
control initialization and exit functions defined there, then replace 
the explicit calls in main.c with references to the generic functions. 
The patch has two parts.

First, net/mac80211/rate.h currently conditionally expands calls to 
rc80211_pid_{init|exit} and rc80211_minstrel_{init|exit} based on the 
setting for CONFIG_MAC80211_RC_PID and CONFIG_MAC80211_RC_MINSTREL. The 
patch would add two wrapper functions:

static inline int mac80211_rc_init() to call all the initializers, and
static inline void mac80211_rc_exit() to call all the exit functions.

These symbols to not appear to be currently defined as of 3.12.11.

Second, in net/mac80211/main.c, ieee80211_init() and ieee80211_exit() 
currently call rc80211_pid_{init|exit} and rc80211_minstrel_{init|exit} 
individually, relying on the conditional definitions in rate.h to 
appropriately expand the calls. The patch replaces the initialization 
calls in ieee80211_init() with:

ret=mac80211_rc_init();

and the exit calls in ieee80211_exit() with:

mac80211_rc_exit();

If this proposal is deemed to be a worthwhile effort, let me know the 
appropriate version of the kernel to target, and I'll code (compile in 
target kernel without error or warning messages using gcc 4.7.2) and 
test (modified kernel does not crash) a formal patch and submit it to 
wherever you deem appropriate.

Additional comments and suggestions will be appreciated.

Thanks,
-- 
Bryan
-
Large corporations are not notably capitalistic.
