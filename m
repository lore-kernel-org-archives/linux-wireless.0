Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:58171 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbYKKQkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 11:40:11 -0500
Received: by an-out-0708.google.com with SMTP id d40so660926and.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 08:40:09 -0800 (PST)
Message-ID: <40f31dec0811110840q65b8152ekc28c880f11197595@mail.gmail.com> (sfid-20081111_174022_221739_40E70A43)
Date: Tue, 11 Nov 2008 18:40:09 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [RFC 2/2] mac80211: implement dynamic power save
Cc: "Vivek Natarajan" <vivek.natraj@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87fxlybea4.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	 <1226245439-30329-3-git-send-email-kalle.valo@nokia.com>
	 <20081110201444.GI6918@tesla> <87zlk6vink.fsf@nokia.com>
	 <8e92b4100811110218q2b45f70amdba39159ef9799bd@mail.gmail.com>
	 <87fxlybea4.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/11 Kalle Valo <kalle.valo@nokia.com>:
> Vivek Natarajan <vivek.natraj@gmail.com> writes:
>
>> Currently there is no support for powersave in ath9k( Not sure about
>> ath5k though). There is a code level implementation for the following
>> although we do not enable them:
>>  Support for network sleep mode:
>>      If a request for network sleep comes from higher layers, the
>> sleep duration having been configured based on beacon interval and the
>> TIM offset in the beacon based on AID is all configured, then the
>> chip will happily go to sleep and wake up for the beacon to read TIM.
>
>> But the code for calulating TIM offset, reading TIM, to decide the power
>> level based on TIM, extending awake time based on DTIM needs to be
>> done.
>
> Thanks, this was useful. Is the interface for these power save
> commands available somewhere? I would like to take a look so that I
> understand what kind of paremeters the driver can set.
>

Check out these 2 functions...
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath5k/base.c;h=8c9961525cc44bee2ff4be4619264faa3f02962d;hb=HEAD#l2035
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath5k/pcu.c;h=d7f0c1017bda55a86a18acbb1384ebee34377eb5;hb=HEAD#l674

We set some intervals during beacon_update_timers and init_beacon is
called to pass them on hw, init_beacon can (should) also set enhanced
sleep registers on AR5212, for more infos you can check legacy-hal or
read reg.h
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath5k/reg.h;h=69755fc2f9bee78ab78489bec6cd1ceb782ef914;hb=HEAD#l1602


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
