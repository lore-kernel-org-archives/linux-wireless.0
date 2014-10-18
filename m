Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47261 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaJRRmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 13:42:09 -0400
Received: by mail-wg0-f50.google.com with SMTP id a1so2781138wgh.33
        for <linux-wireless@vger.kernel.org>; Sat, 18 Oct 2014 10:42:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413652424-14345-1-git-send-email-karl.beldan@gmail.com>
References: <1413575459-29612-5-git-send-email-karl.beldan@gmail.com> <1413652424-14345-1-git-send-email-karl.beldan@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 18 Oct 2014 23:11:48 +0530
Message-ID: <CABPxzY+W48L-OjWy5Zd9VJGhtG684dtOd-2rzW-9dW09YKFXaQ@mail.gmail.com> (sfid-20141018_194224_569478_686D835E)
Subject: Re: [PATCH v3 0/4] add VHT support to minstrel_ht
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 18, 2014 at 10:43 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
>
> From: Karl Beldan <karl.beldan@rivierawaves.com>
>
>
> Karl Beldan (4):
>   mac80211: minstrel_ht: Increase the range of handled rate indexes
>   mac80211: minstrel_ht: macros adjustments for future VHT_GROUPs
>   mac80211: minstrel_ht: include type (cck/ht) in rates flag
>   mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz
> v2:
> - typo in Kconfig
> - adjust room in debugfs rc_stats buffer
> - add a module param to mix ht rates with vht ones
> - default to 3SS instead of 2SS (with "mac80211: minstrel_ht: macros
>   adjustments for future VHT_GROUPs")
> - use common MINSTREL_MAX_STREAMS both for VHT and HT so that we can get
>   rid of the 'MINSTREL_MAX_STREAMS >= 3' checks for minstrel_mcs_groups
> v3:
> - put module param *vht_only* under CONFIG_MAC80211_RC_MINSTREL_VHT
>
>  net/mac80211/Kconfig                       |   7 +
>  net/mac80211/rc80211_minstrel_ht.c         | 292 +++++++++++++++++++++++------
>  net/mac80211/rc80211_minstrel_ht.h         |  38 +++-
>  net/mac80211/rc80211_minstrel_ht_debugfs.c |  32 ++--
>  4 files changed, 290 insertions(+), 79 deletions(-)
>
> --
>
We have been using you patches for some time and they do the work well.
Except for the sampling holes, where we were needed to add some
supported checks.
Thanks for sharing them early.
