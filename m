Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:46581 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751046AbeEPJZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 05:25:08 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Use correct GFP_ mask in cfg80211_del_sta_sinfo()
In-Reply-To: <20180516084836.GB23043@mwanda>
References: <20180516084836.GB23043@mwanda>
Date: Wed, 16 May 2018 11:25:07 +0200
Message-ID: <87lgckymto.fsf@toke.dk> (sfid-20180516_112514_083132_1AAED641)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> Smatch complains that we should use the passed in "gfp" instead of hard
> coding GFP_KERNEL.  I looked at some of the callers and this would
> probably be a bug for rtw_cfg80211_indicate_sta_disassoc() which uses
> GFP_ATOMIC and a NULL "sinfo".
>
> Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to usersp=
ace")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Ah, right, didn't notice that that was supposed to be a gfp value.
Thanks for the fix :)

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>


-Toke
