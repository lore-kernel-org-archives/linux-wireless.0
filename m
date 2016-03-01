Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58359 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbcCAPNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 10:13:10 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 15/15] wil6210: add oob_mode module parameter
References: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
	<1456781570-16552-16-git-send-email-qca_merez@qca.qualcomm.com>
Date: Tue, 01 Mar 2016 17:13:05 +0200
In-Reply-To: <1456781570-16552-16-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Mon, 29 Feb 2016 23:32:50 +0200")
Message-ID: <877fhmmdtq.fsf@purkki.adurom.net> (sfid-20160301_161313_377309_F9AC67CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> From: Lior David <qca_liord@qca.qualcomm.com>
>
> Add module parameter oob_mode. Takes effect the next time
> the interface is brought up and FW is loaded. Puts the FW
> in special "out of the box" (OOB) mode which is used for
> diagnostics and certification.
>
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/wil6210/main.c
> +++ b/drivers/net/wireless/ath/wil6210/main.c
> @@ -27,6 +27,10 @@ bool debug_fw; /* = false; */
>  module_param(debug_fw, bool, S_IRUGO);
>  MODULE_PARM_DESC(debug_fw, " do not perform card reset. For FW debug");
>  
> +static bool oob_mode;
> +module_param(oob_mode, bool, S_IRUGO);
> +MODULE_PARM_DESC(oob_mode, " enable OOB mode in FW");

The modparam descript doesn't really tell anything to the user, a
parameter foo_mode with help text "enable foo" is useless :) Please add
more informative message so that users have an idea what the parameter
is about, without the need to check commit logs.

-- 
Kalle Valo
