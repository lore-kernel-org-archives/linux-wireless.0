Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bromo.msbb.uc.edu ([129.137.3.146]:37308 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751214AbYG3N2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 09:28:48 -0400
Date: Wed, 30 Jul 2008 09:28:46 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: AP association timeout bugzilla PR?
Message-ID: <20080730132846.GA10959@bromo.msbb.uc.edu> (sfid-20080730_152850_741923_F1C11B93)
References: <20080728172722.GA26893@bromo.msbb.uc.edu> <1217266609.15381.4.camel@johannes.berg> <20080730001012.GA2046@bromo.msbb.uc.edu> <1217402210.10489.81.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217402210.10489.81.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,
   I do see one oddity with the current ath9k git, 2.6.26-rc1
(which appears to have all of the changes in the mywireless-testing
git, your skb->cb fix and my attempt at the same patch for ath9k.
The ath9k driver seems to work okay but I see the following in
the messages log...

Jul 30 08:19:39 localhost kernel:
Jul 30 08:19:39 localhost kernel: =============================================
Jul 30 08:19:39 localhost kernel: [ INFO: possible recursive locking detected ]
Jul 30 08:19:39 localhost kernel: 2.6.27-0.186.rc1.fc9.x86_64 #1
Jul 30 08:19:39 localhost kernel: ---------------------------------------------
Jul 30 08:19:39 localhost kernel: ath9k/1379 is trying to acquire lock:
Jul 30 08:19:39 localhost kernel: (_xmit_IEEE80211#2){-...}, at: [<ffffffffa00f5
c46>] ieee80211_scan_completed+0x142/0x2e2 [mac80211]
Jul 30 08:19:39 localhost kernel:
Jul 30 08:19:39 localhost kernel: but task is already holding lock:
Jul 30 08:19:39 localhost kernel: (_xmit_IEEE80211#2){-...}, at: [<ffffffffa00f5
c46>] ieee80211_scan_completed+0x142/0x2e2 [mac80211]
Jul 30 08:19:39 localhost kernel:
Jul 30 08:19:39 localhost kernel: other info that might help us debug this:
Jul 30 08:19:39 localhost kernel: 3 locks held by ath9k/1379:
Jul 30 08:19:39 localhost kernel: #0:  ((name)){--..}, at: [<ffffffff81053f56>]
run_workqueue+0xb6/0x207
Jul 30 08:19:39 localhost kernel: #1:  (&(&local->scan_work)->work){--..}, at: [
<ffffffff81053f56>] run_workqueue+0xb6/0x207
Jul 30 08:19:39 localhost kernel: #2:  (_xmit_IEEE80211#2){-...}, at: [<ffffffff
a00f5c46>] ieee80211_scan_completed+0x142/0x2e2 [mac80211]
Jul 30 08:19:39 localhost kernel:
Jul 30 08:19:39 localhost kernel: stack backtrace:
Jul 30 08:19:39 localhost kernel: Pid: 1379, comm: ath9k Not tainted 2.6.27-0.18
6.rc1.fc9.x86_64 #1
Jul 30 08:19:39 localhost kernel:
Jul 30 08:19:39 localhost kernel: Call Trace:
Jul 30 08:19:39 localhost kernel: [<ffffffff8106625e>] __lock_acquire+0x790/0xaa
7
Jul 30 08:19:39 localhost kernel: [<ffffffffa00f5c46>] ? ieee80211_scan_complete
d+0x142/0x2e2 [mac80211]
Jul 30 08:19:39 localhost kernel: [<ffffffff8106660b>] lock_acquire+0x96/0xc3
Jul 30 08:19:39 localhost kernel: [<ffffffffa00f5c46>] ? ieee80211_scan_complete
d+0x142/0x2e2 [mac80211]
Jul 30 08:19:39 localhost kernel: [<ffffffff81309838>] _spin_lock+0x2b/0x58
Jul 30 08:19:39 localhost kernel: [<ffffffffa00f5c46>] ieee80211_scan_completed+
0x142/0x2e2 [mac80211]
Jul 30 08:19:39 localhost kernel: [<ffffffff81053f56>] ? run_workqueue+0xb6/0x20
7
Jul 30 08:19:39 localhost kernel: [<ffffffffa00f6097>] ieee80211_sta_scan_work+0
xb4/0x1ad [mac80211]
Jul 30 08:19:39 localhost kernel: [<ffffffff81053fa0>] run_workqueue+0x100/0x207
Jul 30 08:19:39 localhost kernel: [<ffffffffa00f5fe3>] ? ieee80211_sta_scan_work
+0x0/0x1ad [mac80211]
Jul 30 08:19:39 localhost kernel: [<ffffffff810541a4>] worker_thread+0xfd/0x111
Jul 30 08:19:39 localhost kernel: [<ffffffff81057ee1>] ? autoremove_wake_functio
n+0x0/0x3d
Jul 30 08:19:39 localhost kernel: [<ffffffff810540a7>] ? worker_thread+0x0/0x111
Jul 30 08:19:39 localhost kernel: [<ffffffff81057b64>] kthread+0x4e/0x7b
Jul 30 08:19:39 localhost kernel: [<ffffffff81011849>] child_rip+0xa/0x11
Jul 30 08:19:39 localhost kernel: [<ffffffff81010b5e>] ? restore_args+0x0/0x30
Jul 30 08:19:39 localhost kernel: [<ffffffff81057b16>] ? kthread+0x0/0x7b
Jul 30 08:19:39 localhost kernel: [<ffffffff8101183f>] ? child_rip+0x0/0x11
Jul 30 08:19:39 localhost kernel:
Jul 30 08:19:39 localhost kernel: ADDRCONF(NETDEV_CHANGE): ath0: link becomes re
ady

Is this a known issue or perhaps due to may skb->cb patch for ath9k?
                                 Jack

On Wed, Jul 30, 2008 at 09:16:50AM +0200, Johannes Berg wrote:
> On Tue, 2008-07-29 at 20:10 -0400, Jack Howarth wrote:
> > Johannes,
> >     FYI, does this following patch look okay for ath9k?
> > 
> > --- drivers/net/wireless/ath9k/xmit.c.orig	2008-07-29 19:32:26.000000000 -0400
> > +++ drivers/net/wireless/ath9k/xmit.c	2008-07-29 20:04:09.000000000 -0400
> > @@ -37,6 +37,10 @@
> >  
> >  #define OFDM_SIFS_TIME    	    16
> >  
> > +#ifndef ETH_P_PAE
> > +#define ETH_P_PAE 0x888E /* Port Access Entity (IEEE 802.1X) */
> > +#endif /* ETH_P_PAE */
> > +
> >  static u_int32_t bits_per_symbol[][2] = {
> 
> I guess that should finally be moved to a more appropriate place as the
> todo-list on wireless.kernel.org mentions.
> 
> johannes


