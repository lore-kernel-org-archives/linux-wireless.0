Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15541 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbDQGox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 02:44:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: use MAC clock rate same as FW uses for survey accuracy
References: <6a113cdb1b0dbbb6d98ab6b363b4912474c32bac.1428701627.git.poh@qca.qualcomm.com>
Date: Fri, 17 Apr 2015 09:44:43 +0300
In-Reply-To: <6a113cdb1b0dbbb6d98ab6b363b4912474c32bac.1428701627.git.poh@qca.qualcomm.com>
	(Peter Oh's message of "Mon, 13 Apr 2015 11:01:20 -0700")
Message-ID: <87egnj45k4.fsf@kamboji.qca.qualcomm.com> (sfid-20150417_084457_488921_92EA88BB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> WLAN survey data provides several informative values on each channels
> such as noise, active time, transmit time, and etc.
> Regarding the channel activity time data, it is reported from firmware
> in different form which is number of cycles instead of time itself.
> Hence host driver converts it to time unit by dividing it by clock rate
> that is used at baseband MAC.
>
> Using difference clock rate from that actual HW is using will result in
> inaccurate survey data. For instance, channel active time can be reported
> with bigger than 150ms even though we set Dwell time to 150ms.
> Therefore set the clock rate to 88000 (88 MHz) which is ath10k baseband
> MAC is using.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
