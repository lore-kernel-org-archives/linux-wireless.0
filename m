Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:39879 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZAWPZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 10:25:02 -0500
Received: by yw-out-2324.google.com with SMTP id 9so2166632ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 07:25:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com>
References: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com>
	 <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com>
Date: Fri, 23 Jan 2009 15:25:00 +0000
Message-ID: <e27b78a40901230725r4dc40975t8e4cb9f481df1702@mail.gmail.com> (sfid-20090123_162508_375428_40BAE758)
Subject: Re: ath5k mesh in 2.6.28?
From: Keir <keirlawson@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would really like support in 2.6.28, but I don't want to
inconvenience anyone... who's Greg?  What I would really like is ath5k
mesh support in a stable kernel, the wireless-testing kernel I'm
currently using is too unstable for my testing.

Cheers

Keir

2009/1/23 Bob Copeland <me@bobcopeland.com>:
> On Fri, Jan 23, 2009 at 8:30 AM, Keir <keirlawson@gmail.com> wrote:
>> Hi,
>>
>> According to the 802.11s website it seems to claim that mesh
>> networking is supported for ath5k devices in kernel 2.6.28, however,
>> upon running ifconfig mesh0 up (having previously created the mesh
>> device using iw) I get "SIOCSIFFLAGS: Operation not supported".
>
> 2.6.28 does not support mesh, at least from looking at the code,
> ath5k_add_interface has:
>
>    switch (conf->type) {
>    case NL80211_IFTYPE_STATION:
>    case NL80211_IFTYPE_ADHOC:
>    case NL80211_IFTYPE_MONITOR:
>        sc->opmode = conf->type;
>        break;
>    default:
>        ret = -EOPNOTSUPP;
>        goto end;
>    }
>
> It needs to at least also have NL80211_IFTYPE_MESH_POINT.
>
> Mesh was enabled for 2.6.29 via b706e65b40417e03c2451bb3f92488f3736843fa,
> so if you need it in 2.6.28 you can ask Greg to pick it up for stable.
>
> --
> Bob Copeland %% www.bobcopeland.com
>
