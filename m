Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18226 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbbF3JcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 05:32:07 -0400
Date: Tue, 30 Jun 2015 12:31:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dean Lee <dean.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com,
	chris.park@atmel.com, nicolas.ferre@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH 4/6] staging: wilc1000: rework address value.
Message-ID: <20150630093147.GN28762@mwanda> (sfid-20150630_113212_301821_53D76CD8)
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
 <1435653278-5168-4-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435653278-5168-4-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL) {
> +	if (pstrHostIfSetDrvHandler->pAddress == NULL) {

In the linux kernel we do not like using 'p' to stand for pointer.  This
new name uses CamelCase.  Use scripts/checkpatch.pl to find obvious
mistakes like this.

The name "address" is too generic.  Use a meaningful name.

regards,
dan carpenter

