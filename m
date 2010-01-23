Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:59259 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab0AWPYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 10:24:35 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] mac80211: move control.hw_key assignment
Date: Sat, 23 Jan 2010 16:22:03 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
References: <20100117004754.624627000@sipsolutions.net> <20100117004825.177097479@sipsolutions.net>
In-Reply-To: <20100117004825.177097479@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201001231622.03394.rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 January 2010 01:47:58 Johannes Berg wrote:

> When mac80211 asks a driver to encrypt a frame, it
> must assign the control.hw_key pointer for it to
> know which key to use etc. Currently, mac80211 does
> this whenever it would software-encrypt a frame.
> 
> Change the logic of this code to assign the hw_key
> pointer when selecting the key, and later check it
> when deciding whether to encrypt the frame or let
> it be encrypted by the hardware. This allows us to
> later simply skip the encryption function since it
> no longer modifies the TX control.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Hi Johannes,
this patch breaks my wireless connection. I'm able to authenticate and 
associate to my AP but I can't use the connection, a simple ping towards my AP 
doesn't work. I bisected the problem and your patch is the bad commit.

I have the latest wireless-testing.git (v2.6.33-rc5-47285-g96ada3c). After 
having removed all the commits related to this patch, i.e.

- commit f12553ebe045a8a40ab33fa500fb57d10706e226
- commit e4fca007b06165900d0e44e8d5e251376819bf5d
- commit 813d76694043d00b59475baa1fbfaf54a2eb7fad

the connection is working again.

Fabio
