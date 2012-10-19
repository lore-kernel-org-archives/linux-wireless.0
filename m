Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:44700 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169Ab2JSRnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 13:43:07 -0400
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id bsxBPtgM0GpQcBiw (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2012 13:43:05 -0400 (EDT)
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: bug in mesh_sync_adjust_tbtt()
Date: Fri, 19 Oct 2012 17:43:03 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D075EBFDE@RockMX01.rock.corp> (sfid-20121019_194319_850823_0C6D9E48)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have checked a few kernel versions between 3.5 and 3.6.2, even the latest version 3.6.2 has the same problem.


In file net/mac80211/mesh_sync.c

Function: coid  mesh_sync_adjust_tbtt()
{
    spin_lock_bh(&ifmsh->sync_offset_lock);
..
    tsf = drv_get_tsf(local, sdata);
    if (tsf != -1ULL)
        drv_set_tsf(local, sdata, tsf + tsfdelta);

    spin_unlock_bh(&ifmsh->sync_offset_lock);
}


In file net/mac80211/driver-ops.h

static inline u64 drv_get_tsf(struct ieee80211_local *local,
                  struct ieee80211_sub_if_data *sdata)
{   
.
    might_sleep(); 
.
}

The problem is drv_get_tsf() can sleep, but it's called in sleep-prohibit context (enclosed by spin_lock_bh() and    spin_unlock_bh())

As a result, when running mesh traffic for a while, kernel keeps complaining like below.

One question is, can I get rid of might_sleep() in drv_get/set_tsf()? What would be the impact?


Jan 10 01:46:36 2005 default user.err kernel: BUG: scheduling while atomic: kworker/u:1/37/0x10000200
Jan 10 01:46:36 2005 default user.warn kernel: Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables x_tables staNat(PO) arc4 ath9k(O
Jan 10 01:46:36 2005 default user.warn kernel: Call Trace:
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbd20] [c00072b0] show_stack+0x58/0x148 (unreliable)
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbd60] [c00413dc] __schedule_bug+0x48/0x60
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbd70] [c035273c] __schedule+0x68/0x46c
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbe60] [c0041418] __cond_resched+0x24/0x38
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbe80] [c0352bd4] _cond_resched+0x2c/0x48
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbe90] [d53af420] mesh_sync_adjust_tbtt+0x8c/0x160 [mac80211]
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbec0] [d53aa53c] ieee80211_mesh_work+0x17c/0x184 [mac80211]
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbee0] [d538e384] ieee80211_iface_work+0x2a8/0x2b0 [mac80211]
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbf20] [c00321d8] process_one_work+0x1e0/0x2dc
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbf50] [c0033b84] worker_thread+0x24c/0x348
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbfa0] [c003804c] kthread+0xa4/0xa8
Jan 10 01:46:36 2005 default user.warn kernel: [ce9bbff0] [c000ccac] kernel_thread+0x4c/0x68


