Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31041 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752149AbdAaMXp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 07:23:45 -0500
Date: Tue, 31 Jan 2017 13:11:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Mel Stimmel <crosscreekconsulting@earthlink.net>,
        linux-wireless@vger.kernel.org
Subject: Re: Intel Pro 4965 wireless
Message-ID: <20170131121129.GA12516@redhat.com> (sfid-20170131_132408_706123_8E1D0704)
References: <b4724c04-1377-fda3-a65e-8c84fe60838a@earthlink.net>
 <1485848188.26003.54.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485848188.26003.54.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2017 at 09:36:28AM +0200, Luca Coelho wrote:
> On Mon, 2017-01-30 at 21:04 -0500, Mel Stimmel wrote:
> >      I have a problem that recently arose with my Thinkpad model T61 
> > running Ubuntu 16.04 with the Intel Pro 4965 installed.
> >      This system was working just fine until sometime in Dec., when 
> > after one of the routine updates, the software can't see/find/recognize 
> > the wireless adapter. It's not the adapter, as if I boot the system from 
> > an older CD (show and tell mode) the wifi works just fine.

It's hard to tell for me what could changed after ubuntu update. I would
check if device initialize using "dmesg", then if interface is created
by "iw dev". If interface is created problem will be realted with 
wpa_supplicant or NetworkManager . If there are no messages about
4965 device in 'dmesg' I would check if driver module is sill there: 

find /lib/modules/`uname -r`/ -name "*iwl*"

> >      When I do the command LSHW, it shows the driver as iwl4965, and the 
> > version as 3.13.0-93-generic.
> >      I've been in the computer business since 1958 but are a newby to 
> > Linux so don't any/many of the commands and/or it's inner workings.
> >      Any help that y'all could provide would be greatly appreciated.

> Adding Stanislaw, who is the maintainer of iwlegacy (which is the driver
> that supports iwl4965).

It's actually system configuration problem not driver by itself, better
place to search help would be ubuntu forums or google.
 
Stanislaw
