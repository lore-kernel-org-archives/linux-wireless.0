Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47642 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3CSMbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 08:31:44 -0400
Received: by mail-wi0-f177.google.com with SMTP id hm14so424183wib.10
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 05:31:43 -0700 (PDT)
Date: Tue, 19 Mar 2013 13:28:36 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC V2 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
Message-ID: <20130319122836.GA26078@magnum.frso.rivierawaves.com> (sfid-20130319_133148_718712_E68B04C5)
References: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
 <1363652600-23223-2-git-send-email-karl.beldan@gmail.com>
 <1363693626.3355.14.camel@WLAN-SW-TEST-03>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363693626.3355.14.camel@WLAN-SW-TEST-03>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 19, 2013 at 05:17:06PM +0530, Mahesh Palivela wrote:
> On Tue, 2013-03-19 at 01:23 +0100, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > Drivers that don't use chanctxes cannot perform VHT association because
> > they still use a "backward compatibility" pair of {ieee80211_channel,
> > nl80211_channel_type} in ieee80211_conf and ieee80211_local.
> > 
> > FIXME: this only changes mac80211_hwsim for the RFC
> > 
> > Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> > ---
> >  drivers/net/wireless/mac80211_hwsim.c |   44 +++++++++++++++++---------
> >  include/net/mac80211.h                |   15 +++++----
> >  net/mac80211/cfg.c                    |    7 +---
> >  net/mac80211/chan.c                   |    8 ++---
> >  net/mac80211/ieee80211_i.h            |    3 +-
> >  net/mac80211/main.c                   |   55 +++++++++++++++++++--------------
> >  net/mac80211/mlme.c                   |   20 ++++++++----
> >  net/mac80211/scan.c                   |    6 ++--
> >  net/mac80211/trace.h                  |   21 ++++++++-----
> >  net/mac80211/tx.c                     |    4 +-
> >  net/mac80211/util.c                   |    3 +-
> >  11 files changed, 107 insertions(+), 79 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> > index 7490c4f..96e75e2 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.c
> > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > @@ -1056,11 +1056,13 @@ out:
> >  	return HRTIMER_NORESTART;
> >  }
> >  
> > -static const char *hwsim_chantypes[] = {
> > -	[NL80211_CHAN_NO_HT] = "noht",
> > -	[NL80211_CHAN_HT20] = "ht20",
> > -	[NL80211_CHAN_HT40MINUS] = "ht40-",
> > -	[NL80211_CHAN_HT40PLUS] = "ht40+",
> > +static const char *hwsim_chanwidth[] = {
> > +	[NL80211_CHAN_WIDTH_20_NOHT] = "noht",
> > +	[NL80211_CHAN_WIDTH_20] = "ht20",
> > +	[NL80211_CHAN_WIDTH_40] = "ht40",
> > +	[NL80211_CHAN_WIDTH_80] = "ht80",
> 
> better we call as vht80 instead of ht80. ditto below..
> 
Yes

> > +	[NL80211_CHAN_WIDTH_80P80] = "ht80p80",
> > +	[NL80211_CHAN_WIDTH_160] = "ht160",
> >  };
> >  
> 
> > +	cfreq_off = local->csa_channel->center_freq -
> > +		local->_oper_chandef.chan->center_freq;
> > +
> > +	local->_oper_chandef.center_freq1 += cfreq_off;
> > +	local->_oper_chandef.center_freq2 += cfreq_off;
> 
> can't add cfreq_off to center_freq2. Add only in case of non-zero
> center_freq2?
> 
At first I was like "why ?", but I hadn't spotted the places where we
only check for "center_freq2 != 0".


Thanks Mahesh, Have you tested vht with this ? 


 
Karl
