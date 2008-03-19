Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19721 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760592AbYCSTx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:28 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: store rssi as an int
Date: Wed, 19 Mar 2008 16:20:18 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803181515.15584.hs4233@mail.mn-solutions.de> <1205938267.26119.33.camel@localhost.localdomain>
In-Reply-To: <1205938267.26119.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803191620.18554.hs4233@mail.mn-solutions.de> (sfid-20080319_195438_346290_B2FCBB4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> RSSI as defined in 802.11 as a positive 8-bit value; the
> libertas firmware also reports the RSSI in scan results as a
> u8.  So I'd suggest a u8 instead of an int; an int isn't the
> right thing to do here.

"struct bss_descriptor" has nothing to do with hardware, 
otherwise you would see __le32 there. Using an "u8" saves us 
nothing, except we move all u8's at the end of the struct. But 
this would give us unaligned u8's and some processors have 
problems with that.
