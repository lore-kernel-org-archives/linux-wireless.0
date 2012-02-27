Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.watchguard.com ([206.191.171.101]:39964 "EHLO
	watchguard.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751268Ab2B0WhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:37:15 -0500
From: Bryan Phillippe <Bryan.Phillippe@watchguard.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Help I.D. stalling monitor-interface bugfix made after
 compat-wireless 3.0-2
Date: Mon, 27 Feb 2012 22:08:50 +0000
Message-ID: <DF7D9030-224F-4E2D-985A-ABB5300FC2FF@watchguard.com> (sfid-20120227_233720_069681_EF012662)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,

I've been trying to settle on a stable version of compat-wireless to use with Linux 2.6.35-ish kernels, for driving an access-point based on Atheros AR9160 or AR9300 chips.  Originally I was using compat-wireless 3.0-2 and ath9k with good results.  However, I found a particular problem that happened whenever more than a dozen or so clients were connected, where all wireless traffic and authentication attempts would suddenly stall for a minute or two, then start working again.  There were no kernel logs emitted during this time, and hostapd would just report WPA key timeouts.  Clients could see the SSID, but not connect.  I found at least one problem that I think was to blame for this, which was that the sendmsg() in hostapd code was blocking on the monitor interface.  Killing hostapd would automatically "correct" this problem (because the monitor interface is destroyed and recreated), but I don't think it's a hostapd problem.  I tried 0.7.3 as well as the 0.8 pre-release - same problem.

However, this problem went away when I tried compat-wireless 2012-02-06.  Unfortunately, a number of other problems were introduced in this version, including the WARN_ON() from driver-ops.h introduced in this patch (http://johannes.sipsolutions.net/patches/old/all/2011-11-09-09%3A16/005-validate-sdata.patch), problems with 5Ghz channels not working properly, and a number of other weird bugs.  So I can't settle on this version of compat-wireless.

I tried looking over the deltas between 3.0-2 and 2012-02-06, but it's incredibly large and feels like searching for the needle in the haystack.

So I'm hoping to connect with someone who is either familiar with the stalling monitor-interface problem I described, or could help me troubleshoot the compat-wireless 3.0-2 to narrow down on what's causing it.  Or, failing all else, suggest an alternative version to test with.

Thanks,
--
-bp


