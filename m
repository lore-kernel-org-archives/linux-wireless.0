Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:37056 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0ASOGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 09:06:44 -0500
Received: by iwn35 with SMTP id 35so2867163iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 06:06:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263907302.12555.27.camel@johannes.local>
References: <1263907302.12555.27.camel@johannes.local>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 20 Jan 2010 01:06:19 +1100
Message-ID: <646765f41001190606w389a7702ja5891fa60458c24a@mail.gmail.com>
Subject: Re: [PATCH] mac80211: pass station instead of address to
	update_tkip_key
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 20, 2010 at 00:21, Johannes Berg <johannes@sipsolutions.net> wrote:
> When a TKIP key is updated, we should pass the station
> pointer instead of just the address, since drivers can
> use that to store their own data.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>
> --- wireless-testing.orig/net/mac80211/driver-trace.h   2010-01-16 20:18:21.000000000 +0100
> +++ wireless-testing/net/mac80211/driver-trace.h        2010-01-19 14:20:57.000000000 +0100
> @@ -332,25 +332,25 @@ TRACE_EVENT(drv_set_key,
>  TRACE_EVENT(drv_update_tkip_key,
>        TP_PROTO(struct ieee80211_local *local,
>                 struct ieee80211_key_conf *conf,
> -                const u8 *address, u32 iv32),
> +                struct sta_info *sta, u32 iv32),
>
>        TP_ARGS(local, conf, address, iv32),

Should you change address to sta?

>        TP_STRUCT__entry(
>                LOCAL_ENTRY
> -               __array(u8, addr, 6)
> +               STA_ENTRY
>                __field(u32, iv32)
>        ),
>
>        TP_fast_assign(
>                LOCAL_ASSIGN;
> -               memcpy(__entry->addr, address, 6);
> +               STA_ASSIGN;
>                __entry->iv32 = iv32;
>        ),
>
>        TP_printk(
> -               LOCAL_PR_FMT " addr:%pM iv32:%#x",
> -               LOCAL_PR_ARG, __entry->addr, __entry->iv32
> +               LOCAL_PR_FMT STA_PR_FMT " iv32:%#x",
> +               LOCAL_PR_ARG,STA_PR_ARG, __entry->iv32
>        )
>  );
>

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
