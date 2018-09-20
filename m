Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:45708 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbeITWvF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 18:51:05 -0400
Message-ID: <1537463187.3874.34.camel@sipsolutions.net> (sfid-20180920_190752_845596_C5E9D81C)
Subject: Re: [PATCH v2 1/5] netlink: remove NLA_NESTED_COMPAT
From: Johannes Berg <johannes@sipsolutions.net>
To: David Laight <David.Laight@ACULAB.COM>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Date: Thu, 20 Sep 2018 19:06:27 +0200
In-Reply-To: <1811E905-CD9B-4346-AF17-CE9DBEBBE4F6@sipsolutions.net>
References: <20180919194905.16462-1-johannes@sipsolutions.net>
         <20180919194905.16462-2-johannes@sipsolutions.net>
         <15cc8087b97d4b8693fad397b27f4d10@AcuMS.aculab.com>
         <1811E905-CD9B-4346-AF17-CE9DBEBBE4F6@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-20 at 16:56 +0200, Johannes Berg wrote:
> 
> 
> > > @@ -172,7 +172,6 @@ enum {
> > >  	NLA_FLAG,
> > >  	NLA_MSECS,
> > >  	NLA_NESTED,
> > > -	NLA_NESTED_COMPAT,
> > >  	NLA_NUL_STRING,
> > >  	NLA_BINARY,
> > >  	NLA_S8,
> > 
> > ...
> > 
> > Is it safe to remove an item from this emun ?
> 
> I believe it is, since it's not part of uapi. At least as long as you
> recompile all netlink policies afterwards.

That came out confusing. It isn't UAPI, so the renumbering doesn't
matter, at least as long as you don't try to load a module compiled with
one version of the enum into a kernel compiled with the other, or
something strange like that.

johannes
