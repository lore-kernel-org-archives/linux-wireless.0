Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hevs.ch ([153.109.23.10]:50051 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYFTHJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 03:09:37 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: make mesh code configurable
Date: Fri, 20 Jun 2008 08:48:27 +0200
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200806191704.10297.hs4233@mail.mn-solutions.de>
In-Reply-To: <200806191704.10297.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806200848.28077.marc.pignat@hevs.ch> (sfid-20080620_090939_949864_AEF2A656)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On Thursday 19 June 2008, Holger Schurig wrote:
> There are no known firmwares for CF and SDIO based devices that
> support MESH. For those devices, mesh-support in the driver is just
> a bit of bloat. Moreover, they're mostly used in embedded devices,
> where space counts.
> 
> This patch saves about 10 kB in .text and 288 bytes in .data:
> 
>  129542    4012      28  133582   209ce libertas.ko
>  119279    3724      28  123031   1e097 nomesh/libertas.ko
> 
>    8142     840       0    8982    2316 libertas_cs.ko
>    8134     840       0    8974    230e nomesh/libertas_cs.ko
> 
>    9516     700       8   10224    27f0 libertas_sdio.ko
>    9516     700       8   10224    27f0 nomesh/libertas_sdio.ko
> 
>   10333     860       0   11193    2bb9 usb8xxx.ko
>   10333     860       0   11193    2bb9 nomesh/usb8xxx.ko
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Looking at the numbers, this seems a good idea.

But, looking at the code, there are so many #ifdefs!

These #ifdefs have a cost:
  * #ifdefs decrease code readability
  * every future patch should be (compile AND runtime) tested with the mesh
    code enable and disable.

IHMO, the cost versus benefits is far to high.



Best regards

Marc
