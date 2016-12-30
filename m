Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35858 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754015AbcL3OfM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 09:35:12 -0500
Received: by mail-io0-f195.google.com with SMTP id m204so15938367ioe.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Dec 2016 06:35:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c3f99e7634384475b475b97ff46bec76@euamsexm01a.eu.qualcomm.com>
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
 <c3f99e7634384475b475b97ff46bec76@euamsexm01a.eu.qualcomm.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 30 Dec 2016 15:35:10 +0100
Message-ID: <CAAd0S9DcCM9XQOihZx1sVf_1=S3VvDye4k1gEMgWEmNWDaBk5Q@mail.gmail.com> (sfid-20161230_153515_284929_CDAFDEF3)
Subject: Re: [1/2] ath10k: add accounting for the extended peer statistics
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 29, 2016 at 3:11 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Christian Lamparter <chunkeey@googlemail.com> wrote:
>> The 10.4 firmware adds extended peer information to the
>> firmware's statistics payload. This additional info is
>> stored as a separate data field and the elements are
>> stored in their own "peers_extd" list.
>>
>> These elements can pile up in the same way as the peer
>> information elements. This is because the
>> ath10k_wmi_10_4_op_pull_fw_stats() function tries to
>> pull the same amount (num_peer_stats) for every statistic
>> data unit.
>>
>> Fixes: 4a49ae94a448faa ("ath10k: fix 10.4 extended peer stats update")
>> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
>
> My understanding is that I should skip this patch 1. Please let me know if
> I misunderstood. But I'm still plannning to apply patch 2.

I added Mohammed (I hope, he can reply to the open question when he
returns), Since I'm not sure what he wants or not.

As far as I'm aware, the "extended" boolean serves no purpose
because it was only used in once place in debugfs_sta which was
removed in the patch. ( "ath10k_sta_update_stats_rx_duration"
and "ath10k_sta_update_extd_stats_rx_duration" have been unified).


> Patch set to Changes Requested.
Isn't there a: "Waiting for Maintainer" state as well?
Otherwise, if nobody has any complains or question:
can you please queue it for the next merge window?

Regards,
Christian
> --
> https://patchwork.kernel.org/patch/9461631/
>
> Documentation about submitting wireless patches and checking status
> from patchwork:
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
