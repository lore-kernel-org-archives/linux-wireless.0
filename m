Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab3GZN3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 09:29:04 -0400
Message-ID: <1374845339.8248.48.camel@jlt4.sipsolutions.net> (sfid-20130726_152909_689735_CA01B2A1)
Subject: Re: [PATCH 3.11] iwlwifi: dvm: fix calling
 ieee80211_chswitch_done() with NULL
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Fri, 26 Jul 2013 15:28:59 +0200
In-Reply-To: <20130726132909.GA21925@redhat.com> (sfid-20130726_152609_851490_821A0124)
References: <20130726132909.GA21925@redhat.com>
	 (sfid-20130726_152609_851490_821A0124)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-26 at 15:29 +0200, Stanislaw Gruszka wrote:
> If channel switch is pending and we remove interface we can
> crash like showed below due to passing NULL vif to mac80211:
> 
> BUG: unable to handle kernel paging request at fffffffffffff8cc
> IP: [<ffffffff8130924d>] strnlen+0xd/0x40
> Call Trace:
>  [<ffffffff8130ad2e>] string.isra.3+0x3e/0xd0
>  [<ffffffff8130bf99>] vsnprintf+0x219/0x640
>  [<ffffffff8130c481>] vscnprintf+0x11/0x30
>  [<ffffffff81061585>] vprintk_emit+0x115/0x4f0
>  [<ffffffff81657bd5>] printk+0x61/0x63
>  [<ffffffffa048987f>] ieee80211_chswitch_done+0xaf/0xd0 [mac80211]
>  [<ffffffffa04e7b34>] iwl_chswitch_done+0x34/0x40 [iwldvm]
>  [<ffffffffa04f83c3>] iwlagn_commit_rxon+0x2a3/0xdc0 [iwldvm]
>  [<ffffffffa04ebc50>] ? iwlagn_set_rxon_chain+0x180/0x2c0 [iwldvm]
>  [<ffffffffa04e5e76>] iwl_set_mode+0x36/0x40 [iwldvm]
>  [<ffffffffa04e5f0d>] iwlagn_mac_remove_interface+0x8d/0x1b0 [iwldvm]
>  [<ffffffffa0459b3d>] ieee80211_do_stop+0x29d/0x7f0 [mac80211]
> 
> This is because we nulify ctx->vif in iwlagn_mac_remove_interface()
> before calling some other functions that teardown interface. To fix
> just check ctx->vif on iwl_chswitch_done(). We should not call
> ieee80211_chswitch_done() as channel switch works were already canceled
> by mac80211 in ieee80211_do_stop() -> ieee80211_mgd_stop().

Thanks, I've picked this up.

johannes

