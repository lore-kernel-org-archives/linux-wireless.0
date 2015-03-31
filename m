Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53125 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbbCaOWC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 10:22:02 -0400
Message-ID: <1427811715.2057.24.camel@sipsolutions.net> (sfid-20150331_162207_173215_3106EF11)
Subject: Re: broadcast ssid in scheduled scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 31 Mar 2015 16:21:55 +0200
In-Reply-To: <55105DA7.3040703@broadcom.com>
References: <55105DA7.3040703@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-23 at 19:38 +0100, Arend van Spriel wrote:
> Johannes, Jouni,
> 
> I have noticed that under some circumstances wpa_supplicant initiates a 
> scheduled scan with broadcast ssid. This is something our firmware can 
> not do so could this be avoided? Maybe by adding a feature flag for it. 

I guess this would be difficult to do since you'd basically have to
"remove" support for normal scheduled scan (that assumes this ability)
and add support for another scheduled scan (that doesn't assume it) in
nl80211 ... just to be compatible with older implementations of
wpa_supplicant etc.

I do wonder why the firmware cannot do this though - there's no
fundamental reason the 0-length SSID is all that different from a 1-byte
one?

johannes

