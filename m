Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:50083 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZCWM11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 08:27:27 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Marvell CF8381
Date: Mon, 23 Mar 2009 13:27:18 +0100
Cc: Marek Vasut <marek.vasut@gmail.com>,
	libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com> <200903220511.50229.marek.vasut@gmail.com>
In-Reply-To: <200903220511.50229.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903231327.18890.hs4233@mail.mn-solutions.de> (sfid-20090323_132730_714881_B8E43A09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -       priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
> +       priv->regioncode = (le16_to_cpu(cmd.regioncode) & 
0xFF00) >> 8;

Hmm, the change that this breaks 8385 is quite high, maybe 100
percent.

It could simply be the case that your firmware returns the value
in a different order than mine. So we either need to test for the
firmware version or for the hardware before getting the value via
one or the other method.

Maybe it's worthwhile to create some hw_is_8381() function and 
then do the things that need to be differently based on it's 
return value?



The documentation for CMG_GET_HW_SPEC that I have says

RegionCode   UINT16    Set to 0

so I see no indicator that we have two 8 bit values here. But
we've seen bugs in docs before :-)
