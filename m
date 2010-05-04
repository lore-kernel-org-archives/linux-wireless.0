Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48237 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934571Ab0EDXLb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 19:11:31 -0400
Subject: Re: [PATCH] mac80211: remove association work when processing
 deauth request
From: reinette chatre <reinette.chatre@intel.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1273014289-21765-1-git-send-email-reinette.chatre@intel.com>
References: <1273014289-21765-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 16:11:29 -0700
Message-ID: <1273014689.20081.85.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-04 at 16:04 -0700, Chatre, Reinette wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> In https://bugzilla.kernel.org/show_bug.cgi?id=15794 a user encountered the
> following:
> 
> [18967.469098] wlan0: authenticated
> [18967.472527] wlan0: associate with 00:1c:10:b8:e3:ea (try 1)
> [18967.472585] wlan0: deauthenticating from 00:1c:10:b8:e3:ea by local choice (reason=3)
> [18967.672057] wlan0: associate with 00:1c:10:b8:e3:ea (try 2)
> [18967.872357] wlan0: associate with 00:1c:10:b8:e3:ea (try 3)
> [18968.072960] wlan0: association with 00:1c:10:b8:e3:ea timed out
> [18968.076890] ------------[ cut here ]------------
> [18968.076898] WARNING: at net/wireless/mlme.c:341 cfg80211_send_assoc_timeout+0xa8/0x140()
> [18968.076900] Hardware name: GX628
> [18968.076924] Pid: 1408, comm: phy0 Not tainted 2.6.34-rc4-00082-g250541f-dirty #3
> [18968.076926] Call Trace:
> [18968.076931]  [<ffffffff8103459e>] ?  warn_slowpath_common+0x6e/0xb0
> [18968.076934]  [<ffffffff8157c2d8>] ?  cfg80211_send_assoc_timeout+0xa8/0x140
> [18968.076937]  [<ffffffff8103ff8b>] ? mod_timer+0x10b/0x180
> [18968.076940]  [<ffffffff8158f0fc>] ?  ieee80211_assoc_done+0xbc/0xc0
> [18968.076943]  [<ffffffff81590d53>] ?  ieee80211_work_work+0x553/0x11c0
> [18968.076945]  [<ffffffff8102d931>] ? finish_task_switch+0x41/0xb0
> [18968.076948]  [<ffffffff81590800>] ?  ieee80211_work_work+0x0/0x11c0
> [18968.076951]  [<ffffffff810476fb>] ? worker_thread+0x13b/0x210
> [18968.076954]  [<ffffffff8104b6b0>] ?  autoremove_wake_function+0x0/0x30
> [18968.076956]  [<ffffffff810475c0>] ? worker_thread+0x0/0x210
> [18968.076959]  [<ffffffff8104b21e>] ? kthread+0x8e/0xa0
> [18968.076962]  [<ffffffff810031f4>] ?  kernel_thread_helper+0x4/0x10
> [18968.076964]  [<ffffffff8104b190>] ? kthread+0x0/0xa0
> [18968.076966]  [<ffffffff810031f0>] ?  kernel_thread_helper+0x0/0x10
> [18968.076968] ---[ end trace 8aa6265f4b1adfe0 ]---
> 
> As explained by Johannes Berg <johannes@sipsolutions.net>:
> 
> We authenticate successfully, and then userspace requests association.
> Then we start that process, but the AP doesn't respond. While we're
> still waiting for an AP response, userspace asks for a deauth. We do
> the deauth, but don't abort the association work. Then once the
> association work times out we tell cfg80211, but it no longer wants
> to know since for all it is concerned we accepted the deauth that
> also kills the association attempt.
> 
> Fix this by, upon receipt of deauth request, removing the association work
> and continuing to send the deauth.
> 
> Unfortunately the user reporting the issue is not able to reproduce this
> problem anymore and cannot verify this fix. This seems like a well understood
> issue though and I thus present the patch.
> 
> Bug-identified-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

Please also consider this patch for wireless-2.6 - it applies cleanly.

Reinette


