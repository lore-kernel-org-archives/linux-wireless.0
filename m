Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55143 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaJTJkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:40:31 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so4979090wgh.7
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 02:40:30 -0700 (PDT)
Date: Mon, 20 Oct 2014 11:40:27 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v4 0/4] add VHT support to minstrel_ht
Message-ID: <20141020094027.GB11871@magnum.frso.rivierawaves.com> (sfid-20141020_114034_945801_996891BB)
References: <1413652424-14345-5-git-send-email-karl.beldan@gmail.com>
 <1413795342-11995-1-git-send-email-karl.beldan@gmail.com>
 <5444CF6B.9020309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5444CF6B.9020309@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Varka Bhadram,

On Mon, Oct 20, 2014 at 02:31:31PM +0530, Varka Bhadram wrote:
> Hi Karl Beldan,
> 
> On 10/20/2014 02:25 PM, Karl Beldan wrote:
> >From: Karl Beldan <karl.beldan@rivierawaves.com>
> >
> >Hi,
> >
> >This is just a respin rebased on v2 of "mac80211: minstrels: fix buffer
> >overflow in HT debugfs" which only affects 4/4.
> >
> >Karl Beldan (4):
> >   mac80211: minstrel_ht: Increase the range of handled rate indexes
> >   mac80211: minstrel_ht: macros adjustments for future VHT_GROUPs
> >   mac80211: minstrel_ht: include type (cck/ht) in rates flag
> >   mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz
> >v2:
> >- typo in Kconfig
> >- adjust room in debugfs rc_stats buffer
> >- add a module param to mix ht rates with vht ones
> >- default to 3SS instead of 2SS (with "mac80211: minstrel_ht: macros
> >   adjustments for future VHT_GROUPs")
> >- use common MINSTREL_MAX_STREAMS both for VHT and HT so that we can get
> >   rid of the 'MINSTREL_MAX_STREAMS >= 3' checks for minstrel_mcs_groups
> >v3:
> >- put module param *vht_only* under CONFIG_MAC80211_RC_MINSTREL_VHT
> >v4:
> >- rebase on v2 of "mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats"
> >
> >  net/mac80211/Kconfig                       |   7 +
> >  net/mac80211/rc80211_minstrel_ht.c         | 292 +++++++++++++++++++++++------
> >  net/mac80211/rc80211_minstrel_ht.h         |  38 +++-
> >  net/mac80211/rc80211_minstrel_ht_debugfs.c |  32 ++--
> >  4 files changed, 290 insertions(+), 79 deletions(-)
> >
> Check patch errors on this series.. run checkpatch.pl on this series.
> 
Same report as previous series.

Except format warnings there are 2
"ERROR: Macros with complex values should be enclosed in parenthesis",
which fit with current style.

However I too think this series can be improved wrt checkpatch report
and I'll send another version, thanks for pointing that out.
 
Karl
