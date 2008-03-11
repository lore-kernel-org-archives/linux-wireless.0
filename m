Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:10763 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbYCKQzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 12:55:03 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1510619rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 09:54:59 -0700 (PDT)
Message-ID: <43e72e890803110954m2eb4ee07x8eedcec7e263da45@mail.gmail.com> (sfid-20080311_165507_193250_13E65AF1)
Date: Tue, 11 Mar 2008 12:54:59 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: handling Qdisc issues
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1205094818.6387.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <200803061902.33865.IvDoorn@gmail.com>
	 <1204826767.25502.135.camel@johannes.berg>
	 <200803061927.09891.IvDoorn@gmail.com>
	 <1204829243.25502.137.camel@johannes.berg>
	 <c85cb4470803090443v3748a986vfc909c984369a4a7@mail.gmail.com>
	 <1205094818.6387.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 9, 2008 at 4:33 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>  > John, Johannes, what will be the preferred way to continue? it seems
>  > that Ivo and Michael agree that the adjustments needed can be inserted
>  > quite fast. would you like to re-base and merge the current RFC as a
>  > patch and fix things on top of it, or to merge all the fixes and push
>  > it at once?
>
>  I'd like to take a look at it first, though if you tested it and it
>  works we can just as well put it into -testing, it can't really be worse
>  than what we have now.
>
>  What I'd like to do though is just make mac80211 depend on
>  NETDEVICES_MULTIQUEUE (or select it if possible?) so we don't have to
>  bother with all the ifdefs. OTOH that'll totally break compat so Luis?NETDEVICES_MULTIQUEUE

I've been reviewing this for a bit now and I think if we make mac80211
depend on NETDEVICES_MULTIQUEUE and just have compat.diff patch the
sources with ifdefs where needed. The file include/linux/netdevice.h
already provides hints as to how to port over some calls but won't be
sure until we test this. Seems we need a new patch for this anyway.
Once posted I can try to port on compat-wireless.

  Luis
