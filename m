Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:39934 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYG2VOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 17:14:25 -0400
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Cc: "Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	<48874F09.7060400@lwfinger.net>
	<3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	<200807290021.45400.herton@mandriva.com.br>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 30 Jul 2008 00:12:58 +0300
In-Reply-To: <200807290021.45400.herton@mandriva.com.br> (ext Herton Ronaldo Krzesinski's message of "Tue\, 29 Jul 2008 00\:21\:45 -0300")
Message-ID: <87d4kwl7hh.fsf@nokia.com> (sfid-20080729_231429_001740_8DFB5840)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski <herton@mandriva.com.br> writes:

>> I also wonder how Herton encountered the problem :-). Older
>> wireless-testing simply say "unimplemented" or something if one
>> tries to set power-saving. Maybe Herton has a few devices which he
>> routinely tries out every part of iwconfig?
>
> The original sequence of commands:
> [1] /sbin/ip link set dev wlan0 down
> [2] /sbin/ip link set dev wlan0 up
> [3] /sbin/iwconfig wlan0 power on
> [4] /sbin/iwconfig wlan0 essid any
> [5] /sbin/iwconfig wlan0 power on
> [6] /sbin/iwconfig wlan0 essid <my AP>
> [7] /sbin/iwconfig wlan0 key open <my key>
>
> That show the issue on rtl8187b I have to test just is near on what Mandriva 
> 2008.0 ifup-wireless script does, so that's what first made me catch the bug. 
> the '... power on' after '... essid any' is what causes later the association 
> or any scan attempt to fail, if I place a sleep between [4] and [5] I don't 
> get the problem too.

Thanks for the clarification, this kind of information is important
when reporting a bug.

> The problem is, I couldn't see yet how a power on after essid any
> could cause this.

I'm guessing that it has something to do ieee80211_ioctl_siwpower()
calling ieee80211_hw_config(local) which ends up as an extra call to
rtl8187_config(). I do not know why this is a problem for rtl8187b.

It would help if you, or someone else seeing the same problem, could
provide more information by enabling MAC80211_VERBOSE_DEBUG and
MAC80211_LOWTX_FRAME_DUMP config options, and sending the kernel log
output here. I don't have a rtl8187b card myself so I cannot test
this.

-- 
Kalle Valo
