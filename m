Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41411 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJRWTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 18:19:07 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so3062706wgh.7
        for <linux-wireless@vger.kernel.org>; Sat, 18 Oct 2014 15:19:05 -0700 (PDT)
Date: Sun, 19 Oct 2014 00:19:00 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v3 0/4] add VHT support to minstrel_ht
Message-ID: <20141018221844.GA17413@magnum.frso.rivierawaves.com> (sfid-20141019_001911_539524_9E3E09DE)
References: <1413575459-29612-5-git-send-email-karl.beldan@gmail.com>
 <1413652424-14345-1-git-send-email-karl.beldan@gmail.com>
 <CABPxzY+W48L-OjWy5Zd9VJGhtG684dtOd-2rzW-9dW09YKFXaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABPxzY+W48L-OjWy5Zd9VJGhtG684dtOd-2rzW-9dW09YKFXaQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 18, 2014 at 11:11:48PM +0530, Krishna Chaitanya wrote:
> On Sat, Oct 18, 2014 at 10:43 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
> >
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> >
> >
> > Karl Beldan (4):
> >   mac80211: minstrel_ht: Increase the range of handled rate indexes
> >   mac80211: minstrel_ht: macros adjustments for future VHT_GROUPs
> >   mac80211: minstrel_ht: include type (cck/ht) in rates flag
> >   mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz
> > v2:
> > - typo in Kconfig
> > - adjust room in debugfs rc_stats buffer
> > - add a module param to mix ht rates with vht ones
> > - default to 3SS instead of 2SS (with "mac80211: minstrel_ht: macros
> >   adjustments for future VHT_GROUPs")
> > - use common MINSTREL_MAX_STREAMS both for VHT and HT so that we can get
> >   rid of the 'MINSTREL_MAX_STREAMS >= 3' checks for minstrel_mcs_groups
> > v3:
> > - put module param *vht_only* under CONFIG_MAC80211_RC_MINSTREL_VHT
> >
> >  net/mac80211/Kconfig                       |   7 +
> >  net/mac80211/rc80211_minstrel_ht.c         | 292 +++++++++++++++++++++++------
> >  net/mac80211/rc80211_minstrel_ht.h         |  38 +++-
> >  net/mac80211/rc80211_minstrel_ht_debugfs.c |  32 ++--
> >  4 files changed, 290 insertions(+), 79 deletions(-)
> >
> > --
> >
> We have been using you patches for some time and they do the work well.
> Except for the sampling holes, where we were needed to add some
> supported checks.
Maybe you missed f12140c "mac80211: minstrel_ht: do not sample
unsupported rates"? I posted it about the same time as the vht rfc a
year ago. Thanks for the feedback.
 
Karl
