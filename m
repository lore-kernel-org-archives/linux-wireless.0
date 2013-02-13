Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55696 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760039Ab3BMREy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 12:04:54 -0500
Date: Wed, 13 Feb 2013 11:04:45 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
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
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Luciano Coelho <coelho@ti.com>, ath9k-devel@venema.h4ckr.net,
	brcm80211-dev-list@broadcom.com, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/4] mac80211: Convert PS configuration from a binary
 flag to a set of modes
Message-ID: <20130213170445.GC22867@thinkpad-t410> (sfid-20130213_180458_524683_80072CF9)
References: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
 <1360184478-31481-2-git-send-email-seth.forshee@canonical.com>
 <1360767970.8868.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360767970.8868.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 13, 2013 at 04:06:10PM +0100, Johannes Berg wrote:
> On Wed, 2013-02-06 at 15:01 -0600, Seth Forshee wrote:
> > The powersave configuration in struct ieee80211_conf is currently a
> > binary state, either enabled or disabled. This is inadequate for
> > expressing the situation during off-channel operation, when powersave is
> > set at the AP to request bufferring of frames but the hardware remains
> > fully awake. Some drivers (e.g. brcmsmac) need to perform configuration
> > to support this in-between state but lack the information to do so.
> > 
> > To prepare for adding an off-channel powersave mode, expand the current
> > powersave configuration flag to two bits to support expressing another
> > state. Add helper functions for setting and retrieving the state, and
> > convert mac80211 and drivers to use these functions.
> > 
> > In changing from a binary flag to powersave mode, also update the
> > terminology used to name the states for clarity. The "enabled" state is
> > changed to "doze" to indicate a low power hardware state, and the
> > "disabled" state is changed to "awake" to indicate a fully powerd on
> > hardware state. This is consistent with the terminology defined in IEEE
> > 802.11-2012 section 10.2.1.2.
> 
> Ok so I'm reviewing this again.
> 
> I'm not really convinced this is the right thing to do. Sooner or later,
> multi-virtual interface support will become more relevant, and then all
> of this is completely moot because then powersave is entirely disabled
> and not handled right now.

Hmm, I don't recall you really going into any detail regarding
powersave, only managing the queues for off-channel. Though I can see
that multi-vif throws a wrench into things, even if I don't understand
all the details.

> Is all this really worth it? It seems a quick fix for brcmsmac might be
> to always set the powersave bit when IEEE80211_CONF_OFFCHANNEL is
> enabled in the config, and then go implement a real solution like I
> described earlier with powersave being separated out of the core
> mac80211 routines, and actually made possible for multiple interfaces?

Using IEEE80211_CONF_OFFCHANNEL won't work. When the nullfunc to enable
PS is sent the flag won't be set, as we're still on the operating
channel. When we're actually off-channel the value of PM doesn't matter
for the types of frames which are being sent. The only quick fix I've
found is to watch out for frames with PM set and set the powersave bit
while they're being transmitted.

I'm going to have to spend some time trying to grok how powersave would
work out with multiple interfaces. Honestly though I don't know that
multiple interfaces is something that we have any interest in at the
moment, and if not then it may be difficult for me to justify spending
much time on it.

Seth

