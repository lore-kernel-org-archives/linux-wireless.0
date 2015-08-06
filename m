Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50980 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbbHFHKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 03:10:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] mwifiex: remove explicit mwifiex_complete_cmd calls
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1437117186-25243-2-git-send-email-afenkart@gmail.com>
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Andreas Fenkart <afenkart@gmail.com>
Message-Id: <20150806071026.0D62E141EF6@smtp.codeaurora.org> (sfid-20150806_091030_607560_BD2DB938)
Date: Thu,  6 Aug 2015 07:10:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> standard call chain when releasing a cmd node:
> mwifiex_recycle_cmd_node
> -> mwifiex_insert_cmd_to_free_q
> -> mwifiex_complete_cmd, if wait_q_enabled
> 
> calling mwifiex_complete_cmd explicitly and setting
> wait_q_enabled = false is redundant
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

e3a3ef25b8cb mwifiex: remove explicit mwifiex_complete_cmd calls
aeb03000837e mwifiex: remove redundant reset of cmd_wait_q status
e9f21d403699 mwifiex: remove CMD_F_CANCELED flag
c5bc15fce6aa mwifiex: simplify mwifiex_complete_cmd

Kalle Valo
