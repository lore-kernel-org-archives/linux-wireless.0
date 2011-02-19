Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65129 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab1BSDoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 22:44:32 -0500
Received: by bwz15 with SMTP id 15so1328981bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 19:44:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
	<1298064074-8108-1-git-send-email-linville@tuxdriver.com>
Date: Fri, 18 Feb 2011 19:44:30 -0800
Message-ID: <AANLkTikJeN=CG20PAj-n1ZoaiJLbsiG=jfZnbu4Or3KS@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
From: Nathaniel Smith <njs@pobox.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	johannes@sipsolutions.net, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 1:21 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> +       /* grab timestamp info for buffer control estimates */
> +       tserv = ktime_sub(ktime_get(), skb->tstamp);
[...]
> +               ewma_add(&sta->sdata->qdata[q].tserv_ns_avg,
> +                        ktime_to_ns(tserv));

I think you're still measuring how long it takes one packet to get
from the end of the queue to the beginning, rather than measuring how
long it takes each packet to go out?

-- Nathaniel
