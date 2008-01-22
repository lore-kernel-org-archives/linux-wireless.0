Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:57849 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbYAVXRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 18:17:10 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JHSMb-0004lq-T5
	for linux-wireless@vger.kernel.org; Tue, 22 Jan 2008 23:17:06 +0000
Received: from userch028.dsl.pipex.com ([62.190.239.28])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 23:17:05 +0000
Received: from linux by userch028.dsl.pipex.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 23:17:05 +0000
To: linux-wireless@vger.kernel.org
From: Adam Baker <linux@baker-net.org.uk>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Tue, 22 Jan 2008 23:16:58 +0000 (UTC)
Message-ID: <loom.20080122T230306-543@post.gmane.org> (sfid-20080122_231715_681153_8543F20D)
References: <20080118125252.6455.41047.stgit@one> <200801211705.24221.IvDoorn@gmail.com> <43e72e890801221147uedf8002oc21840bdd80a157c@mail.gmail.com> <200801222054.23433.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn <ivdoorn@...> writes:

> 
> Hi,
> 
> > > > > Then there is a problem for rt2x00. Since the mactime isn't known.
> > > > > rt2400pci is the _only_ device which has a RX_END_TIME field in the
> > > > > RX descriptor.
> > > >
> > > > one workaround could be to simply use the current TSF at the time in
> > > > the tasklet or interrupt handler (to be more close to the actual rx 
> > > > time). this should be sufficient to catch most cases where an IBSS 
> > > > merge is necessary - usually the beacon's TSF will be much higher
> > > > than the local TSF.
> > >
> > > Should the driver to this, or should mac80211 handle that?
> > 
> > The driver should if it has access to some the mactime of the received
> > packet otherwise yes -- I think mac80211 can handle this using the
> > supplied get_tsf().
> > 
> > > Personally I think it is something for the mac80211 layer since the
> > > driver will give what it can, and can be sure that it is what mac80211 
> > > expects instead of drivers interpreting what mac80211 might want as 
> > > replacement. If mac80211 needs the TSF value when no mac time is 
> > > given, it could just use the get_tsf() callback function to the driver
> > >  to get the substitute. When the get_tsf() callback is not provided,
> > >  then mac80211 can complain about missing information.
> > 
>

I see one problem with this. At the moment rt2x00 doesn't implement get_tsf
for USB devices. In the case of RT73 this is because mac80211 requires
get_tsf to be atomic which precludes waiting for a USB device to reply
to a request. Ivo has got an implementation in the code but it is disabled
as the fact it sleeps was causing bugs. Presumably other USB devices would
have the same problem.

I'm not sure if the code path for IBSS merging would require an atomic
version, I'm guessing it wouldn't. If so do we need to consider whether 
to either have both get_tsf and get_tsf_atomic or have a flag to get_tsf
indicating if it can sleep if it needs to?

Adam Baker

