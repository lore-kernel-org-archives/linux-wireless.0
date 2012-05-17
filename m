Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51299 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2EQIgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 04:36:47 -0400
Received: by yhmm54 with SMTP id m54so1598500yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 01:36:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEZZmbEExFr6=7G6kQb_bbpt=wfiNDuoR+U4_Eu_wLdair=SrA@mail.gmail.com>
References: <1336479518-23006-1-git-send-email-yoni.divinsky@ti.com>
	<1336485961.4320.1.camel@jlt3.sipsolutions.net>
	<CANJm+iAoVkPOO61ufrM3mxzsURFZzuNcMm9N6Y=3xUbSCaC1+w@mail.gmail.com>
	<1337072920.4546.0.camel@jlt3.sipsolutions.net>
	<CANJm+iDif1+KREB=CJ_wYbo+Hzxo=nJL6fUxbBTQ5_C8Tz0E9Q@mail.gmail.com>
	<CANJm+iDU1ahy3B9u6nn=0E4d0Pge+OubaNE9bPaE1EXYGahOUA@mail.gmail.com>
	<CAEZZmbEExFr6=7G6kQb_bbpt=wfiNDuoR+U4_Eu_wLdair=SrA@mail.gmail.com>
Date: Thu, 17 May 2012 14:06:46 +0530
Message-ID: <CAEZZmbF6wa3JF48KsCiyg4T7OsBS73OnzAMVYPkPdPro9EYUtg@mail.gmail.com> (sfid-20120517_103653_559210_BF230AEA)
Subject: Re: [PATCH] mac80211: add op to configure default key id to driver
From: Ravi Sharma <sharmaravi.lx@gmail.com>
To: "Divinsky, Yonatan" <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All
I know this use case is quite trivial looking regarding WEP (Since it
is going to be deprecated), we faced a issue with minap (softap) in
WEP security with auth mode as shared. Since the default key is not
passed to driver, we can not program firmware default key idx (default
key is programmed when data packet exchange started, looking into type
of encryption) and the handshake failed in shared auth mode. In open
mode, there is no need for this.

Personally, i dont like WEP in miniAP mode but sometime we dont have the choice!

Rsh.

>
>
>
> On Thu, May 17, 2012 at 1:55 PM, Divinsky, Yonatan <yoni.divinsky@ti.com> wrote:
>>
>> ---------- Forwarded message ----------
>> From: Divinsky, Yonatan <yoni.divinsky@ti.com>
>> Date: Tue, May 15, 2012 at 1:59 PM
>> Subject: Re: [PATCH] mac80211: add op to configure default key id to driver
>> To: Johannes Berg <johannes@sipsolutions.net>
>>
>>
>> On Tue, May 15, 2012 at 12:08 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2012-05-15 at 11:46 +0300, Divinsky, Yonatan wrote:
>> >> On Tue, May 8, 2012 at 5:06 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> >> > On Tue, 2012-05-08 at 15:18 +0300, Yoni Divinsky wrote:
>> >> >> When hw_accel is enabled and encryption type is set to WEP,
>> >> >> the driver should get the default key index from mac80211.
>> >> >
>> >> > Well, why?
>> >> >
>> >> If the WEP encryption is done by the HW, then then low level driver
>> >> needs to know the defualt key index in
>> >> case there is more than one WEP key configured.
>> >
>> > I don't see why, for every packet mac80211 tells you what key to use.
>>
>> If the HW supports auto ARP responses, then it will need to have the correct
>> key id in order to encrypt the ARP response.
>>
>> >
>> > johannes
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
