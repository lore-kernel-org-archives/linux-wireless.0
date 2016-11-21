Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:45235 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932226AbcKUORq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 09:17:46 -0500
Subject: Re: [PATCH 4.9.0-rc5] AR9300 calibration problems with antenna
 selected
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <m3wpg52hii.fsf@t19.piap.pl>
 <61055e757c5645dfb69da3fc555cbcf5@aptaiexm02f.ap.qualcomm.com>
 <2ea016e563f5db553f201a7d4205c2c0@codeaurora.org>
 <m3d1hp2b0z.fsf@t19.piap.pl>
Cc: miaoqing@codeaurora.org,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Matthias May <matthias.may@neratec.com>
Message-ID: <e1d1516a-2d1c-b696-b121-9b55ba36460b@neratec.com> (sfid-20161121_151816_192803_107D033B)
Date: Mon, 21 Nov 2016 15:11:34 +0100
MIME-Version: 1.0
In-Reply-To: <m3d1hp2b0z.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21/11/16 14:54, Krzysztof Hałasa wrote:
> miaoqing@codeaurora.org writes:
> 
>>> rmmod ath9k
>>> modprobe ath9k
>>> iw dev wlan0 set type ibss
>>> iw phy phyX set antenna 2
>>
>> 2 is a bad mask. We use bitmap, the valid masks are 1, 3, 7.
> 
> Thanks for your response.
> 
> I have two antenna connections (and a single antenna). Is it possible to
> select the secondary antenna connector only? How?
> 

No this is not really possible.
We have been playing around with this two, three years ago with this.
There are just too many things which rely on chain0
Noise calibration, DFS, Temperature measurement, Spectrum measurement
are just a few of the things I remember which don't work realiably anymore.
See [1] for more.

BR
Matthias

[1]
http://ath9k-devel.ath9k.narkive.com/QZcobwy1/ath9k-deaf-qca9558-when-setting-rxchainmask#post1
