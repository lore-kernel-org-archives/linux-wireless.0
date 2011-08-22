Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2956 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1HVM5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 08:57:39 -0400
Message-ID: <4E525235.7060501@broadcom.com> (sfid-20110822_145743_039392_51AA4846)
Date: Mon, 22 Aug 2011 14:57:25 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
References: <20110814121646.GA5188@stt008.linux.site>
 <4E4A5641.4020604@broadcom.com>
 <1313509211.2065.36.camel@dcbw.foobar.com>
 <4E4B9A45.5090507@broadcom.com> <4E4CC85A.7010504@broadcom.com>
 <4E4E73F4.4040105@broadcom.com>
 <20110819152140.GA7506@stt008.linux.site>
 <CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com>
 <4E52297D.9090301@broadcom.com>
 <20110822112737.GA5936@stt008.linux.site>
In-Reply-To: <20110822112737.GA5936@stt008.linux.site>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Camaleón,

thanks for the additional information you provided.

> One difference, though, is that now (with kernel 3.0.0) when I shutdown
> the system it hangs at NetworkManager if wifi LED is on. As soon as I
> turn off the wifi led, the system can continue the shutdown.

 > Moreover, "service network-manager stop" returns "failed" unless I
 > first turn off the wifi led (and so phy0 hard blocked is set as "yes").

Interesting observations. Ok, lets keep this in the back of our minds 
but first focus on the bad scan results.

 >> Can you do a 'rfkill unblock all' to see if that makes a difference ?
 >> It makes no difference. No wifi networks are detected automatically 
nor connecting manually to a hidden network is possible (unless I sit 
next to the AP).

Hmmm, so it seems that rfkill switch functionality is not causing the 
bad scan result.

Can you try to disable Bluetooth (e.g. by temporary blacklisting the 
bluetooth modules) ? Bluetooth operates in the same frequency band as WiFi.

Would you happen to know if with kernel 2.6.39, the brcmsmac driver was 
active as well (and not a different driver) ?

 > Just in case this helps, I have tried another wifi adapater (USB, based
 > on rt2xx chipset) and works like a charm, I mean, it detects the
 > avialbale wifi networks and automatically stablishes a connection with
 > mine.

Lets shoot for that as well :-)

Thanks, Roland.

