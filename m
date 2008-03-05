Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37207 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbYCEB5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 20:57:40 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 4/8] mac80211: RCU-ify STA info structure access
Date: Tue, 4 Mar 2008 17:57:08 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003CFB0E4@orsmsx416.amr.corp.intel.com> (sfid-20080305_015801_816748_E7CBCBBE)
In-Reply-To: <20080222111749.689180000@sipsolutions.net>
References: <20080222111644.183587000@sipsolutions.net> <20080222111749.689180000@sipsolutions.net>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
Cc: <linux-wireless@vger.kernel.org>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Johannes Berg  wrote:

> This makes access to the STA hash table/list use RCU to protect
> against freeing of items. However, it's not a true RCU, the
> copy step is missing: whenever somebody changes a STA item it
> is simply updated. That will be addressed by a later change.
> 

This patch is causing some problems in the iwlwifi driver. Often when
one of these RCU locks are held the driver tries to send a command to
the device and waits for the response, or it does some other activity
requiring sleeping. This causes numerous BUG messages as seen below:

BUG: sleeping function called from invalid context at
/home/rchatre/wifi/repos.git/iwlwifi-2.6/kernel/mutex.c:209
in_atomic():1, irqs_disabled():0
3 locks held by iwl3945/3831:
 #0:  ((name)){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #1:  (&ifsta->work){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #2:  (rcu_read_lock){..--}, at: [<dc9d558d>]
ieee80211_rx_mgmt_assoc_resp+0x273/0x773 [mac80211]
Pid: 3831, comm: iwl3945 Not tainted 2.6.25-rc3-wl #7
 [<c0118a4d>] __might_sleep+0xc2/0xc9
 [<c02ab3f3>] mutex_lock_nested+0x1d/0x231
 [<c01300d8>] ? sys_timer_settime+0x2a/0x225
 [<c02acae9>] ? _spin_unlock_irqrestore+0x38/0x58
 [<dca8e637>] iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
 [<dc9d186a>] ieee80211_sta_wmm_params+0x165/0x195 [mac80211]
 [<dc9d5a19>] ieee80211_rx_mgmt_assoc_resp+0x6ff/0x773 [mac80211]
 [<c01662b7>] ? cache_flusharray+0xdf/0xf2
 [<c013c360>] ? __lock_acquire+0xb0c/0xb39
 [<dc9d70ab>] ieee80211_sta_work+0x726/0xfde [mac80211]
 [<c013c371>] ? __lock_acquire+0xb1d/0xb39
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<c012d87c>] run_workqueue+0xbb/0x18b
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<dc9d6985>] ? ieee80211_sta_work+0x0/0xfde [mac80211]
 [<c012e21f>] worker_thread+0xb6/0xc2
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<c012e169>] ? worker_thread+0x0/0xc2
 [<c01306b0>] kthread+0x3b/0x63
 [<c0130675>] ? kthread+0x0/0x63
 [<c01057af>] kernel_thread_helper+0x7/0x10
 =======================
BUG: scheduling while atomic: iwl3945/3831/0x00000002
4 locks held by iwl3945/3831:
 #0:  ((name)){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #1:  (&ifsta->work){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #2:  (rcu_read_lock){..--}, at: [<dc9d558d>]
ieee80211_rx_mgmt_assoc_resp+0x273/0x773 [mac80211]
 #3:  (&priv->mutex){--..}, at: [<dca8e637>]
iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
Pid: 3831, comm: iwl3945 Not tainted 2.6.25-rc3-wl #7
 [<c011af81>] __schedule_bug+0x59/0x60
 [<c02aa617>] schedule+0x91/0x5f7
 [<c013b2dc>] ? mark_held_locks+0x4e/0x66
 [<c02ab50b>] ? mutex_lock_nested+0x135/0x231
 [<c02ab520>] mutex_lock_nested+0x14a/0x231
 [<dca8e637>] ? iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
 [<dca8e637>] iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
 [<dc9d186a>] ieee80211_sta_wmm_params+0x165/0x195 [mac80211]
 [<dc9d5a19>] ieee80211_rx_mgmt_assoc_resp+0x6ff/0x773 [mac80211]
 [<c01662b7>] ? cache_flusharray+0xdf/0xf2
 [<c013c360>] ? __lock_acquire+0xb0c/0xb39
 [<dc9d70ab>] ieee80211_sta_work+0x726/0xfde [mac80211]
 [<c013c371>] ? __lock_acquire+0xb1d/0xb39
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<c012d87c>] run_workqueue+0xbb/0x18b
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<dc9d6985>] ? ieee80211_sta_work+0x0/0xfde [mac80211]
 [<c012e21f>] worker_thread+0xb6/0xc2
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<c012e169>] ? worker_thread+0x0/0xc2
 [<c01306b0>] kthread+0x3b/0x63
 [<c0130675>] ? kthread+0x0/0x63
 [<c01057af>] kernel_thread_helper+0x7/0x10
 =======================
BUG: scheduling while atomic: iwl3945/3831/0x00000002
4 locks held by iwl3945/3831:
 #0:  ((name)){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #1:  (&ifsta->work){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #2:  (rcu_read_lock){..--}, at: [<dc9d558d>]
ieee80211_rx_mgmt_assoc_resp+0x273/0x773 [mac80211]
 #3:  (&priv->mutex){--..}, at: [<dca8e637>]
iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
Pid: 3831, comm: iwl3945 Not tainted 2.6.25-rc3-wl #7
 [<c011af81>] __schedule_bug+0x59/0x60
 [<c02aa617>] schedule+0x91/0x5f7
 [<c02acaf3>] ? _spin_unlock_irqrestore+0x42/0x58
 [<c0127b22>] ? __mod_timer+0xa5/0xb0
 [<c02aad57>] schedule_timeout+0x6d/0x8b
 [<c0127703>] ? process_timeout+0x0/0xa
 [<c02aad52>] ? schedule_timeout+0x68/0x8b
 [<dca86643>] iwl3945_send_cmd_sync+0x5e9/0x1180 [iwl3945]
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<dca87302>] iwl3945_send_cmd_pdu+0x2f/0x37 [iwl3945]
 [<dca875c7>] iwl3945_activate_qos+0xce/0xd7 [iwl3945]
 [<dca8e661>] iwl3945_mac_conf_tx+0x1da/0x234 [iwl3945]
 [<dc9d186a>] ieee80211_sta_wmm_params+0x165/0x195 [mac80211]
 [<dc9d5a19>] ieee80211_rx_mgmt_assoc_resp+0x6ff/0x773 [mac80211]
 [<c01662b7>] ? cache_flusharray+0xdf/0xf2
 [<c013c360>] ? __lock_acquire+0xb0c/0xb39
 [<dc9d70ab>] ieee80211_sta_work+0x726/0xfde [mac80211]
 [<c013c371>] ? __lock_acquire+0xb1d/0xb39
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<c012d87c>] run_workqueue+0xbb/0x18b
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<dc9d6985>] ? ieee80211_sta_work+0x0/0xfde [mac80211]
 [<c012e21f>] worker_thread+0xb6/0xc2
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<c012e169>] ? worker_thread+0x0/0xc2
 [<c01306b0>] kthread+0x3b/0x63
 [<c0130675>] ? kthread+0x0/0x63
 [<c01057af>] kernel_thread_helper+0x7/0x10
 =======================
BUG: scheduling while atomic: iwl3945/3831/0x00000002
4 locks held by iwl3945/3831:
 #0:  ((name)){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #1:  (&ifsta->work){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #2:  (rcu_read_lock){..--}, at: [<dc9d558d>]
ieee80211_rx_mgmt_assoc_resp+0x273/0x773 [mac80211]
 #3:  (&priv->mutex){--..}, at: [<dca8e637>]
iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
Pid: 3831, comm: iwl3945 Not tainted 2.6.25-rc3-wl #7
 [<c011af81>] __schedule_bug+0x59/0x60
 [<c02aa617>] schedule+0x91/0x5f7
 [<c02acaf3>] ? _spin_unlock_irqrestore+0x42/0x58
 [<c0127b22>] ? __mod_timer+0xa5/0xb0
 [<c02aad57>] schedule_timeout+0x6d/0x8b
 [<c0127703>] ? process_timeout+0x0/0xa
 [<c02aad52>] ? schedule_timeout+0x68/0x8b
 [<dca86643>] iwl3945_send_cmd_sync+0x5e9/0x1180 [iwl3945]
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<dca87302>] iwl3945_send_cmd_pdu+0x2f/0x37 [iwl3945]
 [<dca875c7>] iwl3945_activate_qos+0xce/0xd7 [iwl3945]
 [<dca8e661>] iwl3945_mac_conf_tx+0x1da/0x234 [iwl3945]
 [<dc9d186a>] ieee80211_sta_wmm_params+0x165/0x195 [mac80211]
 [<dc9d5a19>] ieee80211_rx_mgmt_assoc_resp+0x6ff/0x773 [mac80211]
 [<c01662b7>] ? cache_flusharray+0xdf/0xf2
 [<c013c360>] ? __lock_acquire+0xb0c/0xb39
 [<dc9d70ab>] ieee80211_sta_work+0x726/0xfde [mac80211]
 [<c013c371>] ? __lock_acquire+0xb1d/0xb39
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<c012d87c>] run_workqueue+0xbb/0x18b
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<dc9d6985>] ? ieee80211_sta_work+0x0/0xfde [mac80211]
 [<c012e21f>] worker_thread+0xb6/0xc2
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<c012e169>] ? worker_thread+0x0/0xc2
 [<c01306b0>] kthread+0x3b/0x63
 [<c0130675>] ? kthread+0x0/0x63
 [<c01057af>] kernel_thread_helper+0x7/0x10
 =======================
BUG: scheduling while atomic: iwl3945/3831/0x00000002
4 locks held by iwl3945/3831:
 #0:  ((name)){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #1:  (&ifsta->work){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #2:  (rcu_read_lock){..--}, at: [<dc9d558d>]
ieee80211_rx_mgmt_assoc_resp+0x273/0x773 [mac80211]
 #3:  (&priv->mutex){--..}, at: [<dca8e637>]
iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
Pid: 3831, comm: iwl3945 Not tainted 2.6.25-rc3-wl #7
 [<c011af81>] __schedule_bug+0x59/0x60
 [<c02aa617>] schedule+0x91/0x5f7
 [<c02acaf3>] ? _spin_unlock_irqrestore+0x42/0x58
 [<c0127b22>] ? __mod_timer+0xa5/0xb0
 [<c02aad57>] schedule_timeout+0x6d/0x8b
 [<c0127703>] ? process_timeout+0x0/0xa
 [<c02aad52>] ? schedule_timeout+0x68/0x8b
 [<dca86643>] iwl3945_send_cmd_sync+0x5e9/0x1180 [iwl3945]
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<dca87302>] iwl3945_send_cmd_pdu+0x2f/0x37 [iwl3945]
 [<dca875c7>] iwl3945_activate_qos+0xce/0xd7 [iwl3945]
 [<dca8e661>] iwl3945_mac_conf_tx+0x1da/0x234 [iwl3945]
 [<dc9d186a>] ieee80211_sta_wmm_params+0x165/0x195 [mac80211]
 [<dc9d5a19>] ieee80211_rx_mgmt_assoc_resp+0x6ff/0x773 [mac80211]
 [<c01662b7>] ? cache_flusharray+0xdf/0xf2
 [<c013c360>] ? __lock_acquire+0xb0c/0xb39
 [<dc9d70ab>] ieee80211_sta_work+0x726/0xfde [mac80211]
 [<c013c371>] ? __lock_acquire+0xb1d/0xb39
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<c012d87c>] run_workqueue+0xbb/0x18b
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<dc9d6985>] ? ieee80211_sta_work+0x0/0xfde [mac80211]
 [<c012e21f>] worker_thread+0xb6/0xc2
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<c012e169>] ? worker_thread+0x0/0xc2
 [<c01306b0>] kthread+0x3b/0x63
 [<c0130675>] ? kthread+0x0/0x63
 [<c01057af>] kernel_thread_helper+0x7/0x10
 =======================
BUG: scheduling while atomic: iwl3945/3831/0x00000002
4 locks held by iwl3945/3831:
 #0:  ((name)){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #1:  (&ifsta->work){--..}, at: [<c012d841>] run_workqueue+0x80/0x18b
 #2:  (rcu_read_lock){..--}, at: [<dc9d558d>]
ieee80211_rx_mgmt_assoc_resp+0x273/0x773 [mac80211]
 #3:  (&priv->mutex){--..}, at: [<dca8e637>]
iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
Pid: 3831, comm: iwl3945 Not tainted 2.6.25-rc3-wl #7
 [<c011af81>] __schedule_bug+0x59/0x60
 [<c02aa617>] schedule+0x91/0x5f7
 [<c02acaf3>] ? _spin_unlock_irqrestore+0x42/0x58
 [<c0127b22>] ? __mod_timer+0xa5/0xb0
 [<c02aad57>] schedule_timeout+0x6d/0x8b
 [<c0127703>] ? process_timeout+0x0/0xa
 [<c02aad52>] ? schedule_timeout+0x68/0x8b
 [<dca86643>] iwl3945_send_cmd_sync+0x5e9/0x1180 [iwl3945]
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<dca87302>] iwl3945_send_cmd_pdu+0x2f/0x37 [iwl3945]
 [<dca875c7>] iwl3945_activate_qos+0xce/0xd7 [iwl3945]
 [<dca8e661>] iwl3945_mac_conf_tx+0x1da/0x234 [iwl3945]
 [<dc9d186a>] ieee80211_sta_wmm_params+0x165/0x195 [mac80211]
 [<dc9d5a19>] ieee80211_rx_mgmt_assoc_resp+0x6ff/0x773 [mac80211]
 [<c01662b7>] ? cache_flusharray+0xdf/0xf2
 [<c013c360>] ? __lock_acquire+0xb0c/0xb39
 [<dc9d70ab>] ieee80211_sta_work+0x726/0xfde [mac80211]
 [<c013c371>] ? __lock_acquire+0xb1d/0xb39
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<c012d87c>] run_workqueue+0xbb/0x18b
 [<c012d841>] ? run_workqueue+0x80/0x18b
 [<dc9d6985>] ? ieee80211_sta_work+0x0/0xfde [mac80211]
 [<c012e21f>] worker_thread+0xb6/0xc2
 [<c013076e>] ? autoremove_wake_function+0x0/0x30
 [<c012e169>] ? worker_thread+0x0/0xc2
 [<c01306b0>] kthread+0x3b/0x63
 [<c0130675>] ? kthread+0x0/0x63
 [<c01057af>] kernel_thread_helper+0x7/0x10
 =======================
