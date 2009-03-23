Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44923 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759444AbZCWQRo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:17:44 -0400
Subject: Re: [PATCH] Marvell CF8381
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	Marek Vasut <marek.vasut@gmail.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200903231327.18890.hs4233@mail.mn-solutions.de>
References: <200903220127.21836.marek.vasut@gmail.com>
	 <200903220511.50229.marek.vasut@gmail.com>
	 <200903231327.18890.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 12:15:27 -0400
Message-Id: <1237824927.14758.20.camel@localhost.localdomain> (sfid-20090323_171801_649155_384AF803)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-03-23 at 13:27 +0100, Holger Schurig wrote:
> > -       priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
> > +       priv->regioncode = (le16_to_cpu(cmd.regioncode) & 
> 0xFF00) >> 8;
> 
> Hmm, the change that this breaks 8385 is quite high, maybe 100
> percent.

The cf8385-5.0.16.p0-26306 (gumstix) driver has:

	Adapter->RegionCode = wlan_le16_to_cpu(hwspec->RegionCode) >> 8;

So it appears there's precedent for this even on 8385 parts.

Dan

> It could simply be the case that your firmware returns the value
> in a different order than mine. So we either need to test for the
> firmware version or for the hardware before getting the value via
> one or the other method.
> 
> Maybe it's worthwhile to create some hw_is_8381() function and 
> then do the things that need to be differently based on it's 
> return value?
> 
> 
> 
> The documentation for CMG_GET_HW_SPEC that I have says
> 
> RegionCode   UINT16    Set to 0
> 
> so I see no indicator that we have two 8 bit values here. But
> we've seen bugs in docs before :-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

