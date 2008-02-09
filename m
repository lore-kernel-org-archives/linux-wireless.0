Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:5483 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbYBIAYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 19:24:39 -0500
Received: by an-out-0708.google.com with SMTP id d31so949387and.103
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 16:24:38 -0800 (PST)
Subject: Re: [PATCH 02/13] o11s: (nl80211/cfg80211) support for mesh
	interfaces and set_mesh_cfg command
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202343489.9965.47.camel@johannes.berg>
References: <47a7825f.03b48c0a.7362.5cd9@mx.google.com>
	 (sfid-20080204_212410_095702_D5CB4C0C)  <1202343489.9965.47.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 16:25:43 -0800
Message-Id: <1202516743.7025.20.camel@localhost> (sfid-20080209_002446_823720_EFF755A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-07 at 01:18 +0100, Johannes Berg wrote:
> However, maybe I don't understand the mesh ID well enough yet, can you
> maybe explain in a few sentences where it is used and what for?

The mesh ID works as the SSID for mesh networks, on mesh beacons/probes
SSID is set to the wildcard value to avoid interfering with non-mesh
STAs.

An MP only opens a peer link with a neighboring mesh peer if you have
the same mesh configuration. This mesh configuration is composed by the
mesh ID and path discovery protocol/metric/congestion control IDs. Once
the link is open the mesh ID is not included in the frames. Let me know
if you want more info.

It might be a good idea as you suggest in another thread to refuse to
change the mesh id for running interfaces as it would make a lot of
information stale, will consider it.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


