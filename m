Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46998 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab2HNOXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 10:23:15 -0400
Message-ID: <502A5F4C.7040002@qca.qualcomm.com> (sfid-20120814_162557_023973_0AFD4C3C)
Date: Tue, 14 Aug 2012 17:23:08 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: restart concurrent vifs on failed connect
References: <1343351471-2800-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1343351471-2800-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/27/2012 04:11 AM, Thomas Pedersen wrote:
> When an ath6kl STA vif is issued a connect command, the firmware will
> disconnect all other beaconing vifs in preparation for a potential
> channel switch. The case where the connect fails is currently unhandled,
> so if a connection attempt on a STA vif fails and any vifs were waiting
> for a new channel, simply restart the concurrent vifs on their previous
> channel.
> 
> Requires that we start tracking the last issued channel in ar->last_ch,
> which is valid since ath6kl only supports 1 channel at a time.
> 
> Also clear the beaconing vif's want_ch_switch bit regardless of whether
> channel switch succeeds, to stop recommitting the same failed profile.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle
