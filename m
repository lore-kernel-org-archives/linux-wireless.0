Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48754 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbbEHN2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 09:28:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brent Taylor <motobud@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath6kl@lists.infradead.org
Subject: Re: [PATCH 1/1] ath6kl: Fix multiple clients associating in AP mode
References: <CAP+RiCDFH-=MqRZLtrjUEyShgw5V2KV-6FnMWe2crB1QqJyh2Q@mail.gmail.com>
Date: Fri, 08 May 2015 16:28:23 +0300
In-Reply-To: <CAP+RiCDFH-=MqRZLtrjUEyShgw5V2KV-6FnMWe2crB1QqJyh2Q@mail.gmail.com>
	(Brent Taylor's message of "Tue, 5 May 2015 18:49:24 -0500")
Message-ID: <87egmrp5ag.fsf@kamboji.qca.qualcomm.com> (sfid-20150508_152845_792119_6AEBE7C4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brent Taylor <motobud@gmail.com> writes:

> When one client is associated and connected to an ar6003 hw version
> 2.0 with firmware 3.1.1.149, and another client tries to connect, the
> first client's MAC address is lost in the station list because the
> "aid" is always "1".  The structure "wmi_connect_event" has the "aid"
> as the second byte in the message, but it should be the first byte.
>
> This patch has been tested with linux-3.10.40, and should apply
> cleanly to linux-4.1-rc1
>
> Signed-off-by: Brent Taylor <motobud@gmail.com>

Odd, I don't see your patch in patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/

> --- a/drivers/net/wireless/ath/ath6kl/wmi.h     2015-05-05
> 18:30:14.767029624 -0500
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h     2015-05-05
> 18:30:21.359031473 -0500

Ok, this looks broken and most likely the reason why it's not in
patchwork. Can you please resend and make sure that patchwork sees the
patch? It's best to use git-send-email to submit patches.

-- 
Kalle Valo
