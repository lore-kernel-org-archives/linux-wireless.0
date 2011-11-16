Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60267 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1KPSkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 13:40:08 -0500
Received: by yenq3 with SMTP id q3so1751yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 10:40:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WLQUqbWoVGC4WgGVFTUJC1i8_um4=sBU-V+NpfW57YHg@mail.gmail.com>
References: <1321445323-71774-1-git-send-email-nbd@openwrt.org>
	<1321445323-71774-2-git-send-email-nbd@openwrt.org>
	<CAB=NE6XOz9p=GwQWZ3TibMMan70QO7dXgVRP4PLuV6p=P1-RXA@mail.gmail.com>
	<A6331C99-8D86-4CD6-88F2-123B38F31B26@nbd.name>
	<CAB=NE6WLQUqbWoVGC4WgGVFTUJC1i8_um4=sBU-V+NpfW57YHg@mail.gmail.com>
Date: Wed, 16 Nov 2011 10:40:07 -0800
Message-ID: <CAMcMvsjsCzDH6hpS6Bon-5Zrad5eNf41Zq0ei_iw+MFK41rF=w@mail.gmail.com> (sfid-20111116_194012_785911_D4B63DFD)
Subject: Re: [PATCH 2/4] ath9k: rework power state handling
From: Paul Stewart <pstew@google.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Felix Fietkau <nbd@nbd.name>, Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In fact, could this be made contingent on whether there's an AP-mode
interface, since the problem you're encountering seems to only be in
AP mode?  What troubles me, Felix, is your statement that " this
series fixes some "PCI error" crashes".  Does this mean that you
haven't root-caused the problem, and that this may only partially mask
it?

--
Paul

On Wed, Nov 16, 2011 at 10:23 AM, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:
> On Wed, Nov 16, 2011 at 10:16 AM, Felix Fietkau <nbd@nbd.name> wrote:
>> On 16.11.2011, at 18:42, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com> wrote:
>>
>>> On Wed, Nov 16, 2011 at 4:08 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>> Turning off the radio when mac80211 tells the driver that it's idle is not
>>>> a good idea, as idle interfaces might still occasionally scan or send packets.
>>>> The only time the radio can be safely turned off is when drv_stop has been
>>>> called. In the mean time, use sc->ps_idle only to indicate network sleep vs
>>>> full sleep.
>>>> Move the LED GPIO changes out of the PCI suspend/resume path, the start/stop
>>>> functions already take care of that.
>>>>
>>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>
>>> This set of patches are going to need some good amount of testing for
>>> power impact. The benefits and gains need to be considered. I'll yield
>>> to Senthil and Paul for final approval on this.
>>
>> One of the gains is that this series fixes some "PCI error" crashes
>> on OpenWrt during hostapd restarts.
>
> Thanks for the clarification, I was expecting this to be the case, the
> point I am trying to make though is that this "fix" itself may
> introduce a regression for non-AP devices, specifically in terms of
> power consumption and I'd like the stakeholders who do care about that
> to review these changes carefully as well. The difficulty will be to
> find a reasonable middle ground.
>
>  Luis
>
