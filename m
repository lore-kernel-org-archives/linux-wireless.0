Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2KMU2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 15:28:01 -0500
Message-ID: <1352838513.9466.31.camel@jlt4.sipsolutions.net> (sfid-20121113_212824_955811_B4D04AC3)
Subject: Re: [BUG]: 3.7.0.rc2 iwlwifi: Mn=onitor mode for Intel 6235
 includes FCS in frames
From: Johannes Berg <johannes@sipsolutions.net>
To: MARK PHILLIPS <mark.phillips@virgin.net>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Nov 2012 21:28:33 +0100
In-Reply-To: <CAAPJqkbqZhRm08N0mTfKcW1PKc=XdhqiC8-668s_ydwRAZ9M2Q@mail.gmail.com> (sfid-20121029_125608_365462_578D7DBB)
References: <CAAPJqkbqZhRm08N0mTfKcW1PKc=XdhqiC8-668s_ydwRAZ9M2Q@mail.gmail.com>
	 (sfid-20121029_125608_365462_578D7DBB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark, sorry for the delay,

On Mon, 2012-10-29 at 11:56 +0000, MARK PHILLIPS wrote:
> I have found bug which breaks monitor mode for the Intel Centrino
> Advanced-N 6235. When in monitor mode the FCS is returned appended to
> the frames which confuses wireshark.
> 
> The fix appears to be trivial, just add IEEE80211_HW_RX_INCLUDES_FCS
> to the hw->flags when in monitor mode via a change to
> drivers/net/wireless/iwlwifi/dvm/mac80211.c

Yes, this seems to be a reasonable change, unfortunately mac80211
doesn't provide a per packet flag whether the FCS is present or not.

I think I prefer doing the modification in iwlagn_mac_add_interface(),
and will also add a comment.

FWIW, this appears to be a regression introduced in
578977264199de9815ace51ade87cec4894cf010, which went into 3.5. I'm a bit
confused why this didn't appear in my tests though, so I'm trying to see
if different firmware versions behave differently.

johannes

