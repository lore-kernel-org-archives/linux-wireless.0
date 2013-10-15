Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48092 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874Ab3JOQQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 12:16:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/7] ath10k: fix scheduling while atomic bug
References: <20131015161434.21869.51150.stgit@localhost6.localdomain6>
Date: Tue, 15 Oct 2013 19:16:11 +0300
In-Reply-To: <20131015161434.21869.51150.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Tue, 15 Oct 2013 19:14:34 +0300")
Message-ID: <87zjqabjck.fsf@kamboji.qca.qualcomm.com> (sfid-20131015_181619_986907_684D2FAC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Michal Kazior <michal.kazior@tieto.com>
>
> Recent WMI/HTC changes made it possible for WMI
> commands to sleep (if there's not enough HTC TX
> credits to submit a command). TX path is in an
> atomic context so calling WMI commands in it is
> wrong.
>
> This simply moves WEP key index update to a worker
> and fixes the 'scheduling while atomic' bug.
>
> This still leaves multiple WEP key handling laggy,
> i.e. some frames may be TXed with an old/different
> key (although recipient should still be able to RX
> them).
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Please ignore, I sent this accidentally too early.

-- 
Kalle Valo
