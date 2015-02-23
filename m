Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38644 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbBWFnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 00:43:04 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21738.48812.661312.969621@gargle.gargle.HOWL> (sfid-20150223_064308_969114_89C29492)
Date: Mon, 23 Feb 2015 11:16:20 +0530
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
In-Reply-To: <CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus Torvalds wrote:
> 14:07:23.542927: wlp1s0: Event DEAUTH (12) received
> 14:07:23.542946: wlp1s0: Deauthentication notification
> 14:07:23.542964: wlp1s0:  * reason 2
> 14:07:23.542982: wlp1s0:  * address 20:9f:db:e7:80:80
> 14:07:23.542997: Deauthentication frame IE(s) - hexdump(len=0): [NULL]
> 14:07:23.543055: wlp1s0: CTRL-EVENT-DISCONNECTED bssid=20:9f:db:e7:80:80 reason=2

Sporadic association problems could be a problem with the chosen rates.
This would show the rates for the EAPOL frames:

iw dev wlp1s0 interface add mon0 type monitor
ifconfig mon0 up
tshark -i mon0 -Y eapol -T fields -e radiotap.datarate -e wlan -e eapol -e wlan.sa -e wlan.da
Run wpa_s.

Does setting a lower rate improve connectivity ?

'iw dev wlp1s0 set bitrates ht-mcs-2.4 1' would choose a lower
rate for the key-exchange frames.

Sujith
