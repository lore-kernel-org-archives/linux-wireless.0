Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:41667 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757055Ab2AEKnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 05:43:17 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 02062-09 for <linux-wireless@vger.kernel.org>;
 Thu,  5 Jan 2012 10:43:11 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 5/6] ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump() into functions
Date: Thu, 5 Jan 2012 10:41:28 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AF2F@saturn3.aculab.com> (sfid-20120105_114331_613132_27506D22)
In-Reply-To: <1325720472.4116.7.camel@joe2Laptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Joe Perches" <joe@perches.com>,
	"Kalle Valo" <kvalo@qca.qualcomm.com>
Cc: <linville@tuxdriver.com>, <sfr@canb.auug.org.au>,
	<netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
	<ath6kl-devel@qualcomm.com>, <davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> > +	va_start(args, fmt);
> > +	ath6kl_printk(KERN_DEBUG, fmt, &args);
> 
> Passing a va_list as an argument?
> I believe this doesn't work.
> I think you'll need to add and use:

Passing a va_list certainly does work - vprintf() etc.
What is problematical is taking the address of a va_list.

The likely problem is a 'levels of indirection' one
because, when va_list needs to be a struct (very
likely when arguments are passed in registers),
it is often declared as as array type.

	David


