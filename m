Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63359 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZCTNau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 09:30:50 -0400
Received: by ewy24 with SMTP id 24so848068ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2009 06:30:47 -0700 (PDT)
Message-ID: <49C39A83.5090004@giuppi.com> (sfid-20090320_143053_261543_22CCBC88)
Date: Fri, 20 Mar 2009 14:30:43 +0100
From: "Info[at]Giuppi" <info@giuppi.com>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 bug report
References: <49C12DFA.80308@giuppi.com>	 <3ace41890903191439q1c375925md2e4227f79147399@mail.gmail.com>	 <49C2D537.6080406@giuppi.com> <3ace41890903191856s234118c9j2f4de15486cb37a9@mail.gmail.com>
In-Reply-To: <3ace41890903191856s234118c9j2f4de15486cb37a9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung ha scritto:
>
> You are somewhat wrong about Realtek's position - I am speaking as on=
e
> of the 3 current maintainers of the new rtl8187 code, by the way, if
> you didn't know that... - Realtek staff have been quite co-operative,
> and while the vendor driver is behind and have some other issues, the=
y
> have regular releases through OEM channels. (there is also a chance
> that the "one guy" you refer to is me - at least 3 people had tried t=
o
> port the vendor driver forward).
>
>  =20
I'm talking about rtl8187 B chipset which seems different from the firs=
t
one rtl8187 L
In realtek drivers dowload page I can't see a linux version for rtl8187=
b
so as a normal user I think there's no official support
http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=3D1&PNid=3D=
1&PFid=3D1&Level=3D6&Conn=3D5&DownTypeID=3D3&GetDown=3Dfalse&Downloads=3D=
true#RTL8187B
About them being co-operative, so that makes a right choise to buy thei=
r
hardware at least!
I don't know who you people are, nice to meet you now. I just felt the
need to share a question with you and since I'm inexperienced perhaps I
tend to confuse things trying to explain myself.
>>> On a different issue - I think such adaptation are frown upon and w=
ill
>>> not make it into the standard kernel, due to its nature of typical
>>> usage in a controversal scenario. Maybe other wireless dev people,
>>> especially Herton and Larry, can advise.
>>>      =20
>> As far as I know there are no adaptations needed. Wanted or not, it
>> already works in those "controversal scenario".
>> The rt73usb driver comes from the same compat-wireless package and i=
t
>> hasn't that problem, for example. The rtl8187 driver itself works
>> great for networks other than WEP.
>>
>> Thanks very much for your reply, I hope some of the devs can take th=
e
>> time to check if I'm wrong.
>>    =20
>
> According to http://www.aircrack-ng.org/doku.php?id=3Drtl8187 , two
> small patches are recommended.
> vs the vendor driver, which needs one rather big patch:
> http://www.aircrack-ng.org/doku.php?id=3Dr8187
>
> The fragmentation patch applies to both rtl8187 anf rt73usb, but the
> injection patch is rtl8187-specific. If the latter works better for
> you and have no detrimental effect on "normal" usage, we can consider
> putting it in. (it looks a bit wrong though)
>
>  =20
Talking about those links, the one I should follow is this one
http://www.aircrack-ng.org/doku.php?id=3Dr8187b and the driver download
offered is r8187b-2.6.25-hirte.tar.bz2 since rtl8187 version L seems
different from version B. But that's not my point.

I'm not complaining neither about fragmentation nor any injection patch
to be in the compat-wireless driver.
New drivers seem to natively support monitor mode. I've put the device
in monitor mode. While in monitor mode, the driver has some issues
handling WEP protected networks. Other networks are shown correctly in
monitor mode.
If you're asking on which bases I say that, I've anticipated the answer
telling you I've used a - svn updated version of - "=EF=BB=BFraw 802.11=
 frames
packet capturing software" called airodump-ng. It "=EF=BB=BFwrites out =
a text
file containing the details of all access points and clients seen".
As I can see, beacons - "Number of announcements packets sent by the AP=
=2E
Each access point sends about ten beacons per second at the lowest rate
(1M), so they can usually be picked up from very far" - from WEP
networks aren't detected at all.
Parts between " " are from
http://www.aircrack-ng.org/doku.php?id=3Dairodump-ng just to let you kn=
ow
what I've read about and I'm referencing to.
Maybe this makes my delirium clearer, maybe I miss something and I can'=
t
understand this is a normal behaviour.
Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
