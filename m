Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44442 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab2EAVU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 17:20:56 -0400
Received: by lbbgm6 with SMTP id gm6so1137615lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 14:20:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA0507E.6010407@lwfinger.net>
References: <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com>
 <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com>
 <4F9DD22F.8010305@lwfinger.net> <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com>
 <4F9DE46E.6030103@lwfinger.net> <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com>
 <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com>
 <4F9DFF0A.7080604@lwfinger.net> <20120430120037.GG9863@alittletooquiet.net>
 <CAKVccoU_eWtStR=XJEBuUSQJOTMfXuHuHNxs+xbEwd+mdFiG0Q@mail.gmail.com>
 <4F9F55F9.3090800@lwfinger.net> <CAKVccoV+fNYVZUjkNSPzp=T8TC6L_zqUdocp=oYBP0=r-M9HRA@mail.gmail.com>
 <4F9F6B67.5000400@lwfinger.net> <CAKVccoVA=Rk8AkD+h0n9aeV95h0iMcnQgM_WMJq3rjzoFvkU-w@mail.gmail.com>
 <CAKVccoX=u=qX_OJ8RMSxpNEMGYdGVzimZURJ+ZeNZjhW1jPt6Q@mail.gmail.com>
 <4F9FF3D3.1020006@lwfinger.net> <CAKVccoWJPdPZqoLn6L+_PUKdiM0sLZhCBQCAa2aM7i1xgR21DA@mail.gmail.com>
 <4FA0507E.6010407@lwfinger.net>
From: Simple W <simplew8@gmail.com>
Date: Tue, 1 May 2012 22:20:34 +0100
Message-ID: <CAKVccoUD2dtfxTmrKd+yK6OYmYX_EBE1ie5ZwCPxH_t47B3d6A@mail.gmail.com> (sfid-20120501_232058_951614_DB2599B2)
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Forest Bond <forest@alittletooquiet.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/5/1 Larry Finger <Larry.Finger@lwfinger.net>:
> On 05/01/2012 03:42 PM, simple w8 wrote:
>>
>> 2012/5/1 Larry Finger<Larry.Finger@lwfinger.net>:
>>>
>>> On 05/01/2012 08:36 AM, simple w8 wrote:
>>>>
>>>>
>>>>
>>>> SEams that was your last fix for rtl8192
>>>>
>>>>
>>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=eb641120479de7ee703fabb5e6ee0ec7947474ba
>>>>   that reduced the wifi force, thus detecting less wifi networks.
>>>>
>>>> Running without that "fix" the notebook detects more wifi networks,
>>>> seams like the antenna have more force.
>>>
>>>
>>>
>>> You keep talking about "antenna force". What does that mean?
>>>
>>> That patch keeps your device from running forever at a maximum of 1 Mbps
>>> by
>>> adjusting the initial gain of the RX amplifier. You may reverse it if you
>>> want so that you can detect more APs when you scan; however, most people
>>> prefer to get better performance from the device. That patch will not be
>>> reversed.
>>
>>
>> Could you please clarify a litle more about the why and the patch fix?
>
>
> Before that patch, when the device scanned after the connection was up and
> running, it set the gain very low. When that happened, the receiver failed
> to see any info coming from the AP. The AP would retry several times, and
> then cut its transmit rate to 1 Mbps. That rate would stay until rtl8192xe
> was unloaded and reloaded. To me, that is a lot bigger problem that what you
> are seeing, which is why I will not change it back!
>
> Larry
>

That in fact used to happen severall times, if the wifi network was
not near enough it would be hard to connect to it, and if this patch
fixes its good knews in a way, but its not very good to loose the
ability to check wifi networks, but if you didnt find a better
intermediate point between loosing the wifi force and have better
connection its not me whos going to say otherwise, your the expert
here :)

But what happens now is that in NetworkManager i can see 3 wifi
networks, but if i run kismet or airodump-ng, it
can detect wifi networks that do not appear listed in NM.
