Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44831 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaBRS1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 13:27:41 -0500
Date: Tue, 18 Feb 2014 21:27:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
Subject: Re: [PATCH 3/7] rtl818x: check for pci_map_single() success when
 initializing RX ring
Message-ID: <20140218182714.GO26776@mwanda> (sfid-20140218_192746_168941_09E05CCA)
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
 <1392685846-10116-4-git-send-email-andrea.merello@gmail.com>
 <20140218093135.GJ26776@mwanda>
 <CAN8YU5N=_-9hVZc+6sW5xrwmybQ_aTLAMFODzyuGk0g97OV6Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN8YU5N=_-9hVZc+6sW5xrwmybQ_aTLAMFODzyuGk0g97OV6Gg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I guess what I was going to suggest is that you are overthinking the
error handling.  Your code tries very hard to allocate 32 buffers.  But
I bet it's just a matter of allocating the buffers and if it doesn't
work then clean up and return an error.  Probably it alocates 32 buffers
successfully or it doesn't allocate any, it's less likely that we will
allocate a partial number of buffers.

If this were in the receive path or something like that then maybe we
would worry about situations like that.  Although even in that case
probably the right approach would be to drop everything and let the
protocol handle the error...  Offtopic.  What I mean is that this is in
the init path so everything will likely work except in manufactured
situations.

regards,
dan carpenter

