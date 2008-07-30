Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:32684 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760821AbYG3BBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 21:01:08 -0400
Received: by wf-out-1314.google.com with SMTP id 27so194864wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 18:01:07 -0700 (PDT)
Message-ID: <3ace41890807291801p38a0c432mfc16eec5a8cca96c@mail.gmail.com> (sfid-20080730_030118_223898_C595D345)
Date: Wed, 30 Jul 2008 02:01:07 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>,
	"Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <874p68l75x.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
	 <1217314430.15381.11.camel@johannes.berg>
	 <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	 <874p68l75x.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 10:19 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Tomas Winkler <tomasw@gmail.com> writes:
>
>> On Tue, Jul 29, 2008 at 9:53 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Tue, 2008-07-29 at 00:21 -0300, Herton Ronaldo Krzesinski wrote:
>>>
>>>> [3] /sbin/iwconfig wlan0 power on
>>>
>>> I don't think turning on power management (yes, this command is
>>> completely misnamed, it turns on power _management_ not the power, you
>>> may want "txpower auto") does anything on this chip, does it?

I had look through the code - mac80211 itself, the rtl8187b driver,
and the client tool
(iwconfig 29). The thing is, there is absolutely nothing in rtl8187b
other than one reference
to IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING, and in mac80211, as far
as I understand,
power saving should only has effect for driver in AP mode (as is
IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING)?

In any case, I tried removing IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING
in the driver code,
and also enabling CONFIG_MAC80211_VERBOSE_PS_DEBUG in net/mac80211/*.c
- the former does not improve
the situation, the latter seems to have no effect (i.e. none of the
code with PS_DEBUG is invoked when using
the driver in STA mode) - is that correct?


>>
>> iwconfig power on is not implemented by mac80211 yet. There was one
>> patch posted that implements it.
>
> John has already applied Samuel's patch to wireless-testing:
>
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=8f87dd7e540d455f8e7f11478133b85edc969c67

This is one of the two patches we have been talking about which breaks
the rt8187b driver. (the other being the tx seq no one).

>
>> I wanted to expand it but wireless_tools 29 has a bug in parsing
>> this command. It is fixed only in 30.pre6 which is usually not in
>> distros.
>
> Could you be more specific, please? We have been using it for few
> years now.

Yes, I like to know what's the bug referring to also. I have looked at
iwconfig 29
and it seems to be doing the right thing ("off" sets disable, "on"
sets the value).

Hin-Tak
