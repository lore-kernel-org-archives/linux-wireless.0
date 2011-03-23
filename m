Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab1CWTRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:17:47 -0400
Subject: RE: [PATCH v3] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Ramesh Radhakrishnan <rramesh@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FA7916C7@SC-VEXCH1.marvell.com>
References: <1300755650-21740-1-git-send-email-bzhao@marvell.com>
	 <1300884446.3790.38.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FA7916C7@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 20:17:44 +0100
Message-ID: <1300907864.3790.43.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

> > In iwlwifi, we just have iwl_send_cmd_sync(), which does all the wait.
> > That also has the added benefit that the wait queue doesn't need to be
> > dynamically allocated, it can just be on the stack. Also, your dynamic
> > allocations for that don't really seem to require GFP_ATOMIC in most
> > places, but that's probably the least of the worries here.
> 
> I will study the iwl_send_cmd_sync() implementation. And have mwifiex
> use the same way to send commands as iwlwifi driver does.

I'm not saying that you need to do that exactly in the same way. It's
just that allocating the wait queue dynamically and then passing it
across a few functions seems to bloat the code and I also think it's
more error prone.

Are there any asynchronous commands at all anyway?

johannes

