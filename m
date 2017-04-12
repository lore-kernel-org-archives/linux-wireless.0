Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37770 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752345AbdDLO3J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 10:29:09 -0400
Message-ID: <1492007347.2855.12.camel@sipsolutions.net> (sfid-20170412_162916_061671_02976605)
Subject: Re: [RFC 3/3] mac80211: support bpf monitor filter
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 12 Apr 2017 16:29:07 +0200
In-Reply-To: <20170412110726.9689-3-johannes@sipsolutions.net> (sfid-20170412_130907_870638_0C9870E2)
References: <20170412110726.9689-1-johannes@sipsolutions.net>
         <20170412110726.9689-3-johannes@sipsolutions.net>
         (sfid-20170412_130907_870638_0C9870E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-12 at 13:07 +0200, Johannes Berg wrote:
> 
>  struct ieee80211_if_mntr {
>  	u32 flags;
> 
[...]
+	bool deliver;

That's ... broken for multi-queue RX. I haven't really found a good
other way to do it. The best way will likely be to copy the SKB the
first time it's needed, build the radiotap header, and then keep a
reference to it to be able to clone it later if it's needed again.

johannes
