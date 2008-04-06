Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:5137 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbYDFQmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 12:42:09 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1060464fgb.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Apr 2008 09:42:07 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 hardware encryption
Date: Sun, 6 Apr 2008 18:44:14 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200804051931.58895.IvDoorn@gmail.com>
In-Reply-To: <200804051931.58895.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804061844.14166.IvDoorn@gmail.com> (sfid-20080406_174216_494563_7A43D9A5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I'm investigating hardware encryption support for the rt2x00 drivers,
> Support for rt61pci and rt73usb should be the easiest to do so currently I'm
> only focussing on that, and decide later if rt2500pci and rt2500usb should
> also be implemented.

After some more research I have a similar question for the RX path.
The device will strip the IV out of the ieee80211 frame but provides
the IV/EIV seperately in the descriptor.

Would it be any added value to instead of setting the RX_FLAG_IV_STRIPPED
flag the IV is reinserted into the frame, provide the IV/EIV seperately in
struct ieee80211_rx_status, or simply set RX_FLAG_IV_STRIPPED and ignore
the entire field?

Thanks.

Ivo
