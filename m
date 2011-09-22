Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42813 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1IVHrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:47:41 -0400
Message-ID: <4E7AE818.5010503@qca.qualcomm.com> (sfid-20110922_094744_446497_774817D5)
Date: Thu, 22 Sep 2011 10:47:36 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix disconnect event reporting
References: <1316534999-26990-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1316534999-26990-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2011 07:09 PM, Vasanthakumar Thiagarajan wrote:
> Driver does not report disconnect event properly when in connecting state,
> this leads to issues like not reporting the unavailablity of the
> connected AP and failures in starting reconnection. Send a disconnect
> command to target when a disconnect event is received with reason code
> other than 3 (DISCONNECT_CMD - disconnect request from host) to make the
> stop trying even after giving disconnect event. There will be one more
> disconnect event for this disconnect command which will be notified to
> cfg80211.

A similar comment in the code would be nice. It's not obvious from the
code why a separate disconnect command is needed.

Kalle
