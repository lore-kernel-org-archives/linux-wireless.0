Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55692 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KVU3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:29:03 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so2136236wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 12:29:02 -0800 (PST)
From: "Mark Phillips" <mark.phillips@virgin.net>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <CAAPJqkbqZhRm08N0mTfKcW1PKc=XdhqiC8-668s_ydwRAZ9M2Q@mail.gmail.com>	 (sfid-20121029_125608_365462_578D7DBB) <1352838513.9466.31.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352838513.9466.31.camel@jlt4.sipsolutions.net>
Subject: RE: [BUG]: 3.7.0.rc2 iwlwifi: Mn=onitor mode for Intel 6235 includes FCS in frames
Date: Thu, 22 Nov 2012 01:03:47 -0000
Message-ID: <005a01cdc84d$3c7ffc30$b57ff490$@virgin.net> (sfid-20121122_212925_056952_679C637F)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great, glad you are sorting it out, thanks for all your help!

Cheers
Mark

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: 13 November 2012 20:29
To: MARK PHILLIPS
Cc: linux-wireless@vger.kernel.org
Subject: Re: [BUG]: 3.7.0.rc2 iwlwifi: Mn=onitor mode for Intel 6235 includes FCS in frames

Hi Mark, sorry for the delay,

On Mon, 2012-10-29 at 11:56 +0000, MARK PHILLIPS wrote:
> I have found bug which breaks monitor mode for the Intel Centrino 
> Advanced-N 6235. When in monitor mode the FCS is returned appended to 
> the frames which confuses wireshark.
> 
> The fix appears to be trivial, just add IEEE80211_HW_RX_INCLUDES_FCS 
> to the hw->flags when in monitor mode via a change to 
> drivers/net/wireless/iwlwifi/dvm/mac80211.c

Yes, this seems to be a reasonable change, unfortunately mac80211 doesn't provide a per packet flag whether the FCS is present or not.

I think I prefer doing the modification in iwlagn_mac_add_interface(), and will also add a comment.

FWIW, this appears to be a regression introduced in 578977264199de9815ace51ade87cec4894cf010, which went into 3.5. I'm a bit confused why this didn't appear in my tests though, so I'm trying to see if different firmware versions behave differently.

johannes

