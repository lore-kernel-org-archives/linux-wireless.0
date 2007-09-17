Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39413 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbXIQU7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 16:59:12 -0400
Message-ID: <46EEEA9B.70407@garzik.org>
Date: Mon, 17 Sep 2007 16:59:07 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] revert ath5k ioread32()/iowrite32() usage - use readl()/writel(),  we're MMIO-only
References: <43e72e890709171334y321dc2c8ke255a126a733dad6@mail.gmail.com> <46EEE735.5050306@gmail.com>
In-Reply-To: <46EEE735.5050306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby wrote:
> NACK, this is wrong. iomap returns platform dependant return value, which may or

Incorrect.  readl() and writel() work just fine on all existing 
platforms where Atheros may be used.

If you want pci_iomap() usage removed as well, that's a fair request.

	Jeff


