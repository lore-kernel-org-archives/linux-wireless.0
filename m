Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35896 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759643AbZCYQcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 12:32:35 -0400
Date: Wed, 25 Mar 2009 18:32:25 +0200
From: Jouni Malinen <j@w1.fi>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Optional IEs into scan request
Message-ID: <20090325163225.GA28509@jm.kir.nu> (sfid-20090325_173249_908415_C1606549)
References: <20090213105306.GA18754@jm.kir.nu> <1234522804.4219.13.camel@johannes.local> <20090213111523.GA22438@jm.kir.nu> <1ba2fa240902150509i5df08adcg214901548d3cd538@mail.gmail.com> <20090215154408.GA6845@jm.kir.nu> <1ba2fa240902151240v3bbe2885l4ef4d90e5d78b0a7@mail.gmail.com> <1ba2fa240903250838qab8acb1v3abffe06c5384d13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240903250838qab8acb1v3abffe06c5384d13@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 05:38:11PM +0200, Tomas Winkler wrote:

> After reading the WPS spec again and specifically the section 10.3
> that talks about PBC, it looks like for PBC you will need to have the
> WPS IE in the Probe request for it to function correctly. So it
> doesn't look optional to mee
> 
> The WPS IE in the Probe Request will indicate that the device is in
> PBC mode. The WPS IE is also used for Registrars to see if multiple
> requests were received within the PBC Monitor time.

It is not ideal to work without including the WPS IE in Probe Request,
but the Registrar should be able to do similar detection for session
overlap using M1. If you want something better, all you need to do is to
move from using WEXT to nl80211.. ;-)

The spec is somewhat unclear on this, but there are couple of places
which indicate that the WPS IE may not always be included in Probe
Request (e.g., APs must not reject WPS based on missing WPS IE in Probe
Request).

-- 
Jouni Malinen                                            PGP id EFC895FA
