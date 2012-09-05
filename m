Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41554 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2IEHbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 03:31:09 -0400
Received: by ieje11 with SMTP id e11so486401iej.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 00:31:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120905071653.GB3629@w1.fi>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<1346746298.3737.0.camel@jlt4.sipsolutions.net>
	<CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	<20120904102204.GA2541@w1.fi>
	<CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
	<CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
	<1346758521.3737.28.camel@jlt4.sipsolutions.net>
	<CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
	<20120905071653.GB3629@w1.fi>
Date: Wed, 5 Sep 2012 15:31:08 +0800
Message-ID: <CAEFj985iHQJTAqXBkz56BDPodHb9q0Z=x3S5Q43UwA5vU-mfMw@mail.gmail.com> (sfid-20120905_093138_823012_9E9B3A67)
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

> Could you please describe what exactly you mean with "current secured
> mesh requires the AES CMAC to be enabled" and what is that claim based
> on?
I am based on the authsae source code for secured mesh setup which can
be found at:
https://github.com/cozybit/authsae/blob/master/linux/meshd-nl80211.c

There are total 5 keys for secured mesh:

/* key to protect integrity of multicast mgmt frames tx*/
install_key(nlcfg, NULL, CIPHER_AES_CMAC, NL80211_KEYTYPE_GROUP, 4, mgtk_tx);
/* key to encrypt multicast data traffic */
install_key(nlcfg, NULL, CIPHER_CCMP, NL80211_KEYTYPE_GROUP, 0, mgtk_tx);
/* key to encrypt/decrypt unicast data AND mgmt traffic to/from this peer */
install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_PAIRWISE, 0, mtk);
/* key to decrypt multicast data traffic from this peer */
install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_GROUP, 0, peer_mgtk);
/* to check integrity of multicast mgmt frames from this peer */
install_key(&nlcfg, peer, CIPHER_AES_CMAC, NL80211_KEYTYPE_GROUP, 4, peer_mgtk);

> Any pointers to the specific standard clause(s) that say that?
I have not gone through the standard on this.

-----
Chun-Yeow
