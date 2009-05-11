Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38910 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909AbZEKXVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 19:21:30 -0400
Received: by fxm2 with SMTP id 2so3011734fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 16:21:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242081608.24094.14.camel@localhost.localdomain>
References: <1242042898.18637.0.camel@johannes.local>
	 <1242049846.28322.12.camel@localhost.localdomain>
	 <1242050962.29777.12.camel@johannes.local>
	 <3ace41890905111516m2d5f9f70k83edbdef1ca6e2b8@mail.gmail.com>
	 <1242081608.24094.14.camel@localhost.localdomain>
Date: Tue, 12 May 2009 00:21:29 +0100
Message-ID: <3ace41890905111621h1f078101sb8ec0974ab901992@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: implement wext key handling
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	Samuel Ortiz <sameo@linux.intel.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 11:40 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2009-05-11 at 23:16 +0100, Hin-Tak Leung wrote:
>> On Mon, May 11, 2009 at 3:09 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Mon, 2009-05-11 at 09:50 -0400, Dan Williams wrote:
>> >
>> >> I modified the meaning of RESTRICTED/OPEN a few years ago to cont=
rol the
>> >> WEP auth mode, for a few reasons... =A0First, some fullmac driver=
s already
>> >> used it to mean WEP auth mode. =A0Second, there was no other mech=
anism to
>> >> control WEP auth mode at the time, and there were a lot of Shared=
 Key
>> >> installations around. =A0Third, WE-18/WPA was nowhere near being =
landed,
>> >> and it was only supported by one driver (hostap), and it was the =
only
>> >> thing that would plausibly support WEP auth mode via SIWAUTH. =A0=
=46ourth,
>> >> only hostap and maybe airo really implemented the refuse-non-enco=
ded
>> >> anyway.
>> >
>> > But didn't update the header file ;)
>> >
>> >> TBH, SK is nice because it tells you that the WEP key is wrong
>> >> *immediately*, and the only reason NM doesn't use SK by default (=
and
>> >> then fall back to OS) like the original Mac Airport drivers did i=
s that
>> >> WEXT simply cannot return reliable association error information.
>> >
>> > Hah. Well, we could have that now, but I suspect SK is no longer c=
ommon
>> > enough to put a lot of work into it.
>> >
>> >> But in the end, we still need a mechanism with WEXT to be able to=
 set SK
>> >> auth when associating.
>> >
>> > We still have that, with WE18, in IW_AUTH_80211_AUTH_ALG. And mac8=
0211
>> > never actually supported _setting_ the WEP auth mechanism with
>> > RESTRICTED/OPEN, only _getting_ that information.
>> >
>> > johannes
>> >
>> >
>>
>> Argh, is this the reason why compat-wireless(wireless-testing?) toda=
y
>> doesn't quite work any more?
>> NetworkManager no longer wants to work, with this message in syslog:
>>
>> localhost NetworkManager: <WARN> =A0nm_device_wifi_disable_encryptio=
n():
>> error setting key for device wlan2: Invalid argument
>
> That specific call shouldn't cause a hard error. =A0It's just advisor=
y.
> And really, I could just remove that call in NM entirely, since
> wpa_supplicant does clear keys in the MLME disconnect method now.
>
> Dan

I reverted that specific change
(bf2c6a38af6095ee1116278f240ccb9c65c6337d cfg80211: implement wext key
handling)
and redo compat-wireless and it is working again.

I suppose the important thing is to keep userland change in sync.
Somehow NW is using those IOCTLs, at least on my system. FWIW, I am
using the distro's NetworkManager-0.7.1-4.git20090414.fc10.x86_64 .

Hin-Tak
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
