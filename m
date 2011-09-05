Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54307 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1IEJF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 05:05:59 -0400
Message-ID: <4E6490F1.2020301@qca.qualcomm.com> (sfid-20110905_110607_502503_FB901ED6)
Date: Mon, 5 Sep 2011 12:05:53 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] athk6l: Fix channel list processing in scan requests
References: <20110902170706.GA16999@jouni.qca.qualcomm.com>
In-Reply-To: <20110902170706.GA16999@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/02/2011 08:07 PM, Jouni Malinen wrote:
> Limit the length of the channel list to WMI_MAX_CHANNELS to avoid
> rejection of the request in wmi.c. Since there is not really much
> point in using a specific list of more than 32 channels, drop the
> channel list if more channels are specified and scan all channels.
> 
> Fix cfg80211 scan API use: ar->scan_req must be set only if returning
> success from scan() handler. The previous version would result in use
> of freed memory and likely kernel panic should the scan request fail
> to be sent to the target.

Thanks, applied.

Kalle
