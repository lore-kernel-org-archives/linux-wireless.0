Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2IEGwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 02:52:09 -0400
Received: by iahk25 with SMTP id k25so305537iah.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2012 23:52:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346777666.3737.38.camel@jlt4.sipsolutions.net>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<1346746298.3737.0.camel@jlt4.sipsolutions.net>
	<CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	<20120904102204.GA2541@w1.fi>
	<CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
	<CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
	<1346758521.3737.28.camel@jlt4.sipsolutions.net>
	<CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
	<1346777666.3737.38.camel@jlt4.sipsolutions.net>
Date: Wed, 5 Sep 2012 14:52:08 +0800
Message-ID: <CAEFj9866ZAaZ1T-RSVj7Rp8-7giBF9xgtsvnwa_+Wi+ShTfVeA@mail.gmail.com> (sfid-20120905_085215_043128_2134E4E6)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

> Well, that's a separate question. Of course we could enable it, but what
> would the point be? You don't have CCM for management frames right now,
> so CMAC is pretty useless? And if you had CCM for management frames, say
> with the things discussed in the p54 thread, then you could just enable
> both, right?

We will load the ath5k with nohwcrypt=, so no hardware encryption at
all. But to proceed with key installation using AES CMAC to be
processed in software, we need somethings related to:
http://www.spinics.net/lists/linux-wireless/msg96187.html

Otherwise, we may need to bypass the cfg80211_supported_cipher_suite checking:
http://www.spinics.net/lists/linux-wireless/msg95951.html

Is this relevant?

---
Chun-Yeow
