Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3F0Obc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 10:31:32 -0400
Message-ID: <1372343489.8160.11.camel@jlt4.sipsolutions.net> (sfid-20130627_163134_761620_BA3A1452)
Subject: Re: [PATCHv4 02/18] mac80211/rc80211: add chandef to rate
 initialization
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 27 Jun 2013 16:31:29 +0200
In-Reply-To: <1372343457.8160.10.camel@jlt4.sipsolutions.net> (sfid-20130627_163106_779970_99BBA4BD)
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1372337064-19254-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1372337940.8160.3.camel@jlt4.sipsolutions.net>
	 <20130627142754.GA19965@pandem0nium>
	 <1372343457.8160.10.camel@jlt4.sipsolutions.net>
	 (sfid-20130627_163106_779970_99BBA4BD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-27 at 16:30 +0200, Johannes Berg wrote:
> On Thu, 2013-06-27 at 16:27 +0200, Simon Wunderlich wrote:
> > On Thu, Jun 27, 2013 at 02:59:00PM +0200, Johannes Berg wrote:
> > > On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:
> > > 
> > > >  static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
> > > > +			  struct cfg80211_chan_def *chandef,
> > > 
> > > I'd argue you can remove the sband pointer now, since the band is known
> > > from the chandef?
> > 
> > Not really, these rate algos usually access sband->bitrates, and sband can not be
> > derived from just the band and these others parameters (at least I miss to see how).
> 
> sband = hw->wiphy->bands[chandef->chan.band];

might be more efficient to just pass it though :)

johannes

