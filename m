Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34667 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753424AbdDFKv5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 06:51:57 -0400
Received: by mail-io0-f175.google.com with SMTP id b140so27009212iof.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 03:51:57 -0700 (PDT)
Message-ID: <1491475915.10124.75.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20170406_125201_310461_96337D26)
Subject: Re: [Make-wifi-fast] [PATCH v3] mac80211: Dynamically set CoDel
 parameters per station
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Thu, 06 Apr 2017 03:51:55 -0700
In-Reply-To: <20170406093826.16626-1-toke@toke.dk>
References: <20170405161810.30671-1-toke@toke.dk>
         <20170406093826.16626-1-toke@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-06 at 11:38 +0200, Toke Høiland-Jørgensen wrote:

> +
> +	if (thr && thr < STA_SLOW_THRESHOLD * sta->local->num_sta) {
> +		sta->cparams.target = MS2TIME(50);
> +		sta->cparams.interval = MS2TIME(300);
> +		sta->cparams.ecn = false;
> +	} else {
> +		sta->cparams.target = MS2TIME(20);
> +		sta->cparams.interval = MS2TIME(100);
> +		sta->cparams.ecn = true;
> +	}
> +}

Why ECN is flipped on/off like that ? ECN really should be an admin
choice.

Also, this change in parameters looks suspect to me, adding a bimodal
behavior. I would consult Kathleen and Van on this possibility.
