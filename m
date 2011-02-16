Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab1BPJzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 04:55:01 -0500
Date: Wed, 16 Feb 2011 10:54:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix conn_mon_timer running after disassociate
Message-ID: <20110216095443.GC2812@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
 <1297698696.4723.16.camel@wwguy-ubuntu>
 <20110215113444.GC2162@redhat.com>
 <1297770602.3935.3.camel@jlt3.sipsolutions.net>
 <20110215130428.GA2515@redhat.com>
 <1297775393.3935.15.camel@jlt3.sipsolutions.net>
 <20110215132202.GC2515@redhat.com>
 <1297776631.3935.16.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297776631.3935.16.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Low level driver could pass rx frames to us after disassociate, what
can lead to run conn_mon_timer by ieee80211_sta_rx_notify(). Thats
is obviously wrong, but nothing happens until we unload modules and
resources are used after free. If kernel debugging is enabled following
warning could be observed:

WARNING: at lib/debugobjects.c:259 debug_print_object+0x65/0x70()
Hardware name: HP xw8600 Workstation
ODEBUG: free active (active state 0) object type: timer_list
Modules linked in: iwlagn(-) iwlcore mac80211 cfg80211 ...
Pid: 13827, comm: rmmod Tainted: G        W   2.6.38-rc4-wl+ #22
Call Trace:
 [<ffffffff810649cf>] ? warn_slowpath_common+0x7f/0xc0
 [<ffffffff81064ac6>] ? warn_slowpath_fmt+0x46/0x50
 [<ffffffff81226fc5>] ? debug_print_object+0x65/0x70
 [<ffffffff81227625>] ? debug_check_no_obj_freed+0x125/0x210
 [<ffffffff8109ebd7>] ? debug_check_no_locks_freed+0xf7/0x170
 [<ffffffff81156092>] ? kfree+0xc2/0x2f0
 [<ffffffff813ec5c5>] ? netdev_release+0x45/0x60
 [<ffffffff812f1067>] ? device_release+0x27/0xa0
 [<ffffffff81216ddd>] ? kobject_release+0x8d/0x1a0
 [<ffffffff81216d50>] ? kobject_release+0x0/0x1a0
 [<ffffffff812183b7>] ? kref_put+0x37/0x70
 [<ffffffff81216c57>] ? kobject_put+0x27/0x60
 [<ffffffff813d5d1b>] ? netdev_run_todo+0x1ab/0x270
 [<ffffffff813e771e>] ? rtnl_unlock+0xe/0x10
 [<ffffffffa0581188>] ? ieee80211_unregister_hw+0x58/0x120 [mac80211]
 [<ffffffffa0377ed7>] ? iwl_pci_remove+0xdb/0x22a [iwlagn]
 [<ffffffff8123cde2>] ? pci_device_remove+0x52/0x120
 [<ffffffff812f5205>] ? __device_release_driver+0x75/0xe0
 [<ffffffff812f5348>] ? driver_detach+0xd8/0xe0
 [<ffffffff812f4111>] ? bus_remove_driver+0x91/0x100
 [<ffffffff812f5b62>] ? driver_unregister+0x62/0xa0
 [<ffffffff8123d194>] ? pci_unregister_driver+0x44/0xa0
 [<ffffffffa0377df5>] ? iwl_exit+0x15/0x1c [iwlagn]
 [<ffffffff810ab492>] ? sys_delete_module+0x1a2/0x270
 [<ffffffff81498889>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100bf42>] ? system_call_fastpath+0x16/0x1b

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/mlme.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d89e878..7b3f9df 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1071,6 +1071,12 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(hdr->addr1))
 		return;
 
+	/*
+	 * In case we receive pending frames after disassociation.
+	 */
+	if (!sdata->u.mgd.associated)
+		return;
+
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-- 
1.7.1

