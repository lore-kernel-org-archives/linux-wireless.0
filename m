Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7878 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbbGXLJx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 07:09:53 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH 3/4] mwifiex: remove CMD_F_CANCELED flag
Date: Fri, 24 Jul 2015 11:09:49 +0000
Message-ID: <e39a5c966cd745398c2710ed02ccbe44@SC-EXCH04.marvell.com> (sfid-20150724_130956_383356_E4100152)
References: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
 <1437117186-25243-4-git-send-email-afenkart@gmail.com>
In-Reply-To: <1437117186-25243-4-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

> From: Andreas Fenkart [mailto:afenkart@gmail.com]
> Sent: Friday, July 17, 2015 12:43 PM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Kalle Valo; Andreas Fenkart
> Subject: [PATCH 3/4] mwifiex: remove CMD_F_CANCELED flag
> 
> CMD_F_CANCELED was used to abort mwifiex_process_cmdresp in case it
> already started or starts processing the cmd.
> But this was probably not working the way intended:
> - it is racy: mwifiex_process_cmdresp might already have passed that
>   test and is continuing to use the cmd node being recycled
> - mwifiex_process_cmdresp repeatedly uses adapter->curr_cmd which
>   we just set to NULL
> - mwifiex_recycle_cmd_node will clear the flag
> 
> The reason why it probably works is that mwifiex_cancel_pending_ioctl is
> only called from mwifiex_cmd_timeout_func, where the there is little
> chance of a command response still arriving
> 

You are right. Command timeout handler is called when there is no response from firmware for 10 seconds. If firmware is alive and working, we would have received command response within a  millisecond. So there is very little chance of command response arriving while executing command timeout handler.

Regards,
Amit
