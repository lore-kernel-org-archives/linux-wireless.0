Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47174 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753507AbdCFNIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 08:08:42 -0500
Message-ID: <1488803104.5761.6.camel@sipsolutions.net> (sfid-20170306_140846_652420_3726E214)
Subject: Re: [PATCH] mac80211: Use setup_timer instead of init_timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Ond=C5=99ej_Lyson=C4=9Bk?= <ondrej.lysonek@seznam.cz>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 06 Mar 2017 13:25:04 +0100
In-Reply-To: <20170303124535.30125-1-jslaby@suse.cz>
References: <20170303124535.30125-1-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-03 at 13:45 +0100, Jiri Slaby wrote:
> From: Ondřej Lysoněk <ondrej.lysonek@seznam.cz>
> 
> Use setup_timer() and setup_deferrable_timer() to set the data and
> function timer fields. It makes the code cleaner and will allow for
> easier change of the timer struct internals.

Btw, I suspect you generated this with coccinelle and didn't put enough
"..." there, because you missed one in mesh_path_new() :)

Care to send a patch for that one too?

johannes
