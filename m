Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54612 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYJOUQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 16:16:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 13:16:29 -0700
Date: Wed, 15 Oct 2008 06:16:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081015131622.GH6509@tesla> (sfid-20081015_221634_140008_93FF1964)
References: <1224018957.3027.9.camel@johannes.berg> <20081014211912.GF3349@tuxdriver.com> <1224019662.3027.13.camel@johannes.berg> <1224085609.4764.18.camel@californication> <1224086374.735.4.camel@johannes.berg> <1224091577.28173.9.camel@californication> <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com> <1224092868.28173.21.camel@californication> <20081015112517.GF6509@tesla> <1224098748.28173.32.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224098748.28173.32.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 12:25:48PM -0700, Marcel Holtmann wrote:
> > The problem here is not this though the problem here is the case
> > where people are using 2.6.28 without no iw or crda *and* have more
> > than two cards :)
> 
> it might sound like an unlikely case and it will most likely only be the
> A-band usage anyway, but it is a valid case. People with old laptops do
> use newer wireless cards in PCMCIA or USB form factor to get better WiFi
> performance and/or stability. In some cases you can just replace your
> internal card, but with the switch from MiniPCI to half-MiniPCI this is
> not as likely anymore. So the use of a second external card becomes more
> likely.

Right, and the proposed solution I had was to use an intersection
between two regulatory domains. This solution just doesn't currently
work well with Intel cards due to the capability <-> regulatory one to
one mapping.

> I am still for the first card wins concept when no CRDA is present or
> the userspace just doesn't know about setting the regulatory domain.
> However we should have it separated for each band to not lock some
> people out who have no clue on why they now loose the 5 GHz band.

Sure.

  Luis
