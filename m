Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34905 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759540AbZKFSRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 13:17:06 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 23/41] rt2x00: add driver private field to struct rt2x00_dev
Date: Fri, 6 Nov 2009 17:27:50 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <200911051952.51189.IvDoorn@gmail.com> <200911051957.06276.IvDoorn@gmail.com>
In-Reply-To: <200911051957.06276.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200911061727.50118.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 November 2009 19:57:05 Ivo van Doorn wrote:
> On Thursday 05 November 2009, Ivo van Doorn wrote:
> > On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Subject: [PATCH] rt2x00: add driver private field to struct rt2x00_dev
> > > 
> > > Enhance rt2x00 infrastructure by adding driver specific field to
> > > struct rt2x00_dev.
> > > 
> > > The new field will be used by rt2800 drivers for chipset registers
> > > access abstraction layer.
> > > 
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > 
> > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> Sorry I have a better idea, please the pointer into struct rt2x00_ops,
> that way you can assign it statically like the rest of that structure.
> That makes actually sense since all other function ops structures
> are assigned like that as well.

I thought about doing it this way initially but since:

- rt2800_ops are used by rt2800 drivers only and rt2x00dev->priv can be
  reused by other drivers for different purposes

- I couldn't come up with the good name for new rt2x00_ops field :)

I decided on the more flexible IMO for the whole rt2x00 stack solution
(however there is some minor difference between them that it can be
changed if you feel strongly about it).

-- 
Bartlomiej Zolnierkiewicz
