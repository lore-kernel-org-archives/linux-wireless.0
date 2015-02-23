Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33839 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbbBWCFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 21:05:06 -0500
Received: by mail-ig0-f171.google.com with SMTP id h15so14996804igd.4
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 18:05:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmomz+hydAPGJ2gQcbqBC6uxY=aMRuysyMB-Z9CFL8SY81A@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
	<CAJ-Vmomz+hydAPGJ2gQcbqBC6uxY=aMRuysyMB-Z9CFL8SY81A@mail.gmail.com>
Date: Sun, 22 Feb 2015 18:05:05 -0800
Message-ID: <CAJ-VmonTFj2X-V40E0G=xEa5KJM4tzzhwbDKyRod1Qsd9JL_nQ@mail.gmail.com> (sfid-20150223_030511_161548_ED9CB4D5)
Subject: Re: AR9462 problems connecting again..
From: Adrian Chadd <adrian@freebsd.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So the interesting part thus far:

14:07:23.513500: RTM_NEWLINK: operstate=1 ifi_flags=0x1003 ([UP])
14:07:23.513662: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlp1s0' added
14:07:23.513842: nl80211: if_removed already cleared - ignore event
14:07:23.536309: nl80211: Event message available
14:07:23.536454: nl80211: Delete station 20:9f:db:e7:80:80
14:07:23.542786: nl80211: Event message available
14:07:23.542882: nl80211: MLME event 39
14:07:23.542903: nl80211: Deauthenticate event
14:07:23.542927: wlp1s0: Event DEAUTH (12) received
14:07:23.542946: wlp1s0: Deauthentication notification
14:07:23.542964: wlp1s0:  * reason 2
14:07:23.542982: wlp1s0:  * address 20:9f:db:e7:80:80
14:07:23.542997: Deauthentication frame IE(s) - hexdump(len=0): [NULL]
14:07:23.543055: wlp1s0: CTRL-EVENT-DISCONNECTED
bssid=20:9f:db:e7:80:80 reason=2
14:07:23.543096: wlp1s0: Auto connect enabled: try to reconnect (wps=0
wpa_state=9)
14:07:23.543115: wlp1s0: Setting scan request: 0 sec 100000 usec
14:07:23.543133: Added BSSID 20:9f:db:e7:80:80 into blacklist

You've associated, you do the 4-way handshake, that works fine; then
one second later you do it again; then one second later it fails and
it sends a disconnect.

Whenever I've seen this in the past, it's been because some part of
the EAPOL exchange is being transmitted at the wrong rate or something
about the sequence number/etc is incorrect. So, hm, I'd want to verify
that the whole exchange is working correctly and peek into the header
values for each of those.





-adrian
