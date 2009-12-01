Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36573 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZLASRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 13:17:37 -0500
Subject: Re: [PATCH] mac80211: allow disabling 40MHz on 2.4GHz
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1259688582.32171.97.camel@johannes.local>
References: <1259688582.32171.97.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 01 Dec 2009 13:17:26 -0500
Message-Id: <1259691446.4806.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-12-01 at 18:29 +0100, Johannes Berg wrote:
> In some situations it is required that a system be
> configured with no support for 40 MHz channels in
> the 2.4 GHz band. Rather than imposing any such
> restrictions on everybody, allow configuration a
> system like that with a module parameter. It is
> writable at runtime but only takes effect at the
> time of the next association.

That looks like a hack to me.

Maybe it should be treated like other CRDA flags?  In fact, you can find
this in dbparse.py in the wireless-regdb sources:

    # hole at bit 9. FIXME: Where is NO-HT40 defined?
    'NO-HT40':          1<<10,

However, there are no other references to NO-HT40 in the wireless-regdb
or CRDA sources.  I assume it's not implemented.

-- 
Regards,
Pavel Roskin
