Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52609 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbbFIJld (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 05:41:33 -0400
Message-ID: <1433842889.1892.9.camel@sipsolutions.net> (sfid-20150609_114202_675145_19D06E37)
Subject: Re: about .dump_station() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 09 Jun 2015 11:41:29 +0200
In-Reply-To: <5576AFA2.9090004@broadcom.com>
References: <5576AFA2.9090004@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-09 at 11:19 +0200, Arend van Spriel wrote:

> I am looking in get_station() and consequently dump_station() callback 
> for our brcmfmac driver. The latter is called with index. Can I expect 
> this to be starting at 0 and iterate through or can it be requested in 
> any order.

You can expect that, yes.

If it would help, we could instead give the driver one or two pointers
to unsigned long values that start out as 0 and can be controlled
entirely by the driver?

johannes

