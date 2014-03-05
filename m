Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaCESIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 13:08:23 -0500
Message-ID: <1394042899.5275.47.camel@jlt4.sipsolutions.net> (sfid-20140305_190826_281855_058D7D51)
Subject: Re: [PATCH 3.14.0-rc5 v3 1/10] rsi: Adding RS9113 driver files
From: Johannes Berg <johannes@sipsolutions.net>
To: Fariya Fathima <fariya.f@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Mar 2014 19:08:19 +0100
In-Reply-To: <-1822401706-40502@mail.redpinesignals.com>
References: <-1822401706-40502@mail.redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-05 at 23:28 +0530, Fariya Fathima wrote:

> The num_debugfs entries corresponds to the number of debugfs entries
> to be created by the core layer.  Our driver has support for 2
> interfaces - SDIO & USB. The SDIO driver intends to create 4 debugfs
> entries and the USB driver intends to create 3. This information is
> indicated to the core layer by initializing the num_debufs entries,
> depending on the interface.

Yeah I got confused with this. I guess it's OK, although likely to break
in the future? Maybe the SDIO layer should provide that one debugfs
handler itself, rather than having it in the core, so that this
distinction isn't needed?

> These seem odd ... maybe they should at least come with comments
> about 
> how generic kernel functionality can't be used and why it needs
> another 
> abstraction layer?
> We did put in various fields inside the rsi_event and rsi_thread
> structs to create a slight abstraction. I hope that is fine.

I have no issues with that really, it just seems odd, but maybe it just
means the kernel functionality isn't precisely what you need.

johannes

