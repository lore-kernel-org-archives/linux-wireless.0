Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34164 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaFWS03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 14:26:29 -0400
Received: by mail-pd0-f173.google.com with SMTP id r10so5963476pdi.32
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 11:26:29 -0700 (PDT)
Date: Mon, 23 Jun 2014 11:26:23 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user
 hints
Message-ID: <20140623182623.GC1390@garbanzo.do-not-panic.com> (sfid-20140623_202633_004076_E4A220A8)
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-4-git-send-email-arik@wizery.com>
 <CAB=NE6XTgcMWNHppF7WgZjqGCyaZSOJLF4FUC1hwVyyaBrJ79g@mail.gmail.com>
 <CA+XVXfedV=Frh8UmAzRfgPbOw8nq1Aa-Yr7QSgZTKe8h=bh78Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfedV=Frh8UmAzRfgPbOw8nq1Aa-Yr7QSgZTKe8h=bh78Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2014 at 08:14:43PM +0300, Arik Nemtsov wrote:
> On Thu, Jun 19, 2014 at 2:34 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> >> Allow driver and user hints to set the "world" regulatory domain,
> >
> > NACK - as expressed in the other patch, letting the drivers to use the
> > new API to set the world regulatory domain doesn't make sense as we
> > have custom apply stuff, and the world regulatory domain is not
> > something dynamic.
> 
> Well we want to set the world regdomain from FW. This obviously
> happens after wiphy registration, so I don't think the custom apply
> can be used here? (since we generally want cfg80211 to own the
> regdomain settings).

Can the driver not obtain the world regulatory domain from firmware
prior to wiphy registration? Why not?

One thing to be careful on all this new API design is to ensure that
upon disconnect we want the driver to go back to the original state,
whatever that is.

  Luis
