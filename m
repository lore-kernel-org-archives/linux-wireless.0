Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:39539 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1BLOXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 09:23:40 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000020773.msg
	for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 16:22:56 +0200
Subject: Re: SSB AI support code
From: George Kashperko <george@znau.edu.ua>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4D56851D.7000509@hauke-m.de>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <4D56851D.7000509@hauke-m.de>
Content-Type: text/plain
Date: Sat, 12 Feb 2011 16:15:45 +0200
Message-Id: <1297520145.10761.43.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

> Hi,
> 
> After rethinking this I came to the same result as Michael that it would
> bet better to have a extra module for the AI bus separated from the ssb.
> I grepped for ssb_ in the b43 driver code and it should be doable to
> change the api of ssb so that adding an other bus can be done without
> any changes to ssb. After the SSB API was changed once.
Good way, already thinking of it but still need more planning for it. 

> Most of the ssb_* methods calls in the b43 driver are getting an
> ssb_device struct so just a common struct for ssb and the ai bus is
> needed and it must contain some function pointers to the needed functions.
Well its almost the way I'm currently going. Unfortunately I was too
blinded with mips-only part of the bus implementation. Thanks to
Michael's feedback and to Larry trying to build it for x86_64 (ohh I
feel so much sorry for that, made you wasting your time while resulting
code will not be working for anything else rather than embeddables was
stupid from me. Again apologises for that - I was not seeing the whole
picture unfortunately).

> Then the drivers integrated in the drivers/ssb must be extracted and
> unbundled from the ssb code. One common header file with some common
> structs for ssb and AI is needed and the rest can be separated.
This one makes me think that SB and AI are much more SSB rather than SSB
SB and lets say BCM AI. There were too much messup in the code I've
posted, realised that too late. That messup and lack of SB-side
knowledge was preventing me from seeing where I'm wrong. I understand
now how scary it could have been looking for people who are familiar
with SB. Thanks to your feedback and few days of rest think I see the
clean way how let two buses coexists on single code base without
intrusing drivers too much and without messing bus abstration.

> If you need help with something, I would like to help you with these
> things. I just ordered an Netgear WNR3500L. ;-)
Heh, congrats with that one ;)
I own 5 N16'ths currently, imagine how was I happy when realised that
Openwrt can't be set up on those ;)

Have nice day,
George


