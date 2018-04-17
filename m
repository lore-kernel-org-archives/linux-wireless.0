Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44290 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbeDQOvL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 10:51:11 -0400
Message-ID: <1523976667.3473.2.camel@sipsolutions.net> (sfid-20180417_165134_550387_C19C18E0)
Subject: Re: [PATCH] mac80211: don't WARN on bad WMM parameters from buggy
 APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2018 16:51:07 +0200
In-Reply-To: <50803899.jTqZALSPQ5@debian64> (sfid-20180417_141102_898998_85452A55)
References: <20180326132104.26709-1-emmanuel.grumbach@intel.com>
         <50803899.jTqZALSPQ5@debian64> (sfid-20180417_141102_898998_85452A55)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-04-17 at 14:11 +0200, Christian Lamparter wrote:
> 
> > -		if (params[ac].cw_min > params[ac].cw_max) {
> > +		if (params->cw_min == 0 ||

Yeah. We already have a fix pending

https://patchwork.kernel.org/patch/10320823/

I just haven't been keeping up during the merge window.

johannes
