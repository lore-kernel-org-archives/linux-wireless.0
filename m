Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:51512 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842AbZKYV3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 16:29:46 -0500
Received: by ey-out-2122.google.com with SMTP id 4so53557eyf.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 13:29:51 -0800 (PST)
Message-ID: <4B0DA1CC.4020308@gmail.com>
Date: Wed, 25 Nov 2009 22:29:48 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH v2 8/8] rt2x00: Properly request tx headroom for	alignment
 operations.
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com> <1259012694-14869-2-git-send-email-gwingerde@gmail.com> <1259012694-14869-3-git-send-email-gwingerde@gmail.com> <1259012694-14869-4-git-send-email-gwingerde@gmail.com> <1259012694-14869-5-git-send-email-gwingerde@gmail.com> <1259012694-14869-6-git-send-email-gwingerde@gmail.com> <1259012694-14869-7-git-send-email-gwingerde@gmail.com> <1259012694-14869-8-git-send-email-gwingerde@gmail.com> <1259012694-14869-9-git-send-email-gwingerde@gmail.com> <20091125194746.GG7800@tuxdriver.com>
In-Reply-To: <20091125194746.GG7800@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/09 20:47, John W. Linville wrote:
> On Mon, Nov 23, 2009 at 10:44:54PM +0100, Gertjan van Wingerde wrote:
>> Current rt2x00 drivers may result in a "ieee80211_tx_status: headroom too
>> small" error message when a frame needs to be properly aligned before
>> transmitting it.
>> This is because the space needed to ensure proper alignment isn't
>> requested from mac80211.
>> Fix this by adding sufficient amount of alignment space to the amount
>> of headroom requested for TX frames.
>>
>> Reported-by: David Ellingsworth <david@identd.dyndns.org>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
>   CC [M]  drivers/net/wireless/rt2x00/rt2x00dev.o
> drivers/net/wireless/rt2x00/rt2x00dev.c: In function ‘rt2x00lib_probe_hw’:
> drivers/net/wireless/rt2x00/rt2x00dev.c:690: error: ‘IEEE80211_TX_STATUS_HEADROOM’ undeclared (first use in this function)
> drivers/net/wireless/rt2x00/rt2x00dev.c:690: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/rt2x00/rt2x00dev.c:690: error: for each function it appears in.)
> 
> Did I miss a patch?

Patch 7 of the series creates that define within mac80211. It is a prerequisite for this patch.

---
Gertjan.
