Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56816 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2CGHf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 02:35:56 -0500
Message-ID: <4F570FD6.3080906@qca.qualcomm.com> (sfid-20120307_083600_655096_BBDA2694)
Date: Wed, 7 Mar 2012 09:35:50 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v3] ath6kl: Check wow state before sending control and
 data pkt
References: <1331100304-15903-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1331100304-15903-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2012 08:05 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Below two scenarios are taken care in this patch which helped
> to fix the firmware crash during wow suspend/resume.
> 
> * TX operation (ctrl tx and data tx) has to be controlled based
>   on suspend state. i.e, with respect to WOW mode, control packets
>   are allowed to send from the host until the suspend state goes
>   ATH6KL_STATE_WOW and the data packets are allowed until WOW
>   suspend operation starts.
> 
> * Similarly, wow resume is NOT allowed if WOW suspend is in progress.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, applied.

I had a small conflict in ath6kl_cfg80211_suspend(). Please check that I
didn't break anything.

Kalle
