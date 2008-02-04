Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:19793 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYBDLVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 06:21:18 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2893233wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 03:21:17 -0800 (PST)
Message-ID: <1ba2fa240802040321s515e61deld176d79eef2b444d@mail.gmail.com> (sfid-20080204_112123_155422_250011A2)
Date: Mon, 4 Feb 2008 13:21:17 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <-4694429725714512287@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1202114774.4188.127.camel@johannes.berg>
	 <1ba2fa240802040153g1d0c9902u6af2ddf3dead975d@mail.gmail.com>
	 <6231174111099834440@unknownmsgid>
	 <1ba2fa240802040227g23fe41adu446adc8f0de22712@mail.gmail.com>
	 <-6799378017406559341@unknownmsgid>
	 <1ba2fa240802040305u611bb7edk3c757b73f40c1037@mail.gmail.com>
	 <-4694429725714512287@unknownmsgid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 1:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Tomas Winkler wrote:
>
> > No I won't we add rate flags which are part of spec anyway  and then
> > plcp rate it self will be in bitrate.
>
> >         IEEE80211_RATE_HT_GF  =  1<<5,  /* green field */
> >         IEEE80211_RATE_HT_SGI =  1<<5,  /* short guarding interval */
> >         IEEE80211_RATE_HT_FAT =  1<<6, /* 40Mhz Channel */
> >         IEEE80211_RATE_HT_SISO        =  1<<7,
> >         IEEE80211_RATE_HT_MIMO        =  1<<8,
> >         IEEE80211_RATE_ANT_A   =  1<<8,    /* Number of antenna - no
> > radio goes over 3 so 4 will be enough */
> >         IEEE80211_RATE_ANT_B   =  1<<8,
> >         IEEE80211_RATE_ANT_C   =  1<<8,
> >         IEEE80211_RATE_ANT_D   =  1<<8,
>
> Ah, I see. Since these flags aren't really rate specific, so shouldn't
> they rather be part of the TX control, TX status and RX status directly
> rather than inside the rate? The flags within the bitrate are meant to
> indicate hardware capabilities and/or spec flags (like ERP) not control
> flags like these are.

No, they are rate specific the are not modulation specific, each of
them can change from packet to packet.
Thanks
Tomas

> johannes
>
