Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25348 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1KPIyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 03:54:41 -0500
Message-ID: <4EC379CD.9050105@qca.qualcomm.com> (sfid-20111116_095445_019646_ADA741DA)
Date: Wed, 16 Nov 2011 10:52:29 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix AP mode operation after interface down/up
References: <1321429894-10845-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1321429894-10845-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2011 09:51 AM, Vasanthakumar Thiagarajan wrote:
> When operating AP interface is brough down the mode is reset to
> STA. This STA will be reconfigured into AP mode when the interface
> is brought up again. This sequence will be successful only when
> change_virtual_intf() returns with no error, but there is a
> check in this callback which does the type change only when
> that interface is active. This callback does nothing more
> than saving the new interface type to vif and wdev, so the
> sanity check for interface state and wmi state is not necessary.
> This makes the AP interface functional again after interface down/up.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
