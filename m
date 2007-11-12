Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:31618 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbXKLTsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 14:48:06 -0500
Received: by ik-out-1112.google.com with SMTP id c28so7588ika
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2007 11:48:04 -0800 (PST)
Subject: Re: [PATCH 2/4] o80211s: (nl80211) support for mesh interfaces and
	set_mesh_cfg command
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1194687275.7258.36.camel@johannes.berg>
References: <473516df.18bb720a.41e8.5fdc@mx.google.com>
	 (sfid-20071110_022645_005653_498DB7A6)  <1194687275.7258.36.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 12 Nov 2007 11:47:41 -0800
Message-Id: <1194896861.6980.28.camel@localhost> (sfid-20071112_194812_149912_85E33456)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-11-10 at 10:34 +0100, Johannes Berg wrote:
> So if I bring up a mesh interface and don't use SET_MESH_CFG, it won't
> operate at all?

Yes it would, it would use the wild card, zero-length mesh ID.

> I think I'd prefer if the MESH_ID attribute would be given as part of
> SET_INTERFACE/NEW_INTERFACE instead of a new command. I'm attempting to
> keep nl80211 as object oriented as possible and this single command
> doesn't really fit the picture.

Will that be the way to specify the SSID for the STA interfaces? If so,
I agree it would be better to use that command instead of an additional
mesh specific command. As by now it's just used to set the interface
type I was not sure it was appropriate to add the mesh configuration
there.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


