Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2C3ShF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 14:37:05 -0400
Message-ID: <1333132621.3804.0.camel@jlt3.sipsolutions.net> (sfid-20120330_203728_916998_6E85F845)
Subject: Re: [PATCH 2/4] mac80211: Indicate basic rates when adding
 supported rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	thomas@cozybit.com, devel@lists.open80211s.org,
	linville@tuxdriver.com
Date: Fri, 30 Mar 2012 20:37:01 +0200
In-Reply-To: <CACcxo+rbPwcjm6=2vpXE6ikdEwKfL-dUyBpxgpVcbUmLgXUuvQ@mail.gmail.com> (sfid-20120330_195830_877346_0DE33DA1)
References: <1333063729-9353-1-git-send-email-ashok@cozybit.com>
	 <1333063729-9353-2-git-send-email-ashok@cozybit.com>
	 <1333090147.3908.6.camel@jlt3.sipsolutions.net>
	 <CACcxo+rbPwcjm6=2vpXE6ikdEwKfL-dUyBpxgpVcbUmLgXUuvQ@mail.gmail.com>
	 (sfid-20120330_195830_877346_0DE33DA1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-30 at 10:57 -0700, Ashok Nagarajan wrote:
> Hello Johannes,
> 
> On Thu, Mar 29, 2012 at 11:49 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-03-29 at 16:28 -0700, Ashok Nagarajan wrote:
> >> and extended supported rates
> >>
> >> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> >> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> >> ---
> >>  net/mac80211/util.c |   12 ++++++++++--
> >>  1 files changed, 10 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> >> index 32f7a3b..a1e2ff5 100644
> >> --- a/net/mac80211/util.c
> >> +++ b/net/mac80211/util.c
> >> @@ -1685,6 +1685,7 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
> >>       struct ieee80211_supported_band *sband;
> >>       int rate;
> >>       u8 i, rates, *pos;
> >> +     u32 basic_rates = vif->bss_conf.basic_rates;
> >>
> >>       sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
> >>       rates = sband->n_bitrates;
> >> @@ -1698,8 +1699,11 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
> >>       *pos++ = WLAN_EID_SUPP_RATES;
> >>       *pos++ = rates;
> >>       for (i = 0; i < rates; i++) {
> >> +             u8 basic = 0;
> >> +             if (basic_rates & BIT(i))
> >> +                     basic = 0x80;
> >>               rate = sband->bitrates[i].bitrate;
> >> -             *pos++ = (u8) (rate / 5);
> >> +             *pos++ = basic | (u8) (rate / 5);
> >>       }
> >
> > I'm not sure you should do this unconditionally with the
> > vif->bss_conf.basic_rates, for example this code is also used with TDLS
> > and I have no idea what that should be there -- since we didn't add
> > anything before maybe it should indeed not have any basic rate bits?
> >
> > johannes
> >
> 
> Do you want us to add a check if the vif.type is mesh point or have an
> extra parameter indicating the need for basic rates? What approach
> would you suggest?

I'd probably say add an argument since you might want to actually set
the basic rate bits in some other cases too.

johannes

