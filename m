Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37566 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbbLHO6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:58:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH] wil6210: prevent external wmi commands during suspend flow
References: <1448350215-4202-1-git-send-email-qca_merez@qca.qualcomm.com>
Date: Tue, 08 Dec 2015 16:58:28 +0200
In-Reply-To: <1448350215-4202-1-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Tue, 24 Nov 2015 09:30:15 +0200")
Message-ID: <87bna19ecr.fsf@kamboji.qca.qualcomm.com> (sfid-20151208_155837_130086_674E4FD8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> In __wmi_send we check if fw is ready at the beginning of the function.
> While we wait for the completion of the previous command, system suspend
> can be invoked and reset the HW, causing __wmi_send to read from HW
> registers while it is not ready.
> Taking the wmi_mutex in the reset flow when setting the FW ready bit
> to zero will prevent the above race condition.
>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
