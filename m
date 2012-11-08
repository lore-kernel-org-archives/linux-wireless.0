Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2KHPif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 10:38:35 -0500
Message-ID: <1352389150.11421.6.camel@jlt4.sipsolutions.net> (sfid-20121108_163846_935336_C50D01C0)
Subject: Re: [PATCH] mac80211: add debugfs file for HW queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 08 Nov 2012 16:39:10 +0100
In-Reply-To: <CAB3XZEdBFZ+ztESgKwprLmJH+5F=x3z66trn_QRq7WJCdcsz1g@mail.gmail.com> (sfid-20121108_163625_184975_0AED8C0B)
References: <1352385113-21671-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEdBFZ+ztESgKwprLmJH+5F=x3z66trn_QRq7WJCdcsz1g@mail.gmail.com>
	 (sfid-20121108_163625_184975_0AED8C0B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-08 at 17:36 +0200, Eliad Peller wrote:
> On Thu, Nov 8, 2012 at 4:31 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Add a debugfs file showing which HW queues were
> > allocated to a virtual interface, including the
> > CAB queue for AP interfaces.
> >
> > Change-Id: I486924e961b6ad6785a79db09620919ee644e703
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/mac80211/debugfs_netdev.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> > diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> > index 3393ad5..c3f089a 100644
> > --- a/net/mac80211/debugfs_netdev.c
> > +++ b/net/mac80211/debugfs_netdev.c
> > @@ -169,6 +169,26 @@ IEEE80211_IF_FILE(flags, flags, HEX);
> >  IEEE80211_IF_FILE(state, state, LHEX);
> >  IEEE80211_IF_FILE(channel_type, vif.bss_conf.channel_type, DEC);
> >
> > +static ssize_t
> > +ieee80211_if_fmt_hw_queues(const struct ieee80211_sub_if_data *sdata,
> > +                          char *buf, int buflen)
> > +{
> > +       int len;
> > +
> > +       len = scnprintf(buf, buflen, "AC queues: VO:%d VI:%d BE:%d BK:%d\n",
> > +                       sdata->vif.hw_queue[IEEE80211_AC_VO],
> > +                       sdata->vif.hw_queue[IEEE80211_AC_VI],
> > +                       sdata->vif.hw_queue[IEEE80211_AC_BE],
> > +                       sdata->vif.hw_queue[IEEE80211_AC_BK]);
> > +
> > +       if (sdata->vif.type == NL80211_IFTYPE_AP && len < buflen)
> > +               len += scnprintf(buf + len, buflen - len, "cab queue: %d\n",
> > +                                sdata->vif.cab_queue);
> > +
> the (len < buflen) condition is redundant (scnprintf returns the
> number of chars written not including the trailing NULL, so it will
> always be < buflen)

Err, yeah, good point. Thanks.

johannes

