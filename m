Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbYERNd2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2008 09:33:28 -0400
Subject: Re: [PATCHv2] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Helmut Schaa <hschaa@suse.de>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com>
References: <20080517203531.vus3gj5ce8ksskkc@imap.suse.de>
	 <1ba2fa240805180337h35bc3244od619e78c0d95d895@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 18 May 2008 09:32:58 -0400
Message-Id: <1211117578.686.12.camel@localhost.localdomain> (sfid-20080518_153333_132712_A3FC81FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-05-18 at 13:37 +0300, Tomas Winkler wrote:
> On Sat, May 17, 2008 at 9:35 PM, Helmut Schaa <hschaa@suse.de> wrote:
> > Fix a possible NULL pointer dereference in ieee80211_compatible_rates
> > introduced in the patch "mac80211: fix association with some APs".
> >
> > Signed-off-by: Helmut Schaa <hschaa@suse.de>
> > ---
> >
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index 76ad4ed..2642551 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -664,15 +664,22 @@ static int ieee80211_compatible_rates(struct
> > ieee80211_sta_bss *bss,
> >        int i, j, count;
> >        *rates = 0;
> >        count = 0;
> > -       for (i = 0; i < bss->supp_rates_len; i++) {
> > -               int rate = (bss->supp_rates[i] & 0x7F) * 5;
> >
> > -               for (j = 0; j < sband->n_bitrates; j++)
> > -                       if (sband->bitrates[j].bitrate == rate) {
> > -                               *rates |= BIT(j);
> > -                               count++;
> > -                               break;
> > -                       }
> > +       if (bss) {
> > +               for (i = 0; i < bss->supp_rates_len; i++) {
> > +                       int rate = (bss->supp_rates[i] & 0x7F) * 5;
> > +
> > +                       for (j = 0; j < sband->n_bitrates; j++)
> > +                               if (sband->bitrates[j].bitrate == rate) {
> > +                                       *rates |= BIT(j);
> > +                                       count++;
> > +                                       break;
> > +                               }
> > +               }
> > +       } else {
> > +               for (i = 0; i < sband->n_bitrates; i++)
> > +                       *rates |= BIT(i);
> > +               count = sband->n_bitrates;
> >        }
> >
> >        return count;
> >
> 
> Again, mac should rather solve the problem that we do not connect to
> AP's that are not in the BSS list
> Personally I would NACK this as it's just hiding  the real problem

Ugh; is that what's happening?  If the AP isn't in the BSS list of the
card, then the card shouldn't be connecting to it.  It should have been
probe-scanned already and thus exist in the BSS list, right?

Dan

> The other issue is that we call ieee80211_rx_bss_put(dev, bss); before
> this call in ieee80211_send_assoc.
> 
> Tomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

