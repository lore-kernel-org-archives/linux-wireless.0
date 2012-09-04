Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:56864 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773Ab2IDLGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 07:06:03 -0400
Date: Tue, 4 Sep 2012 13:22:04 +0300
From: Jouni Malinen <j@w1.fi>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
Message-ID: <20120904102204.GA2541@w1.fi> (sfid-20120904_130615_423185_E5733558)
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
 <1346746298.3737.0.camel@jlt4.sipsolutions.net>
 <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 04, 2012 at 05:28:40PM +0800, Yeoh Chun-Yeow wrote:
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

Depends on what those nodes were.. If they were both using the same
ath5k implementation, then no, that would not be enough. If the CCMP
processing is done incorrectly, they could both mangle the results in
the same way to hide the issue. It should also be noted that there has
been key cache changes between hardware revisions, so working with
AR2414 or even AR5213 does not necessarily mean that this would work
with AR5210, AR5211, or AR5212.

You would need to test an ath5k-based device with another device that is
known to handle unicast robust management frame protection correctly. If
you do not have a suitable other device for this, it should be possible
to force one of the devices to use software encryption for everything
(i.e., make sure it does not configure any CCMP keys in the hardware key
cache) and then run a test that exchanges robust unicast management
frames (both TX and RX using the modified ath5k driver). I would also
verify that unicast data frames get processed in hardware and robust
management frames in software.

-- 
Jouni Malinen                                            PGP id EFC895FA
