Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:33815 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbdCOIZS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 04:25:18 -0400
Received: by mail-qt0-f182.google.com with SMTP id n21so6808421qta.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Mar 2017 01:25:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1489500275.10872.9.camel@sipsolutions.net>
References: <CAEFj985oo-Dv3dXN7rTTph74mkw_jW=7QrCfEXSjP=OGoexuYg@mail.gmail.com>
 <1489500275.10872.9.camel@sipsolutions.net>
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Date: Wed, 15 Mar 2017 16:25:16 +0800
Message-ID: <CAEFj985tdOMJOHdPEeSqWE6SvicGMdexcKxu8mxJb5CS=mm-iQ@mail.gmail.com> (sfid-20170315_092522_908325_7BB1505F)
Subject: Re: Beacon interval for Mesh/AP in single interface
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Interesting. Did hardware actually support this, and if so, what did it
> do?

Yes, ath9k for mesh/AP running simultaneously in one single radio
interface can do beaconing using different beacon interval. Mesh
providing backhaul to user accessing via STA/AP mode.

> If that worked, then it'd be reasonable to add the appropriate value to
> the interface combinations to let it work as before.
>
> If it didn't really work properly, then we can just fix the defaults to
> be compatible?

I try to put beacon_int_min_gcd in the interface combination with
mesh/AP/adhoc but the patch "[PATCH] cfg80211: disallow
beacon_int_min_gcd with IBSS" disables the mesh interface due to adhoc
interface is there.

---
Chun-Yeow
