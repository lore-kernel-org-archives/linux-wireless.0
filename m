Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60367 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaAZOfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 09:35:43 -0500
MIME-Version: 1.0
In-Reply-To: <d4d1340a176aee1e58ffe80e83ddc3394f2829e3.1389975095.git.gamerh2o@gmail.com>
References: <d4d1340a176aee1e58ffe80e83ddc3394f2829e3.1389975095.git.gamerh2o@gmail.com>
Date: Sun, 26 Jan 2014 15:35:42 +0100
Message-ID: <CACna6rw3GuZ-hmGJvQRQvb33GtSFrA50OpQjyjwYcUHQsHK-fQ@mail.gmail.com> (sfid-20140126_153548_838055_7D455ACE)
Subject: Re: [PATCH v4 1/2] b43: fix the wrong assignment of status.freq in b43_rx()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonas Gorski <jogo@openwrt.org>, Luca Coelho <luca@coelho.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/17 ZHAO Gang <gamerh2o@gmail.com>:
> Use the right function to update frequency value.
>
> If rx skb is probe response or beacon, the wrong frequency value can
> cause problem that bss info can't be updated when it should be.

Zhao: this fix is great. My development machine was running some
ancient distro with kernel 2.6.22, so I couldn't test it earlier.

For a long time I got problem with finding AP on channel 13. I reported it in:
cfg80211: use DS or HT operation IEs to determine BSS channel"

I did 10 tests *without* your patch. wpa_supplicant had to scan 43,
33, 7, 2, 46, 12, 7, 32, 6, 6 times to find my AP on channel 13.
With your patch wpa_supplicant finds it in scanning results after the first try!

Thanks a lot for finding and fixing it!

[0] http://lists.infradead.org/pipermail/b43-dev/2013-March/003003.html
