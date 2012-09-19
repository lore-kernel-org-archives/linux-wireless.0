Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:37316 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab2ISSmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 14:42:16 -0400
Message-ID: <505A1206.4020606@msgid.tls.msk.ru> (sfid-20120919_204221_734980_4B217839)
Date: Wed, 19 Sep 2012 22:42:14 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: Jarl Friis <jarl@softace.dk>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	=?ISO-8859-1?Q?G=E1bor_S?= =?ISO-8859-1?Q?tefanik?=
	<netrolller.3d@gmail.com>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] Added information about which firmware file is being
 requested.
References: <1348053493-22955-1-git-send-email-jarl@softace.dk>
In-Reply-To: <1348053493-22955-1-git-send-email-jarl@softace.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19.09.2012 15:18, Jarl Friis wrote:

> +	b43info(ctx->dev->wl, "Requesting firmware file '%s'\n", ctx->fwname);
>  	err = request_firmware(&blob, ctx->fwname, ctx->dev->dev->dev);

Hmm.  I wonder if this should be printed in request_firmware()
itself instead of in all callers?

/mjt
