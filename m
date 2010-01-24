Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:20004 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0AXS0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 13:26:53 -0500
Received: by fg-out-1718.google.com with SMTP id l26so748602fgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 10:26:52 -0800 (PST)
Subject: Re: [PATCH 4/5] mac80211: move control.hw_key assignment
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <201001231622.03394.rossi.f@inwind.it>
References: <20100117004754.624627000@sipsolutions.net>
	 <20100117004825.177097479@sipsolutions.net>
	 <201001231622.03394.rossi.f@inwind.it>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Jan 2010 20:26:48 +0200
Message-ID: <1264357608.4152.7.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-01-23 at 16:22 +0100, Fabio Rossi wrote: 
> On Sunday 17 January 2010 01:47:58 Johannes Berg wrote:
> 
> > When mac80211 asks a driver to encrypt a frame, it
> > must assign the control.hw_key pointer for it to
> > know which key to use etc. Currently, mac80211 does
> > this whenever it would software-encrypt a frame.
> > 
> > Change the logic of this code to assign the hw_key
> > pointer when selecting the key, and later check it
> > when deciding whether to encrypt the frame or let
> > it be encrypted by the hardware. This allows us to
> > later simply skip the encryption function since it
> > no longer modifies the TX control.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Hi Johannes,
> this patch breaks my wireless connection. I'm able to authenticate and 
> associate to my AP but I can't use the connection, a simple ping towards my AP 
> doesn't work. I bisected the problem and your patch is the bad commit.
> 
> I have the latest wireless-testing.git (v2.6.33-rc5-47285-g96ada3c). After 
> having removed all the commits related to this patch, i.e.
> 
> - commit f12553ebe045a8a40ab33fa500fb57d10706e226
> - commit e4fca007b06165900d0e44e8d5e251376819bf5d
> - commit 813d76694043d00b59475baa1fbfaf54a2eb7fad
> 
> the connection is working again.

Exactly same problem, here with iwl3945.
I am using software encryption (CCMP), and I noticed that it is the
default in iwl3945. Also hardware encryption doesn't work (unrelated
issue)

Best regards,
Maxim Levitsky


