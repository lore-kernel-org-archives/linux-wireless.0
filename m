Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37501 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2LJTOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 14:14:07 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so1464700wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 11:14:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D07C12939@RockMX01.rock.corp>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru> <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com>
 <alpine.DEB.2.02.1212080721070.8165@icf.org.ru> <alpine.DEB.2.02.1212080726150.22564@icf.org.ru>
 <CAG6hwVMsghDHzgyk1ZJE7YoMi2+t-LKNGtgw_ha2DdEwHc71hg@mail.gmail.com>
 <alpine.DEB.2.02.1212080739540.23821@icf.org.ru> <BD54DDEB2546894FAB0731EA7B0EDF8D07C12939@RockMX01.rock.corp>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 10 Dec 2012 11:13:46 -0800
Message-ID: <CAG6hwVMVd0azJotzVqcz+Uu7vpDtxJa+4XfK0BS_31=gBPD2vA@mail.gmail.com> (sfid-20121210_201413_511628_F457298A)
Subject: Re: help: 802.11s bad performance with 802.11n enabled
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Cc: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 10, 2012 at 7:48 AM, Chaoxing Lin
<Chaoxing.Lin@ultra-3eti.com> wrote:
> TP>
> TP>Are you talking about a different bug?
>
> GY> Hm, may bee, but according to Chaoxing Lin emails there is several bugs which cause performance degradation in 802.11s mode, and symptoms in my case indentical, i get same results as Chaoxing Lin, and seems same throbles, i will make tests what you want anyway and report results.
>
> For easy reference, I summarize the 4 problems I uncovered so far that contribute to in-stability of 7-node 802.11s network.
>
> 1. ath9k "Tx DMA error". Ping packet loss is seen each time "Fail to stop Tx DMA" log is seen.  It's NOT the main cause.
>
> 2. authsae or 802.11s kernel problem: The two ends of a peer link get out of sync for whatever reason. One end says, the peer link is "ESTAB" and all 3 keys are in place. While the other end says this peer link is not "ESTAB", no keys installed for the peer.

We recently applied
https://github.com/cozybit/authsae/commit/0e5c65c3f773db820d6cee7b365cd4a70181c72d
which may fix your issue.

> 3. AES-CCM pairwise key sometimes complains packet replay so ping packets are dropped. A kernel key dump in this error case is below. (I overwrote key_key_read() function in debugfs_key.c to dump all info)
>
>         Key 362:
>         0xcf393800 AES-CCM Key: 49305a736a8b6d5fcb34057ee6983d44   Pairwise
>         Peer MAC: 00:0e:8e:38:36:03
>         tx_pn: 000000000000009f
>
>
>         rx_pn[ 0]: 0000000d788b  rx_pn[ 1]: 000000000000  rx_pn[ 2]: 000000000000
>         rx_pn[ 3]: 000000000000
>         rx_pn[ 4]: 000000000000  rx_pn[ 5]: 000000000000  rx_pn[ 6]: 000000000000
>         rx_pn[ 7]: 000000000000
>         rx_pn[ 8]: 000000000000  rx_pn[ 9]: 000000000000  rx_pn[10]: 000000000000
>         rx_pn[11]: 000000000000
>         rx_pn[12]: 000000000000  rx_pn[13]: 000000000000  rx_pn[14]: 000000000000
>         rx_pn[15]: 000000000000
>         rx_pn[16]: 000000003580
>
>         replays: 11970 icverror:  <=======================problem here===========
>
> The worse thing for problem 2 and 3 above is, when it gets into this state, the mpath still stays active. So all packets are still routed to the bad peer link/mpath and will be dropped by peer.

ok. Patches are welcome.

> 4. 802.11n packet aggregation. I believe this is the main problem by the fact that, disabling 802.11n packet aggregation in ath9k driver will make the network stable and problem 2 and 3 are not seen. In other words, problem 2 and 3 may be caused by aggregation (my imagination, aggregation caused certain error condition that is not handled properly, which triggers problem 2 and 3)

And to reproduce you run a simultaneous ping from one node to ~6
others? It will take me a few days to find time to reproduce this, so
any interesting observations you can offer in the mean time would be
helpful.

Thanks,
Thomas
