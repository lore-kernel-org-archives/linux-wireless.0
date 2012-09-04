Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2IDJbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 05:31:05 -0400
Message-ID: <1346751102.3737.25.camel@jlt4.sipsolutions.net> (sfid-20120904_113110_107705_CA7FEDE0)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org
Date: Tue, 04 Sep 2012 11:31:42 +0200
In-Reply-To: <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com> (sfid-20120904_112842_613203_3FC30AEF)
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	 <1346746298.3737.0.camel@jlt4.sipsolutions.net>
	 <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	 (sfid-20120904_112842_613203_3FC30AEF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 17:28 +0800, Yeoh Chun-Yeow wrote:
> Hi, Johannes
> 
> > _How_ did you test this? Did you test that management frames are
> > properly encrypted using AES CCM, and not mangled when decrypted?
> 
> I have setup the two mesh nodes using the secured mesh with the
> following key installation:
> 
> /* key to encrypt/decrypt unicast data AND mgmt traffic to/from this peer */
> install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_PAIRWISE, 0, mtk);
> 
> I confirm that the hardware key for CCMP is set and
> IEEE80211_KEY_FLAG_SW_MGMT is not enabled in mac80211-ops.c. Both
> nodes are able to ping each others. Is this enough?

I don't know? Did this encrypt any management frames with AES-CCM and
rely on them being exchanged properly?

johannes

