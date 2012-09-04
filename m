Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2IDLeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 07:34:46 -0400
Message-ID: <1346758521.3737.28.camel@jlt4.sipsolutions.net> (sfid-20120904_133450_761914_FDFA6D52)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Date: Tue, 04 Sep 2012 13:35:21 +0200
In-Reply-To: <CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com> (sfid-20120904_132540_615042_3B7789FB)
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	 <1346746298.3737.0.camel@jlt4.sipsolutions.net>
	 <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	 <20120904102204.GA2541@w1.fi>
	 <CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
	 <CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
	 (sfid-20120904_132540_615042_3B7789FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 19:25 +0800, Yeoh Chun-Yeow wrote:
> Hi, Jouni
> 
> I have retested with the following:
> 
> case 1 with submitted patch:
> mesh1: ath5k nohwcrypt=1
> mesh2: ath5k (no IEEE80211_KEY_FLAG_SW_MGMT)
> Result: Both of them are not able to ping each other. Also, the PREP
> action frame is not able to decrypted by another node.
> 
> case 2 with submitted patch:
> mesh1: ath5k nohwcrypt=1
> mesh2: ath5k nohwcrypt=1
> Result: They are able to ping each other.
> 
> case 3 with submitted patch but enable IEEE80211_KEY_FLAG_SW_MGMT:
> mesh1: ath5k nohwcrypt=1
> mesh2: ath5k (with IEEE80211_KEY_FLAG_SW_MGMT)
> Result: They are able to ping each other
> 
> case 4 with submitted patch but enable IEEE80211_KEY_FLAG_SW_MGMT:
> mesh1: ath5k (with IEEE80211_KEY_FLAG_SW_MGMT)
> mesh2: ath5k (with IEEE80211_KEY_FLAG_SW_MGMT)
> Result: Both of them are not able to ping each other. Also, the PREP
> action frame is not able to decrypted by another node.
> 
> So can we conclude that hardware encryption is not working for both
> robust unicast management frame and also unicast
> data frame? I am confuse why on case 4, it is not working?

I would guess that hardware *decryption* is faulty, maybe only one
action frame needs to be correct and so if one of them is nohwcrypt=1 it
still works?

johannes

