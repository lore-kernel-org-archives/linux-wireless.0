Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:4896 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZAWR3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:29:24 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2622482fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 09:29:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com>
References: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com>
	 <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com>
Date: Fri, 23 Jan 2009 09:29:22 -0800
Message-ID: <45e8e6c40901230929r6efbf19xbe2c32bef92db8e@mail.gmail.com> (sfid-20090123_182929_457435_650E3377)
Subject: Re: ath5k mesh in 2.6.28?
From: Andrey Yurovsky <andrey@cozybit.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Keir <keirlawson@gmail.com>, linux-wireless@vger.kernel.org,
	greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, looks like that's my mistake (I thought the patch had made it
in).  Greg -- thanks for queuing the patch.

For completeness, I should note that ath5k mesh is later broken by
"ath5k: Update PCU code" and fixed again (hopefully both in by
2.6.29!) by "ath5k: Correct usage of AR5K_CFG_ADHOC"

Greg and Keir -- I also suggest Brian's patch, "mac80211: decrement
ref count to netdev after launching mesh discovery", commit
05188d21d21dc8976bff13a9ca73a230eef86d40 for stable as it should apply
there and fixes a bug that will sometimes prevent module unload if a
mesh interface was active.

Thanks,

On Fri, Jan 23, 2009 at 7:17 AM, Bob Copeland <me@bobcopeland.com> wrote:
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
