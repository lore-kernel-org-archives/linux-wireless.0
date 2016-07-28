Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56439 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748AbcG1LqA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 07:46:00 -0400
MIME-Version: 1.0
Message-ID: <trinity-308db848-f204-4ebe-9336-484347ffbf37-1469706334519@3capp-gmx-bs72> (sfid-20160728_134640_866494_C7A92B84)
From: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
To: "SF Markus Elfring" <elfring@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	"Steve Caldwell" <Steve.Caldwell@microchip.com>
Subject: Aw: Re: staging: wilc1000: Reduce scope for a few variables in
 mac_ioctl()
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 Jul 2016 13:45:34 +0200
In-Reply-To: <d8d9729c-6d65-a901-1b29-c0b031e143d2@users.sourceforge.net>
References: <1c4cac35-dded-ea88-45aa-3f8ac098289d@gmx.de>,
 <d8d9729c-6d65-a901-1b29-c0b031e143d2@users.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> Gesendet: Dienstag, 26. Juli 2016 um 08:25 Uhr
> Von: "SF Markus Elfring" <elfring@users.sourceforge.net>

>
> >> -			if (strncasecmp(buff, "RSSI", length) == 0) {
> >> +			if (strncasecmp(buff, "RSSI", 0) == 0) {
> >> +				s8 rssi;
> >> +
> > 
> > Um, please think a second about if it makes any sense at all to compare 
> > zero chars of two strings.
> 
> Under which circumstances should the variable "length" contain an other
> value than zero?

Which circumstances do "not any sense at all" imply? 

> 
> How can this open issue be fixed better?

The code is not too complicated and I think it is very obvious which value/variable
should be passed instead of 0. I suggest to fix this since it is indeed a bug, instead of 
doing "micro optimizations" - which is the last thing that code in the staging area 
needs (as IIRC you have already been told by others, including the staging maintainer).

Regards,
Lino


