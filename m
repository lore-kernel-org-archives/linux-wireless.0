Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60678 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbYIDBoZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 21:44:25 -0400
Subject: Re: [PATCH] p54usb: support LM87 firmwares
From: Pavel Roskin <proski@gnu.org>
To: Christian Lamparter <chunkeey@web.de>
Cc: Tomas Winkler <tomasw@gmail.com>, linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200809030200.50745.chunkeey@web.de>
References: <200809022139.12969.chunkeey@web.de>
	 <1ba2fa240809021614t4dfb1422sa82efeae8869ff6b@mail.gmail.com>
	 <200809030200.50745.chunkeey@web.de>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 21:44:22 -0400
Message-Id: <1220492662.7700.21.camel@dv> (sfid-20080904_034429_392088_26FF85C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-03 at 02:00 +0200, Christian Lamparter wrote:

> whats the main difference between be32_to_cpu vs be32_to_cpus vs be32_to_cpup?
> Does the extra p just stand for something like "pointer"?

Yes.  See include/linux/byteorder/generic.h
> 
> hmm,
> if yes, >>*<<(__be32 *)bootrec->data.
> if no, please tell me more about it ;-). 

The pointer versions take the pointer.  They do the cast and the
dereference for you.  The cast in your code should be unnecessary.

The in-situ version don't return anything; they put the result into the
original variable.

-- 
Regards,
Pavel Roskin
