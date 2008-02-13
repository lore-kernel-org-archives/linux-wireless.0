Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.183]:27500 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbYBMSsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 13:48:45 -0500
Received: by el-out-1112.google.com with SMTP id v27so108739ele.23
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2008 10:48:40 -0800 (PST)
Subject: Re: [PATCH 02/13] o11s: (nl80211/cfg80211) support for mesh
	interfaces and set_mesh_cfg command
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202889089.8931.14.camel@johannes.berg>
References: <47a7825f.03b48c0a.7362.5cd9@mx.google.com>
	 (sfid-20080204_212410_095702_D5CB4C0C)  <1202343489.9965.47.camel@johannes.berg>
	 <1202516743.7025.20.camel@localhost>
	 (sfid-20080209_002444_593114_CF652DE8)  <1202889089.8931.14.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 10:49:56 -0800
Message-Id: <1202928596.6870.16.camel@localhost> (sfid-20080213_184848_832140_D1639698)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-02-13 at 08:51 +0100, Johannes Berg wrote:
> > the same mesh configuration. This mesh configuration is composed by the
> > mesh ID and path discovery protocol/metric/congestion control IDs. Once
> > the link is open the mesh ID is not included in the frames. Let me know
> > if you want more info.
> 
> We don't have settings for the other control IDs yet, or did I miss
> them?

Those settings are in the struct ieee80211_if_sta. We are just
hardcoding the values on route initialization, since we just support one
path protocol and link metric.

> Another, off-topic in this thread, question: How is beaconing defined
> for a mesh point? Is it similar to how it works in an IBSS?

According to the draft you can choose IBSS-like beaconing (wait a small
random time before sending the beacon and don't send it if you hear it
first) or AP-like beaconing.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


