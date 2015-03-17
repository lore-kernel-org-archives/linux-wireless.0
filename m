Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53183 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933385AbbCQKCX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 06:02:23 -0400
Message-ID: <1426586533.1985.3.camel@sipsolutions.net> (sfid-20150317_110300_955800_6689C3FF)
Subject: Re: [PATCH v3] mac80211: Get IV len from key conf and not cipher
 scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 17 Mar 2015 11:02:13 +0100
In-Reply-To: <5842EA9CC042B141995329508713AD672105AD37@ILMAIL1.corp.local>
References: <5842EA9CC042B141995329508713AD672105AD37@ILMAIL1.corp.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 16:29 +0000, Cedric Izoard wrote:
> When a key is installed using a cipher scheme, a new flag
> IEE80211_KEY_FLAG_CIPHER_SCHEME is set.

Should this flag really be visible to the driver? The driver should
better know if it's a CS key anyway, no? And then we could use an
internal key flag (see net/mac80211/key.h) and avoid increasing the size
of the flags field.

johannes

