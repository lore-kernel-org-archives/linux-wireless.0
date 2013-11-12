Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:58429 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3KLOep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 09:34:45 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so4453846wgh.29
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 06:34:44 -0800 (PST)
Date: Tue, 12 Nov 2013 15:34:22 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC 1/2] mac80211: minstrel_ht: add basic support for VHT rates
 <= 80MHz
Message-ID: <20131112143422.GB22775@magnum.frso.rivierawaves.com> (sfid-20131112_153457_143734_A2C187FB)
References: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1384266625-22431-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 12, 2013 at 03:30:24PM +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Helps feel current minstrel and stack rate-control API limits.
> Helped trigger some bugs in vht tx code path in the past.
> Some ppl were interested in checking that out.
> some TODOs:
> - Optimize rate-indexes loops and sampling holes
> - The txinfo flags for vht STAs
> 
> VHT rates support depends on a new CONFIG_MAC80211_RC_MINSTREL_VHT.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---
>  net/mac80211/Kconfig                       |   7 +
>  net/mac80211/rc80211_minstrel_ht.c         | 235 ++++++++++++++++++++++++-----
>  net/mac80211/rc80211_minstrel_ht.h         |  33 +++-
>  net/mac80211/rc80211_minstrel_ht_debugfs.c |  30 ++--
>  4 files changed, 248 insertions(+), 57 deletions(-)
> 
This commit log is temporary as I am sure I'll have to respin.
 
Karl
