Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm9.bullet.mail.bf1.yahoo.com ([98.139.212.168]:21664 "HELO
	nm9.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757360Ab1F0K0y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 06:26:54 -0400
References: <loom.20110621T215346-191@post.gmane.org> <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com> <1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com> (sfid-20110622_154146_913504_76736765) <1308750416.29571.10.camel@jlt3.sipsolutions.net> <1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com> <1308754204.29571.15.camel@jlt3.sipsolutions.net> <1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com> <4E074609.5080500@openwrt.org>
Message-ID: <1309170413.17395.YahooMailRC@web161202.mail.bf1.yahoo.com> (sfid-20110627_124357_713001_E20ED04B)
Date: Mon, 27 Jun 2011 03:26:53 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [ath5k-devel] Performance regression between Madwifi/net80211 and ath5k/mac80211
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <4E074609.5080500@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix,
thanks for taking an interest in this.

To answer your questions:
Originally I ran the stock Fedora 15 wireless modules from kernel 
2.6.38.8-32.fc15.i686.
Today I reran the test with the wireless modules from compat-wireless-3.0-rc4-1.
Unfortunately there doesn't seem to be any difference. Attached are the summary 
lines
from a 100secon TCP iperf run:

ath5k from kernel 2.6.38.8-32.fc15:   [  4]  0.0-100.7 sec   265 MBytes  22.1 
Mbits/sec
ath5k from compat-wireless-3.0-rc4-1: [  4]  0.0-100.9 sec   268 MBytes  22.2 
Mbits/sec
madwifi-0.9.4-r4144-20110602:         [  4]  0.0-100.4 sec   306 MBytes  25.6 
Mbits/sec

There is obviously little performance change from 2.6.38 to the current 3.0 
version
of ath5k. And there is a significant performance loss relative to Madwifi.

The iperf tests were run in 802.11a (channel 40) in IBSS mode. Similar 
performance
differences were previously observed in AP mode as well.


-- 
Thanks and kind regards 
Joerg 




----- Original Mail ----
> Von: Felix Fietkau <nbd@openwrt.org>
> An: Joerg Pommnitz <pommnitz@yahoo.com>
> CC: linux-wireless@vger.kernel.org; ath5k-devel@lists.ath5k.org
> Gesendet: Sonntag, den 26. Juni 2011, 16:45:29 Uhr
> Betreff: Re: [ath5k-devel] Performance regression between Madwifi/net80211 and 
>ath5k/mac80211
> 
> On 2011-06-22 5:07 PM, Joerg Pommnitz wrote:
> >>  I guess  you'll  need more help from the HW people here.
> > 
> > Bob,  Bruno, Felix, Luis, Nick: Do you read?
> What mac80211/ath5k version did you  use? If you're using the in-kernel ath5k 
>from 2.6.38, 
>
> then I'd suggest testing  with a recent compat-wireless version. I made some 
>bug fixes and
> performance  improvements in April - and I think those went into 2.6.39.
> 
> - Felix
> 
