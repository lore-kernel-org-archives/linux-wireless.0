Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49517 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab2ALMFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 07:05:07 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20238.52557.813540.434796@gargle.gargle.HOWL> (sfid-20120112_130512_009696_B0BB3AD3)
Date: Thu, 12 Jan 2012 17:38:45 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath6kl: Initialize a variable properly
In-Reply-To: <4F0EC61C.5090608@qca.qualcomm.com>
References: <20235.48473.693136.780100@gargle.gargle.HOWL>
	<4F0EC61C.5090608@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> But there's also the same init later in the function, inside the while loop:
> 
> 		INIT_LIST_HEAD(&rx_pktq);
> 		INIT_LIST_HEAD(&comp_pktq);
> 
> Is this intentional?

I think so.

If we break out of the loop on the first iteration because of the condition
"if (id >= ENDPOINT_MAX)", then comp_pktq ends up being used without having
been initialized.

Sujith
