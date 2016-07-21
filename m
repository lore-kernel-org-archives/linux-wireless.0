Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43374 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099AbcGUOz0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 10:55:26 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: [PATCH] mwifiex: fix large amsdu packets causing firmware hang
Date: Thu, 21 Jul 2016 14:55:22 +0000
Message-ID: <bed5a4d11d1e4a83811785237c5b90c9@SC-EXCH04.marvell.com> (sfid-20160721_165530_650293_EAF4C12E)
References: <1469098824-8031-1-git-send-email-akarwar@marvell.com>
 <8737n39hdl.fsf@purkki.adurom.net>
In-Reply-To: <8737n39hdl.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Kalle Valo
> Sent: Thursday, July 21, 2016 8:19 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam
> Subject: Re: [PATCH] mwifiex: fix large amsdu packets causing firmware
> hang
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: Cathy Luo <cluo@marvell.com>
> >
> > Sometimes host prepares and downloads a large amsdu packet to firmware
> > which leads to a memory corruption in firmware.
> > The reason is __dev_alloc_skb() may allocate larger buffer than
> > required size. This patch solves the problem by checking "adapter-
> >tx_buf_size"
> > instead of relying on skb_tailroom().
> >
> > Signed-off-by: Cathy Luo <cluo@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> Should this go to 4.8 as an important fix?
> 

Yes. Please.

Regards,
Amitkumar.
