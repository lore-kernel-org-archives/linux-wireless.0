Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:36247 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaCYJiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 05:38:07 -0400
Received: by mail-ve0-f178.google.com with SMTP id jw12so219302veb.9
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 02:38:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQmNVHj-rNvVgvTx=Adq6J1kpra2qwi3Pmzh2G2Npn-jGg@mail.gmail.com>
References: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com>
	<CAEFj9867Z+x3orcwUpwjwQB-9c5r4FfAuZBHYDGZ1hNe=6Z1pA@mail.gmail.com>
	<CA+BoTQn4ji2boTV8x-owO8PbaPm510wYEKmbKqf+VS+MS+DXnQ@mail.gmail.com>
	<CAEFj9854WN5qJ4L4V1vkLeGhj=pstjoha19iJMQ8Vy-g24a66A@mail.gmail.com>
	<CA+BoTQmNVHj-rNvVgvTx=Adq6J1kpra2qwi3Pmzh2G2Npn-jGg@mail.gmail.com>
Date: Tue, 25 Mar 2014 17:38:05 +0800
Message-ID: <CAEFj984srRCqzFmzjGuE2nFLrC-V+PEgDPC-mejsZnfGH52g_Q@mail.gmail.com> (sfid-20140325_103812_035680_688D5515)
Subject: Re: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I don't think that's true for 10.1 firmware and AP interface types.

I try to play around with 10.1 firmware as AP (3 connected STAs) and I
get the following:

The first WMI_UPDATE_STATS_EVENTID as follow:
[  338.290000] ath10k: pdev 0 vdev 0 peer 3
[  338.300000] ath10k: MAC 04:f0:21:0c:a5:44
[  338.300000] ath10k: RSSI 60
[  338.300000] ath10k: Tx 1170000
[  338.310000] ath10k: Rx 1170000
[  338.310000] ath10k: MAC 04:f0:21:0c:a5:19
[  338.320000] ath10k: RSSI 64
[  338.320000] ath10k: Tx 1300000
[  338.320000] ath10k: Rx 975000
[  338.320000] ath10k: MAC 04:f0:21:0c:a5:1c
[  338.330000] ath10k: RSSI 71
[  338.330000] ath10k: Tx 975000
[  338.330000] ath10k: Rx 1300000

I think that above is correct.

The second WMI_UPDATE_STATS_EVENTID as follow:
[  338.340000] ath10k: pdev 1 vdev 0 peer 1
[  338.350000] ath10k: MAC a8:02:00:00:00:00
[  338.350000] ath10k: RSSI 0
[  338.350000] ath10k: Tx 565
[  338.360000] ath10k: Rx 0

Although indicating 1 peer, but the data seems to be not the peer
stats, not even self STA stats. Any idea?

---
Chun-Yeow
