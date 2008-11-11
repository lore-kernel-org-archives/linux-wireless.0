Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64771 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbYKKNJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 08:09:19 -0500
To: "Vivek Natarajan" <vivek.natraj@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/2] mac80211: implement dynamic power save
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	<1226245439-30329-3-git-send-email-kalle.valo@nokia.com>
	<20081110201444.GI6918@tesla> <87zlk6vink.fsf@nokia.com>
	<8e92b4100811110218q2b45f70amdba39159ef9799bd@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 11 Nov 2008 15:09:07 +0200
In-Reply-To: <8e92b4100811110218q2b45f70amdba39159ef9799bd@mail.gmail.com> (ext Vivek Natarajan's message of "Tue\, 11 Nov 2008 15\:48\:24 +0530")
Message-ID: <87fxlybea4.fsf@nokia.com> (sfid-20081111_140924_671521_89FA591C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> Currently there is no support for powersave in ath9k( Not sure about
> ath5k though). There is a code level implementation for the following
> although we do not enable them:
>  Support for network sleep mode:
>      If a request for network sleep comes from higher layers, the
> sleep duration having been configured based on beacon interval and the
> TIM offset in the beacon based on AID is all configured, then the
> chip will happily go to sleep and wake up for the beacon to read TIM.

> But the code for calulating TIM offset, reading TIM, to decide the power
> level based on TIM, extending awake time based on DTIM needs to be
> done. 

Thanks, this was useful. Is the interface for these power save
commands available somewhere? I would like to take a look so that I
understand what kind of paremeters the driver can set.

> Since these are common to all drivers, these may get into mac80211(
> Not sure if it is already implemented). Please correct me if I am
> wrong here.

Yes, if both stlc45xx and ath5/9k need these it would make sense to
add support to mac80211.

> I believe all these are done in the firmware for Intel since Tomas mentioned
> sometime back that all the power save features works in iwlwifi.

Yes. I have seen other hardware as well which have the power save
support in firmware.

>>  Actually there are three types of power save now:
>> AP mode buffering for clients in power save, the normal ("static")
>> power save for client mode and the dynamic version. So this will get
>> very confusing.
>
> I have come across  this dynamic power save(Switch off radio when there
> is no RX/Tx for sometime) and also buffering in AP mode. I would be happy to
> know about the static power save.

The term "static power save" is just my own invention and it means
opposite of dynamic power save. For me static power save means that
the chip sleeps as much as possible, for example transmits a frame and
goes back to sleep immediately after receiving the ack.

Sorry for bad wording, all the power save terms should be standardised :)

-- 
Kalle Valo
