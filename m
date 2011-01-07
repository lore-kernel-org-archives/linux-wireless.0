Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18817 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab1AGVeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 16:34:12 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 13:33:55 -0800
Date: Fri, 7 Jan 2011 13:34:11 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jason Andryuk <jandryuk@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH] compat: fix a typo in pm_qos_update_request for 2.6.35
Message-ID: <20110107213411.GN21588@tux>
References: <4CDD8BDD.7050903@openwrt.org>
 <AANLkTimsTn7SFPXvUM7Puc7N+30O=c5LC+AiN4b=8wmy@mail.gmail.com>
 <AANLkTiksqbUnvNV=yQJxC=kGJzBpRk2FrwftKWv5A18G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTiksqbUnvNV=yQJxC=kGJzBpRk2FrwftKWv5A18G@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 07, 2011 at 12:42:05PM -0800, Jason Andryuk wrote:
> On Fri, Nov 12, 2010 at 2:16 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Fri, Nov 12, 2010 at 10:47 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >
> > Applied and pushed, thanks!
> >
> >  Luis
> 
> This patch is to compile compat-wireless-2.6.37-2-sn.tar.bz2 on Ubuntu
> 10.10 2.6.35-24-generic.

I just sucked these two:

commit 7010ed051959df86a772dd730b8ea5921cc350d8
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Fri Nov 12 11:15:28 2010 -0800

    compat: fix a typo in pm_qos_update_request for 2.6.35
    
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>

commit e8f244e7399eb4eb0ef6930bbcefe6fea74b4a73
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Fri Nov 12 11:14:44 2010 -0800

    compat: fix pm_qos_params compile error on 2.6.35
    
    Linux 2.6.35 pm_qos_params.h is missing a #ifndef/define/endif around
    its header file contents, causing a compile error when its functions
    are overwritten by macros in the compat header files.
    Fix this by adding these to the compat version of this header file.
    
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>

into these releases:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-3.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-3-sn.tar.bz2

Please test and let me know if that fixes your woes.

  Luis
