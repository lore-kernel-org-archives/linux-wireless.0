Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:63971 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZKFSYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 13:24:50 -0500
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 35/41] rt2800: prepare for rt2800lib addition
Date: Fri, 6 Nov 2009 19:24:52 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173617.28463.6733.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173617.28463.6733.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911061924.52696.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> @@ -2644,6 +2658,8 @@ static int rt2800usb_probe_hw(struct rt2
>  {
>  	int retval;
>  
> +	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
> +
>  	rt2x00dev->priv = (void *)&rt2800usb_rt2800_ops;
>  
>  	/*
> 

Another afterthought, so perhaps you could make it an incremental patch.
Could you move the rt2x00_set_chip_intf() to rt2x00pci and rt2x00usb?
That way the field will be set automatically for all drivers early during probe.

Thanks,

Ivo
