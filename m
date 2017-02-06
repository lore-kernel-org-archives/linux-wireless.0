Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35918 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdBFG5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 01:57:13 -0500
Message-ID: <1486364230.14226.3.camel@sipsolutions.net> (sfid-20170206_075716_122285_3318724F)
Subject: Re: [PATCH] mac80211: Fix adding of mesh vendor IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>, linux-wireless@vger.kernel.org
Cc: Thorsten Horstmann <thorsten@defutech.de>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Simon Wunderlich <sw@simonwunderlich.de>
Date: Mon, 06 Feb 2017 07:57:10 +0100
In-Reply-To: <20170203133829.3219-1-sven@narfation.org> (sfid-20170203_145249_969240_F468065B)
References: <20170203133829.3219-1-sven@narfation.org>
         (sfid-20170203_145249_969240_F468065B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-02-03 at 14:38 +0100, Sven Eckelmann wrote:
> From: Thorsten Horstmann <thorsten@defutech.de>
> 
> The function ieee80211_ie_split_vendor doesn't return 0 on errors.
> Instead
> it returns any offset < ielen when WLAN_EID_VENDOR_SPECIFIC is found.
> The
> return value in mesh_add_vendor_ies must therefore be checked against
> ifmsh->ie_len and not 0. Otherwise all ifmsh->ie starting with
> WLAN_EID_VENDOR_SPECIFIC will be rejected.
> 
> Fixes: 082ebb0c258d ("mac80211: fix mesh beacon format")
> Signed-off-by: Thorsten Horstmann <thorsten@defutech.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.
> de>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> [sven@narfation.org: Add commit message]
> Signed-off-by: Sven Eckelmann <sven@narfation.org>

I'm impressed by how many people signed this off without thinking about
a commit message ... :)

Anyway, applied.

johannes
