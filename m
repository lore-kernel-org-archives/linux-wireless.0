Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab2H1Mmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 08:42:50 -0400
Date: Tue, 28 Aug 2012 14:42:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <dgolle@allnet.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	users@rt2x00.serialmonkey.com, gwingerde@gmail.com,
	heinold@inf.fu-berlin.de
Subject: Re: [PATCH v2] rt2x00: add MediaTek/RaLink Rt3352 WiSoC
Message-ID: <20120828124214.GA8426@redhat.com> (sfid-20120828_144303_208214_11D0AFBC)
References: <20120821235349.GA14648@earthship.home>
 <20120822105110.GC6082@redhat.com>
 <20120824152542.GA32145@earthship.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120824152542.GA32145@earthship.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Fri, Aug 24, 2012 at 06:25:42PM +0300, Daniel Golle wrote:
> On Wed, Aug 22, 2012 at 12:51:10PM +0200, Stanislaw Gruszka wrote:
> > Please address my comments from previous patch.
> 
> I fixed the CodingStyle issues you mentioned and simplified the initilization of
> the TX_SW_CFG{0,1,2} registers similarly to other SoCs.

Thanks. Could you also provide information what was the source
(registers programming) you based when writing this patch?

> +	if (rt2x00_rt(rt2x00dev, RT3352)) {
> +		rt2800_bbp_write(rt2x00dev, 27, 0x0);
> +		rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);
> +		rt2800_bbp_write(rt2x00dev, 27, 0x20);
> +		rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);

Writes two times to the same registers are intended?

Stanislaw
