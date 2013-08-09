Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3HINH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 09:07:56 -0400
Message-ID: <1376053671.8355.4.camel@jlt4.sipsolutions.net> (sfid-20130809_150800_313252_713279DA)
Subject: Re: [RFC] mac80211: add support for split-MAC implementations
From: Johannes Berg <johannes@sipsolutions.net>
To: Johan Almbladh <ja@anyfi.net>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 09 Aug 2013 15:07:51 +0200
In-Reply-To: <1375968116-24331-1-git-send-email-ja@anyfi.net> (sfid-20130808_152319_898268_ED7ABE6E)
References: <1375968116-24331-1-git-send-email-ja@anyfi.net>
	 (sfid-20130808_152319_898268_ED7ABE6E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-08 at 15:21 +0200, Johan Almbladh wrote:
> This patch enables power save processing for encrypted frames even if the
> encryption key is not set. This is a requirement when implementing split-MAC
> systems like Anyfi.net [1] and CAPWAP [2] on mac80211 using monitor frame
> injection and reception. 

I have no idea what these are, nor do I actually want to care much...
You presumably use Felix's active monitor mode?

> The mac80211 RX handlers are reordered slightly so
> that the power save handler is invoked before the decryption handler.
> 
> The patch is minimal in the sense that it provides the required functionality
> with a minimal change, but I am open to suggestions if this change is too
> intrusive. Please let me know what you think.

I think you should ask yourself if this makes sense in the normal wifi
context... :-)

It actually seems like it *does* make sense, so it should have an
appropriate description for that, but I'm a bit worried about IBSS in
sta_process.

Also I've tried to keep the code in the file sequential, so this patch
should be moving ieee80211_rx_h_decrypt() itself as well.

johannes

