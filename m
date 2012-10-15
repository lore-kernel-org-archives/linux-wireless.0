Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25399 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab2JOO47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 10:56:59 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: RE: Lots of trans->state != IWL_TRANS_FW_ALIVE warnings
Date: Mon, 15 Oct 2012 14:56:45 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3B7D46B@HASMSX106.ger.corp.intel.com> (sfid-20121015_165703_007273_AE378063)
References: <20121015144722.GA12560@redhat.com>
In-Reply-To: <20121015144722.GA12560@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Fedora (3.5 and 3.6 kernels) we are currently overwhelmed by tons of
> iwlwifi warnings at iwlagn_mac_flush() and iwl_dvm_send_cmd() reports.
> 
> iwlagn_mac_flush warning is triggered at:
> 
> static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans) {
>         WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
>                   "%s bad state = %d", __func__, trans->state);
> 
>         return trans->ops->wait_tx_queue_empty(trans);
> }
> 
> We have 2 instances of this issue:
> 
> - started at ieee80211_scan()
> https://bugzilla.redhat.com/show_bug.cgi?id=866013
> - started at ieee80211_sta_monitor_work()
> https://bugzilla.redhat.com/show_bug.cgi?id=861753
> 
> iwl_dvm_send_cmd is triggered at:
> 
> static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
>                                 struct iwl_host_cmd *cmd) {
>         WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
>                   "%s bad state = %d", __func__, trans->state);
> 
>         return trans->ops->send_cmd(trans, cmd); }
> 
> And have 3 instances:
> 
> - started at ieee80211_set_disassoc()
> https://bugzilla.redhat.com/show_bug.cgi?id=861599
> - started at ieee80211_restart_work()
> https://bugzilla.redhat.com/show_bug.cgi?id=865072
> - started at ieee80211_auth()
> https://bugzilla.redhat.com/show_bug.cgi?id=866015
> 

I glanced at the bugs and I can only see the trace dump. I am pretty sure there is an issue before the dump - fw assert of something like that. Can it be possible to get the full log?

> Can those be fixed in some reasonable time ?
> 
> I'm not sure if they are related with some user visible problem like
> disconnects.

Well... if the fw isn't ALIVE then something bad happens, bad enough to get disconnected, yes.
> 
> I'll probably revert f0d120af8f55649571c681f49c920b0822050fa5
> on Fedora, just to stop getting those warnings ...
> 

You will stop get the warnings, but that of course won't solve anything else.
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

