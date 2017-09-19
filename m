Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58726 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbdISP6p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 11:58:45 -0400
Message-ID: <1505836723.3026.10.camel@sipsolutions.net> (sfid-20170919_175853_000168_E4D60BE5)
Subject: Re: [PATCH] mac80211_hwsim: enabling WDS
From: Johannes Berg <johannes@sipsolutions.net>
To: Ramon Fontes <ramonreisfontes@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Sep 2017 17:58:43 +0200
In-Reply-To: <CAK8U23b-i_tYMzVpLiaRrA2PSTGU9Zm=4rQoYRU=WafPkU7ytA@mail.gmail.com> (sfid-20170919_135633_780750_1EC61827)
References: <CAK8U23b-i_tYMzVpLiaRrA2PSTGU9Zm=4rQoYRU=WafPkU7ytA@mail.gmail.com>
         (sfid-20170919_135633_780750_1EC61827)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I'm developing an wireless emulator
> (https://github.com/intrig-unicamp/mininet-wifi) which relies on
> mac80211_hwsim for loading virtual wireless interfaces. In order to
> get access points wirelessly connected I was think to enable WDS (in
> addition to the well known mesh mode).

Why would you want to have WDS? IMHO if you really want to do it over
wifi it makes more sense to use 4-addr AP/client. That at least gives
you a reasonable configuration one might use in the real world - WDS
can't negotiate HT/VHT for example, making it pretty much useless these
days.

> Then, I went through mac80211_hwsim and I noticed that I could make
> it work with BIT(NL80211_IFTYPE_WDS) in mac80211_hwsim. That said, I
> thought to submit this patch.
> 
> ps. I'm not an expert in Linux Kernel and I don't know if something
> else have to be done. It just worked applying this patch.

It may work in hwsim, but I don't really want to encourage such usage.

I'd even argue that we should just remove support for this from the
kernel entirely, but that will probably not happen.

johannes
