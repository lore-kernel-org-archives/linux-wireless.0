Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab2IDQlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 12:41:18 -0400
Received: by iahk25 with SMTP id k25so5684065iah.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2012 09:41:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346758521.3737.28.camel@jlt4.sipsolutions.net>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<1346746298.3737.0.camel@jlt4.sipsolutions.net>
	<CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	<20120904102204.GA2541@w1.fi>
	<CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
	<CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
	<1346758521.3737.28.camel@jlt4.sipsolutions.net>
Date: Wed, 5 Sep 2012 00:41:16 +0800
Message-ID: <CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com> (sfid-20120904_184124_349619_A80CF711)
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

> I would guess that hardware *decryption* is faulty, maybe only one
> action frame needs to be correct and so if one of them is nohwcrypt=1 it
> still works?
Yes, you are correct. Case 3 is working only accidentally not always
if the mesh node loaded with nohwcrypt=1 is reboot. So, with following
case is also not working.

mesh1: ath5k loaded without nohwcrypt=1 (with
IEEE80211_KEY_FLAG_SW_MGMT enabled)
mesh2: ath5k loaded without nohwcrypt=1 (with
IEEE80211_KEY_FLAG_SW_MGMT enabled)

Can we conclude that unicast data frames get processed in hardware and
robust unicast management frames get processed in software for CCMP
are not working.

By the way, current secured mesh requires the AES CMAC to be enabled.
But without enabling IEEE80211_HW_MFP_CAPABLE, the key cannot be added
since this cipher suite is considered not supported. But actually AES
CMAC can be done in software. Any work around on this?

---
Chun-Yeow
