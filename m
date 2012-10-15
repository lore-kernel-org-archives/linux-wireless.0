Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab2JOOsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 10:48:13 -0400
Date: Mon, 15 Oct 2012 16:47:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Lots of trans->state != IWL_TRANS_FW_ALIVE warnings
Message-ID: <20121015144722.GA12560@redhat.com> (sfid-20121015_164817_120200_71D04661)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fedora (3.5 and 3.6 kernels) we are currently overwhelmed by
tons of iwlwifi warnings at iwlagn_mac_flush() and iwl_dvm_send_cmd()
reports.

iwlagn_mac_flush warning is triggered at:

static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
{
        WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
                  "%s bad state = %d", __func__, trans->state);

        return trans->ops->wait_tx_queue_empty(trans);
}

We have 2 instances of this issue:

- started at ieee80211_scan()
https://bugzilla.redhat.com/show_bug.cgi?id=866013
- started at ieee80211_sta_monitor_work()
https://bugzilla.redhat.com/show_bug.cgi?id=861753

iwl_dvm_send_cmd is triggered at:

static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
                                struct iwl_host_cmd *cmd)
{
        WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
                  "%s bad state = %d", __func__, trans->state);

        return trans->ops->send_cmd(trans, cmd);
}

And have 3 instances:

- started at ieee80211_set_disassoc()
https://bugzilla.redhat.com/show_bug.cgi?id=861599
- started at ieee80211_restart_work()
https://bugzilla.redhat.com/show_bug.cgi?id=865072
- started at ieee80211_auth()
https://bugzilla.redhat.com/show_bug.cgi?id=866015

Can those be fixed in some reasonable time ?

I'm not sure if they are related with some user visible problem like
disconnects.

I'll probably revert f0d120af8f55649571c681f49c920b0822050fa5
on Fedora, just to stop getting those warnings ...

Stanislaw

