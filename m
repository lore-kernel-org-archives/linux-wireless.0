Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:56614 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZKJPQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 10:16:03 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: introduce nl80211_get_ifidx()
Date: Tue, 10 Nov 2009 16:15:30 +0100
Cc: pat-lkml@erley.org, Holger Schurig <holgerschurig@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <m3aayu1ttc.wl%holgerschurig@gmail.com> <05d7281ddd3780e3d7f4b485ce361b87@127.0.0.1>
In-Reply-To: <05d7281ddd3780e3d7f4b485ce361b87@127.0.0.1>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911101615.30124.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 10 November 2009 15:50:43 pat-lkml@erley.org wrote:
> On Tue, 10 Nov 2009 12:51:43 +0100, Holger Schurig
> <holgerschurig@googlemail.com> wrote:
> 
> > @@ -3182,20 +3182,11 @@
> >  	int err;
> >  
> >  	if (!ifidx) {
> > -		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
> > -				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
> > -				  nl80211_policy);
> > -		if (err)
> > -			return err;
> > -
> > -		if (!nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX])
> > -			return -EINVAL;
> > -
> > -		ifidx = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX]);
> > -		if (!ifidx)
> > -			return -EINVAL;
> > +		ifidx = nl80211_get_ifidx(cb);
> 
> do you need an:
> 
>  if(ifidx < 0)
>     return ifidx;
> 
> here, as you assign it to cb->args[0], which differs from the original
> behavior.


Do you mean

        if (!ifidx) {
               ifidx = nl80211_get_ifidx(cb);
               if (ifidx < 0)
                  return ifidx;
               cb->args[0] = ifidx;
        }
        if (ifidx < 0)
              return ifidx;

instead?



I'm not familiar with this function, but maybe we
can get away like this:

        int ifidx = cb->args[0];

        if (!ifidx)
               ifidx = nl80211_get_ifidx(cb);
        if (ifidx < 0)
              return ifidx;
        cb->args[0] = ifidx;

-- 
http://www.holgerschurig.de
