Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36804 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754051AbdIHO0g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:26:36 -0400
Message-ID: <1504880794.20347.3.camel@sipsolutions.net> (sfid-20170908_162648_948276_D3508028)
Subject: Re: [RFC 2/4] mac80211_hwsim: add hwsim_tx_rate_flags to Netlink
 Attributes
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 08 Sep 2017 16:26:34 +0200
In-Reply-To: <fb18fe18-c780-4073-886f-9c16788391ee@MAIL1.uni-rostock.de>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
         <fb18fe18-c780-4073-886f-9c16788391ee@MAIL1.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-08 at 16:11 +0200, Benjamin Beichler wrote:
> For correct interpretation of a tx rate, the corresponding rate flags
> are needed (e.g. whether a HT-MCS rate or a legacy rate) and
> moreover for more correct simulation the other infos of the flags are
> important (like short-GI). Keeping compability, the flags
> are not integrated into the existing hwsim_tx_rate, but transmitted
> as an additional netlink attribute.

This still exposes a lot of internal detail - perhaps it'd be better to
convert to some sort of stable rate representation, like in cfg80211?
Not sure that's sufficient though, it's a bit less detailed.

johannes
