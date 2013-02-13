Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036Ab3BMTJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 14:09:54 -0500
Message-ID: <1360782582.8868.28.camel@jlt4.sipsolutions.net> (sfid-20130213_200958_872306_C9FEB5E3)
Subject: Re: [PATCH 1/4] mac80211: Convert PS configuration from a binary
 flag to a set of modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
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
Date: Wed, 13 Feb 2013 20:09:42 +0100
In-Reply-To: <511BE15B.8090507@broadcom.com>
References: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
	 <1360184478-31481-2-git-send-email-seth.forshee@canonical.com>
	 <1360767970.8868.24.camel@jlt4.sipsolutions.net>
	 <20130213170445.GC22867@thinkpad-t410> <511BE15B.8090507@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 19:54 +0100, Arend van Spriel wrote:
> On 02/13/2013 06:04 PM, Seth Forshee wrote:
> >> Is all this really worth it? It seems a quick fix for brcmsmac might be
> >> > to always set the powersave bit when IEEE80211_CONF_OFFCHANNEL is
> >> > enabled in the config, and then go implement a real solution like I
> >> > described earlier with powersave being separated out of the core
> >> > mac80211 routines, and actually made possible for multiple interfaces?
> > Using IEEE80211_CONF_OFFCHANNEL won't work. When the nullfunc to enable
> > PS is sent the flag won't be set, as we're still on the operating
> > channel. When we're actually off-channel the value of PM doesn't matter
> > for the types of frames which are being sent. The only quick fix I've
> > found is to watch out for frames with PM set and set the powersave bit
> > while they're being transmitted.
> 
> I actually don't see that one fly. The frames are posted on a DMA fifo
> towards the hardware so in the driver we have no clue when that frame is
> being processes/transmitted hence no way of knowing when to write the
> register(s).

I think the various flushing would prevent issues there, no?

johannes

