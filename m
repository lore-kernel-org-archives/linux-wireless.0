Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:57550 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751075Ab3IIFvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 01:51:32 -0400
Message-ID: <1378705263.1928.7.camel@joe-AO722> (sfid-20130909_075139_778102_B9E9AE48)
Subject: Re: [PATCH] mwifiex: Remove casting the return value which is a
 void pointer
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	'David Miller' <davem@davemloft.net>,
	'Bing Zhao' <bzhao@marvell.com>
Date: Sun, 08 Sep 2013 22:41:03 -0700
In-Reply-To: <004d01cead1d$3058dcf0$910a96d0$%han@samsung.com>
References: <004d01cead1d$3058dcf0$910a96d0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-09 at 14:26 +0900, Jingoo Han wrote:
> Casting the return value which is a void pointer is redundant.
> The conversion from void pointer to any other pointer type is
> guaranteed by the C programming language.

spatch (aka: Coccinelle) should be able to find a lot
of these with:

$ cat void.cocci 
@@
void *t;
type other;
@@

-	(other *)t
+	t


