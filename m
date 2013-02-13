Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4016 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297Ab3BMSzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 13:55:08 -0500
Message-ID: <511BE15B.8090507@broadcom.com> (sfid-20130213_195514_377530_0271B083)
Date: Wed, 13 Feb 2013 19:54:19 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"Jouni Malinen" <jouni@qca.qualcomm.com>,
	"Vasanthakumar Thiagarajan" <vthiagar@qca.qualcomm.com>,
	"Senthil Balasubramanian" <senthilb@qca.qualcomm.com>,
	"Christian Lamparter" <chunkeey@googlemail.com>,
	"Ivo van Doorn" <IvDoorn@gmail.com>,
	"Gertjan van Wingerde" <gwingerde@gmail.com>,
	"Helmut Schaa" <helmut.schaa@googlemail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Chaoming Li" <chaoming_li@realsil.com.cn>,
	"Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
	"Intel Linux Wireless" <ilw@linux.intel.com>,
	"Luciano Coelho" <coelho@ti.com>, ath9k-devel@venema.h4ckr.net,
	brcm80211-dev-list@broadcom.com, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/4] mac80211: Convert PS configuration from a
 binary flag to a set of modes
References: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
 <1360184478-31481-2-git-send-email-seth.forshee@canonical.com>
 <1360767970.8868.24.camel@jlt4.sipsolutions.net>
 <20130213170445.GC22867@thinkpad-t410>
In-Reply-To: <20130213170445.GC22867@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2013 06:04 PM, Seth Forshee wrote:
>> Is all this really worth it? It seems a quick fix for brcmsmac might be
>> > to always set the powersave bit when IEEE80211_CONF_OFFCHANNEL is
>> > enabled in the config, and then go implement a real solution like I
>> > described earlier with powersave being separated out of the core
>> > mac80211 routines, and actually made possible for multiple interfaces?
> Using IEEE80211_CONF_OFFCHANNEL won't work. When the nullfunc to enable
> PS is sent the flag won't be set, as we're still on the operating
> channel. When we're actually off-channel the value of PM doesn't matter
> for the types of frames which are being sent. The only quick fix I've
> found is to watch out for frames with PM set and set the powersave bit
> while they're being transmitted.

I actually don't see that one fly. The frames are posted on a DMA fifo
towards the hardware so in the driver we have no clue when that frame is
being processes/transmitted hence no way of knowing when to write the
register(s).

Gr. AvS

