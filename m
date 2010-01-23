Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:65244 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab0AWNkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 08:40:06 -0500
Received: by iwn35 with SMTP id 35so968585iwn.4
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 05:40:04 -0800 (PST)
Date: Sat, 23 Jan 2010 07:40:05 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Kacper <kacper@kacper.se>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k phy0: unsupported jumbo
Message-ID: <20100123134005.GA11322@progeny.tock>
References: <20100123105111.GA24790@progeny.tock>
 <fe54d8c01001230418u3de7f4ccuc4fbfdecc7c76ebf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <fe54d8c01001230418u3de7f4ccuc4fbfdecc7c76ebf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kacper wrote:

> It's listen under the ath5k todo tasks at
> <http://linuxwireless.org/en/users/Drivers/ath5k>.

Thanks for the pointer.  Looks like Bob Copeland investigated this last
year. [1]  Looking at messages from around that time, I find some words
of explanation: [2]

| I think the jumbo flag is supposed to indicate the packet is larger
| than the buffer size.  However, we have a buffer size of 2500 so that
| shouldn't happen for standard frames.  I did check into whether there
| was a corruption issue, like skb_tailroom was smaller than a full 
| packet because of an skb reuse bug or something like that.  But no, 
| all were > 2500 bytes (incl roundup for cache line).  That's when 
| I did the unmap and a hexdump and saw they have no 802.11 headers or
| anything of the sort.  Felix suggested we just drop the warning.

So it looks like we receive some strange packets that haven’t been
explained yet.  It might be worth looking at a few --- sounds kind of
interesting.

Am I understanding correctly?  This is a hardware bug or undocumented
hardware feature then, right?

It might be nice to add some user-oriented explanation too, but for
now, how about this comment?

Thanks,
Jonathan

[1] http://linuxwireless.org/en/users/Drivers/ath5k?action=diff&rev1=36&rev2=37
[2] http://thread.gmane.org/gmane.linux.kernel.wireless.general/27439/focus=27476

-- %< --
From: Jonathan Nieder <jrnieder@gmail.com>
Subject: ath5k: Add a comment describing the unsupported jumbo phenomenon

Every now and then, the ath5k driver warns:

ath5k phy0: unsupported jumbo

Add some notes for the curious sysadmin to find when grepping for
an explanation.

Cc: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 5577bcc..9fffe6c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1814,6 +1814,19 @@ ath5k_tasklet_rx(unsigned long data)
 		}
 
 		if (unlikely(rs.rs_more)) {
+			/*
+			 * The jumbo flag is supposed to indicate the packet
+			 * is larger than the buffer size.  However, we have a
+			 * buffer size of 2500 so that shouldn't happen for
+			 * standard frames.
+			 *
+			 * The relevant frames really are all > 2500 bytes
+			 * (including roundup for cache line).  unmap and
+			 * hexdump reveals that they have no 802.11 headers or
+			 * anything of the sort.
+			 *
+			 * XXX just drop the warning?
+			 */
 			ATH5K_WARN(sc, "unsupported jumbo\n");
 			goto next;
 		}
