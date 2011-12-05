Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1447 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab1LEJgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 04:36:25 -0500
Date: Mon, 5 Dec 2011 15:06:05 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Inform bss information to cfg80211 before
 connect event
Message-ID: <20111205093603.GA3570@chvasanth-lnx> (sfid-20111205_103630_749240_0B02A76C)
References: <1322818619-29265-1-git-send-email-vthiagar@qca.qualcomm.com>
 <20111202114843.GC4358@jouni.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20111202114843.GC4358@jouni.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 02, 2011 at 01:48:43PM +0200, Jouni Malinen wrote:
> the issue is most likely from the BSS entry getting timed
> out and removed between the operations and the proper fix for this is to
> make sure the entry does not get removed and that should be doable
> without filling it with bogus information.

Do you mean updating aging (bss->ts) related bss information in
cfg80211?, I don't see any possibility to update this information
in bss entry from driver. The bss entry needs to protected with
bss_lock which we can't use from driver.

Vasanth
