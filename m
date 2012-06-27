Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2F0Nvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 09:51:42 -0400
Message-ID: <1340805097.11012.24.camel@jlt3.sipsolutions.net> (sfid-20120627_155146_490557_390B90C9)
Subject: 3.4.x bug with channel type changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	manschwetus@googlemail.com
Date: Wed, 27 Jun 2012 15:51:37 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

I'm debugging a problem for a user (Florian)
(http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2363) that turns
out to be a mac80211 bug in 3.4, apparently introduced by an interaction
between your commit

commit 3117bbdb7899d43927c8ce4fe885ab7c1231c121
Author: Paul Stewart <pstew@chromium.org>
Date:   Tue Mar 13 07:46:18 2012 -0700

    mac80211: Don't let regulatory make us deaf


and Rajkumar's commit

commit 7cc44ed48d0ec0937c1f098642540b6c9ca38de5
Author: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Date:   Fri Sep 16 15:32:34 2011 +0530

    mac80211: Fix regression on queue stop during 2040 bss change


The problem is that the code looks like this in 3.4, after both commits:

        if (beacon_htcap_ie && (prev_chantype != rx_channel_type)) {
                /*
                 * Whenever the AP announces the HT mode change that can be
                 * 40MHz intolerant or etc., it would be safer to stop tx
                 * queues before doing hw config to avoid buffer overflow.
                 */
                ieee80211_stop_queues_by_reason(&sdata->local->hw,
                                IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);

                /* flush out all packets */
                synchronize_net();

                drv_flush(local, false);  
        }

        /* channel_type change automatically detected */
        ieee80211_hw_config(local, 0);

        if (prev_chantype != tx_channel_type) {
                rcu_read_lock();
                sta = sta_info_get(sdata, bssid);
                if (sta)
                        rate_control_rate_update(local, sband, sta,
                                                 IEEE80211_RC_HT_CHANGED,
                                                 tx_channel_type);
                rcu_read_unlock();
  
                if (beacon_htcap_ie)
                        ieee80211_wake_queues_by_reason(&sdata->local->hw,
                                IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
        }


In the tracing I got from Florian, I see that the AP is constantly
switching between HT20 and HT40-. At some point, all this switching
leads to all queues remaining stopped -- forever. The module has to be
unloaded & reloaded for this to get fixed because the CHTYPE_CHANGE stop
reason is never cleared and thus we never transmit any packets again.

Clearly, the problem is that in the first if, we check beacon_htcap_ie
as well as "prev_chantype != rx_channel_type", and in the second if that
would wake the queues, it's "prev_chantype != tx_channel_type". Since RX
and TX channel type can differ (which was the point of your commit),
this can lead to queues being woken that weren't stopped (which is not a
problem) or queues being stopped and never woken again (major issue).

Now, the reason I'm writing all this in an email and not a commit log is
that I don't know what the TX/RX channel type usage should be, or if
maybe it should be "if (queues_stopped) wake_queues()" or something like
that... Can you tell me what it should be?

Thanks,
johannes

