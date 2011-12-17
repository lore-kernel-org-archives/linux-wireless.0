Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59571 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1LQSLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 13:11:48 -0500
Received: by iaeh11 with SMTP id h11so6141919iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 10:11:47 -0800 (PST)
Message-ID: <4EECDB5C.6020104@lwfinger.net> (sfid-20111217_191152_165204_A528D7B6)
Date: Sat, 17 Dec 2011 12:11:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/8] b43: reoder functions in phy_n.c
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/17/2011 06:57 AM, Rafał Miłecki wrote:
> [APPLYING] This patchset is based on top of wireless-next with:
> b43: mark some vars __maybe_unused in b43_nphy_pmu_spur_avoid
> applied.
>
>
> As noted on b43-dev, we got really messy in phy_n.c. Functions were
> implemented quite randomly, with specs appering during development,
> sometimes without knowing real mining of the routies.
>
> That resulted in code hard to read and with some not-so-nice early
> declarations.
>
> This patches makes some cleaning with that code. It moves tons of LOCs,
> but I think we have to do this finally instead of going deeper and
> deeper into that mess.
>
> As Larry suggested, I've made small patches and tried my best to get
> them formatted nicely, to have diffs really clean. I've been
> compiling b43 after each patch, so there shouldn't be any build
> breakage between.
>
> Rafał Miłecki (8):
>    b43: N-PHY: reorder functions: put basic ones at beginning
>    b43: N-PHY: reorder functions: collect radio ones
>    b43: N-PHY: reorder functions: collect samples ones
>    b43: N-PHY: reorder functions: collect RSSI selects
>    b43: N-PHY: split gain control workarounds
>    b43: N-PHY: reorder functions: move RSSI calibration
>    b43: N-PHY: reorder functions: move rest of workarounds
>    b43: N-PHY: reorder functions: random clenaups
>
>   drivers/net/wireless/b43/phy_n.c | 4575 +++++++++++++++++++-------------------
>   1 files changed, 2301 insertions(+), 2274 deletions(-)

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

I like all these patches, and you don't have to change anything. Note, that 
cleanups is misspelled in the subject line for #8.

Larry
