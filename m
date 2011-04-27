Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:54687 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384Ab1D0GQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 02:16:32 -0400
Received: by ewy22 with SMTP id 22so430279ewy.7
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 23:16:29 -0700 (PDT)
Subject: Re: [PATCH] mac80211: report MIC failure for truncated packets in
 AP mode
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <BANLkTikMMMck78MhFuFNqc+CrUBGpG+TxQ@mail.gmail.com>
References: <1303849642-9014-1-git-send-email-arik@wizery.com>
	 <BANLkTim45NHT3o2mB7Ofb9KvqBDrGjJcaw@mail.gmail.com>
	 <BANLkTikMMMck78MhFuFNqc+CrUBGpG+TxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 09:16:23 +0300
Message-ID: <1303884983.2336.46.camel@cumari> (sfid-20110427_081635_545110_831A7ACA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-27 at 01:03 +0300, Arik Nemtsov wrote:
> On Tue, Apr 26, 2011 at 23:55, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Tue, Apr 26, 2011 at 10:27 PM, Arik Nemtsov <arik@wizery.com> wrote:
> >> MIC failure notifications for packets too short to contain a key index
> >> are currently ignored in AP-mode. Fix the check to only ignore packets
> >> with an existing non-zero key index.
> >>
> >> The wl12xx chip always truncates packets with a failed MIC and requires
> >> this change to operate correctly in AP-mode.
> >>
> >> No such check is made in STA mode. Therefore its relatively safe to assume
> >> there's no other HW that relies on the current code to avoid spurious
> >> MIC failures with correct yet truncated packets.
> >>
> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> >> ---
> >>  net/mac80211/rx.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> >> index a864890..875fc3c 100644
> >> --- a/net/mac80211/rx.c
> >> +++ b/net/mac80211/rx.c
> >> @@ -2391,7 +2391,7 @@ static void ieee80211_rx_michael_mic_report(struct ieee80211_hdr *hdr,
> >>        if (!ieee80211_has_protected(hdr->frame_control))
> >>                return;
> >>
> >> -       if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx) {
> >> +       if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx > 0) {
> >>                /*
> >>                 * APs with pairwise keys should never receive Michael MIC
> >>                 * errors for non-zero keyidx because these are reserved for
> >> --
> > wait! Since you seem able to trigger MIC events frequently, could you
> > please test if the following patch:
> >
> > <http://www.spinics.net/lists/linux-wireless/msg67571.html>
> >
> > <a little more info:http://www.spinics.net/lists/linux-wireless/msg67461.html>
> >
> > would help in your case as well?
> >
> 
> I seem to have missed this thread entirely :)
> The patch you mentioned does indeed help. I tested in STA and AP mode.
> 
> This bit is important for wl12xx:
> 
> +       /*
> +        * No way to verify the MIC if the hardware stripped it or
> +        * the IV with the key index. In this case we have solely rely
> +        * on the driver to set RX_FLAG_MMIC_ERROR in the event of a
> +        * MIC failure report.
> +        */
> +       if (status->flag & (RX_FLAG_MMIC_STRIPPED | RX_FLAG_IV_STRIPPED)) {
> +               if (status->flag & RX_FLAG_MMIC_ERROR)
> +                       goto mic_fail;
> 
> This prevents us from getting to the problematic check that I tried to
> remove with my patch.
> 
> Just for the record - generating a MIC failure is pretty easy. I'm
> using the (very cool) mac80211 debugfs feature that allows simulating
> a MIC failure (see ieee80211_if_parse_tkip_mic_test()).
> It works well with a rt2x00 based card and the latest compat. I'm
> simulating it from AP as well as STA.
> 
> To summarize - either patch will work for us.

Great! If this can be solved in a generic way in mac80211, I'd prefer if
that one is used.

Christian, are you planning to submit this patch again any time soon? If
not, we could include the wl12xx patch for now and revert it later when
the proper fix in mac80211 is applied.

What do you guys think?

-- 
Cheers,
Luca.

