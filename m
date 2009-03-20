Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:27490 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZCTVGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 17:06:52 -0400
Received: by fg-out-1718.google.com with SMTP id 16so112947fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2009 14:06:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C39A83.5090004@giuppi.com>
References: <49C12DFA.80308@giuppi.com>
	 <3ace41890903191439q1c375925md2e4227f79147399@mail.gmail.com>
	 <49C2D537.6080406@giuppi.com>
	 <3ace41890903191856s234118c9j2f4de15486cb37a9@mail.gmail.com>
	 <49C39A83.5090004@giuppi.com>
Date: Fri, 20 Mar 2009 22:06:49 +0100
Message-ID: <69e28c910903201406o1e908214s4f0ab8cfa28392f1@mail.gmail.com> (sfid-20090320_220655_829197_94A3FC8B)
Subject: Re: rtl8187 bug report
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <gst@remote-exploit.org>
To: "Info[at]Giuppi" <info@giuppi.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 20, 2009 at 2:30 PM, Info[at]Giuppi <info@giuppi.com> wrote=
:
> Hin-Tak Leung ha scritto:
>>
>> You are somewhat wrong about Realtek's position - I am speaking as o=
ne
>> of the 3 current maintainers of the new rtl8187 code, by the way, if
>> you didn't know that... - Realtek staff have been quite co-operative=
,
>> and while the vendor driver is behind and have some other issues, th=
ey
>> have regular releases through OEM channels. (there is also a chance
>> that the "one guy" you refer to is me - at least 3 people had tried =
to
>> port the vendor driver forward).
>>
>>
> I'm talking about rtl8187 B chipset which seems different from the fi=
rst
> one rtl8187 L
> In realtek drivers dowload page I can't see a linux version for rtl81=
87b
> so as a normal user I think there's no official support
> http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=3D1&PNi=
d=3D1&PFid=3D1&Level=3D6&Conn=3D5&DownTypeID=3D3&GetDown=3Dfalse&Downlo=
ads=3Dtrue#RTL8187B
> About them being co-operative, so that makes a right choise to buy th=
eir
> hardware at least!
> I don't know who you people are, nice to meet you now. I just felt th=
e
> need to share a question with you and since I'm inexperienced perhaps=
 I
> tend to confuse things trying to explain myself.
>>>> On a different issue - I think such adaptation are frown upon and =
will
>>>> not make it into the standard kernel, due to its nature of typical
>>>> usage in a controversal scenario. Maybe other wireless dev people,
>>>> especially Herton and Larry, can advise.
>>>>
>>> As far as I know there are no adaptations needed. Wanted or not, it
>>> already works in those "controversal scenario".
>>> The rt73usb driver comes from the same compat-wireless package and =
it
>>> hasn't that problem, for example. The rtl8187 driver itself works
>>> great for networks other than WEP.
>>>
>>> Thanks very much for your reply, I hope some of the devs can take t=
he
>>> time to check if I'm wrong.
>>>
>>
>> According to http://www.aircrack-ng.org/doku.php?id=3Drtl8187 , two
>> small patches are recommended.
>> vs the vendor driver, which needs one rather big patch:
>> http://www.aircrack-ng.org/doku.php?id=3Dr8187
>>
>> The fragmentation patch applies to both rtl8187 anf rt73usb, but the
>> injection patch is rtl8187-specific. If the latter works better for
>> you and have no detrimental effect on "normal" usage, we can conside=
r
>> putting it in. (it looks a bit wrong though)
>>
>>
> Talking about those links, the one I should follow is this one
> http://www.aircrack-ng.org/doku.php?id=3Dr8187b and the driver downlo=
ad
> offered is r8187b-2.6.25-hirte.tar.bz2 since rtl8187 version L seems
> different from version B. But that's not my point.
>
> I'm not complaining neither about fragmentation nor any injection pat=
ch
> to be in the compat-wireless driver.
> New drivers seem to natively support monitor mode. I've put the devic=
e
> in monitor mode. While in monitor mode, the driver has some issues
> handling WEP protected networks. Other networks are shown correctly i=
n
> monitor mode.
> If you're asking on which bases I say that, I've anticipated the answ=
er
> telling you I've used a - svn updated version of - "=EF=BB=BFraw 802.=
11 frames
> packet capturing software" called airodump-ng. It "=EF=BB=BFwrites ou=
t a text
> file containing the details of all access points and clients seen".
> As I can see, beacons - "Number of announcements packets sent by the =
AP.
> Each access point sends about ten beacons per second at the lowest ra=
te
> (1M), so they can usually be picked up from very far" - from WEP
> networks aren't detected at all.
> Parts between " " are from
> http://www.aircrack-ng.org/doku.php?id=3Dairodump-ng just to let you =
know
> what I've read about and I'm referencing to.
> Maybe this makes my delirium clearer, maybe I miss something and I ca=
n't
> understand this is a normal behaviour.
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Hi!

Could you please test if you can see packets originating from your
network in Kismet or Wireshark?
Also, did you use the included airmon-ng script to enable monitor
mode, or did you just do "ifconfig wlan0 down; iwconfig wlan0 mode
monitor, ifconfig wlan0 up"? (The two are significantly different, as
airmon-ng uses iw/nl80211 to enable monitor mode on a separate
interface - it would be good if you tried it both ways.)

Thanks,
G=C3=A1bor (.NetRolller 3D)

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
