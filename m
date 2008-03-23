Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:1051 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbYCWJ0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 05:26:49 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1195242rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 23 Mar 2008 02:26:48 -0700 (PDT)
Message-ID: <c85cb4470803230226h1269c193v3574da0736a4ec5e@mail.gmail.com> (sfid-20080323_092656_967644_892C913B)
Date: Sun, 23 Mar 2008 11:26:48 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: handling Qdisc issues
Cc: linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <43e72e890803110954m2eb4ee07x8eedcec7e263da45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <200803061902.33865.IvDoorn@gmail.com>
	 <1204826767.25502.135.camel@johannes.berg>
	 <200803061927.09891.IvDoorn@gmail.com>
	 <1204829243.25502.137.camel@johannes.berg>
	 <c85cb4470803090443v3748a986vfc909c984369a4a7@mail.gmail.com>
	 <1205094818.6387.46.camel@johannes.berg>
	 <43e72e890803110954m2eb4ee07x8eedcec7e263da45@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >  > John, Johannes, what will be the preferred way to continue? it seems
> >  > that Ivo and Michael agree that the adjustments needed can be inserted
> >  > quite fast. would you like to re-base and merge the current RFC as a
> >  > patch and fix things on top of it, or to merge all the fixes and push
> >  > it at once?
> >
> >  I'd like to take a look at it first, though if you tested it and it
> >  works we can just as well put it into -testing, it can't really be worse
> >  than what we have now.
> >
> >  What I'd like to do though is just make mac80211 depend on
> >  NETDEVICES_MULTIQUEUE (or select it if possible?) so we don't have to
> >  bother with all the ifdefs. OTOH that'll totally break compat so Luis?NETDEVICES_MULTIQUEUE
>
> I've been reviewing this for a bit now and I think if we make mac80211
> depend on NETDEVICES_MULTIQUEUE and just have compat.diff patch the
> sources with ifdefs where needed. The file include/linux/netdevice.h
> already provides hints as to how to port over some calls but won't be
> sure until we test this. Seems we need a new patch for this anyway.
> Once posted I can try to port on compat-wireless.
>
>  Luis

thanks Luis.
Johannes, i guess it's back to previous mail - should we put this into
testing and let us all patch on top of it (with a heads-up notice of
course to everyone) ?
Ron
