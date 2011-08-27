Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3300 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1H0KLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 06:11:36 -0400
Date: Sat, 27 Aug 2011 15:41:49 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: stop tx before doing hw config and rate update
Message-ID: <20110827101147.GA8372@vmraj-lnx.users.atheros.com> (sfid-20110827_121145_869699_EE612244)
References: <1313417839-3617-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1313417839-3617-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 15, 2011 at 07:47:19PM +0530, Rajkumar Manoharan wrote:
> The assumption is that during the hw config, transmission was
> already stopped by mac80211. But during channel type change,
> the mac80211 continue to transmit frames. The driver like ath9k
> does chip reset while doing channel set. This could leads to
> buffer overflow at driver side. And also after setting the channel
> at driver side and before calling rate updation, the frames are
> continued to xmit with older rates. This patch ensures that
> the frames are always xmitted with updated rates and avoid buffer
> overflow.
> 
Any comments are welcome

--
Rajkumar
