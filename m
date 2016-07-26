Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50277 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbcGZG0X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2016 02:26:23 -0400
Subject: Re: staging: wilc1000: Reduce scope for a few variables in
 mac_ioctl()
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
References: <1c4cac35-dded-ea88-45aa-3f8ac098289d@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Steve Caldwell <Steve.Caldwell@microchip.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <d8d9729c-6d65-a901-1b29-c0b031e143d2@users.sourceforge.net> (sfid-20160726_082645_670008_4D312DC8)
Date: Tue, 26 Jul 2016 08:25:54 +0200
MIME-Version: 1.0
In-Reply-To: <1c4cac35-dded-ea88-45aa-3f8ac098289d@gmx.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> -			if (strncasecmp(buff, "RSSI", length) == 0) {
>> +			if (strncasecmp(buff, "RSSI", 0) == 0) {
>> +				s8 rssi;
>> +
> 
> Um, please think a second about if it makes any sense at all to compare 
> zero chars of two strings.

Under which circumstances should the variable "length" contain an other
value than zero?

How can this open issue be fixed better?

Regards,
Markus
