Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab1ENAAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 20:00:48 -0400
Subject: Re: mesh RCU issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org
In-Reply-To: <BANLkTi=R_Eyz8+iZsk+=Gs4vaNo-0eUVng@mail.gmail.com> (sfid-20110513_222907_856686_A223EC2B)
References: <1305203138.3461.24.camel@jlt3.sipsolutions.net>
	 <BANLkTinDyLyVX3HFHU7i4GFUi8SixOdzAQ@mail.gmail.com>
	 <1305270793.3487.3.camel@jlt3.sipsolutions.net>
	 <BANLkTi=R_Eyz8+iZsk+=Gs4vaNo-0eUVng@mail.gmail.com>
	 (sfid-20110513_222907_856686_A223EC2B)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 02:00:47 +0200
Message-ID: <1305331247.680.7.camel@jlt3.sipsolutions.net> (sfid-20110514_020052_338652_0A4B4052)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 13:28 -0700, Javier Cardona wrote:

> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 83ce48e..1db8bba 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
[snip]

With this patch, I get the warnings below. The locking ones are
definitely genuine bugs, but the missing rcu_dereference() ones you
already fixed were bugs too, albeit only on the Alpha architecture (and
maybe elsewhere due to compiler optimisations?)

johannes

  CHECK   /home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:335:48: warning: incorrect type in argument 3 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:335:48:    expected struct mesh_table *tbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:335:48:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] mesh_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:348:13: warning: incorrect type in argument 2 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:348:13:    expected struct atomic_t [usertype] *v
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:348:13:    got struct atomic_t [noderef] <asn:4>*<noident>
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:382:16: warning: incorrect type in assignment (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:382:16:    expected struct mesh_table *oldtbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:382:16:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] mesh_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:383:29: warning: incorrect type in argument 1 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:383:29:    expected struct mesh_table *oldtbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:383:29:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] mesh_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:406:16: warning: incorrect type in assignment (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:406:16:    expected struct mesh_table *oldtbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:406:16:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] mpp_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:407:29: warning: incorrect type in argument 1 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:407:29:    expected struct mesh_table *oldtbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:407:29:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] mpp_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:459:48: warning: incorrect type in argument 3 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:459:48:    expected struct mesh_table *tbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:459:48:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] [assigned] mpp_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:472:13: warning: incorrect type in argument 2 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:472:13:    expected struct atomic_t [usertype] *v
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:472:13:    got struct atomic_t [noderef] <asn:4>*<noident>
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:600:49: warning: incorrect type in argument 3 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:600:49:    expected struct mesh_table *tbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:600:49:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] [assigned] mesh_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:612:37: warning: incorrect type in argument 1 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:612:37:    expected struct atomic_t [usertype] *v
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:612:37:    got struct atomic_t [noderef] <asn:4>*<noident>
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:748:20: warning: incorrect type in assignment (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:748:20:    expected struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] [assigned] mesh_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:748:20:    got struct mesh_table *
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:755:19: warning: incorrect type in assignment (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:755:19:    expected struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] [assigned] mpp_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:755:19:    got struct mesh_table *
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:757:33: warning: incorrect type in argument 1 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:757:33:    expected struct mesh_table *tbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:757:33:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] [assigned] mesh_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:794:25: warning: incorrect type in argument 1 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:794:25:    expected struct mesh_table *tbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:794:25:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] [assigned] mesh_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:795:25: warning: incorrect type in argument 1 (different address spaces)
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:795:25:    expected struct mesh_table *tbl
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:795:25:    got struct mesh_table [noderef] <asn:4>*static [addressable] [toplevel] [assigned] mpp_paths
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:266:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:266:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:266:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:266:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:336:19: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:338:23: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:349:17: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:349:47: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:354:25: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:363:25: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:373:6: warning: context imbalance in 'mesh_mpath_table_grow' - different lock contexts for basic block
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:397:6: warning: context imbalance in 'mesh_mpp_table_grow' - different lock contexts for basic block
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:460:19: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:462:23: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:473:17: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:473:46: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:476:25: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:485:25: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:513:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:513:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:513:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:513:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:550:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:550:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:550:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:550:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:564:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:564:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:564:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:564:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:601:19: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:603:23: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:621:25: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:751:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:752:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:753:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:760:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:761:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:762:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:775:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:775:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:775:9: warning: dereference of noderef expression
/home/johannes/sys/wireless-testing/net/mac80211/mesh_pathtbl.c:775:9: warning: dereference of noderef expression


