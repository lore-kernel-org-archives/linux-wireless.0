Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:48186 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZEBKec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 06:34:32 -0400
Received: by bwz7 with SMTP id 7so2684857bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 02 May 2009 03:34:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wfk54zu7t6.fsf@calligramme.charmers>
References: <557754.25367.qm@web51403.mail.re2.yahoo.com>
	 <efe7343f0904300656g127e83e1ge0b21060d6a69955@mail.gmail.com>
	 <wfk54zu7t6.fsf@calligramme.charmers>
Date: Sat, 2 May 2009 11:34:31 +0100
Message-ID: <efe7343f0905020334g3df47d87j31a351a878968312@mail.gmail.com>
Subject: Re: rt73usb Access point status
From: Luis Correia <luis.f.correia@gmail.com>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jon,

On Sat, May 2, 2009 at 11:18, Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk=
> wrote:
>
> Luis Correia
> <luis.f.correia@gmail.com>
> writes:
>
> Hi Luis; thanks for your replies... more below:
>
>> On Thu, Apr 30, 2009 at 14:41, Joerg Pommnitz <pommnitz@yahoo.com> w=
rote:
>>> Reading the mail from Ivo
>>> (http://sourceforge.net/mailarchive/message.php?msg_id=3D2008080820=
59.11968.IvDoorn%40gmail.com)
>
> I found that before I posted and found it discouraging,
> hence the question.
>
>>> I gather that the ACK in question is not from the peer but from the=
 local
>>> hardware indicating that the frame was actually sent and not lost d=
ue to
>>> some local error.
>>
>> According to Ivo, we cannot be totally sure that the device has sent
>> the frame into the air, so no actual ACK is reported back to mac8021=
1.
>>
>> The hostapd hack works, as long as the stations are not very far fro=
m
>> the AP, and thus not 'too many retries' need to be sent.
>
> So is the bug really in hostapd?

No, the bug is not in hostapd.

As Johannes says, the bug is in the driver.
Apparently, the driver is unable to get the ACK from the hardware and
thus unable to report that ACK back to hostapd.

So the hostapd hack works, as long as there are enough room for
retransmit supposely lost frames.

I can't explain this well enough in English, sorry.

>> AFAIK, this is not optimal at all, so I don't go around and say 'it
>> works'. It may or may not work in your case.
>
> Since I would want to make an AP that generally worked, I
> don't think it would be enough.
>
>> If possible, test and report back your findings.
>
> I don't currently have a dongle. I'd be happy to buy one and
> test it (I really don't mind going through a fair number of
> patch/test/report back cycles, it's just writing code that's
> not currently something I can do), but not if there's a
> demarcation dispute as to who owns the bug!

To be completely honest with you in this whole AP issue, here's what I
used to say to my friends: "if you need an AP working flawlessly under
Linux, got with the Atheros b/g hardware".
But that was in the madwifi days, I haven't tested it with the current
mac80211 based driver.

And again YMMV :)

> --
> J=F3n Fairbairn =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Jon.Fairbairn@cl.cam.ac.uk

p.s. there are tons of Cheap AP's out there, it's just a matter of find=
 them :)

Luis Correia
rt2x00 project admin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
