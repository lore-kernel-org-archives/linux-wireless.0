Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36822 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756173AbdIHO2I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:28:08 -0400
Message-ID: <1504880886.20347.4.camel@sipsolutions.net> (sfid-20170908_162853_629921_74255B08)
Subject: Re: [RFC 4/4] mac80211_hwsim: add radio idx param to netlink
 callback of radio creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 08 Sep 2017 16:28:06 +0200
In-Reply-To: <c6eda3a2-ad9b-4c33-b3c8-ddc36199ea3e@MAIL1.uni-rostock.de>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
         <c6eda3a2-ad9b-4c33-b3c8-ddc36199ea3e@MAIL1.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-08 at 16:11 +0200, Benjamin Beichler wrote:
> Since the radio index is already a valid NL attribute, this patch
> simply
> try to read it and create the radio specific to this index by the
> previously used scheme.
> 
> Since this allows to create radios out of row, we need to search for
> a
> free index for a new radio, when the index is not present as
> parameter.

This seems like a bad idea, what's the point? You can always change the
MAC address later if you want.

Also, you don't seem to actually do what you said, with the -1.

johannes
