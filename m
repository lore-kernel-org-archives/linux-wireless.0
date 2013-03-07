Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:57583 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3CGSJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 13:09:30 -0500
Received: by mail-oa0-f49.google.com with SMTP id j6so945322oag.22
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 10:09:30 -0800 (PST)
Message-ID: <5138D7D7.5020204@lwfinger.net> (sfid-20130307_190934_526646_49865D7D)
Date: Thu, 07 Mar 2013 12:09:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 00/13] b43: implement basic TX power mgmt
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2013 09:47 AM, Rafał Miłecki wrote:
> After spotting a lot of N-PHY-similar functions in
> BCM4331 dump of MMIO ops - split into names parts
> I was able to finally improve HT-PHY code.
>
> It now sets TX basically, I can finally talk with devices that are few
> meters away, not just few centimetres. It's a little patch bomb, sorry
> for that, but I wasn't sure if my code is correct until it was complete
> and started working.
>
> Rafał Miłecki (13):
>    b43: HT-PHY: rename AFE defines
>    b43: HT-PHY: add classifier control function
>    b43: HT-PHY: move TX fix to the separated function
>    b43: HT-PHY: implement spurious tone avoidance
>    b43: HT-PHY: implement MAC reclocking
>    b43: HT-PHY: implement CCA reset
>    b43: HT-PHY: implement PA override
>    b43: HT-PHY: implement controlling TX power control
>    b43: HT-PHY: implement stopping sample tone playback
>    b43: HT-PHY: implement playing sample tone
>    b43: HT-PHY: implement RSSI polling
>    b43: HT-PHY: setup TX power control
>    b43: HT-PHY: enable basic TX power setup
>
>   drivers/net/wireless/b43/phy_ht.c |  603 +++++++++++++++++++++++++++++++++----
>   drivers/net/wireless/b43/phy_ht.h |   77 ++++-
>   2 files changed, 613 insertions(+), 67 deletions(-)

What tree is used for these patches? Numbers 1-7 applied with offsets, and some 
fuzz. Number 8 failed, and I quit trying there. I am using wireless-testing that 
was a fresh pull yesterday after John rebased it.

Larry


