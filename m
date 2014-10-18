Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56432 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaJRJ1x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 05:27:53 -0400
Message-ID: <54423293.3080404@openwrt.org> (sfid-20141018_112756_586800_8F82EEC0)
Date: Sat, 18 Oct 2014 11:27:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: minstrels: fix buffer overflow in HT debugfs
 rc_stats
References: <1413570840-27679-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1413570840-27679-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-10-17 20:34, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> ATM an HT rc_stats line is 106 chars.
> Times 8(MCS_GROUP_RATES)*3(SS)*2(GI)*2(BW) + CCK(4), i.e. x100, this is
> well above the current 8192 - sizeof(*ms) currently allocated.
> 
> Fix this by squeezing the output as follows (not that we're short on
> memory but this also improves readability and range, the new format adds
> one more digit to *ok/*cum and ok/cum):
> 
> - Before (HT) (106 ch):
> type           rate     throughput  ewma prob   this prob  retry   this succ/attempt   success    attempts
> CCK/LP          5.5M           0.0        0.0         0.0      0              0(  0)         0           0
> HT20/LGI ABCDP MCS0            0.0        0.0         0.0      1              0(  0)         0           0
> - After (75 ch):
> type           rate     tpt eprob *prob ret  *ok(*cum)        ok(      cum)
> CCK/LP          5.5M    0.0   0.0   0.0   0    0(   0)         0(        0)
> HT20/LGI ABCDP MCS0     0.0   0.0   0.0   1    0(   0)         0(        0)
> 
> - Align non-HT format Before (non-HT) (83 ch):
> rate      throughput  ewma prob  this prob  this succ/attempt   success    attempts
> ABCDP  6         0.0        0.0        0.0             0(  0)         0           0
>       54         0.0        0.0        0.0             0(  0)         0           0
> - After (61 ch):
> rate          tpt eprob *prob  *ok(*cum)        ok(      cum)
> ABCDP  1      0.0   0.0   0.0    0(   0)         0(        0)
>       54      0.0   0.0   0.0    0(   0)         0(        0)
> 
> *This also adds dynamic checks for overflow, lowers the size of the
> non-HT request (allowing > 30 entries) and replaces the buddy-rounded
> allocations (s/sizeof(*ms) + 8192/8192).
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> Cc: Felix Fietkau <nbd@openwrt.org>
Acked-by: Felix Fietkau <nbd@openwrt.org>
