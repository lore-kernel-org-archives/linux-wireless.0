Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56194 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbbEZNWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:22:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rndis_wlan: harmless issue calling set_bit()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150514083750.GD1665@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Joe Perches <joe@perches.com>
Message-Id: <20150526105527.B1B371416EC@smtp.codeaurora.org> (sfid-20150526_152305_744206_972AA032)
Date: Tue, 26 May 2015 10:55:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> These are used like:
> 
> 	set_bit(WORK_LINK_UP, &priv->work_pending);
> 
> The problem is that set_bit() takes the actual bit number and not a mask
> so static checkers get upset.  It doesn't affect run time because we do
> it consistently, but we may as well clean it up.
> 
> Fixes: 6010ce07a66c ('rndis_wlan: do link-down state change in worker thread')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
