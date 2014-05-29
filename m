Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34428 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348AbaE2P5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 11:57:07 -0400
Message-ID: <538758CF.8090208@candelatech.com> (sfid-20140529_175711_252247_9581C3A3)
Date: Thu, 29 May 2014 08:57:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix vdev map size for 10.x firmware
References: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com> <53873A58.1070209@candelatech.com> <CACKGw+FT0GTRF+tn_Odi0KQvEFL93Oyjj4x=SKgNP1aayB4-QA@mail.gmail.com> <CACKGw+HZEvVVaGk3DzbvCTe7GSvU206=hr4QswLXVyiat1ozZg@mail.gmail.com>
In-Reply-To: <CACKGw+HZEvVVaGk3DzbvCTe7GSvU206=hr4QswLXVyiat1ozZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2014 07:42 AM, Bartosz Markowski wrote:
> On 29 May 2014 16:10, Bartosz Markowski <bartosz.markowski@tieto.com> wrote:
>> On 29 May 2014 15:47, Ben Greear <greearb@candelatech.com> wrote:
>>>
>>>
>>> On 05/29/2014 06:36 AM, Bartosz Markowski wrote:
>>>>
>>>> Firmware 10.x supports up to 8 virtual AP interfaces
>>>> (comparing to 7 for main firmware). Previous vdev map
>>>> initialization was missing enough space for 8 + 1 vdevs
>>>> (we may spent one for mac monitor), due to wrong define used.
>>>>
>>>> Use correct one - TARGET_10X_NUM_VDEVS - for 10.x firmware.
>>>
>>>
>>> You are bumping total vdevs up to 16 with that patch...have you
>>> actually tested that many?  The stock firmware has quite a bit of
>>> deficiencies in the concurrency handling, at least for stations.
>>
>> No, I have never tested it with so many. I'm running tests with 8 at
>> most. And by this patch I just aimed to support 8 VAPS we advertise in
>> iface_combinations to mac80211 (.max_interfaces = 8). I was managed to
>> get only 7 before, since 1 vdev was being allocated as monitor.
> 
> FYI: I quickly tried to extend the .max_interfaces +
> interface_combinations limit in ath10k and check with 15 VAPs (using
> hostapd, open network; on MIPS platform) and it just worked.. I did
> not perform any exploratory testing, but managed to connect a couple
> of clients to various bssids + run some sane iperf traffic etc.

Good to know that many VAPs can work...

If the OS limits are going to remain at 8, then maybe
only set the vdev mask to support 9 instead of 16
vifs to handle the monitor interface?  That should make
it easier (or at least safer) to support my firmware on
un-patched kernels...

Some of the problems with running out of resources in the
firmware (which generally just asserts or crashes in that case)
are only seen under load and/or random-ish cases
in my experience.  I'm all for pushing the firmware to the
max, but I suspect 16 vifs may not be that stable.

That said, I have only been testing multiple stations, so maybe it
will just work fine.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

