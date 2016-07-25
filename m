Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60125 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbcGYTSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 15:18:16 -0400
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: 702302e0-0056-9fff-7bb4-f54d4a0b0afc@users.sourceforge.net
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: Re: [PATCH 3/3] staging: wilc1000: Reduce scope for a few variables
 in mac_ioctl()
Message-ID: <1c4cac35-dded-ea88-45aa-3f8ac098289d@gmx.de> (sfid-20160725_211850_651221_BCC85BA4)
Date: Mon, 25 Jul 2016 21:17:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  
> -			if (strncasecmp(buff, "RSSI", length) == 0) {
> +			if (strncasecmp(buff, "RSSI", 0) == 0) {
> +				s8 rssi;
> +

Um, please think a second about if it makes any sense at all to compare 
zero chars of two strings.

Lino
