Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42156 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759707Ab2IGDvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 23:51:02 -0400
Received: by obbuo13 with SMTP id uo13so3943851obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2012 20:51:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120905080336.GA4747@w1.fi>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<1346746298.3737.0.camel@jlt4.sipsolutions.net>
	<CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	<20120904102204.GA2541@w1.fi>
	<CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
	<CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
	<1346758521.3737.28.camel@jlt4.sipsolutions.net>
	<CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
	<20120905071653.GB3629@w1.fi>
	<CAEFj985iHQJTAqXBkz56BDPodHb9q0Z=x3S5Q43UwA5vU-mfMw@mail.gmail.com>
	<20120905080336.GA4747@w1.fi>
Date: Fri, 7 Sep 2012 11:51:02 +0800
Message-ID: <CAEFj986i9XUcEN0i2y5=YLh2RX8MZOf+60i8XL4jMiq5-JcJ6Q@mail.gmail.com> (sfid-20120907_055109_177439_E9A0A975)
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

> So yes, if you want to enable support for MFP, you cannot do it unless
> the driver is able to handle both CCMP and BIP protection for robust
> management frames. In case of ath5k, I would assume there are two
> options:
> - only enable MFP if software encryption is used for all frames (i.e.,
>   no hwaccel even for data frames)
> - implement workaround to re-encrypt(incorrectly) received robust
>   unicast management frames if hwaccel for CCMP was configured for the
>   transmitting STA (this is to undo the incorrect decryption done by the
>   hardware) and then pass the encrypted frame to mac80211 for software
>   decryption; with this option, you could advertise MFP support even
>   with CCMP hwaccel enabled

No luck and still cannot work out how to re-encrypt the received
robust unicast management frames if hwaccel for CCMP was configured.
Need to stick with first option then.

---
Chun-Yeow
