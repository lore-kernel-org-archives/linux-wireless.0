Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:45951 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3BSBRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 20:17:12 -0500
Received: by mail-bk0-f42.google.com with SMTP id jk7so2815165bkc.29
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 17:17:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361214203.8555.40.camel@jlt4.sipsolutions.net>
References: <1361186207-1390-1-git-send-email-yeohchunyeow@gmail.com>
	<1361214203.8555.40.camel@jlt4.sipsolutions.net>
Date: Tue, 19 Feb 2013 09:17:10 +0800
Message-ID: <CAEFj986wkWBKy_-1+xzQamy4WYaj3Sy22ENCjw_NpX5Xa7jOhA@mail.gmail.com> (sfid-20130219_021715_888296_7E9E89B3)
Subject: Re: [PATCH] mac80211: fix the problem of unicast forwarding from DS
 to DS in Mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	cedric.voncken@acksys.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> +                     if (!mpath || (mpath && (!next_hop ||
>> +                                     !(mpath->flags & MESH_PATH_ACTIVE))))
>> +                             mppath = mpp_path_lookup(skb->data, sdata);
>
> Heck, even the logic is wrong. Ok actually just weird -- if (!mpath || !
> next_hop || ...) would be totally sufficient.

We go to lookup for mppath if mpath is unavailable, or if mpath is
available but the next_hop is NULL or the path is inactive.

---
Chun-Yeow
