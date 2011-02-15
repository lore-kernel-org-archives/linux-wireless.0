Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1BOLuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 06:50:07 -0500
Subject: Re: [PATCH v2] iwlwifi: fix dma mappings and skbs leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110215113444.GC2162@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
	 <1297698696.4723.16.camel@wwguy-ubuntu>  <20110215113444.GC2162@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 12:50:02 +0100
Message-ID: <1297770602.3935.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 12:34 +0100, Stanislaw Gruszka wrote:

> Today I tried to reproduce problem a few times with
> patch applied and does not see dma warning. Also
> iptables modules still unload fine.
> 
> However during testing, I triggered different warning:
> 
> WARNING: at lib/debugobjects.c:259 debug_print_object+0x5c/0x70()
> Hardware name: HP xw8600 Workstation
> ODEBUG: free active (active state 0) object type: timer_list
> Pid: 9139, comm: rmmod Not tainted 2.6.38-rc4-wl+ #21
> Call Trace:
>  [<ffffffff810649cf>] ? warn_slowpath_common+0x7f/0xc0
>  [<ffffffff81064ac6>] ? warn_slowpath_fmt+0x46/0x50
>  [<ffffffff81226eec>] ? debug_print_object+0x5c/0x70
>  [<ffffffff81227585>] ? debug_check_no_obj_freed+0x125/0x210
>  [<ffffffff8109ebd7>] ? debug_check_no_locks_freed+0xf7/0x170
>  [<ffffffff81156092>] ? kfree+0xc2/0x2f0

>  [<ffffffffa02a5188>] ? ieee80211_unregister_hw+0x58/0x120 [mac80211]

> It looks more like mac80211 issue for me.

Agree, but I wish the timer objects had a name so we'd know what it
was ... hmm, how can we figure out which timer this is?

johannes

