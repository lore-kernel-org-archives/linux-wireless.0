Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28974 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2DRKNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 06:13:37 -0400
Message-ID: <4F8E93CD.3050906@qca.qualcomm.com> (sfid-20120418_121340_994207_5710DAD2)
Date: Wed, 18 Apr 2012 13:13:33 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Configure probed SSID list consistently
References: <20120416162803.GA9671@jouni.qca.qualcomm.com>
In-Reply-To: <20120416162803.GA9671@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 07:28 PM, Jouni Malinen wrote:
> Set max_scan_ssids and max_sched_scan_ssids to same value. These use the
> same probed SSID list, so there is no point in using different maximum
> number of SSIDs.
> 
> Clear probed SSID entries that are not used. This was already done for
> sched_scan, but not for scan. Be consistent and clear the table for both
> cases to avoid leaving bogus entries.
> 
> In addition, share the same function for setting the probed SSIDs for
> scan and sched_scan paths. This fixes setting of wildcard SSID flag
> (ANY_SSID_FLAG) and changes the scan path to use probed SSID index
> consistently (i.e., start with 0 similarly to sched_scan; firmware
> will handle the needed internal mapping).
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

Thanks, applied.

Kalle
