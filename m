Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25505 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaFBR2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 13:28:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix vdev map size for 10.x firmware
References: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
	<87ppirz2ic.fsf@kamboji.qca.qualcomm.com>
	<CACKGw+HRLuaRX3JW86PtMzRG86024m8YOmZj14eyE9vQTffMeg@mail.gmail.com>
Date: Mon, 2 Jun 2014 20:28:12 +0300
In-Reply-To: <CACKGw+HRLuaRX3JW86PtMzRG86024m8YOmZj14eyE9vQTffMeg@mail.gmail.com>
	(Bartosz Markowski's message of "Mon, 2 Jun 2014 19:11:30 +0200")
Message-ID: <87a99vz0er.fsf@kamboji.qca.qualcomm.com> (sfid-20140602_192821_961722_F01414C3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> On 2 June 2014 18:42, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
>> So what is the actual bug you are fixing? Previously with 10.x it was
>> possible to get only 7 VIFs, even though we advertised 8 to user space,
>> and with your fix we get the full 8 VIFs?
>
> For CAC, we use one VDEV to start monitor interface. In case of 10.X
> firmware we advertise support up to 8 VAPs, but if we spent one for
> monitor interface, only 7 left. I've noticed we fail on .add_interface
> when trying to add 8th AP, here:
>
>     bit = ffs(ar->free_vdev_map);
>     if (bit == 0) {
>         ret = -EBUSY;
>         goto err;
>     }
>
> and this lead me to initialization code for vdev_map
>
>     ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
>
> We have an API split for main and 10.x firmware (incl. number of
> vdevs, target fw is able to handle), but here we missed this split.

This is a bit too technical. Basically I need a simple description of
the bug so that both kernel and distro maintainers can quicly understand
what this fix is about. Would this be correct:

"ath10k: fix 8th virtual AP interface with DFS

Firmware 10.x supports up to 8 virtual AP interfaces, but in a DFS
channel it was possible to create only 7 interfaces as ath10k internal
creates a monitor interface for DFS. Previous vdev map initialization
was missing enough space for 8 + 1 vdevs due to wrong define used and
that's why there was no space for 8th interface. Use the correct define
TARGET_10X_NUM_VDEVS with 10.x firmware to make it possible to create
the 8th virtual interface."

> Ben has a valid point, the TARGET_10X_NUM_VDEVS claims to be 16, so
> there's an inconsistency between what we adverts to mac in max
> interfaces, but I'm not sure if this is such a big deal.

I don't see that as a problem as long as we advertise 8 to user space.

>> It would be good to clear have that in the commit log so that anyone
>> can understand what bug is fixed.
>
> Do you want me to send a v2 with just an updated commit (better user
> impact description)? (No patch content changes)

I can update the commit log, we just need to agree on the content.

-- 
Kalle Valo
