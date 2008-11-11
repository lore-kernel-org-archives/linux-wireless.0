Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:30835 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbYKKKS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 05:18:27 -0500
Received: by mu-out-0910.google.com with SMTP id g7so3319679muf.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 02:18:25 -0800 (PST)
Message-ID: <8e92b4100811110218q2b45f70amdba39159ef9799bd@mail.gmail.com> (sfid-20081111_111831_891321_FF738977)
Date: Tue, 11 Nov 2008 15:48:24 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [RFC 2/2] mac80211: implement dynamic power save
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87zlk6vink.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	 <1226245439-30329-3-git-send-email-kalle.valo@nokia.com>
	 <20081110201444.GI6918@tesla> <87zlk6vink.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 11, 2008 at 12:44 PM, Kalle Valo <kalle.valo@nokia.com> wrote:

> While talking about power save, can you give me any hints how power
> save in client mode works in ath5k/ath9k? I haven't looked at the
> drivers yet, but any hints (even how small) always help and save time.
> I'm trying to understand how power save is implemented in different
> hardware so that I can take that into account in my patches.

Currently there is no support for powersave in ath9k( Not sure about
ath5k though). There is a code level implementation for the following
although we do not enable them:
 Support for network sleep mode:
     If a request for network sleep comes from higher layers, the
sleep duration having been configured based on beacon interval and the
TIM offset in the beacon based on AID is all configured, then the
chip will happily go to sleep and wake up for the beacon to read TIM.

But the code for calulating TIM offset, reading TIM, to decide the power
level based on TIM, extending awake time based on DTIM needs to be
done. Since these are common to all drivers, these may get into
mac80211( Not sure if it is already implemented). Please correct me if
I am wrong here.

I believe all these are done in the firmware for Intel since Tomas mentioned
sometime back that all the power save features works in iwlwifi.

>  Actually there are three types of power save now:
> AP mode buffering for clients in power save, the normal ("static")
> power save for client mode and the dynamic version. So this will get
> very confusing.
I have come across  this dynamic power save(Switch off radio when there
is no RX/Tx for sometime) and also buffering in AP mode. I would be happy to
know about the static power save.

Regards,
Vivek.
