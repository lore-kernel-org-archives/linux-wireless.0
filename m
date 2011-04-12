Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42363 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568Ab1DLVn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 17:43:26 -0400
Message-ID: <4DA4C777.4060803@openwrt.org>
Date: Tue, 12 Apr 2011 23:43:19 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?UTF-8?B?5rW36Je75pWs5LmL?= <tkaiso@thinktube.com>
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 5/7] ath5k: remove ts_retry from	ath5k_tx_status
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>	<1302453139-11437-2-git-send-email-nbd@openwrt.org>	<1302453139-11437-3-git-send-email-nbd@openwrt.org>	<1302453139-11437-4-git-send-email-nbd@openwrt.org> <1302453139-11437-5-git-send-email-nbd@openwrt.org> <4DA3F986.3070800@thinktube.com>
In-Reply-To: <4DA3F986.3070800@thinktube.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-12 9:04 AM, 海藻敬之 wrote:
> Hi,
>
> Isn't there any chance in which info->status.rates[x].count has
>    different retry-count value from the one which the firmware actually did.
>
>    For example, driver requests invalid value of retry count and firmware rejects it (take other value).
>
>    no such chance  ?
The driver will not request an invalid value, and even if it would, 
reading back the information from the control field in the descriptor 
would simply return the same value that was put in there in the first 
place. Only the retry count for the final rate in the status field 
contains useful data.

- Felix
