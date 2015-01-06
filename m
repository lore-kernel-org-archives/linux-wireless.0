Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59771 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbbAFOFO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 09:05:14 -0500
Message-ID: <1420553111.1966.32.camel@sipsolutions.net> (sfid-20150106_150519_011633_F895ABF1)
Subject: Re: [PATCH 1/3] mac80211: consider only relevant vifs for
 radar_required calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Jan 2015 15:05:11 +0100
In-Reply-To: <1420542274.1966.21.camel@sipsolutions.net> (sfid-20150106_120447_628454_273C3B51)
References: <1420366399-31535-1-git-send-email-eliad@wizery.com>
	 (sfid-20150104_111329_158953_6FBC20BD) <1420542274.1966.21.camel@sipsolutions.net>
	 (sfid-20150106_120447_628454_273C3B51)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-06 at 12:04 +0100, Johannes Berg wrote:
> all three applied.

Nope, dropped patch 2 again - it was causing issues when running the
hwsim tests:

$ ./vm-run.sh dfs ap_ht_40mhz_intolerant_ap
Starting test run in a virtual machine
./run-all.sh: passing the following args to run-tests.py: dfs
ap_ht_40mhz_intolerant_ap 
START dfs 1/2
19
703
PASS dfs 65.148949 2015-01-06 14:02:54.263314
START ap_ht_40mhz_intolerant_ap 2/2
19
719
command failed: Device or resource busy (-16)
Exception: AP startup failed
FAIL ap_ht_40mhz_intolerant_ap 15.53641 2015-01-06 14:03:09.842131
failed tests: ap_ht_40mhz_intolerant_ap

Maybe the tests don't clean up properly, or something, but I'm not going
to investigate this now.

johannes

