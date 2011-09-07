Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42462 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab1IGQtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 12:49:53 -0400
Message-ID: <4E671BD6.2040201@qca.qualcomm.com> (sfid-20110907_185007_411803_F2C9D073)
Date: Wed, 7 Sep 2011 10:23:02 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Avoid taking semaphore in TCMD event report handling
 func
References: <1315307155-11878-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1315307155-11878-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2011 02:05 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> ath6kl_tm_rx_report() func takes ar->sem and sends tcmd to the chip
> and then waits for wake_up event from ath6kl_tm_rx_report_event() with timeout.
> 
> In the current case, When tcmd report is reached to the host,
> ath6kl_tm_rx_report_event() func tries to take the same semaphore (ar->sem)
> which is already taken in ath6kl_tm_rx_report().
> 
> Due to this, ath6kl_tm_rx_report_event() func always fails to update
> tcmd report in the local buffer and sends wake_up event to ath6kl_tm_rx_report().
> So, the timeout will happen in ath6kl_tm_rx_report() always and
> then it will release ar->sem. Now ath6kl_tm_rx_report_event() will
> get a chance to update tcmd report in the local buffer.

This makes sense. I remember seeing something similar myself.

> There is no need of taking ar->sem in ath6kl_tm_rx_report_event(), we can go ahead
> and update the local buffer and send wake_up event to ath6kl_tm_rx_report().
> In this way, we will get tcmd report (in the user space) in the first time itself.

To me that looks racy. What will then prevent concurrent access to
ar->tm.rx_report?

Wouldn't it be better to release semaphore beforing calling
wait_event_interruptible_timeout() and then take it again after the
event has happened?

Kalle
