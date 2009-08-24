Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:49199 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZHXUIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 16:08:37 -0400
Received: by ey-out-2122.google.com with SMTP id 22so688108eye.37
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 13:08:39 -0700 (PDT)
Message-ID: <4A92F2F5.6000909@lwfinger.net>
Date: Mon, 24 Aug 2009 15:07:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, Chr <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Kernel Panic in __ieee80211_tx with p43usb as AP
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In trying to track down a WARNING reported while using p54usb as the
basis for an AP (http://bugzilla.kernel.org/show_bug.cgi?id=13725), I
created an AP using hostapd 0.6.8. It worked fine as long as I used a
Linux client. I ran repeated tcpperf runs through it to my server, and
repeated installations of b43 firmware. That routine uses wget to pull
the driver files. The only machine I had available as a client does
not include X, so I could not run a browser.

All went well until I had a Windows Vista client connect to the
network. As soon as I launched a browser, the kernel on the AP crashed.

The kernel in question is 2.6.31-rc7-Linus-00012-g3edf2fb from the
mainline tree. I do not know the reported reason for the panic, as
that scrolls off the screen. The traceback shows the error to be in
__ieee80211_tx in this statement: ret = drv_tx(local, skb), which
makes the problem be here:

static inline int drv_tx(struct ieee80211_local *local, struct sk_buff
*skb)
{
        return local->ops->tx(&local->hw, skb);
}

Are there any suggest changes that would let me debug this problem
without crashing the kernel?

Thanks,

Larry

