Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13678 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbXHAHVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 03:21:03 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: libertas: blows chunks on failed firmware load
Date: Wed, 1 Aug 2007 09:00:00 +0200
Cc: Andy Green <andy@warmcat.com>
References: <46AF913F.9010006@warmcat.com> <1185935705.17940.40.camel@xo-13-A4-25.localdomain> <46B01F86.5050406@warmcat.com>
In-Reply-To: <46B01F86.5050406@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708010900.00514.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 01 August 2007 07:52, Andy Green wrote:
> One of the other cheapo cards I randomly got was a Libertas
> 88W8335 PC Card, I assume I am SOL on that as well.

No, you aren't.

I published the driver into the libertas tree what handles PC 
Cards. At least mine (a compact flash based 8388), the one from 
Marcin and another guy. The driver is still extremely new, maybe 
a little bit fragile, but having people test this beast would be 
wonderful.

The error handling for firmware is a little bit better :-)   
Because the firmware format for the CF card is different to the 
one for the USB dongles, I can (actually must!) download the 
firmware before calling libertas-code. So you shouldn't get a 
kernel crash if you forgot to install the firmware 
in /lib/firmware.

However, *IF* you need the firmware, you can use the firmware 
cutter that is currently only in SVN, see 
http://projects.linuxtogo.org/scm/?group_id=24
