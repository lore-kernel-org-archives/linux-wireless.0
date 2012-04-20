Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:42319 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab2DTSkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 14:40:14 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] wireless: at76c50x: allocating too much data
References: <20120420064705.GE22649@elgon.mountain>
	<CAGRGNgVgtAYknmpB_8Q0OpcUWFjTxBistG+RNs1ORDZeckGsWw@mail.gmail.com>
	<20120420091449.GI27101@mwanda>
Date: Fri, 20 Apr 2012 21:14:44 +0300
In-Reply-To: <20120420091449.GI27101@mwanda> (Dan Carpenter's message of "Fri,
	20 Apr 2012 12:14:49 +0300")
Message-ID: <87vcku9sob.fsf@purkki.adurom.net> (sfid-20120420_204021_358458_FFC1E697)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> On Fri, Apr 20, 2012 at 06:57:00PM +1000, Julian Calaby wrote:
>> > -       struct mib_local *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
>> > +       struct mib_local *m = kmalloc(sizeof(struct mib_local), GFP_KERNEL);
>> 
>> Would it be better practice to use sizeof(*m)?
>> 
>
> That was my temptation as well...  But I decided to make it match
> with the surrounding code.  I'm happy to resend if people want.

IMHO sizeof(*m) is better and I tend to use it.

Related to this: I have a bad habit of sometimes dropping '*' from
sizeof()? Is there a tool which could spot that?

-- 
Kalle Valo
