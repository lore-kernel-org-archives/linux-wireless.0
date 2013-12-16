Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61170 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab3LPP06 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:26:58 -0500
Received: from [192.168.1.138] ([79.218.126.58]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MOOpx-1Vvaji0JiX-005n1r for
 <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 16:26:57 +0100
Message-ID: <52AF1BBE.5020602@rempel-privat.de> (sfid-20131216_162712_066882_F2C4B8D1)
Date: Mon, 16 Dec 2013 16:26:54 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	David Herrmann <dh.herrmann@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [BUG] P2P setup timeout
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>	 <1387197416.4665.15.camel@jlt4.sipsolutions.net>	 <CANq1E4TAt_Pw-V5_2LtJjY3LRcuwsxr1mBkcHjmX+MJUxc=zPQ@mail.gmail.com>	 <1387201528.2057.1.camel@jlt4.sipsolutions.net>	 <CANq1E4TJWCgM4yCFC25b3ssQEvFv+hEhW6jP3_mQKxQCw-QtUQ@mail.gmail.com>	 <52AF14EC.9010803@rempel-privat.de>	 <CANq1E4S+u6UZf15fU9aO6JvY4OTE+RnOKGL0K16T9A_4vr+C6A@mail.gmail.com>	 (sfid-20131216_160940_365143_3C2C01EE) <1387206912.2057.25.camel@jlt4.sipsolutions.net>
In-Reply-To: <1387206912.2057.25.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 16.12.2013 16:15, schrieb Johannes Berg:
> On Mon, 2013-12-16 at 16:09 +0100, David Herrmann wrote:
> 
>> Thanks, I tracked down the ENETDOWN. I'm not entirely sure but I think it's:
> 
> Obviously :)
> 
>> @Oleksij, I actually have three ath9k-htc devices so I'd like to get
>> this working, and the devices are really nice apart from this bug. I
>> will keep you up to date, but if you have any hints where to continue
>> digging, lemme know. Until it's fixed, I'll just work on
>> wired-displays via ethernet instead of wifi-displays..
> 
> Based on what Oleksij said, these issues are likely not even related -
> maybe ath9k_htc can't even set the rates to exclude CCK, so even if that
> call were to succeed it wouldn't work?

Hmm.. WMI_BITRATE_MASK should do it.
ieee80211_ops->set_bitrate_mask is set, so theoretically we should be
able to exclude CCK. Today i won't be able to check it.

> The issue here doesn't seem to be that call anyway, since that call was
> for the data frames on the p2p-wlan1-0 interface, but rather seems to be
> that ath9k_htc ignores the no-CCK parameter for the NL80211_CMD_FRAME
> command (in mac80211, this would be IEEE80211_TX_CTL_NO_CCK_RATE)
> 
> johannes
> 


-- 
Regards,
Oleksij
