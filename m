Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3ADNJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 08:09:59 -0500
Message-ID: <1357305013.11302.7.camel@jlt4.sipsolutions.net> (sfid-20130104_141002_556024_402D9100)
Subject: Re: [PATCHv5 7/8] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 04 Jan 2013 14:10:13 +0100
In-Reply-To: <20130103074732.GD20780@pandem0nium>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1355407113-27006-8-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357134469.9839.35.camel@jlt4.sipsolutions.net>
	 <20130103074732.GD20780@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-03 at 08:47 +0100, Simon Wunderlich wrote:
> On Wed, Jan 02, 2013 at 02:47:49PM +0100, Johannes Berg wrote:
> > On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:
> > 
> > > +	mutex_lock(&local->mtx);
> > > +	if (local->ap_cs_chandef.chan->flags & IEEE80211_CHAN_RADAR) {
> > > +		sdata_info(sdata, "changing to DFS channel\n");
> > > +		/* when changing to a DFS channel, stop AP. Userspace must
> > > +		 * restart AP or do start radar detection first.
> > > +		 */
> > > +		stop_ap = true;
> > 
> > I don't see any value in this. You might just as well simply forbid
> > requesting a channel change to a DFS channel, hostapd could then stop
> > instead of doing the switch.
> > 
> 
> We explicitly want the channel switch, this was the original idea in 802.11h
> - announce the next channel, then switch. To announce the next channel, we
> need to allow this.
> 
> As discussed before, doing stop_ap here is probably not a good idea. We
> can change that back to let the driver disable transmissions and expect
> an explicit enable_tx call from userspace after CAC on the new channel.

I just don't see that the clients will wait a minute (?) for the CAC on
the new channel, they'll probably just disconnect and look for another
AP. So I guess the question is whether we should ever switch to a radar
channel ...

johannes

