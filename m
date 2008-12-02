Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:52467 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYLBPzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 10:55:55 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 1/6 v2.2] mac80211: add sta_notify_ps callback
Date: Tue, 2 Dec 2008 16:55:53 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
References: <200811292232.56550.chunkeey@web.de> <200811300048.42352.chunkeey@web.de> <20081201191723.GI5992@tesla>
In-Reply-To: <20081201191723.GI5992@tesla>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812021655.53141.chunkeey@web.de> (sfid-20081202_165558_665017_A0440AD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 December 2008 20:17:23 Luis R. Rodriguez wrote:
> On Sat, Nov 29, 2008 at 03:48:41PM -0800, Christian Lamparter wrote:
> > This patch is necessary in order to provide a proper Access point support for p54.
> > Unfortunately for us, there is no documented way to disable the interfering
> > power save buffering mechanism in firmware completely.
> > 
> > Therefore we give in and notify the driver through our new sta_notify_ps callback,
> > so that we can update the filter state.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > +/**
> >   * enum ieee80211_tkip_key_type - get tkip key
> >   *
> >   * Used by drivers which need to get a tkip key for skb. Some drivers need a
> > @@ -1248,6 +1261,9 @@ enum ieee80211_ampdu_mlme_action {
> >   * @sta_notify: Notifies low level driver about addition or removal
> >   *     of associated station or AP.
> >   *
> > + * @sta_ps_notify: Notifies low level driver about the power state transition
> > + *     of a associated station. Must be atomic.
> > + *
> 
> Can we add documentation that this is only required when the AP cannot
> figure this out by itself? This can help people working on AP support to
> not think they need to implement this for all drivers.

Do you think "This callback is optional. Only use it, if your hardware/
firmware really implements a station filter table" is enough (and correct spelled btw?)
Or do you volunteer for adding one or two DOC entries about APs, BC & MC Buffering,
TIM and station filters mechanism, caveats, and available callbacks or solutions?

Regards,
	Chr
