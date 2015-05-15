Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58550 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345AbbEOHZS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 03:25:18 -0400
Message-ID: <1431674716.2426.2.camel@sipsolutions.net> (sfid-20150515_092523_501483_B4D33CCD)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 15 May 2015 09:25:16 +0200
In-Reply-To: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com> (sfid-20150515_084819_998708_F401717F)
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	 (sfid-20150515_084819_998708_F401717F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-05-15 at 09:48 +0300, Emmanuel Grumbach wrote:

> I'd be glad if someone could take a look. If not, I'll have someone
> from our team to look at it, but I don't know how long it will take...

Without looking too much - it seems to me that this is a fundamental
problem with PTK rekeying, in that it re-uses the key index that is
intended to avoid this.

The issue at hand here is likely a hardware decryption vs. key replacing
race, in that hardware decryption happens while the key replacing also
happens, and then the PN checking after key replace hits the wrong key
(due to the above-mentioned issue with not being able to change the key
index in PTK rekeying.)

I don't see how we can fix this, except perhaps heuristically by
dropping packets that were encrypted with the *old* key and therefore
not updating the replay counter for them. However, detecting that they
were encrypted with the old key would only be possible by detecting a
large jump in PN, which could theoretically also happen in real
usage ...

johannes

