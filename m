Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43878 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751112AbdALPqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 10:46:44 -0500
Message-ID: <1484235986.19860.1.camel@sipsolutions.net> (sfid-20170112_164647_857564_7351E442)
Subject: Re: [PATCH] ath10k: prevent sta pointer rcu violation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>, kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        greearb@candelatech.com, mohammed@qti.qualcomm.com
Date: Thu, 12 Jan 2017 16:46:26 +0100
In-Reply-To: <1484234070-7431-1-git-send-email-michal.kazior@tieto.com> (sfid-20170112_161320_723424_362B312F)
References: <1484234070-7431-1-git-send-email-michal.kazior@tieto.com>
         (sfid-20170112_161320_723424_362B312F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-12 at 16:14 +0100, Michal Kazior wrote:
> Station pointers are RCU protected so driver must
> be extra careful if it tries to store them
> internally for later use outside of the RCU
> section it obtained it in.
> 
> It was possible for station teardown to race with
> some htt events. The possible outcome could be a
> use-after-free and a crash.
> 
> Only peer-flow-control capable firmware was
> affected (so hardware-wise qca99x0 and qca4019).
> 
> This could be done in sta_state() itself via
> explicit synchronize_net() call but there's
> already a convenient sta_pre_rcu_remove() op that
> can be hooked up to avoid extra rcu stall.

I don't think this makes sense. You're not using RCU-protected pointers
to the stations yourself, all accesses to them are locked under the
&ar->data_lock. As a consequence, you can't have any need for waiting
for a grace period. Since you also remove the pointer (under lock) when
the station gets removed, I don't think RCU can be the problem?

johannes
