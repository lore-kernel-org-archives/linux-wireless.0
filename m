Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:53097 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab1HJQkl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 12:40:41 -0400
Date: Wed, 10 Aug 2011 18:40:28 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] ssb: fix DMA translation for some specific boards
Message-ID: <20110810184028.3cb9c532@milhouse> (sfid-20110810_184046_937974_A31A64DE)
In-Reply-To: <1312992688-6976-1-git-send-email-zajec5@gmail.com>
References: <1312992688-6976-1-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 10 Aug 2011 18:11:27 +0200
> +/* Some chipsets need routing known for PCIe and 64-bit DMA */
> +static bool ssb_dma_translation_special_bit(struct ssb_device *dev)
> +{
> +	u16 chip_id = dev->bus->chip_id;
> +
> +	if (dev->id.coreid == SSB_DEV_80211)
> +		return (chip_id == 0x4322 || chip_id == 43221 ||
> +			chip_id == 43231 || chip_id == 43222);
> +	return 0;
> +}

ACK, apart from this coding style violation (missing curly braces).

-- 
Greetings, Michael.
