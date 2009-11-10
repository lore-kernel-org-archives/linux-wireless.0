Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:47422 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891AbZKJPAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 10:00:30 -0500
MIME-Version: 1.0
Date: Tue, 10 Nov 2009 09:50:43 -0500
From: <pat-lkml@erley.org>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: introduce =?UTF-8?Q?nl=38=30=32=31=31=5Fget=5Fifidx?=
 =?UTF-8?Q?=28=29?=
In-Reply-To: <m3aayu1ttc.wl%holgerschurig@gmail.com>
References: <m3aayu1ttc.wl%holgerschurig@gmail.com>
Message-ID: <05d7281ddd3780e3d7f4b485ce361b87@127.0.0.1>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 10 Nov 2009 12:51:43 +0100, Holger Schurig
<holgerschurig@googlemail.com> wrote:

> @@ -3182,20 +3182,11 @@
>  	int err;
>  
>  	if (!ifidx) {
> -		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
> -				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
> -				  nl80211_policy);
> -		if (err)
> -			return err;
> -
> -		if (!nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX])
> -			return -EINVAL;
> -
> -		ifidx = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX]);
> -		if (!ifidx)
> -			return -EINVAL;
> +		ifidx = nl80211_get_ifidx(cb);

do you need an:

 if(ifidx < 0)
    return ifidx;

here, as you assign it to cb->args[0], which differs from the original
behavior.

>  		cb->args[0] = ifidx;
>  	}
> +	if (ifidx < 0)
> +		return ifidx;
>  
>  	dev = dev_get_by_index(sock_net(skb->sk), ifidx);
>  	if (!dev)

