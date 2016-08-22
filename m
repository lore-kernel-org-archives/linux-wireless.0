Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:61695 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753202AbcHVUut (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 16:50:49 -0400
Subject: Re: [PATCH] checkpatch: See if modified files are marked obsolete in
 MAINTAINERS
To: Joe Perches <joe@perches.com>
References: <87shtwvm63.fsf@kamboji.qca.qualcomm.com>
 <7ceaa510dc9d2df05ec4b456baed7bb1415550b3.1471889575.git.joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andy Whitcroft <apw@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>,
        linux-kernel@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <30522d64-8303-cf13-d967-a5759aeb2278@users.sourceforge.net> (sfid-20160822_225116_280034_C7FB02AD)
Date: Mon, 22 Aug 2016 22:50:15 +0200
MIME-Version: 1.0
In-Reply-To: <7ceaa510dc9d2df05ec4b456baed7bb1415550b3.1471889575.git.joe@perches.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> @@ -2289,6 +2299,10 @@ sub process {
>  		}
>  
>  		if ($found_file) {
> +			if (is_maintained_obsolete($realfile)) {
> +				WARN("OBSOLETE",
> +				     "$realfile is marked as 'obsolete' in the MAINTAINERS hierarchy.  No unnecessary modifications please.\n");
> +			}

How do you think about to avoid a double negation in such a warning message?

Would a wording like "… Only really necessary modifications please.\n"
be more useful here?

Regards,
Markus
