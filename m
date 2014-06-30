Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50470 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaF3OaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 10:30:15 -0400
Date: Mon, 30 Jun 2014 10:20:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: lolilolicon <lolilolicon@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Subject: Re: Bug: USB wifi card TL-WN722N (AR9271, ath9k_htc) fails to get
 DHCP lease
Message-ID: <20140630142007.GA29198@tuxdriver.com> (sfid-20140630_163020_766852_469468BB)
References: <CAMtVo_MxCfV7MWC+ksWc=PJM0KEHDUVuCMpg0NCWBW8EeLU5Jw@mail.gmail.com>
 <53AF5FB8.3060505@lwfinger.net>
 <CAMtVo_PAkxCkxO7ETV6r=Xg75LLRt0GHi8GdqhT4tXKZSpmOvQ@mail.gmail.com>
 <53B047F7.2000204@lwfinger.net>
 <CAMtVo_NLnfDsYrcf7_Pzt47WyMexkzuZuUREYhoKC2F8ZyfXzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMtVo_NLnfDsYrcf7_Pzt47WyMexkzuZuUREYhoKC2F8ZyfXzQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2014 at 05:08:01AM +0800, lolilolicon wrote:
> On Mon, Jun 30, 2014 at 1:08 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > On 06/29/2014 04:32 AM, lolilolicon wrote:
> >>
> >> % git bisect start 88daf80 010d3c3 35582ad
> >> 88daf80dcca19ff995cc263592426f734a9702f3 is the first bad commit
> >>
> >> What am I getting wrong?
> >
> >
> > I am not an expert in git, but I think you are being too restrictive with
> > that command. If you do "git bisect start 88daf80 010d3c3", there are ath9k
> > patches in the code left to test. With the other option "git bisect start
> > 88daf80 35582ad", git visualize does not show any ath9k changes.
> 
> In fact it was through `git bisect start 88daf80 010d3c3` that I found
> out 35582ad was good:
> 
> % git bisect log
> # bad: [88daf80dcca19ff995cc263592426f734a9702f3] Merge branch
> 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
> into for-davem
> # good: [010d3c3989706d800ae72253773fa6537cc9f74c] bonding: fix
> bond_arp_rcv() race of curr_active_slave
> git bisect start '88daf80dcca19ff995cc263592426f734a9702f3'
> '010d3c3989706d800ae72253773fa6537cc9f74c'
> # good: [841577c3d33b8a2bff66d1b506d8198b25900bde] Merge branch
> 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
> git bisect good 841577c3d33b8a2bff66d1b506d8198b25900bde
> # good: [e57f1734d87aa0e9a00905ed08888f0c62f56227] mwifiex: add key
> material v2 support
> git bisect good e57f1734d87aa0e9a00905ed08888f0c62f56227
> # good: [0e028ab0fb2da47fd235dafd4159859892e73d08] Merge branch
> 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless
> git bisect good 0e028ab0fb2da47fd235dafd4159859892e73d08
> # good: [41ed1a787c4940d58d5870c633ab6291dd4679dd] wlcore: consider
> multiple APs when checking active_link_count
> git bisect good 41ed1a787c4940d58d5870c633ab6291dd4679dd
> # good: [546c505bdc64c471be33a5ab525458431d718f5e] wcn36xx: Wait
> longer for SMD commands to complete
> git bisect good 546c505bdc64c471be33a5ab525458431d718f5e
> # good: [2ba0b46175967a40773f8be15f6678307fa3f45a] wcn36xx: Rename
> wcn36xx_vif.ucast_dpu_signature to self_ucast_dpu_sign
> git bisect good 2ba0b46175967a40773f8be15f6678307fa3f45a
> # good: [908628db148ed542fcfde1bff9e5d4607f684b73] wcn36xx: Update
> dtim period before starting BSS
> git bisect good 908628db148ed542fcfde1bff9e5d4607f684b73
> # good: [35582ad9d342025653aaf28ed321bf5352488d7f] Staging: rtl8812ae:
> remove modules field of rate_control_ops
> git bisect good 35582ad9d342025653aaf28ed321bf5352488d7f
> # first bad commit: [88daf80dcca19ff995cc263592426f734a9702f3] Merge
> branch 'master' of
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
> into for-davem
> 
> I think `git bisect start 88daf80 35582ad` would probably get me a
> series of good commits and reach 010d3c3, in the same manner.
> 
> Since 88daf80, which is bad, has two parents which are both good, I
> feel that it's the merge that produced the bug. Maybe 88daf80 is one
> of those "evil merges"?
> 
> % git show 88daf80
> commit 88daf80dcca19ff995cc263592426f734a9702f3
> Merge: 010d3c3 35582ad
> Author: John W. Linville <linville@tuxdriver.com>
> Date:   Thu Feb 20 15:02:02 2014 -0500
> 
>     Merge branch 'master' of
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
> into for-davem

I can't dispute what you are saying, but I also don't see any likely
candidates in the merge.  There don't seem to have been any conflicts
in the merge, so nothing for me to have manually (mis-)adjusted.

My guess would be that there is something that came through the net
tree (either in wireless or in the core) that ath9k doesn't like.
Anyone have any suggestions as to what that might be?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
