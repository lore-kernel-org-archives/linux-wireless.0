Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59592 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2IDJ2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 05:28:41 -0400
Received: by obbuo13 with SMTP id uo13so10548346obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2012 02:28:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346746298.3737.0.camel@jlt4.sipsolutions.net>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<1346746298.3737.0.camel@jlt4.sipsolutions.net>
Date: Tue, 4 Sep 2012 17:28:40 +0800
Message-ID: <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com> (sfid-20120904_112844_463000_C4D9D4FC)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

> _How_ did you test this? Did you test that management frames are
> properly encrypted using AES CCM, and not mangled when decrypted?

I have setup the two mesh nodes using the secured mesh with the
following key installation:

/* key to encrypt/decrypt unicast data AND mgmt traffic to/from this peer */
install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_PAIRWISE, 0, mtk);

I confirm that the hardware key for CCMP is set and
IEEE80211_KEY_FLAG_SW_MGMT is not enabled in mac80211-ops.c. Both
nodes are able to ping each others. Is this enough?

Please advice. Thanks

---
Chun-Yeow
