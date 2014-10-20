Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38793 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaJTPeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 11:34:25 -0400
Received: by mail-wi0-f180.google.com with SMTP id em10so6699529wid.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 08:34:24 -0700 (PDT)
Date: Mon, 20 Oct 2014 17:34:21 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v5 0/4] add VHT support to minstrel_ht
Message-ID: <20141020153421.GC7691@magnum.frso.rivierawaves.com> (sfid-20141020_173428_488799_CF796172)
References: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com>
 <1413816546.32358.3.camel@jlt4.sipsolutions.net>
 <20141020151302.GB7691@magnum.frso.rivierawaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20141020151302.GB7691@magnum.frso.rivierawaves.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2014 at 05:13:02PM +0200, Karl Beldan wrote:
> On Mon, Oct 20, 2014 at 04:49:06PM +0200, Johannes Berg wrote:
> > On Mon, 2014-10-20 at 15:45 +0200, Karl Beldan wrote:
> > > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > > 
> > > Hi,
> > > 
> > > Varka Bhadram reported checkpatch is noisy on this series.
> > > I made another pass which affects [2/4](trivially) and [4/4].
> > > This could have been a patch on top of what Felix acked, I hope you
> > > won't bother too much.
> > 
> > This series introduces the following new sparse/smatch complaints:
> > 
> >   CHECK   /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c
> > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c:246:18: warning: cast to restricted __le16
> > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c:1227:49: warning: incorrect type in argument 3 (different base types)
> > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c:1227:49:    expected unsigned short [unsigned] [usertype] mcs_map
> > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c:1227:49:    got restricted __le16 [usertype] tx_mcs_map
> > 
> > Here it looks like the argument to minstrel_get_valid_vht_rates() should
> > be declared __le16.
> > 
> Indeed, will resending only 4/4 do ?
> 
> >   CHECK   /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c
> > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c:47 minstrel_ht_stats_dump() error: testing array offset 'i' after use.
> > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c:61 minstrel_ht_stats_dump() error: testing array offset 'i' after use.
> > 
> > Here I'm not sure, seems like it's a false positive maybe? The array
> > seems large enough for everything that's going on here.
> > 
> False positive.
> I am using CF="-Wsparse-all" and I don't get those warnings with sparse
> 0.4.5, I'll update.
> 
I don't get those with smatch either .. what options are you using ?
Thanks for the pass.
 
Karl
