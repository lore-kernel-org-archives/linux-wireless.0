Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49791 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab1FUQVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 12:21:39 -0400
Received: by iyb12 with SMTP id 12so2976892iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 09:21:39 -0700 (PDT)
Message-ID: <4E00C50F.6030708@lwfinger.net> (sfid-20110621_182143_577994_A20770C3)
Date: Tue, 21 Jun 2011 11:21:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Fred Plissonneau <cohomewp4@gmail.com>
CC: ali@internetdog.org, linux-wireless@vger.kernel.org
Subject: Re: Makefile deletes previous driver install when two WiFi interfaces
 are from the same chip vendor
References: <BANLkTimvMcb5yRHSE91VPTLdy7k5WEDo0Q@mail.gmail.com>	<20110621130752.GB8462@internetdog.org> <BANLkTi=EygUbm5VB+H-mm+ofpbuaK8xafA@mail.gmail.com>
In-Reply-To: <BANLkTi=EygUbm5VB+H-mm+ofpbuaK8xafA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2011 10:02 AM, Fred Plissonneau wrote:
>
> No, no it is not after the power-cycle. I just mention here that after
> power-on, my first installed
> driver as disappeared and I suspect the Makefile to contain "rm"
> command which does too much cleaning
> in my particular case.
>
> I am following the README information here (or may I've made a
> mistake, let me know).
> ./scripts/driver-select ath9k
> make
> sudo make install (I'm running UBUNTU)
> sudo modprode ath9k
>
> ./scripts/driver-select carl9170
> make
> sudo make install
> sudo modprode carl9170
>
> If I don't switch off, everything works fine (just because both
> modules are loaded into the memory).
>
>
> -->>  Last minute (4:30PM today !-) :
> I've found the lines causing the problem. There located just after the
> "uninstall:" tag which is also built during "make install".
> If I delete lines #318 to #326 in the Makefile (right after the "make"
> command and before "make install") it works fine now.
> That is to say, the ath9k.ko file is not deleted anymore during the
> installation of the second driver.
> This workaround is working fine. I am not sure my specific problem is
> relevant in the normal use case .

Your problem is that you are using the driver-select script wrong. It has 
nothing to do with your interfaces having the same chip vendor. In addition, 
your "workaround" is likely to cause many problems with dead modules not being 
removed.

You need to select ALL the modules you will ever need before you do the make 
step. By deleting ath9k from the configuration when you select carl9170 and 
vice-versa, you tell the system that you no longer want the other one. Strangely 
enough, but that is exactly what it does.

You need to use

./scripts/driver-select ath

That will build ath5k, which you do not need; however, the other two will be 
available. In you want, you could always edit config.mk and remove the line with 
"CONFIG_ATH5K=m".

Larry
