Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43322 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2BHJin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 04:38:43 -0500
Message-ID: <4F32429C.5070803@qca.qualcomm.com> (sfid-20120208_103847_436642_0AFB9B21)
Date: Wed, 8 Feb 2012 11:38:36 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Chilam Ng <chilamng@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: prioritize Tx bundling based on AC priorities
References: <1328607180-551-1-git-send-email-chilamng@qca.qualcomm.com>
In-Reply-To: <1328607180-551-1-git-send-email-chilamng@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2012 11:33 AM, Chilam Ng wrote:
> Tx bundling is the more efficient use of SDIO bus and allows more packet
> transfers with fewer bus transactions, and is a way to improve overall
> throughput. However, Tx bundling has only 4 scatter request resources available.
> When there are multiple traffic streams of different priorities, it's possible
> that lower priority traffic may hog all the scatter requests and lock out the
> higher prioirty traffic from bundling.
> Tx bundling is now enabled per AC. When an AC do a scatter request and
> the remaining scatter request resources is lower than a configurable
> threshold, it will disable Tx bundling for all AC's of lower priorities.
> When an AC has Tx bundling disabled and has no Tx bundles sent in a
> consecutive and configurable number of packets, Tx bundling will be re-enabled
> for that AC.
> 
> Signed-off-by: Chilam Ng <chilamng@qca.qualcomm.com>

Thanks, applied.

Kalle
