Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:51248 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaIRSrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 14:47:49 -0400
Received: by mail-we0-f169.google.com with SMTP id w61so1401599wes.14
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 11:47:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319018C1FBC@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A319018C1FBC@sbs2003.acksys.local>
Date: Thu, 18 Sep 2014 20:47:48 +0200
Message-ID: <CAA2SeNLXDTWO95pFeHbpwLFeqjJPkv4Qa27DR0DQ7schGA_aAA@mail.gmail.com> (sfid-20140918_204753_100677_4FEA1DD8)
Subject: Re: [PATCHv2 00/10] add support for ACK timeout estimation in ath9k driver
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Cedric Debarge <cedric.debarge@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, Sept 16, 2014 at 02:13:25AM +0200, Lorenzo Bianconi wrote:
>
> Hi,
>

Hi,

>> This patchset adds support for estimation of the ACK timeout (dynack) in ath9k driver. Ath9k dynack computes the > ACK timeout based on ACK frame RX timestamp, TX frame timestamp and frame duration.
>>
>> Ath9k dynack has been tested in indoor environment using AR9223/AR9280 chipset (running 3.17.0-rc5 kernel), on
>> 9Km PtoP link using AR9280 chipset (running OpenWRT trunk, compat-wireless-2014-05-22) and on an AP using AR9280 > chipset (running OpenWRT trunk, compat-wireless-2014-05-22) serving 35 STA with links up to 8Km
>
> During your indoor tests, did you managed to get precise enough timestamps to compute a significant ACK to (despite of short distances and multipaths)?
>

Dynack tx/rx timestamps are snapshots of PCU's timestamps (expressed
in TSF value).

> Previous tests have shown impressive bandwith gains (10% on a 9Km P2P link). Did you also get improvements in indoor environment?
>

In indoor environment I got the same performance obtained with a
static ACK timeout since LER was roughly 0%. Anyway I guess dynack
should be enabled just on outdoor "long" links (like ones tested by
Philippe) since that environment is really sensitive to ACK timeout.

> Thanks,
>
> Cédric DEBARGE

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
