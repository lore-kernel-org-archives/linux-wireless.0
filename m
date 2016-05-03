Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36839 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbcECUDn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 16:03:43 -0400
Message-ID: <1462305820.10444.14.camel@sipsolutions.net> (sfid-20160503_220402_146462_249B39BA)
Subject: Re: dynamic ps + offchannel mgmt_tx + HW RoC
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 May 2016 22:03:40 +0200
In-Reply-To: <CABPxzYL9ezhovark83mnSVkh7H3XQJjNU+XjvEHdMses6N3FBA@mail.gmail.com> (sfid-20160503_215028_390679_45C6B6FE)
References: <CABPxzYLtu53V79O--eDJEdRfn-zw3Wq9Po04F=uFp_FrfJjuiA@mail.gmail.com>
	 <1462281243.2251.2.camel@sipsolutions.net>
	 <CABPxzYJjRMMaUn+zzpzm8Zv8XAn8nfA8FgMTr7bkZve3XWs8ow@mail.gmail.com>
	 <CABPxzYKj-0kaBP6BYQvcTYZtaTTbtc0nR-=69qC9eCDDJoXxaA@mail.gmail.com>
	 <1462291262.2251.4.camel@sipsolutions.net>
	 <CABPxzY+JXre1SzGyqmwYhTw9BB_-PfR02basW0WS34wZKpxK7g@mail.gmail.com>
	 <CALhHN=pxE2+dHxKLvsdWDt7fZ-FwYSUzps6hWB9m7dmZbFytgg@mail.gmail.com>
	 <1462304144.10444.13.camel@sipsolutions.net>
	 <CABPxzYL9ezhovark83mnSVkh7H3XQJjNU+XjvEHdMses6N3FBA@mail.gmail.com>
	 (sfid-20160503_215028_390679_45C6B6FE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-05-04 at 01:20 +0530, Krishna Chaitanya wrote:
> On Wed, May 4, 2016 at 1:05 AM, Johannes Berg <johannes@sipsolutions.
> net> wrote:
> > 
> > There is, btw, perhaps a different way - just fix the damn stuff.
> > 
> > Requires moving everything into ifmgd rather than local, and then
> > perhaps if only a single managed interface exists mirroring its
> > state
> > into the existing driver calls etc.
> > 
> > It'd still be a big task, and I don't see much advantage over just
> > reimplementing it.
> Yes, requires quite an effort and also need to handle lot of cases.
> Instead, why don't we make the default as complete PS offload
> and force the drivers who need to use mac80211 PS negate these
> in the register_hw? That way we are clear about the intentions.

I don't really see a big advantage, and it'd create churn in a lot of
drivers. Maybe documenting it with the flags that we really think you
should set them or something, or making the powersave DOC section
mention this would be good, but beyond that I don't think it'd be a
good idea.

johannes
