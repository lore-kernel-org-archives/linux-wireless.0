Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34875 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbbHQOr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 10:47:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: refactor phyerr event handlers
References: <1439473033-14724-1-git-send-email-rmani@qti.qualcomm.com>
Date: Mon, 17 Aug 2015 17:47:19 +0300
In-Reply-To: <1439473033-14724-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Thu, 13 Aug 2015 19:07:12 +0530")
Message-ID: <87egj2dlag.fsf@kamboji.qca.qualcomm.com> (sfid-20150817_164729_459140_A429EC85)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> Existing phyerr event handlers directly uses phyerr header format
> (ie, struct wmi_phyerr and struct wmi_phyerr_event) in the code
> exactly on how firmware packs it. This is the problem in 10.4 fw
> specific phyerr event handling where it uses different phyerror
> header format. Before adding 10.4 specific handler, little bit of
> refactor is done in existing phyerr handlers.
>
> Two new abstracted structures (struct wmi_phyerr_ev_hdr_arg and
> struct wmi_phyerr_ev_arg) are introduced to remove dependency of using
> firmware specific header format in the code. So that firmware specific
> phyerror handlers can populate values to abstracted structures and
> the following code can use abstracted struct for further operation.
>
> .pull_phyerr_hdr is added newly to pull common phyerr header info
> like tsf, buf_len, number of phyerr packed. Existing .pull_phyerr
> handler is changed and called to parse every sub phyerrs in the event.
>
> Validated these refactoring on qca988x hw2.0 using fw 10.2.4 version.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Thanks, both applied.

-- 
Kalle Valo
