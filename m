Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1212 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab3BMVnc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 16:43:32 -0500
Message-ID: <511C08F2.6040008@broadcom.com> (sfid-20130213_224336_772377_156BE529)
Date: Wed, 13 Feb 2013 22:43:14 +0100
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
 <20130213170445.GC22867@thinkpad-t410> <511BE15B.8090507@broadcom.com>
 <20130213192519.GD22867@thinkpad-t410>
In-Reply-To: <20130213192519.GD22867@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2013 08:25 PM, Seth Forshee wrote:
> On Wed, Feb 13, 2013 at 07:54:19PM +0100, Arend van Spriel wrote:
>> On 02/13/2013 06:04 PM, Seth Forshee wrote:
>>>> Is all this really worth it? It seems a quick fix for brcmsmac might be
>>>>> to always set the powersave bit when IEEE80211_CONF_OFFCHANNEL is
>>>>> enabled in the config, and then go implement a real solution like I
>>>>> described earlier with powersave being separated out of the core
>>>>> mac80211 routines, and actually made possible for multiple interfaces?
>>> Using IEEE80211_CONF_OFFCHANNEL won't work. When the nullfunc to enable
>>> PS is sent the flag won't be set, as we're still on the operating
>>> channel. When we're actually off-channel the value of PM doesn't matter
>>> for the types of frames which are being sent. The only quick fix I've
>>> found is to watch out for frames with PM set and set the powersave bit
>>> while they're being transmitted.
>>
>> I actually don't see that one fly. The frames are posted on a DMA fifo
>> towards the hardware so in the driver we have no clue when that frame is
>> being processes/transmitted hence no way of knowing when to write the
>> register(s).
> 
> There's a couple of ways of doing it. I had a working patch at one point
> but can't seem to find it now, so I'm not sure which way I used. You're
> right though that we can't tell when the hardware is actually processing
> or transmitting the frame, so in either case MCTL_HPS has to be set
> before you put the frame in the tx fifo.
> 
> The first option is that for any frame with PM set, set MCTL_HPS when
> mac80211 hands off the frame and clear it once it has finished
> transmitting.
> 
> The second option is to look specifically for nullfunc frames and set or
> clear MCTL_HPS based on the value of PM.
> 
> Either of these should work fine with the current mac80211 code, but
> overall the second one is probably a little safer.

So you have verified that the last packet mac80211 sends before going
off-channel is the nullfunc frame with PM bit set. I have seen packets
coming in our driver during the .flush() callback, but never checked
whether the last of those packets is indeed the nullfunc.

Gr. AvS


