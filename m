Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56595 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab0JHV5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 17:57:15 -0400
Received: by fxm14 with SMTP id 14so767823fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 14:57:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH v2] mac80211: temporarily disable reorder release timer
Date: Fri, 8 Oct 2010 23:57:04 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <201010082235.09355.chunkeey@googlemail.com> <201010082249.20545.chunkeey@googlemail.com> <AANLkTi=Pe7tt+As0_Kzjt0PB=cHO_eSO+Qs8dy2o+Mbd@mail.gmail.com>
In-Reply-To: <AANLkTi=Pe7tt+As0_Kzjt0PB=cHO_eSO+Qs8dy2o+Mbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010082357.04992.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 October 2010 23:22:57 Luis R. Rodriguez wrote:
> On Fri, Oct 8, 2010 at 1:49 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Friday 08 October 2010 22:40:39 Luis R. Rodriguez wrote:
> >> On Fri, Oct 8, 2010 at 1:35 PM, Christian Lamparter
> >> <chunkeey@googlemail.com> wrote:
> >> > Several serve threading problems in the current
> >> > release reorder timer implementation have been
> >> > discovered.
> >> >
> >> > A lengthy discussion - which lists some of the
> >> > pitfalls and possible solutions - can be found at:
> >> >  http://marc.info/?t=128635927000001
> >> >
> >> > But due to the complicated nature of the subject and
> >> > the imminent advent of a new -rc cycle, it was
> >> > decided to disable the feature for the time being.
> >> >
> >> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> >>
> >> This patch lacks documentation of the impact of this patch, while it
> >> may fix a lock issue, the does not address what happens when the patch
> >> is actually applied.
> > ? It just disables the timer. The actual reorder code
> > is left untouched, everything is the same as in Linus'
> > 2.6.36-rcX tree.
> >
> > Or what impact are you talking about?
> 
> The timer is what I'm talking about, we don't run then
> ieee80211_release_reorder_timeout() right so we don't clear stale
> frames on aggregates.
What? Who told you that? Because that's just misinformation.

This patch doesn't touch/disable the reorder release mechanism
(ieee80211_sta_reorder_release) at all.
It only disarms the timer which would clean out frames after
approx. 100ms.

And even without the timer, there are still three other ways
for cleaning out "stale" frame aggregates.

1. BAR from peer (ieee80211_rx_h_ctrl)

2. BAW window overflow (ieee80211_sta_manage_reorder_buf,
   part of the aMPDU rx path - executed for every received
   MPDU)

3. ieee80211_sta_reorder_release (automatically called by
   ieee80211_sta_manage_reorder_buf when a reorder gaps
   are opening up.)

(I repeat, the rx path logic & behavior is identical to
vanilla 2.6.36-rcX)

> What impact does this have?
everything is back to stock, at least for now?

see:
http://marc.info/?l=linux-wireless&m=128656352920957

"I don't like reverting these patches, but maybe we should
simply comment out the code that arms the timer, thereby
disabling all of it, while we work on this?"
 -- Johannes

Best regards,
	Christian
