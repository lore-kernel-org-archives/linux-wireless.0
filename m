Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21999 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaAPJ1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 04:27:20 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: set the AP keepalive timer
References: <1389863904-7159-1-git-send-email-yeohchunyeow@gmail.com>
Date: Thu, 16 Jan 2014 11:27:10 +0200
In-Reply-To: <1389863904-7159-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Thu, 16 Jan 2014 17:18:24 +0800")
Message-ID: <877ga0uvip.fsf@kamboji.qca.qualcomm.com> (sfid-20140116_102724_643878_0C30010C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> Set the AP keepalive timer as following:
> ap_keepalive_min_idle_inactive_time_secs to 60 seconds
> ap_keepalive_max_idle_inactive_time_secs to 120 seconds
> ap_keepalive_max_unresponsive_time_secs to 300 seconds
>
> This ensure that the WMI_PEER_STA_KICKOUT_EVENTID is triggered
> by the FW only once the unresponsive timer is expired.
>
> Tested with firmware version 999.999.0.636 but the timer
> is still default to 100 seconds. Tested with firmware 
> version 10.1.467-1, the timer is set according to 
> ap_keepalive_max_unresponsive_time_secs.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Heh, bad timing. Yesterday I implemented STA quick kickout and in that
patch I set the same parameters as you did. I just used longer values to
avoid inactivity timeouts triggering in the firmware. We have the same
functionality in hostapd, so there's no need to use the one in firmware.

I'll send my patch after lunch, please take a look at that and see if
it's ok.

-- 
Kalle Valo
