Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53073 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3KTI71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 03:59:27 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ath10k: add phyerr/dfs handling
References: <1384418018-4973-1-git-send-email-marek.puzyniak@tieto.com>
	<87vbzo1m6d.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 20 Nov 2013 10:59:21 +0200
In-Reply-To: <87vbzo1m6d.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 19 Nov 2013 16:49:30 +0200")
Message-ID: <87wqk3zbx2.fsf@kamboji.qca.qualcomm.com> (sfid-20131120_095930_968054_C2D64FAE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Marek Puzyniak <marek.puzyniak@tieto.com> writes:
>
>> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>
>> Handle phyerr, dfs event, radar_report and fft_report.
>> Add also debugfs dfs_simulate_radar and dfs_stats files.
>> Use ath dfs pattern detector.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> Thanks, all three applied.
>
> In the future please add a changelog when you change something in the
> patches. It's very difficult to review otherwise.

I found out _afterwards_ that these patches actually depend on some
functionality which is only in mac80211-next.git. As I do not want to
submit broken functionality to John I had to rebase ath.git and change
the patch 2:

commit e8a50f8ba44b6933b2a39b6a65528b9a4e8ba5f3
Author: Marek Puzyniak <marek.puzyniak@tieto.com>
Date:   Wed Nov 20 09:59:47 2013 +0200

    ath10k: introduce DFS implementation
    
    Configure interface combination for AP running on channels
    where radar detection is required. It allows only one type
    of interface - AP on DFS channel and limits number of AP
    interfaces to 8. Setup WMI channel flags accordingly to mac
    channel configuration. CAC based on additional monitor vdev
    is started if required for current channel.
    
    kvalo: dropped ATH10K_DFS_CERTIFIED config option as this
    the DFS still depends on few mac80211 and cfg80211 patches
    which are on mac80211-next.git right now. The config option
    will be added later once all dependencies are available.
    
    Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
    Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>


-- 
Kalle Valo
