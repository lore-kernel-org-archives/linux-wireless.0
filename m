Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38435 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaFBSrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 14:47:09 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix vdev map size for 10.x firmware
References: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 2 Jun 2014 21:47:01 +0300
In-Reply-To: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 29 May 2014 15:36:07 +0200")
Message-ID: <87k38zxi6y.fsf@kamboji.qca.qualcomm.com> (sfid-20140602_204713_237900_3FDA21F8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Firmware 10.x supports up to 8 virtual AP interfaces
> (comparing to 7 for main firmware). Previous vdev map
> initialization was missing enough space for 8 + 1 vdevs
> (we may spent one for mac monitor), due to wrong define used.
>
> Use correct one - TARGET_10X_NUM_VDEVS - for 10.x firmware.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied to ath-current with this commit log:

commit dfa413de1e4388818f7dcdce0a90d6212e74895b
Author: Bartosz Markowski <bartosz.markowski@tieto.com>
Date:   Mon Jun 2 21:19:45 2014 +0300

    ath10k: fix 8th virtual AP interface with DFS
    
    Firmware 10.x supports up to 8 virtual AP interfaces, but in a DFS
    channel it was possible to create only 7 interfaces as ath10k internal
    creates a monitor interface for DFS. Previous vdev map initialization
    was missing enough space for 8 + 1 vdevs due to wrong define used and
    that's why there was no space for 8th interface. Use the correct define
    TARGET_10X_NUM_VDEVS with 10.x firmware to make it possible to create
    the 8th virtual interface.
    
    Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
