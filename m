Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:37746 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYHFN4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 09:56:49 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3159646rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 06:56:49 -0700 (PDT)
Message-ID: <b6c5339f0808060656v771a00dar51054236bc4ec50b@mail.gmail.com> (sfid-20080806_155656_924967_F4453C8E)
Date: Wed, 6 Aug 2008 09:56:49 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: YanBo <dreamfly281@gmail.com>
Subject: Re: [ath5k-devel] ath5k hang up in mesh mode
Cc: wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <1197ff4c0808060056q7e10e39cl41a5ea5a26b7cdd6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197ff4c0808060056q7e10e39cl41a5ea5a26b7cdd6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi YanBo,

On Wed, Aug 6, 2008 at 3:56 AM, YanBo <dreamfly281@gmail.com> wrote:
> When I set two PC with Atheros AR2413 in mesh mode, they can find each
> other, then I tried to ping each other, after send 10-12 ping packets,
> the PC will hang up, below is the dmesg output, I suspicion this bug
> is the same as this one
> http://marc.info/?l=linux-wireless&m=121731102709834&w=2,  but don't
> know if anyone has solved it?

I don't think they are the same issue.  The previous one hasn't been solved
yet, but it occurred with 2.6.26 and you are using .27-rc1.

> [  577.639420] Mesh plink with 00:19:e0:86:0f:2f ESTABLISHED
> [  602.864544] BUG: sleeping function called from invalid context at
> mm/slab.c:3043
> [  602.869975] in_atomic():1, irqs_disabled():0
> [  602.874241] INFO: lockdep is turned off.
> [  602.878162] Pid: 5160, comm: ath5k_pci Not tainted
> 2.6.27-rc1-wl-14922-gb73da91 #4
> [  602.885719]  [<c0172e5f>] kmem_cache_alloc+0xef/0x110
> [  602.890794]  [<c04e9908>] mesh_path_add+0xb8/0x2f0
> [  602.895610]  [<c04e9908>] mesh_path_add+0xb8/0x2f0
> [  602.900468]  [<c04eb8c6>] hwmp_route_info_get+0x406/0x4c0
> [  602.905886]  [<c04eb4e5>] hwmp_route_info_get+0x25/0x4c0
> [  602.911927]  [<c04eb9f4>] mesh_rx_path_sel_frame+0x74/0x870
> [  602.917257]  [<c04d76dd>] ieee80211_rx_bss_info+0x67d/0xe80
> [  602.922846]  [<c04d70dc>] ieee80211_rx_bss_info+0x7c/0xe80
> [  602.928353]  [<c04d9d40>] ieee80211_rx_mgmt_action+0x180/0x8a0

I guess mesh_path_add should be using GFP_ATOMIC instead of GFP_KERNEL, since
it's called under rcu_read_lock?  CCed Johannes.

-- 
Bob Copeland %% www.bobcopeland.com
