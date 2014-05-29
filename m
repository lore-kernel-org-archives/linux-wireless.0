Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46592 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbaE2OmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 10:42:15 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so500966wgg.33
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 07:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKGw+FT0GTRF+tn_Odi0KQvEFL93Oyjj4x=SKgNP1aayB4-QA@mail.gmail.com>
References: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
	<53873A58.1070209@candelatech.com>
	<CACKGw+FT0GTRF+tn_Odi0KQvEFL93Oyjj4x=SKgNP1aayB4-QA@mail.gmail.com>
Date: Thu, 29 May 2014 16:42:13 +0200
Message-ID: <CACKGw+HZEvVVaGk3DzbvCTe7GSvU206=hr4QswLXVyiat1ozZg@mail.gmail.com> (sfid-20140529_164219_426601_AD1EF62C)
Subject: Re: [PATCH] ath10k: fix vdev map size for 10.x firmware
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 May 2014 16:10, Bartosz Markowski <bartosz.markowski@tieto.com> wrote:
> On 29 May 2014 15:47, Ben Greear <greearb@candelatech.com> wrote:
>>
>>
>> On 05/29/2014 06:36 AM, Bartosz Markowski wrote:
>>>
>>> Firmware 10.x supports up to 8 virtual AP interfaces
>>> (comparing to 7 for main firmware). Previous vdev map
>>> initialization was missing enough space for 8 + 1 vdevs
>>> (we may spent one for mac monitor), due to wrong define used.
>>>
>>> Use correct one - TARGET_10X_NUM_VDEVS - for 10.x firmware.
>>
>>
>> You are bumping total vdevs up to 16 with that patch...have you
>> actually tested that many?  The stock firmware has quite a bit of
>> deficiencies in the concurrency handling, at least for stations.
>
> No, I have never tested it with so many. I'm running tests with 8 at
> most. And by this patch I just aimed to support 8 VAPS we advertise in
> iface_combinations to mac80211 (.max_interfaces = 8). I was managed to
> get only 7 before, since 1 vdev was being allocated as monitor.

FYI: I quickly tried to extend the .max_interfaces +
interface_combinations limit in ath10k and check with 15 VAPs (using
hostapd, open network; on MIPS platform) and it just worked.. I did
not perform any exploratory testing, but managed to connect a couple
of clients to various bssids + run some sane iperf traffic etc.

-- 
Bartosz
