Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48453 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab2IKRbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 13:31:34 -0400
Received: by eekc1 with SMTP id c1so632561eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 10:31:33 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
Date: Tue, 11 Sep 2012 19:31:23 +0200
Cc: "Yeoh Chun-Yeow" <yeohchunyeow@gmail.com>,
	Kalle Valo <kvalo@adurom.com>,
	Adrian Chadd <adrian@freebsd.org>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@venema.h4ckr.net
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com> <CAEFj986+K6TGpR2MXteAY86vAX8D=xVrFWMAVdc9zSuiix+Ogw@mail.gmail.com> <CAFtRNNwXgr=oN8y9u9MnEt75dAL0R-tJ6yf6vTOMcnCuCb7S-A@mail.gmail.com>
In-Reply-To: <CAFtRNNwXgr=oN8y9u9MnEt75dAL0R-tJ6yf6vTOMcnCuCb7S-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209111931.24258.chunkeey@googlemail.com> (sfid-20120911_193138_391351_650D97C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 September 2012 18:36:27 Nick Kossifidis wrote:
> 2012/9/11 Yeoh Chun-Yeow <yeohchunyeow@gmail.com>:
> >> To be more clear: you can tell the hw to *only* disable decryption and
> >> keep doing encryption.
> >
> > But the question here is that during Rx, need to do SW decryption for
> > management frame and then HW decryption for unicast data frame for all
> > the frame coming from the same STA. I still not so sure how to do
> > that.
> >
> > Jouni said that the workaround is to re-encrypt(incorrectly) received
> > robust unicast management frames if hwaccel for CCMP was configured
> > for the transmitting STA (this is to undo the incorrect decryption
> > done by the hardware) and then pass the encrypted frame to mac80211
> > for software decryption.
> >
> 
> How about disabling acks on hw completely and handle them on sw ?
> This might keep the engine running ok for unicast frames.
> 
> #define AR5K_DIAG_SW_DIS_ACK		0x00000002	/* Disable ACKs */
> #define AR5K_DIAG_SW_DIS_CTS		0x00000004	/* Disable CTSs */

No, CTS and ACKs are control frames and not management frames.
