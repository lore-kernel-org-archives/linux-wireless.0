Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:41177 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYBDLFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 06:05:54 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2886972wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 03:05:54 -0800 (PST)
Message-ID: <1ba2fa240802040305u611bb7edk3c757b73f40c1037@mail.gmail.com> (sfid-20080204_110600_738621_CD642328)
Date: Mon, 4 Feb 2008 13:05:53 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <-6799378017406559341@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1202114774.4188.127.camel@johannes.berg>
	 <1ba2fa240802040153g1d0c9902u6af2ddf3dead975d@mail.gmail.com>
	 <6231174111099834440@unknownmsgid>
	 <1ba2fa240802040227g23fe41adu446adc8f0de22712@mail.gmail.com>
	 <-6799378017406559341@unknownmsgid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 12:32 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Tomas Winkler wrote:
>
> > I prefer not. This is not just plcp rate there is also MCS flags that
> > have to passed. With all combinations the array will be huge.
>
> So you'd actually abuse the struct bitrate contents if you add the
> bitrate? I prefer that wouldn't be done, it makes the code impossible to
> follow.
>
> I guess we need to rework the rate control algorithm API completely.
>

No I won't we add rate flags which are part of spec anyway  and then
plcp rate it self will be in bitrate.

num ieee80211_rate_flags {
	IEEE80211_RATE_SHORT_PREAMBLE	= 1<<0,
	IEEE80211_RATE_MANDATORY_A	= 1<<1,
	IEEE80211_RATE_MANDATORY_B	= 1<<2,
	IEEE80211_RATE_MANDATORY_G	= 1<<3,
	IEEE80211_RATE_ERP_G		= 1<<4,
        IEEE80211_RATE_HT_GF	=  1<<5,  /* green field */
        IEEE80211_RATE_HT_SGI	=  1<<5,  /* short guarding interval */
        IEEE80211_RATE_HT_FAT	=  1<<6, /* 40Mhz Channel */
        IEEE80211_RATE_HT_SISO	=  1<<7,
        IEEE80211_RATE_HT_MIMO	=  1<<8,
        IEEE80211_RATE_ANT_A   =  1<<8,    /* Number of antenna - no
radio goes over 3 so 4 will be enough */
        IEEE80211_RATE_ANT_B   =  1<<8,
        IEEE80211_RATE_ANT_C   =  1<<8,
        IEEE80211_RATE_ANT_D   =  1<<8,
};

/**
 * struct ieee80211_rate - bitrate definition
 *
 * This structure describes a bitrate that an 802.11 PHY can
 * operate with. The two values @hw_value and @hw_value_short
 * are only for driver use when pointers to this structure are
 * passed around.
 *
 * @flags: rate-specific flags
 * @bitrate: bitrate in units of 100 Kbps
 * @hw_value: driver/hardware value for this rate
 * @hw_value_short: driver/hardware value for this rate when
 *	short preamble is used
 */
struct ieee80211_rate {
	u32 flags;
	u16 bitrate;
	u16 hw_value, hw_value_short;
};
> johannes
>
