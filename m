Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58569 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQJBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 04:01:49 -0500
Message-ID: <1389949304.8062.55.camel@porter.coelho.fi> (sfid-20140117_100153_484936_2E0FB94B)
Subject: Re: [PATCH 1/2] b43: fix the wrong assignment of status.freq in
 b43_rx()
From: Luca Coelho <luca@coelho.fi>
To: Jonas Gorski <jogo@openwrt.org>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	ZHAO Gang <gamerh2o@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
Date: Fri, 17 Jan 2014 11:01:44 +0200
In-Reply-To: <CAOiHx=nui0nVGiCLoukRovB3zY5jiKAt__Numo4y4bQv0dzOcQ@mail.gmail.com>
References: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
	 <1389939896.8062.53.camel@porter.coelho.fi>
	 <CACna6rzkKGxBxReQJ0Y=TscY8GJ+r=S+6Cs+g+B0=7k1FFxW2w@mail.gmail.com>
	 <CAOiHx=nui0nVGiCLoukRovB3zY5jiKAt__Numo4y4bQv0dzOcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-17 at 09:56 +0100, Jonas Gorski wrote:
> On Fri, Jan 17, 2014 at 8:11 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> > 2014/1/17 Luca Coelho <luca@coelho.fi>:
> >> On Fri, 2014-01-17 at 13:27 +0800, ZHAO Gang wrote:
> >>> In following patch, replace b43 specific helper function with kernel
> >>> api to reduce code duplication.
> >>>
> >>> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
> >>> ---
> >>>  drivers/net/wireless/b43/xmit.c | 4 ++--
> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
> >>> index 4ae63f4..50e5ddb 100644
> >>> --- a/drivers/net/wireless/b43/xmit.c
> >>> +++ b/drivers/net/wireless/b43/xmit.c
> >>> @@ -821,10 +821,10 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
> >>>                * channel number in b43. */
> >>>               if (chanstat & B43_RX_CHAN_5GHZ) {
> >>>                       status.band = IEEE80211_BAND_5GHZ;
> >>> -                     status.freq = b43_freq_to_channel_5ghz(chanid);
> >>> +                     status.freq = b43_channel_to_freq_5ghz(chanid);
> >>>               } else {
> >>>                       status.band = IEEE80211_BAND_2GHZ;
> >>> -                     status.freq = b43_freq_to_channel_2ghz(chanid);
> >>> +                     status.freq = b43_channel_to_freq_2ghz(chanid);
> >>>               }
> >>>               break;
> >>>       default:
> >>
> >> Why do you need this patch if you're going to remove these calls in the
> >> next patch anyway?
> >
> > I was thinking about this for a moment too. You could just make a one
> > patch and note in commit message that "translation" was reversed.
> 
> That would mean mixing fixes and improvements, which is something you
> are not supposed to do, so IMHO having these split into two is
> correct. Think about stable maintainers wanting the fix but not the
> other change because it might introduce unknown side effects.

Makes sense.  In such case, the first patch should be clearly marked as
a bug fix, so at least the commit message should be changed (ie.
mentioning the next patch in the series is useless).

--
Luca.

