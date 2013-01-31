Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3AaRSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 12:18:34 -0500
Date: Thu, 31 Jan 2013 11:18:26 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Arend van Spriel <arend@broadcom.com>,
	Luciano Coelho <coelho@ti.com>, ath9k-devel@venema.h4ckr.net,
	brcm80211-dev-list@broadcom.com, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 5/7] mac80211: Expand powersave configuration flag to be
 two bits
Message-ID: <20130131171826.GG28799@thinkpad-t410> (sfid-20130131_181837_858005_7C4F8396)
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
 <1359503255-18270-6-git-send-email-seth.forshee@canonical.com>
 <1359645648.8415.77.camel@jlt4.sipsolutions.net>
 <20130131163355.GE28799@thinkpad-t410>
 <1359651229.8415.99.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359651229.8415.99.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 31, 2013 at 05:53:49PM +0100, Johannes Berg wrote:
> On Thu, 2013-01-31 at 10:33 -0600, Seth Forshee wrote:
> > On Thu, Jan 31, 2013 at 04:20:48PM +0100, Johannes Berg wrote:
> > > On Tue, 2013-01-29 at 17:47 -0600, Seth Forshee wrote:
> > > 
> > > > +static inline bool ieee80211_is_ps_disabled(struct ieee80211_conf *conf)
> > > 
> > > > +static inline bool ieee80211_is_ps_enabled(struct ieee80211_conf *conf)
> > > 
> > > Huh, is that worth the confusion? It seems !enabled should be the same
> > > as disabled, but it's not quite the same, which might be confusing.
> > 
> > In this patch there's no distinction, but after adding the off-channel
> > powersave state there is -- disabled == !enabled && !offchannel.
> 
> I thought it was something like that, yeah.
> 
> > Actually one of the last bugs I fixed before sending these was a place
> > where I had used disabled instead of !enabled, and the frames ended up
> > with PM set when it shouldn't have been.
> > 
> > I agree though that the distinction is confusing. Maybe some better
> > state names are needed. Perhaps awake, offchannel, and doze?
> 
> I think what you really want is to distinguish between "HW can go to
> powersave" and "PM bit should be set"? That's pretty much what your
> CONF_PS_ENABLED and CONF_PS_OFFCHANNEL means, respectively, but maybe

Correct, with the understanding that "HW can go to powersave" also
implies "PM bit should be set."

Another approach would be to keep the CONF_PS flag the same and add a
CONF_PM flag or similar. I didn't go with this approach because CONF_PS
&& !CONF_PM really doesn't make any sense, which really doesn't help
with reducing confusion. The advantage is that it separates setting PM
from PS for those driver that don't support PS but need to configure the
hardware to set PM for off-channel.

> putting it in different terms would make it less confusing?

Yes. I think the reason enabled/disabled is confusing because it would
usually imply a binary state.

Seth
