Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46122 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2IKRss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 13:48:48 -0400
Received: by obbuo13 with SMTP id uo13so1192039obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 10:48:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201209111931.24258.chunkeey@googlemail.com>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<CAEFj986+K6TGpR2MXteAY86vAX8D=xVrFWMAVdc9zSuiix+Ogw@mail.gmail.com>
	<CAFtRNNwXgr=oN8y9u9MnEt75dAL0R-tJ6yf6vTOMcnCuCb7S-A@mail.gmail.com>
	<201209111931.24258.chunkeey@googlemail.com>
Date: Tue, 11 Sep 2012 20:48:47 +0300
Message-ID: <CAFtRNNybLaHK3OWE3qbexCK18-Uc6XZ=H3Q9XqfyZzRwknetbA@mail.gmail.com> (sfid-20120911_194853_061682_A57FD2F0)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Nick Kossifidis <mickflemm@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Kalle Valo <kvalo@adurom.com>,
	Adrian Chadd <adrian@freebsd.org>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/11 Christian Lamparter <chunkeey@googlemail.com>:
> On Tuesday 11 September 2012 18:36:27 Nick Kossifidis wrote:
>> 2012/9/11 Yeoh Chun-Yeow <yeohchunyeow@gmail.com>:
>> >> To be more clear: you can tell the hw to *only* disable decryption and
>> >> keep doing encryption.
>> >
>> > But the question here is that during Rx, need to do SW decryption for
>> > management frame and then HW decryption for unicast data frame for all
>> > the frame coming from the same STA. I still not so sure how to do
>> > that.
>> >
>> > Jouni said that the workaround is to re-encrypt(incorrectly) received
>> > robust unicast management frames if hwaccel for CCMP was configured
>> > for the transmitting STA (this is to undo the incorrect decryption
>> > done by the hardware) and then pass the encrypted frame to mac80211
>> > for software decryption.
>> >
>>
>> How about disabling acks on hw completely and handle them on sw ?
>> This might keep the engine running ok for unicast frames.
>>
>> #define AR5K_DIAG_SW_DIS_ACK          0x00000002      /* Disable ACKs */
>> #define AR5K_DIAG_SW_DIS_CTS          0x00000004      /* Disable CTSs */
>
> No, CTS and ACKs are control frames and not management frames.

ACK :-)




-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
