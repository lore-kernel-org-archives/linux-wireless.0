Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:50510 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396AbZKJPl0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 10:41:26 -0500
MIME-Version: 1.0
Date: Tue, 10 Nov 2009 10:41:30 -0500
From: <pat-lkml@erley.org>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Holger Schurig <holgerschurig@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: introduce =?UTF-8?Q?nl=38=30=32=31=31=5Fget=5Fifidx?=
 =?UTF-8?Q?=28=29?=
In-Reply-To: <200911101615.30124.holgerschurig@gmail.com>
References: <m3aayu1ttc.wl%holgerschurig@gmail.com> <05d7281ddd3780e3d7f4b485ce361b87@127.0.0.1> <200911101615.30124.holgerschurig@gmail.com>
Message-ID: <8567e294da1df02e481550fd73a8ff75@127.0.0.1>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 10 Nov 2009 16:15:30 +0100, Holger Schurig
<holgerschurig@gmail.com> wrote:
> On Tuesday 10 November 2009 15:50:43 pat-lkml@erley.org wrote:
>> On Tue, 10 Nov 2009 12:51:43 +0100, Holger Schurig
>> <holgerschurig@googlemail.com> wrote:
>> 
>> > @@ -3182,20 +3182,11 @@
>> >  	int err;
>> >  
>> >  	if (!ifidx) {
>> > -		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
>> > -				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
>> > -				  nl80211_policy);
>> > -		if (err)
>> > -			return err;
>> > -
>> > -		if (!nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX])
>> > -			return -EINVAL;
>> > -
>> > -		ifidx = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX]);
>> > -		if (!ifidx)
>> > -			return -EINVAL;
>> > +		ifidx = nl80211_get_ifidx(cb);
>> 
>> do you need an:
>> 
>>  if(ifidx < 0)
>>     return ifidx;
>> 
>> here, as you assign it to cb->args[0], which differs from the original
>> behavior.
> 
> 
> Do you mean
> 
>     <SNIP>
> 
> instead?
> 
> 
> 
> I'm not familiar with this function, but maybe we
> can get away like this:
>  <SNIP>

I'm not familiar with the code either.  I was just glancing through the
patch 
and noticed a change that changed the behavior of the code that was there.


before, cb->args[0] was left un-altered when ifidx = nla_get_u32(...)
failed, 
but now it's assigned to unconditionally, then, if ifidx is unasigned, an
error 
is returned.  I've not looked at the context or callers, but the commit
message
implied to me that there should be no functional changes, which is not the
case.

pat

