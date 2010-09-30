Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab0I3Ohg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 10:37:36 -0400
Subject: Re: [Patch 1/1] wext: fix 32/64 bit alignment issue for 'point'
 type
From: Johannes Berg <johannes@sipsolutions.net>
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk>
References: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 16:38:07 +0200
Message-ID: <1285857487.5137.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 12:25 +0200, Gerrit Renker wrote:
> wireless: fix alignment problem
> 
> With the current definition, IW_EV_POINT_PK_LEN is 12 on 64-bit and 8 on 32-bit systems,
> due to the way struct iw_event is packed (24 byte on 64-bit systems instead of 20 byte
> on 32-bit systems). Furthermore, the iwe_stream_add_point() in include/net/iw_handler.h
> also uses IW_EV_LCP_PK_LEN as header length. 
> 
> The current definition appears to be a typo (PK_LEN instead of LEN); it causes 
> misalignment on 64 bit systems.

So, correct me if I'm wrong, the only effect this change has is changing
the second memcpy() in iwe_stream_add_point() to not copy an extra 4
bytes that will be overwritten right away by the next memcpy()
(presumably, unless the data is < 4, in which case the memcpy might
actually be out of bounds).

Where's the misalignment issue?

johannes

