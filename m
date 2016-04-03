Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:37837 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbcDCNSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2016 09:18:39 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Alex <alex3kov@zoho.com>
Cc: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: PROBLEM: System hang when connecting USB modem (GCT/Yota LU150)
References: <5700ED33.6020200@zoho.com>
Date: Sun, 03 Apr 2016 15:18:22 +0200
In-Reply-To: <5700ED33.6020200@zoho.com> (Alex's message of "Sun, 3 Apr 2016
	13:15:15 +0300")
Message-ID: <87h9fibzkx.fsf@nemi.mork.no> (sfid-20160403_151848_062485_A901B536)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alex <alex3kov@zoho.com> writes:

> Apr 01 11:33:24 arch kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
> Apr 01 11:33:24 arch kernel: IP: [<ffffffffa0bc62a1>] usbnet_generic_cdc_bind+0x171/0x710 [cdc_ether]
..
> Apr 01 11:33:24 arch kernel: Call Trace:
> Apr 01 11:33:24 arch kernel:  [<ffffffffa0bcf5b2>] generic_rndis_bind+0x62/0x520 [rndis_host]
> Apr 01 11:33:24 arch kernel:  [<ffffffff81499e82>] ? alloc_netdev_mqs+0x302/0x440
> Apr 01 11:33:24 arch kernel:  [<ffffffffa0bcfa83>] rndis_bind+0x13/0x20 [rndis_host]

This is most likely fixed by commit 29c6dd591bbd ("cdc-acm: fix NULL
pointer reference").  Which should defintely go into the 4.4 stable
series.  Could you please add it to your v4.4 queue, David?

Ignore the "cdc-acm" prefix. The patch fixes a NULL pointer dereference
in the cdc_ether/rndis_host drivers introduced by commit 823bd3433424
("cdc-ether: switch to common CDC parser")


Bjørn
