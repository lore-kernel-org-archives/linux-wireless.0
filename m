Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47079 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3CRLy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 07:54:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl-devel@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <mjei78@gmail.com>
Subject: Re: [PATCH] ath6kl: Fix the byte alignment rule to avoid loss of bytes in a TCP segment
References: <20130310061605.27321.89150.stgit@localhost6.localdomain6>
Date: Mon, 18 Mar 2013 13:54:53 +0200
In-Reply-To: <20130310061605.27321.89150.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Sun, 10 Mar 2013 08:16:05 +0200")
Message-ID: <87d2uw9b3m.fsf@kamboji.qca.qualcomm.com> (sfid-20130318_125502_277839_A5928D2A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Myoungje Kim <mjei78@gmail.com>
>
> Either first 3 bytes of the first received tcp segment or last one
> over MTU size file can be loss due to the byte alignment problem.
> Although ATH6KL_HTC_ALIGN_BYTES was defined for 'extra bytes for htc header
> alignment' in the patch "Fix buffer alignment for scatter-gather
> I/O"(1df94a857), there exists the bytes loss issue which means that it will be
> truncated 3 bytes in the transmitted file contents if a file which has over MTU
> size is transferred through TCP/IP stack.  It doesn't look like TCP/IP stack
> bug of 3.5 or the latest version of kernel but the byte alignment issue.  This
> patch is to use the roundup() function for the byte alignment rather than the
> predefined ATH6KL_HTC_ALIGN_BYTES.
>
> kvalo: fixed indentation
>
> Signed-off-by: Myoungje Kim <mjei78@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
