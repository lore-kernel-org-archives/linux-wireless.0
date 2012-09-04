Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2IDQ4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 12:56:54 -0400
Message-ID: <1346777845.3737.39.camel@jlt4.sipsolutions.net> (sfid-20120904_185658_046116_3A10D736)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Date: Tue, 04 Sep 2012 18:57:25 +0200
In-Reply-To: <201209041855.13593.chunkeey@googlemail.com> (sfid-20120904_185524_891747_0BF21249)
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	 <1346758521.3737.28.camel@jlt4.sipsolutions.net>
	 <CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
	 <201209041855.13593.chunkeey@googlemail.com>
	 (sfid-20120904_185524_891747_0BF21249)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 18:55 +0200, Christian Lamparter wrote:

> > By the way, current secured mesh requires the AES CMAC to be enabled.
> > But without enabling IEEE80211_HW_MFP_CAPABLE, the key cannot be added
> > since this cipher suite is considered not supported. But actually AES
> > CMAC can be done in software. Any work around on this?
> > 
> I think you can override this by supplying your own custom set
> of available ciphers. This is done by setting
> 	hw.wiphy->cipher_suites 
> 	hw.wiphy->n_cipher_suites
> during the initalization of the driver (i.e.: before
> ieee80211_register_hw(hw) is called).

Yes, that's the way you could do it, but my argument that it's pointless
still stands, so what good would it do?

johannes

