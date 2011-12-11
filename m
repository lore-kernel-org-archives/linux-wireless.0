Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33168 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1LKD0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 22:26:00 -0500
Received: by ghbf1 with SMTP id f1so264150ghb.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 19:25:59 -0800 (PST)
Message-ID: <4EE422C4.5050005@lwfinger.net> (sfid-20111211_042608_241985_EE26F89D)
Date: Sat, 10 Dec 2011 21:25:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/7] b43: N-PHY fixes, check dependency before applying
References: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2011 07:55 PM, Rafał Miłecki wrote:
> Some N-PHY fixes coming from wl observations and specs changes.
>
> Please note this patchset depends on following patches:
> [PATCH 1/2] ssb: extract FEM info from SPROM
> [PATCH 2/2] bcma: extract FEM info from SPROM
> send 3 days ago.
>
> Rafał Miłecki (7):
>    b43: N-PHY: random trivial fixes for typos, missing writes
>    b43: N-PHY: update some init values
>    b43: N-PHY: workaround BCM43224 hw bug in writing table id 9
>    b43: N-PHY: add table for antenna software control
>    b43: N-PHY: determine various PHY params
>    b43: N-PHY: finish 2.4GHz 0x2056 radio setup
>    b43: N-PHY: implement spurious tone avoidance
>
>   drivers/net/wireless/b43/phy_n.c       |  262 +++++++++++++++++++++++++++++---
>   drivers/net/wireless/b43/phy_n.h       |    8 +
>   drivers/net/wireless/b43/radio_2056.c  |   25 +++-
>   drivers/net/wireless/b43/radio_2056.h  |    1 +
>   drivers/net/wireless/b43/tables_nphy.c |   59 +++++++-
>   drivers/net/wireless/b43/tables_nphy.h |   31 ++--
>   6 files changed, 342 insertions(+), 44 deletions(-)

This set of patches improved the performance of my BCM43224.

netperf TCP_MAERTS (RX)  15.0 => 24.5 Mbps
netperf TCP_STREAM (TX)   6.0 => 13.1 Mbps

I have mac80211 debug on, and I see a lot of

wlan13: detected beacon loss from AP - sending probe request

These occur at 1 second intervals. This particular AP does not have a setting 
for the beacon interval, but I think it is at 100 ms.

Larry


