Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55614 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3AaQpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 11:45:54 -0500
Message-ID: <1359650760.8415.91.camel@jlt4.sipsolutions.net> (sfid-20130131_174558_299669_5884EDC6)
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 31 Jan 2013 17:46:00 +0100
In-Reply-To: <20130131161346.GA1387@pandem0nium>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359642321.8415.56.camel@jlt4.sipsolutions.net>
	 <20130131161346.GA1387@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 17:13 +0100, Simon Wunderlich wrote:

> > > +int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> > > +				  const struct cfg80211_chan_def *c);
> > 
> > Why does that need to be exported to mac80211/drivers? Shouldn't
> > cfg80211 be able to check everything?
> > 
> I'm using it in mac80211/ieee80211_start_ap() to find out whether radar detection
> is required. We could put into struct cfg80211_ap_settings *params if you prefer?
> I guess similar params exist for IBSS.

I kinda think that would make more sense because then it's right there
when you look at the parameters, rather than having to remember it.

> > Don't you need a cac_chandef or something?

> The chandef is stored into wdev->preset_chandef anyway, so I didn't see any
> need to save it twice?

(I'm just worried about that changing, see below. We could use
"wdev->channel" though, which I need to change to chandef anyway)

> Anyway, the idea was that a driver can report a radar only for a certain part of
> the currently used spectrum - e.g. we sense a radar on the extension channel in HT40+,
> we would need to move but could still use the primary channel.
> 
> I don't know if this is overkill since we don't support any more than HT20 yet, but
> that would be kind of future proof.

I guess I'm not worried about internal APIs much. Does that even make
sense? Can you detect radar on one 20 MHz subchannel and then still use
the other subchannel?

> IMHO the channels should be cleared on each regdom change. At least radar
> patterns are different from FCC and ETSI (although I don't know if there is
> a pattern in FCC which can be ignored in ETSI and vice versa). To be sure,
> I would vote for complete reset.

Your call.

> > > @@ -344,7 +467,10 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
> > >  		break;
> > >  	case NL80211_IFTYPE_AP:
> > >  	case NL80211_IFTYPE_P2P_GO:
> > > -		if (wdev->beacon_interval) {
> > > +		if (wdev->cac_started) {
> > > +			*chan = wdev->preset_chandef.chan;
> > > +			*chanmode = CHAN_MODE_SHARED;
> > 
> > Ah, ok, so you're using the preset_chandef for CAC as well. I'm not
> > entirely sure that is correct though, since it could be changed by
> > userspace without much effect, e.g. by setting the channel with iw or
> > iwconfig? Unless you added "if (!cac_started)" there everywhere?
> > 
> 
> Hmm, actually I've tried setting the frequency with iw and got a EINVAL back.
> I'll look into it again if I missed something, but thought it would be good to
> not have this stuff redundant.

Ok. Hmm. EINVAL? Maybe you tried setting to a radar frequency or
something? Can you try setting to say channel 1? I don't think you
changed __nl80211_set_channel() to check cac_started, so ...

> > > +	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
> > > +	if (err < 1)
> > > +		return err;
> > 
> > That doesn't make sense, if userspace starts CAC and that is successful
> > it would expect to eventually receive an event that it completed? Thus
> > if you return 0 here it would get confused, no?
> > 
> 
> Ah yes, I should probably return EINVAL in this case, or the appropriate
> error code otherwise ... 

Maybe return some more useful error code? Can't really find any one that
is appropriate though.

Do we export the state yet when you do try to get the channel list? That
would be helpful for userspace, particularly in this case, I think.

> > > +	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
> > > +	if (!err) {
> > > +		wdev->preset_chandef = chandef;
> > > +		wdev->cac_started = true;
> > > +		chandef.chan->dfs_state_entered = jiffies;
> > 
> > No reason to assign dfs_state_entered since it won't be used in this
> > state anyway, will it?
> > 
> 
> Hmm ... yeah, that's stupid. I'll need to add wdev->cac_entered or something like
> that to track CAC time. Using dfs_state_entered is just wrong.

I didn't see you read that, or did I miss that?

> > > +	if (cfg80211_chandef_usable(&rdev->wiphy, &ibss.chandef,
> > > +				    IEEE80211_CHAN_NO_IBSS))
> > > +		return -EINVAL;
> > 
> > That seems like an unrelated change/fix?
> > 
> 
> Well, yeah, that is a survivor from some intermediate state that I forgot to remove.
> I still have some confusion/questions regarding the other flags, there is a question
> in the cover letter regarding this - we should discuss it there.

Oh I missed that, let me see.

> > > @@ -884,6 +884,9 @@ static void handle_channel(struct wiphy *wiphy,
> > >  		return;
> > >  	}
> > >  
> > > +	chan->dfs_state = IEEE80211_DFS_USABLE;
> > > +	chan->dfs_state_entered = jiffies;
> > 
> > Here also you don't really need the time assignment.
> > 
> > (I skipped this before, so pasting here)
> > 
> 
> Hm, aren't channels initialized in this function? I wanted to set some
> sane values here - although time is not relevant for the USABLE state,
> I thought it might be useful if this info is exported to userspace or
> for debugging.

Maybe so, I just don't think you need the time there since it won't be
of relevance in the USABLE state. The "state entered" time is only used
for UNAVAILABLE.

Maybe therefore state_entered should be renamed to "unavailable_until"
with the corresponding change in the logic of adding the time when it's
set to that state?

johannes

