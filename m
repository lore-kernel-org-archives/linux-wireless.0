Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52623 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1H3Oao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 10:30:44 -0400
Date: Tue, 30 Aug 2011 17:30:39 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 08/20] ath6kl: Request P2P capabilities during target init
Message-ID: <20110830143039.GE8163@jouni.qca.qualcomm.com> (sfid-20110830_163048_392151_D39B9B35)
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
 <1314620641-24257-9-git-send-email-jouni@qca.qualcomm.com>
 <4E5CB2B9.1090606@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E5CB2B9.1090606@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 03:21:53PM +0530, Raja Mani wrote:
> On Monday 29 August 2011 05:53 PM, Jouni Malinen wrote:
> >+	ret = ath6kl_wmi_info_req_cmd(ar->wmi, P2P_FLAG_CAPABILITIES_REQ |
> >+				      P2P_FLAG_MACADDR_REQ |
> >+				      P2P_FLAG_HMODEL_REQ);
> >+	if (ret) {
> >+		printk(KERN_DEBUG "ath6l: Failed to request P2P capabilities "
> >+		       "(%d) - assuming P2P not supported\n", ret);
> 
> Is it possible to use ath6kl_dbg() instead of printk here ?

Sure.

> Should it be ath6kl_err() ?
> 
> Another question is , Don't you have to assign error code (may be
> -EIO) to 'status' variable in case of error ? not sure whether error
> code assignment needed here or not..

No, this is not a fatal error. The driver will just run without P2P
support if the firmware does not support the new P2P commands. I'm not
yet sure what will be the exact mechanism for doing this, i.e., this may
be done either based on the firmware version or the result of this
command. Though, it should be noted that the target returns the
capabilities with a separate event message, so we would need to block
somehow during hardware init to have the information available for
cfg80211 registration. Anyway, the patch to actually start advertising
support for P2P is not included in the patch series.

-- 
Jouni Malinen                                            PGP id EFC895FA
