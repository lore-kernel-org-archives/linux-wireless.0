Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46934 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbbHMIw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 04:52:58 -0400
Message-ID: <1439455976.2114.1.camel@sipsolutions.net> (sfid-20150813_105304_572777_1A6E4397)
Subject: Re: [PATCH 2/4] iw: Avoid possible memory leak for cb. cb got
 memory from nl_cb_alloc() but not doing free
From: Johannes Berg <johannes@sipsolutions.net>
To: amit.khatri@samsung.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Date: Thu, 13 Aug 2015 10:52:56 +0200
In-Reply-To: <2034214352.309341435309836730.JavaMail.weblogic@ep2mlwas06c>
References: <2034214352.309341435309836730.JavaMail.weblogic@ep2mlwas06c>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-26 at 09:10 +0000, Amit Khatri wrote:
> Hi Johannes,
> 
> Subject: [PATCH 2/4] iw: Avoid possible memory leak for cb. cb got 
> memory from
>  nl_cb_alloc() but not doing free

Please fix your submission process to not mangle patches. I've applied
patch 1 in this series and fixed it up manually, but having the subject
again inside the email just makes it harder for me to pick up the
patches.

> Signed-off-by: Amit Khatri <amit.khatri@samsung.com>
> Signed-off-by: Rahul Jain <rahul.jain@samsung.com>
> ---
>  iw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/iw.c b/iw.c
> index dc99566..1e913b6 100644
> --- a/iw.c
> +++ b/iw.c
> @@ -477,8 +477,8 @@ static int __handle_cmd(struct nl80211_state 
> *state, enum id_input idby,
>  	while (err > 0)
>  		nl_recvmsgs(state->nl_sock, cb);
>   out:
> -	nl_cb_put(cb);
>   out_free_msg:
> +	nl_cb_put(cb);
> 
Please don't leave two equivalent labels, remove one of them and
replace the users.

johannes
