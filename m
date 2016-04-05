Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12572 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696AbcDEMlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 08:41:07 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH 1/3] ath10k: fix calibration init sequence of qca99x0
Date: Tue, 5 Apr 2016 12:40:57 +0000
Message-ID: <871t6kcjoo.fsf@kamboji.qca.qualcomm.com> (sfid-20160405_144115_032623_C647B4BD)
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 30 Mar 2016 21:12:29 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> pre-calibration is meant for qca4019 which contains only caldata
> whereas calibration file is used by ar9888 and qca99x0 that contains
> both board data and caldata. So by definition both pre-cal-file and
> cal-file can not coexist. Keeping them in shared memory (union), is
> breaking boot sequence of qca99x0. Fix it by storing both binaries
> in separate memories. This issue is reported in ipq8064 platform which
> includes caldata in flash memory.
>
> Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

I added the fixes line in the pending branch:

Fixes: 3d9195ea19e4 ("ath10k: incorporate qca4019 cal data download sequence")

-- 
Kalle Valo