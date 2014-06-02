Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:59426 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaFBRLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 13:11:32 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so5572194wev.31
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2014 10:11:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ppirz2ic.fsf@kamboji.qca.qualcomm.com>
References: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
	<87ppirz2ic.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 2 Jun 2014 19:11:30 +0200
Message-ID: <CACKGw+HRLuaRX3JW86PtMzRG86024m8YOmZj14eyE9vQTffMeg@mail.gmail.com> (sfid-20140602_191135_637902_33642514)
Subject: Re: [PATCH] ath10k: fix vdev map size for 10.x firmware
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 June 2014 18:42, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> Firmware 10.x supports up to 8 virtual AP interfaces
>> (comparing to 7 for main firmware). Previous vdev map
>> initialization was missing enough space for 8 + 1 vdevs
>> (we may spent one for mac monitor), due to wrong define used.
>>
>> Use correct one - TARGET_10X_NUM_VDEVS - for 10.x firmware.
>>
>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>
> So what is the actual bug you are fixing? Previously with 10.x it was
> possible to get only 7 VIFs, even though we advertised 8 to user space,
> and with your fix we get the full 8 VIFs?

For CAC, we use one VDEV to start monitor interface. In case of 10.X
firmware we advertise support up to 8 VAPs, but if we spent one for
monitor interface, only 7 left. I've noticed we fail on .add_interface
when trying to add 8th AP, here:

    bit = ffs(ar->free_vdev_map);
    if (bit == 0) {
        ret = -EBUSY;
        goto err;
    }

and this lead me to initialization code for vdev_map

    ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;

We have an API split for main and 10.x firmware (incl. number of
vdevs, target fw is able to handle), but here we missed this split.

Ben has a valid point, the TARGET_10X_NUM_VDEVS claims to be 16, so
there's an inconsistency between what we adverts to mac in max
interfaces, but I'm not sure if this is such a big deal.

> It would be good to clear have that in the commit log so that anyone can
> understand what bug is fixed.

Do you want me to send a v2 with just an updated commit (better user
impact description)? (No patch content changes)

-Bartosz
