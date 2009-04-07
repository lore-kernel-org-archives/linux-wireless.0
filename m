Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61249 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbZDGQXr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 12:23:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 09:23:47 -0700
Date: Tue, 7 Apr 2009 09:23:45 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] mac80211: check if HT40+/- is allowed before
	sending assoc
Message-ID: <20090407162345.GC5758@tesla> (sfid-20090407_182351_613656_70A1F156)
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com> <1239048958-11775-4-git-send-email-lrodriguez@atheros.com> <1239099071.22453.12.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1239099071.22453.12.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 07, 2009 at 03:11:11AM -0700, Johannes Berg wrote:
> On Mon, 2009-04-06 at 16:15 -0400, Luis R. Rodriguez wrote:
> > We weren't checking this at all.
> > 
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  net/mac80211/ht.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> > index 4e3c72f..967367c 100644
> > --- a/net/mac80211/ht.c
> > +++ b/net/mac80211/ht.c
> > @@ -122,10 +122,14 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
> >  		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
> >  			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
> >  			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
> > -				channel_type = NL80211_CHAN_HT40PLUS;
> > +				if (!(local->hw.conf.channel->flags &
> > +				    IEEE80211_CHAN_NO_HT40PLUS))
> > +					channel_type = NL80211_CHAN_HT40PLUS;
> 
> This patch is not sufficient -- you also need to modify
> ieee80211_send_assoc. Otherwise we end up telling the AP that we support
> HT40, but tuning the hardware to HT20.

Like this?

                switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
                case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
                        if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
                                cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
                                cap &= ~IEEE80211_HT_CAP_SGI_40;
                        }
                        break;
                case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
                        if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
                                cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
                                cap &= ~IEEE80211_HT_CAP_SGI_40;
                        }
                    
  Luis 
