Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:33578 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZAWPR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 10:17:27 -0500
Received: by rv-out-0506.google.com with SMTP id k40so4744612rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 07:17:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com>
References: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com>
Date: Fri, 23 Jan 2009 10:17:26 -0500
Message-ID: <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com> (sfid-20090123_161732_029381_4B68A89A)
Subject: Re: ath5k mesh in 2.6.28?
From: Bob Copeland <me@bobcopeland.com>
To: Keir <keirlawson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 8:30 AM, Keir <keirlawson@gmail.com> wrote:
> Hi,
>
> According to the 802.11s website it seems to claim that mesh
> networking is supported for ath5k devices in kernel 2.6.28, however,
> upon running ifconfig mesh0 up (having previously created the mesh
> device using iw) I get "SIOCSIFFLAGS: Operation not supported".

2.6.28 does not support mesh, at least from looking at the code,
ath5k_add_interface has:

    switch (conf->type) {
    case NL80211_IFTYPE_STATION:
    case NL80211_IFTYPE_ADHOC:
    case NL80211_IFTYPE_MONITOR:
        sc->opmode = conf->type;
        break;
    default:
        ret = -EOPNOTSUPP;
        goto end;
    }

It needs to at least also have NL80211_IFTYPE_MESH_POINT.

Mesh was enabled for 2.6.29 via b706e65b40417e03c2451bb3f92488f3736843fa,
so if you need it in 2.6.28 you can ask Greg to pick it up for stable.

-- 
Bob Copeland %% www.bobcopeland.com
