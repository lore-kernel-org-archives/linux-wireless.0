Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51822 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3FKTAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 15:00:08 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r5BJ07be024155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 12:00:07 -0700
Message-ID: <51B773B7.5090301@candelatech.com> (sfid-20130611_210013_209733_5352B84F)
Date: Tue, 11 Jun 2013 12:00:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: kmemleak report in 3.9.5+, related to cfg80211_inform_bss_frame
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see several reports similar to the one below while doing some
kmemleak testing on my 3.9.5+ tree (with local patches applied):

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.9.dev.y/.git;a=summary


While looking through the code, I found this in scan.c:cfg80211_bss_update

		} else {
			/*
			 * Ok so we found a beacon, and don't have an entry. If
			 * it's a beacon with hidden SSID, we might be in for an
			 * expensive search for any probe responses that should
			 * be grouped with this beacon for updates ...
			 */
			if (!cfg80211_combine_bsses(dev, new)) {
				kfree(new);
				goto drop;
			}
		}

I don't know if this is the culprit that I am seeing, but I believe
we should be freeing the tmp.pub.beacon_ies (if it is not NULL)
before doing the 'goto drop'?


The kmemleak report is below:


unreferenced object 0xffff8801c8e41e78 (size 192):
   comm "kworker/u:2", pid 157, jiffies 4295509873 (age 86582.869s)
   hex dump (first 32 bytes):
     41 0d 00 30 02 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b  A..0....kkkkkkkk
     6b 6b 6b 6b 6b 6b 6b 6b 69 00 00 00 00 0c 2e 32  kkkkkkkki......2
   backtrace:
     [<ffffffff815de7bf>] kmemleak_alloc+0x73/0x98
     [<ffffffff8118b4d4>] slab_post_alloc_hook+0x28/0x2a
     [<ffffffff8118d605>] __kmalloc+0xf9/0x122
     [<ffffffffa027cb27>] cfg80211_inform_bss_frame+0x114/0x1f8 [cfg80211]
     [<ffffffffa03d6865>] ieee80211_bss_info_update+0x66/0x21f [mac80211]
     [<ffffffffa040aec6>] ieee80211_rx_bss_info+0x12f/0x1ca [mac80211]
     [<ffffffffa040b017>] ieee80211_rx_mgmt_probe_resp+0xb6/0x197 [mac80211]
     [<ffffffffa040e8a3>] ieee80211_sta_rx_queued_mgmt+0xdd/0x60e [mac80211]
     [<ffffffffa03df0ee>] ieee80211_iface_work+0x238/0x2cc [mac80211]
     [<ffffffff810b0cd3>] process_one_work+0x292/0x42e
     [<ffffffff810b36af>] worker_thread+0x14f/0x264
     [<ffffffff810b7bea>] kthread+0xc7/0xcf
     [<ffffffff815f64ec>] ret_from_fork+0x7c/0xb0
     [<ffffffffffffffff>] 0xffffffffffffffff


(gdb) l *(cfg80211_inform_bss_frame+0x114)
0x8b27 is in cfg80211_inform_bss_frame (/home/greearb/git/linux-3.9.dev.y/net/wireless/scan.c:960).
955						   ielen, channel);
956		if (!channel)
957			return NULL;
958	
959		ies = kmalloc(sizeof(*ies) + ielen, gfp);
960		if (!ies)
961			return NULL;
962		ies->len = ielen;
963		ies->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
964		memcpy(ies->data, mgmt->u.probe_resp.variable, ielen);
(gdb)



Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

