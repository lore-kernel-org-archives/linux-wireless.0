Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.229]:29035 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYBIA5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 19:57:36 -0500
Received: by wx-out-0506.google.com with SMTP id h31so4251636wxd.4
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 16:57:33 -0800 (PST)
Subject: Re: [PATCH 10/13] o11s: mesh discovery and peer link establishment
	support
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202346788.9965.95.camel@johannes.berg>
References: <47a78292.22528c0a.1300.1aef@mx.google.com>
	 (sfid-20080204_212438_516087_6199B5A8)  <1202346788.9965.95.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 16:58:38 -0800
Message-Id: <1202518718.7025.60.camel@localhost> (sfid-20080209_005749_617064_41D5BC02)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-07 at 02:13 +0100, Johannes Berg wrote:
> How would you design implementing support secure peer links? It seems
> that to do that much of the mesh bookkeeping would need to be done by
> wpa_supplicant instead of the kernel. In fact, maybe it should always do
> it and much of this code be migrated into wpa_supplicant's userspace
> MLME?

We definitely would implement security in user space but have not
decided yet were to draw the line. I think that it makes sense at least
to have path discovery in-kernel, since there is a lot of activity on
them (each path is rebuilt every few seconds and there can be many of
them) and many path discovery frames just need to be forwarded and do
not have to be transferred to user space.

> Peer link establishment, mesh path updating etc. could all be done in
> wpa_supplicant's userspace MLME, no? If we add all this to the kernel
> now, would we have to reimplement it in the userspace MLME to support
> secure peer links?

AFAIK, it would only be necessary to move part of the peer link
establishment to user space. Path discovery takes place after the peer
links have been established.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.



-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


