Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from amsfep17-int.chello.nl ([213.46.243.15]:15956 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030966AbXDVUwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2007 16:52:23 -0400
Received: from [192.168.4.6] (really [62.163.57.155])
          by amsfep17-int.chello.nl
          (InterMail vM.6.01.04.04 201-2131-118-104-20050224) with ESMTP
          id <20070422205103.KQIE27669.amsfep17-int.chello.nl@[192.168.4.6]>
          for <linux-wireless@vger.kernel.org>;
          Sun, 22 Apr 2007 22:51:03 +0200
Subject: Re: mac80211-7.0.4 ieee80211_ptr trouble
From: Dick Marinus <dick.marinus@chello.nl>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Apr 2007 22:51:05 +0200
Message-Id: <1177275065.9812.9.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Op zaterdag 21-04-2007 om 22:23 uur [tijdzone +0200], schreef Johannes
Berg:
> No, you misunderstood me. The compat package includes a header file
that
> does these defines, but apparently you're missing it.

Ah, it seems ieee80211_ptr doesn't cause the problem, make unmodified
failed:
===
Checking kernel compatibility in:
        /lib/modules/2.6.20-gentoo-r6/source//
 * Kernel requires compatibility version:
   - Requires net_device::ieee80211_ptr compat
   - Requires class_dev -> dev API compat
   - Requires to_net_dev API compat
   - Requires device_rename compat
Building compatibility version in 'compatible/' directory:
Copying compatible/ from origin/...done
 + Applying: patches/ieee80211_ptr.patch
        Re-use ax25_ptr in net_device for ieee80211_ptr
 + Running: ieee80211_ptr.sh
        Type-cast reused void* ax25_ptr to struct wireless_dev *
 + Applying: patches/remove_debugfs.patch
        Remove DEBUGFS usage (due to class_dev breakage)
 + Applying: patches/class_dev_to_dev-wireless-ieee80211_ptr.patch
        Reverse class_dev to dev changes when ieee80211_ptr is used
 + Applying: patches/add_to_net_dev.patch
        Add to_net_dev back in (newer kernels have it in netdevice.h)
-----patch failure output-----
can't find file to patch at input line 4
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|Add to_net_dev back in (newer kernels have it in netdevice.h)
|--- pre/net/mac80211/ieee80211_sysfs.c 2007-04-17 15:54:31.000000000
-0700
|+++ post/net/mac80211/ieee80211_sysfs.c        2007-04-17
15:55:57.000000000 -0700
--------------------------
File to patch: 
Skip this patch? [y] 
Skipping patch.
1 out of 1 hunk ignored

patches/add_to_net_dev.patch failed. Terminating.
If patch or script failed, check pre/ and post/ for current stage.
===
ieee80211_sysfs doesn't seem to exist in {pre,post}/net/mac80211/
neither in /usr/src/linux.

should it have been in the mac80211-7.0.4 tarball?

Thanks,

Dick

