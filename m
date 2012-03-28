Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19063 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612Ab2C1Niz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 09:38:55 -0400
Message-ID: <4F73146A.7000308@qca.qualcomm.com> (sfid-20120328_153902_570360_146CC674)
Date: Wed, 28 Mar 2012 16:38:50 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Store scan request info in-advance before sending
 SCAN request
References: <1332940835-14933-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1332940835-14933-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2012 04:20 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> In current code, Scan request info is recorded in vif->scan_req
> after sending SCAN request to the firmware in ath6kl_cfg80211_scan().
> 
> In some corner cases, firmware sends SCAN_COMPLETE event immediately
> when it receives SCAN request, which internally executes scan
> complete event handler ath6kl_cfg80211_scan_complete_event() first.
> So, Scan completion handler will a get a chance to executed even
> before storing scan request info in ath6kl_cfg80211_scan().
> 
> Scan completion handler never report SCAN_COMPLETE event to
> cfg80211 if scan request info(vif->scan_req) is NULL. This leads
> to scan failure issue ("Device or resource busy error") during
> next SCAN request from the user space. This patch ensures that scan
> request info is stored before sending SCAN request.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, applied.

Kalle
