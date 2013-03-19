Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:33733 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab3CSM4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 08:56:46 -0400
Received: by mail-we0-f170.google.com with SMTP id z53so365737wey.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 05:56:45 -0700 (PDT)
Date: Tue, 19 Mar 2013 13:53:41 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
Message-ID: <20130319125341.GB26078@magnum.frso.rivierawaves.com> (sfid-20130319_135650_485288_DFC5F55C)
References: <1363552234-6752-1-git-send-email-karl.beldan@gmail.com>
 <1363552234-6752-2-git-send-email-karl.beldan@gmail.com>
 <1363634710.8260.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363634710.8260.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 18, 2013 at 08:25:10PM +0100, Johannes Berg wrote:
> On Sun, 2013-03-17 at 21:30 +0100, Karl Beldan wrote:
> 
> > +	if (conf->chandef.chan)
> 
> > +	else
> > +		wiphy_debug(hw->wiphy,
> > +			    "%s (freq=0/%s idle=%d ps=%d smps=%s)\n",
> 
> I don't think the else should be allowed to happen.
> 
> > --- a/net/mac80211/cfg.c
> > +++ b/net/mac80211/cfg.c
> > @@ -805,8 +805,7 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
> >  					IEEE80211_CHANCTX_EXCLUSIVE);
> >  		}
> >  	} else if (local->open_count == local->monitors) {
> > -		local->_oper_channel = chandef->chan;
> > -		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
> > +		memcpy(&local->oper_chandef, chandef, sizeof(local->oper_chandef));
> 
> Somehow I'd prefer an assignment:
> 
> local->oper_chandef = *chandef;
> 
> I know it'll just be a memcpy() again, but ... reads nicer, imho.
> 
> > +			memcpy(chandef, &local->oper_chandef, sizeof(chandef));
> 
> ditto
> 
> > @@ -22,7 +22,9 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
> >  	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_WIDTH);
> >  
> >  	if (!local->use_chanctx) {
> > -		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
> > +		local->oper_chandef.width = chandef->width;
> > +		local->oper_chandef.center_freq1 = chandef->center_freq1;
> > +		local->oper_chandef.center_freq2 = chandef->center_freq2;
> 
> Why not assign all here as well? Is the channel pointer itself special?
> 
> > -	/* For backward compatibility only -- do not use */
> > -	struct ieee80211_channel *_oper_channel;
> > -	enum nl80211_channel_type _oper_channel_type;
> > +	struct cfg80211_chan_def oper_chandef;
> 
> You shouldn't remove the comment, and I think you should also keep the
> leading underscore -- this is still for backward compatibility with
> non-chanctx drivers only, and mac80211 internally must use chanctxes all
> the way except in SW scan and SW roc code.
>  
> > +static int ieee80211_chandef_cmp(const struct cfg80211_chan_def *def1,
> > +				 const struct cfg80211_chan_def *def2)
> 
> indentation
> 
> However this already exists in cfg80211.h --
> cfg80211_chandef_identical().
> 
> >  static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
> >  {
> >  	struct ieee80211_sub_if_data *sdata;
> > +	struct cfg80211_chan_def chandef;
> 
> better initialize this: struct ... chandef = {};
> 
Ok, even though I have done it in the v2 I think I get why now (after
the comment of Mahesh on center_freq2 != 0).
And the reason I'd see is that you take care of zeroing center_freq{1,2}
when they are not used (i.e wrt to the width), and the code behaves
accordingly ?
Then, indeed I could obviously drop cfg80211_chandef_identical for
cfg80211_chandef_identical.
 
Karl
