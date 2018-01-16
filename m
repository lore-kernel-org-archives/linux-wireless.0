Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51268 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbeAPNdZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 08:33:25 -0500
Message-ID: <1516109603.410.47.camel@sipsolutions.net> (sfid-20180116_143328_425827_B48D4CA5)
Subject: Re: [RFC v2 3/5] mac80211: Send control port frames over nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Tue, 16 Jan 2018 14:33:23 +0100
In-Reply-To: <a7b47de8-ad2c-2b73-1e71-d70c47281845@gmail.com> (sfid-20180115_162443_000232_A82BC49E)
References: <20180110170938.2341-1-denkenz@gmail.com>
         <20180110170938.2341-4-denkenz@gmail.com>
         <1516021789.410.28.camel@sipsolutions.net>
         <a7b47de8-ad2c-2b73-1e71-d70c47281845@gmail.com>
         (sfid-20180115_162443_000232_A82BC49E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-01-15 at 09:24 -0600, Denis Kenzior wrote:

> > It's probably better to reset this at interface type switching, if it's
> > not done anyway (we zero a lot of memory there, but not sure precisely
> > what)
> > 
> > Otherwise we'll surely forget this in some place like mesh or OCB ...
> > 
> > Initially it must be false (0) anyway.
> > 
> 
> Where do I look?  Right now I'm mostly following the precedent of other 
> control_port_* stuff.

Oh, interesting. I was thinking of things like sdata->noack_map that
get reset in ieee80211_setup_sdata().

johannes
