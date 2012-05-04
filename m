Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48958 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab2EDSvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 14:51:31 -0400
Message-ID: <4FA4250A.3080609@qca.qualcomm.com> (sfid-20120504_205134_679622_6215DF38)
Date: Fri, 4 May 2012 21:50:50 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl_sdio: Fix the EAPOL out of order issue
References: <1335950725-15597-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1335950725-15597-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2012 12:25 PM, Vivek Natarajan wrote:
> Send the EAPOL and management frames in the same AC_VO queue. The issue
> happens when the AP supports QOS, the management frames are sent to AC_VO
> queue and EAP frame goes to AC_BE queue. Even though the EAP frame is
> queued before the DEAUTH management frame, as they are queued on different
> h/w queues, order of delivery between these frames cannot be controlled.
> 
> This fixes the connection failure seen in P2P case.
> 
> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>

Thanks, applied.

Kalle
