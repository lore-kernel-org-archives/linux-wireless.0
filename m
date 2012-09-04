Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50774 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2IDQzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 12:55:25 -0400
Received: by bkwj10 with SMTP id j10so2757518bkw.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2012 09:55:23 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Yeoh Chun-Yeow" <yeohchunyeow@gmail.com>
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
Date: Tue, 4 Sep 2012 18:55:12 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com> <1346758521.3737.28.camel@jlt4.sipsolutions.net> <CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
In-Reply-To: <CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201209041855.13593.chunkeey@googlemail.com> (sfid-20120904_185528_321978_670C97F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 September 2012 18:41:16 Yeoh Chun-Yeow wrote:
> Hi, Johannes
> 
> > I would guess that hardware *decryption* is faulty, maybe only one
> > action frame needs to be correct and so if one of them is nohwcrypt=1 it
> > still works?
> Yes, you are correct. Case 3 is working only accidentally not always
> if the mesh node loaded with nohwcrypt=1 is reboot. So, with following
> case is also not working.
> 
> mesh1: ath5k loaded without nohwcrypt=1 (with
> IEEE80211_KEY_FLAG_SW_MGMT enabled)
> mesh2: ath5k loaded without nohwcrypt=1 (with
> IEEE80211_KEY_FLAG_SW_MGMT enabled)
> 
> Can we conclude that unicast data frames get processed in hardware and
> robust unicast management frames get processed in software for CCMP
> are not working.
> 
> By the way, current secured mesh requires the AES CMAC to be enabled.
> But without enabling IEEE80211_HW_MFP_CAPABLE, the key cannot be added
> since this cipher suite is considered not supported. But actually AES
> CMAC can be done in software. Any work around on this?
> 
I think you can override this by supplying your own custom set
of available ciphers. This is done by setting
	hw.wiphy->cipher_suites 
	hw.wiphy->n_cipher_suites
during the initalization of the driver (i.e.: before
ieee80211_register_hw(hw) is called).

Regards,
	Chr
