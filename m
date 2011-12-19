Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56870 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1LSNnT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 08:43:19 -0500
Received: by obcwo16 with SMTP id wo16so1730747obc.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 05:43:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111219125052.3B5A42005C@mail.watchdata.com.cn>
References: <jcnavc$psk$1@dough.gmane.org>
	<20111219125052.3B5A42005C@mail.watchdata.com.cn>
Date: Mon, 19 Dec 2011 08:43:17 -0500
Message-ID: <CADGLRPmkbTp-azGJ2=CJum=Y8Mrf7fTbaE9Oi8Om+DQyu7d9uA@mail.gmail.com> (sfid-20111219_144323_073673_CFC436C3)
Subject: Re: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
From: Daniel Smith <viscous.liquid@gmail.com>
To: =?GB2312?B?wO641Q==?= <gang.li@watchdata.com>
Cc: linux-wireless@vger.kernel.org,
	Ath9k Devel List <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/19 ภ๎ธี <gang.li@watchdata.com>:
>
> Hi, Daniel, Thanks you !
>
> Sorry,  I didn't make it clear!  My 9280 is an USB card, so the related code
> is htc_drv_*.c.

No worries, I just was not aware of any USB devices with the 9280 in
it and the ath9k_htc "supported chips" are the 9271 and 7010.


> I have seen these codes in tx.c,  and at first I thought it should work, but
> does not.

So will assume you dealt with this then.

I have not done a lot of delving into the ath9k_htc code myself and I
am not familiar with interfacing with the chips via USB. Normally with
a 9280 where the tx ctrl descriptors are DMA'ed in I just need to make
sure that bit 24 of the third tx ctrl descriptor is set to 1. I did a
cursory look at how a frame is handed from kernel down to hardware and
the hardware control is done through flags set on a struct
tx_frame_hdr. I looked at the flags defined for ath9k_htc and I see no
sign of a flag to control ACK's. So I think this has to be punted to
one of the Atheros guys or someone with the spec sheets that can say
if there is a bit in the flags field to turn off ACK.

Sorry I couldn't be much more help.

Daniel
