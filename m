Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41051 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbcANG6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 01:58:48 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
	<brcm80211-dev-list@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	LKML <linux-kernel@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] net-brcmfmac: Delete an unnecessary variable initialisation in brcmf_sdio_download_firmware()
References: <566ABCD9.1060404@users.sourceforge.net>
	<5686D2E0.2010309@users.sourceforge.net>
	<56878F52.5070308@broadcom.com>
Date: Thu, 14 Jan 2016 08:58:40 +0200
In-Reply-To: <56878F52.5070308@broadcom.com> (Arend van Spriel's message of
	"Sat, 2 Jan 2016 09:50:26 +0100")
Message-ID: <871t9kd4v3.fsf@kamboji.qca.qualcomm.com> (sfid-20160114_075913_605936_F88C916F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 01/01/2016 08:26 PM, SF Markus Elfring wrote:
>> From: Markus Elfring <elfring@users.sourceforge.net>
>> Date: Fri, 1 Jan 2016 20:20:15 +0100
>
> I think it has been said over and over, but please use driver name
> only as prefix. I don't see value to prepend it with 'net-'.

Yes, please use existing naming schemes. This time I can fix it before
I commit the patch, but in the future please use correct prefixes. It's
easy to check what has been used previously:

$ git log --oneline --no-merges --follow drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | head -10
63ce3d5db093 brcmfmac: use msecs_to_jiffies() in macro definitions
4011fc499690 brcmfmac: change brcmf_sdio_wd_timer() prototype
a7decc44a002 brcmfmac: fix waitqueue_active without memory barrier in brcmfmac driver
46d703a77539 brcmfmac: Unify methods to define and map firmware files.
64d66c30c37e brcmfmac: no retries on rxglom superframe errors
6866a64a0f9b brcmfmac: constify brcmf_bus_ops structures
05491d2ccf20 brcm80211: move under broadcom vendor directory
ff4445a8502c brcmfmac: expose device memory to devcoredump subsystem
a32be0177252 brcmfmac: include linux/atomic.h
9d6c1dc4f913 brcmfmac: add dedicated debug level for firmware console logging
$

-- 
Kalle Valo
