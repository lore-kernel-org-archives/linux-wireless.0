Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40687 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2IDLVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 07:21:24 -0400
Received: by obbuo13 with SMTP id uo13so10685809obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2012 04:21:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120904102204.GA2541@w1.fi>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<1346746298.3737.0.camel@jlt4.sipsolutions.net>
	<CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	<20120904102204.GA2541@w1.fi>
Date: Tue, 4 Sep 2012 19:21:23 +0800
Message-ID: <CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com> (sfid-20120904_132128_447075_8D88D8F5)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Jouni

> Depends on what those nodes were.. If they were both using the same
> ath5k implementation, then no, that would not be enough.
Both of nodes are using ath5k.

> so working with AR2414 or even AR5213 does not necessarily mean that this would work
> with AR5210, AR5211, or AR5212.
Noted.

> I would also verify that unicast data frames get processed in hardware and robust
> management frames in software.
I have retested with the following:

mesh1: ath5k nohwcrypt=1
mesh2: ath5k (no IEEE80211_KEY_FLAG_SW_MGMT)
Result: Both of them are not able to ping each other. Also, the PREP
action frame is not able to decrypted by another node.

mesh1: ath5k nohwcrypt=1
mesh2: ath5k nohwcrypt=1
Result: They are able to ping each other.

mesh1: ath5k nohwcrypt=1
mesh2: ath5k (with IEEE80211_KEY_FLAG_SW_MGMT)
Result: They are able to ping each other

mesh1:
mesh2I also try to enable back the IEEE80211_KEY_FLAG_SW_MGMT flags.
Also it does not work. So can we conclude that hardware encryption is
not working for both robust unicast management frame and also unicast
data frame?

Please advice. Thanks

----
Chun-Yeow
