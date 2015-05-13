Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37508 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001AbbEMIgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 04:36:38 -0400
Date: Wed, 13 May 2015 11:36:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gaston Gonzalez <gascoar@gmail.com>
Cc: devel@driverdev.osuosl.org, arnd@arndb.de,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	joe@perches.com, navyasri.tech@gmail.com
Subject: Re: [PATCH] staging: rtl8192u: ieee80211: Silence sparse warning
Message-ID: <20150513083615.GS14154@mwanda> (sfid-20150513_103642_648431_87A9D95F)
References: <1429476231-6197-1-git-send-email-gascoar@gmail.com>
 <20150420082441.GU10964@mwanda>
 <553C18B6.807@gmail.com>
 <20150427101242.GR14154@mwanda>
 <554AD76E.7060605@gmail.com>
 <20150508110328.GT14154@mwanda>
 <55527D6E.7090207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55527D6E.7090207@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What?  No, that patch can't work at all.  It will just oops directly
when you do:

> +    memcpy(&tx->p1k, &tkey->tx_ttak, p1k_len);

How come you didn't use my patch as a base to work from, you shouldn't
be passing tkip_ctx at all.

regards,
dan carpenter

