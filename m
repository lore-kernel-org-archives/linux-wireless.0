Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaAWOzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 09:55:32 -0500
Message-ID: <1390488928.4142.17.camel@jlt4.sipsolutions.net> (sfid-20140123_155535_140562_ABE1014F)
Subject: Re: [PATCH 2/2] mac80211: Support tx-hw-crypt with rx-sw-crypt.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 15:55:28 +0100
In-Reply-To: <52E12C90.3080509@candelatech.com>
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com>
		  <1390431296-20568-2-git-send-email-greearb@candelatech.com>
		  (sfid-20140122_235550_068991_E5B7233B) <1390432245.20070.0.camel@jlt4.sipsolutions.net>
		 <52E05CB1.80308@candelatech.com>
	 <1390465191.4142.2.camel@jlt4.sipsolutions.net>
	 <52E12C90.3080509@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 06:52 -0800, Ben Greear wrote:

> The ieee80211_tkip_decrypt_data method is explicitly checking if the key is uploaded to hardware.

It is, but only for calling drv_update_tkip_key(), which you can make
the driver ignore.

> I need it to think that it is not uploaded to hardware as far as that check
> is concerned, otherwise packets will not decrypt properly.

I don't believe this is true. The stack was always designed so that if
you didn't decrypt the packet, you just don't set the flags indicating
it was decrypted and it'll be decrypted in software.

johannes

