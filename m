Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53445 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab0KSXAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 18:00:19 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oAJN0IMp011740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 15:00:18 -0800
Message-ID: <4CE70182.3010109@candelatech.com>
Date: Fri, 19 Nov 2010 15:00:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Warning at mlme.c in __cfg80211_auth_remove
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I hit this warn-on, not to sure exactly why.

This was on an ath9k system with .37-rc2 wireless testing from yesterday.
29 STA interfaces.

static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
{
	int i;
	bool done = false;

	ASSERT_WDEV_LOCK(wdev);

	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
		if (wdev->authtry_bsses[i] &&
		    memcmp(wdev->authtry_bsses[i]->pub.bssid,
			   addr, ETH_ALEN) == 0) {
			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
			wdev->authtry_bsses[i] = NULL;
			done = true;
			break;
		}
	}

	WARN_ON(!done);
}


WARNING: at /home/greearb/git/linux.wireless-testing/net/wireless/mlme.c:285 __cfg80211_auth_remove+0x98/0x9e [cfg80211]()
Hardware name: PDSBM
Modules linked in: 8021q garp stp llc michael_mic macvlan pktgen fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb microcode ath9]
Pid: 43, comm: kworker/u:3 Tainted: P            2.6.37-rc2-wl+ #50
Call Trace:
  [<78436f25>] warn_slowpath_common+0x77/0x8c
  [<f8da3532>] ? __cfg80211_auth_remove+0x98/0x9e [cfg80211]
  [<f8da3532>] ? __cfg80211_auth_remove+0x98/0x9e [cfg80211]
  [<78436f57>] warn_slowpath_null+0x1d/0x1f
  [<f8da3532>] __cfg80211_auth_remove+0x98/0x9e [cfg80211]
  [<f8da3c6c>] cfg80211_send_auth_timeout+0x90/0xa0 [cfg80211]
  [<784b6538>] ? __slab_free+0x59/0xae
  [<7845a5e5>] ? trace_hardirqs_on+0xb/0xd
  [<f911b329>] ieee80211_probe_auth_done+0x1e/0x7b [mac80211]
  [<f911d68a>] ieee80211_work_work+0xd2a/0xd68 [mac80211]
  [<7845a5e5>] ? trace_hardirqs_on+0xb/0xd
  [<78446f3c>] process_one_work+0x1af/0x2bf
  [<78446ecb>] ? process_one_work+0x13e/0x2bf
  [<f911c960>] ? ieee80211_work_work+0x0/0xd68 [mac80211]
  [<7844868a>] worker_thread+0xf9/0x1bf
  [<78448591>] ? worker_thread+0x0/0x1bf
  [<7844b1ba>] kthread+0x62/0x67
  [<7844b158>] ? kthread+0x0/0x67
  [<784036c6>] kernel_thread_helper+0x6/0x1a
---[ end trace efa7135148c6ef21 ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

