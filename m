Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:59403 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbaDBFsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 01:48:55 -0400
Received: by mail-we0-f172.google.com with SMTP id t61so7376274wes.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 22:48:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87eh1gs3l7.fsf@kamboji.qca.qualcomm.com>
References: <1396015934-7723-1-git-send-email-michal.kazior@tieto.com>
	<1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
	<87eh1gs3l7.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 2 Apr 2014 07:48:53 +0200
Message-ID: <CA+BoTQmbQ0qAO-HGgwjvcZFSVom+QrX+J9pwnb-QUE4QMUBUcQ@mail.gmail.com> (sfid-20140402_074900_330062_3D75280B)
Subject: Re: [PATCH] ath10k: fix initial radar detection logic
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 April 2014 07:27, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This fixes a problem of initial radar detection
>> (CAC) being stuck and blocking Rx in some cases
>> until all interfaces were brought down.
>
> It would be good to describe more about the cases where this problem
> happened.

Ok.


>> For userspace this meant first run of hostapd
>> would perform CAC but due to filtered Rx no
>> clients would associate. Subsequent runs of
>> hostapd would not perform CAC (as it was already
>> done) and would associate clients.
>>
>> This also makes sure radar detection is performed
>> when bandwidth is widened. Before if 20MHz CAC was
>> performed then 40MHz CAC wouldn't start monitor
>> vdev effectively disabling initial radar
>> detection.
>>
>> A driver should just start/stop radar detection
>> based on hw->conf.radar_enabled. However, since
>> ath10k needs to start a monitor vdev for the
>> initial radar detection special care needs to be
>> applied.
>>
>> While at it cleanup the code a bit.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -434,6 +434,8 @@ struct ath10k {
>>       unsigned int filter_flags;
>>       unsigned long dev_flags;
>>       u32 dfs_block_radar_events;
>> +     bool radar_enabled; /* protected by conf_mutex */
>> +     int num_started_vdevs; /* protected by conf_mutex */
>
> I would prefer style like this:
>
>         u32 dfs_block_radar_events;
>
>         /* these are protected by conf_mutex */
>         bool radar_enabled;
>         int num_started_vdevs;

Ok.


>
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -489,6 +489,8 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
>>       return 0;
>>  }
>>
>> +static void ath10k_recalc_radar_detection(struct ath10k *ar);
>
> Forward declarations should be avoided if possible. Can you add a new
> patch which just moves ath10k_recalc_radar_detection() and in this patch
> you do the modifications in the function?

The we need to move ath10k_cac_start/stop and possibly a few other
functions as well. I'll check that out.


>> @@ -571,6 +576,11 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
>>               return ret;
>>       }
>>
>> +     if (WARN_ON(ar->num_started_vdevs == 0)) {
>> +             ar->num_started_vdevs--;
>> +             ath10k_recalc_radar_detection(ar);
>
> Now num_started_vdevs will be -1, what does that mean? It would be good
> to document that in struct ath10k.

Ah, it's missing "!" in front of the WARN_ON..


Michał
