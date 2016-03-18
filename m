Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51176 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbcCRHxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 03:53:08 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH v5] ath10k: move mgmt descriptor limit handle under
 mgmt_tx
Date: Fri, 18 Mar 2016 07:53:00 +0000
Message-ID: <87egb8i5no.fsf@kamboji.qca.qualcomm.com> (sfid-20160318_085313_053513_97D8FC42)
References: <1457535346-16159-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1457535346-16159-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 9 Mar 2016 20:25:46 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Frames that are transmitted via MGMT_TX are using reserved descriptor
> slots in firmware. This limitation is for the htt_mgmt_tx path itself,
> not for mgmt frames per se. In 16 MBSSID scenario, these reserved slots
> will be easy exhausted due to frequent probe responses. So for 10.4
> based solutions, probe responses are limited by a threshold (24).
>
> management tx path is separate for all except tlv based solutions. Since
> tlv solutions (qca6174 & qca9377) do not support 16 AP interfaces, it is
> safe to move management descriptor limitation check under mgmt_tx
> function. Though CPU improvement is negligible, unlikely conditions or
> never hit conditions in hot path can be avoided on data transmission.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo