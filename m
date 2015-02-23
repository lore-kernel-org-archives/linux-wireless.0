Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:43824 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbbBWUGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 15:06:10 -0500
Received: by mail-ig0-f172.google.com with SMTP id l13so21155888iga.5
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 12:06:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150223171700.GA29730@w1.fi>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
	<20150223171700.GA29730@w1.fi>
Date: Mon, 23 Feb 2015 12:06:09 -0800
Message-ID: <CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com> (sfid-20150223_210614_636114_3669F8DD)
Subject: Re: AR9462 problems connecting again..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jouni Malinen <j@w1.fi>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2015 at 9:17 AM, Jouni Malinen <j@w1.fi> wrote:
>
> mac80211: Do not encrypt EAPOL frames before peer has used the key

Hmm. This patch does not seem to make a difference. I thought it did
at first, but then removed the wpa_supplicant debugging, and got the
same failures.

On Sun, Feb 22, 2015 at 10:01 PM, Sujith Manoharan <sujith@msujith.org> wrote:
>
> Or 'iw dev wlp1s0 set bitrates ht-mcs-2.4 0' to choose the lowest
> HT rate.

This *might* have worked. But it's a bit hard to really make sure,
since it sometimes does succeed even without debugging when I do
nothing at all, but it did work twice in a row after doing that.

> Sporadic association problems could be a problem with the chosen rates.
> This would show the rates for the EAPOL frames:
>
> iw dev wlp1s0 interface add mon0 type monitor
> ifconfig mon0 up

Hmm. I don't actually see a "mon0" interface after the "iw dev
interface add" thing. Yes, "iw" sees it when I do "iw dev", but
"ifconfig" does not.

This machine has a fairly minimal kernel config. Does that "type
monitor" interface perhaps need some debug infrastructure that I
haven't added?

> tshark -i mon0 -Y eapol -T fields -e radiotap.datarate -e wlan -e eapol -e wlan.sa -e wlan.da

.. and then this fails, presumably for similar reasons.

                        Linus
