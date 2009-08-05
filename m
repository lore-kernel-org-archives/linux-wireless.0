Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50233 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZHEF3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:29:18 -0400
Received: by fxm17 with SMTP id 17so3677332fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 22:29:18 -0700 (PDT)
Subject: Re: [PATCH 001/002] [MAC80211] Retry probe request few times
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1249438947.3094.30.camel@localhost.localdomain>
References: <1249056817.20593.1.camel@maxim-laptop>
	 <1249056896.20593.3.camel@maxim-laptop>
	 <1249438947.3094.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 08:29:13 +0300
Message-Id: <1249450153.6083.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-08-04 at 19:22 -0700, Marcel Holtmann wrote:
> Hi Maxim,
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Fri, 31 Jul 2009 18:54:12 +0300
> > Subject: [PATCH] [MAC80211] Retry probe request few times
> > 
> > Retry 5 times  (chosen arbitary ), before assuming
> > that station is out of range.
> 
> so today I got the disconnect :(
> 
> [54632.657912] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 1
> [54633.154560] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 2
> [54873.231210] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 1
> [55113.467840] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 1
> [55113.964510] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 2
> [55114.464516] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 3
> [55114.967868] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, try 4
> [55115.464511] No probe response from AP 00:1c:f0:xx:xx:xx after 500ms, disconnecting.
> 
> Should we increase the value to 8 or something? Or just accept that
> sometimes we get a disconnect?
> 
I think a disconnect or two aren't a problem, they are always handled
automatically, and can be caused by natural events.

Even without these patches (I have WPA2, and disconnects were every 4
five seconds), and still it was possible to use network.

One disconnect in a day is really nothing to worry about (I have seen
such here as well)

You can increase try count, probably won't hurt much (each try is 0.5
seconds, so even 10 tries gives total of 5 seconds, before disconnect on
a really unaccessible AP, anyway)

Best regards,
	Maxim Levitsky

