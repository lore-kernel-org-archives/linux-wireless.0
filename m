Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.astracom.cz ([52.28.180.220]:36265 "EHLO mx2.astracom.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754141AbdFWOFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:05:40 -0400
Received: from localhost ([127.0.0.1])
        by mx2.astracom.cz
        (using TLSv1/SSLv3 with cipher AES256-SHA (256 bits))
        for linux-wireless@vger.kernel.org;
        Fri, 23 Jun 2017 13:27:18 +0000
Received: from wondra by trosca.trosc with local (Exim 4.89)
        (envelope-from <wondra@volny.cz>)
        id 1dOOkI-00069b-9R
        for linux-wireless@vger.kernel.org; Fri, 23 Jun 2017 15:35:34 +0200
Date: Fri, 23 Jun 2017 15:35:33 +0200
From: Tomas Vondra <wondra@volny.cz>
To: linux-wireless@vger.kernel.org
Subject: ath9k does not select legacy rates in 802.11n mode
Message-ID: <20170623133533.pacb6ic2rk4id6dq@trosca.trosc> (sfid-20170623_160551_636032_7F5BF068)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list,
I am currently trying to tune my R52n ath9k minipci card for maximum performance in a high interference city environment. Mode is 802.11n in the 5 GHz band.

What I see is better download compared to an R52 ath5k in 802.11a mode, but worse upload. I suspect either that the 802.11n modulation is less robust to noise OR that AMSDU aggregation is in use and is worsening resiliency to interference. See this monitoring screenshot: https://pasteboard.co/o8ykSMG.png The first part is 802.11a, the second is 802.11n, and the third was obtained by limiting the uplink to legacy rates by:

iw dev wlan0 set bitrates legacy-5 6 9 12 18 ht-mcs-5

The problem: Unfortunately, the result of that is that only the 6 Mb/s rate is used. When I allow any ht-mcs-5 rate, none of the legacy rates is ever selected and the throughput is worse. It seems that the wandering minstrel algorithm is failing. The other side is a Mikrotik router and it freely mixes legacy and mcs rates to get optimal throughput, the Linux driver does not.
1. How would I debug this? Last time I did it in Madwifi, minstrel had some debug stats in procfs.
2. How to find out if AMSDU aggregation is in use and to disable it to see if that is the thing hurting performance?

The kernel version is 4.9.0 from Debian.

Thanks for your insights, Tomas Vondra
