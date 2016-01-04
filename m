Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41727 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcADJig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 04:38:36 -0500
Date: Mon, 4 Jan 2016 12:38:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/3] rsi: Delete unnecessary variable initialisations in
 rsi_send_mgmt_pkt()
Message-ID: <20160104093829.GE5284@mwanda> (sfid-20160104_103855_554320_4B218D89)
References: <566ABCD9.1060404@users.sourceforge.net>
 <5687E169.4070704@users.sourceforge.net>
 <5687E203.1070404@users.sourceforge.net>
 <20160104092857.GD5284@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160104092857.GD5284@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Btw, GCC misses a lot of uninitialized variable bugs.  I have a Smatch
check which sometimes catches the bugs that GCC misses but you should
not rely on the tools here.  These patches need to be reviewed manually.

And the "goto err" before the initialization makes everything more
complicated (that's actually what caused the bug in this patch, in fact).

regards,
dan carpenter

