Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37909 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbaJTOtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 10:49:09 -0400
Message-ID: <1413816546.32358.3.camel@jlt4.sipsolutions.net> (sfid-20141020_164920_111882_A2705977)
Subject: Re: [PATCH v5 0/4] add VHT support to minstrel_ht
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Date: Mon, 20 Oct 2014 16:49:06 +0200
In-Reply-To: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com> (sfid-20141020_154620_616928_7EE76961)
References: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20141020_154620_616928_7EE76961)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 15:45 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Hi,
> 
> Varka Bhadram reported checkpatch is noisy on this series.
> I made another pass which affects [2/4](trivially) and [4/4].
> This could have been a patch on top of what Felix acked, I hope you
> won't bother too much.

This series introduces the following new sparse/smatch complaints:

  CHECK   /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c
/home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c:246:18: warning: cast to restricted __le16
/home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c:1227:49: warning: incorrect type in argument 3 (different base types)
/home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c:1227:49:    expected unsigned short [unsigned] [usertype] mcs_map
/home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht.c:1227:49:    got restricted __le16 [usertype] tx_mcs_map

Here it looks like the argument to minstrel_get_valid_vht_rates() should
be declared __le16.

  CHECK   /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c
/home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c:47 minstrel_ht_stats_dump() error: testing array offset 'i' after use.
/home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c:61 minstrel_ht_stats_dump() error: testing array offset 'i' after use.

Here I'm not sure, seems like it's a false positive maybe? The array
seems large enough for everything that's going on here.

johannes

