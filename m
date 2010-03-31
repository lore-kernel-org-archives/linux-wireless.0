Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32390 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab0CaDP6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 23:15:58 -0400
Subject: Re: firmware_loading_store: vmap() failed, broken firmware with
 kernles .27 - .30
From: Pavel Roskin <proski@gnu.org>
To: Golden <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <733969.9491.qm@web56807.mail.re3.yahoo.com>
References: <733969.9491.qm@web56807.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Tue, 30 Mar 2010 23:15:52 -0400
Message-Id: <1270005352.27938.14.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-25 at 09:20 -0700, Golden wrote:

> Recent compat-wireless releases break firmware loading under slightly
> older kernels. The bug occurs as tested by me with 2.6.27 and 2.6.30,
> it does not appear on kernels 2.6.31 and up.
...
> b43 ssb0:0: firmware: requesting b43-open/ucode5.fw
> compat_firmware ssb0:0: firmware_loading_store: unexpected value (0)

I was able to reproduce "unexpected value" with Linux 2.6.28.10 and
ar9170usb.

After adding some debug printk's, I get this:

firmware_loading_store: loading = 1
firmware_loading_store: loading = 1
firmware_loading_store: loading = 0
fw_priv->fw->data = ffffc2001027a000
firmware_loading_store: loading = 0
compat_firmware 1-7: firmware_loading_store: unexpected value (0)
firmware_loading_store: abort
usb 1-7: ar9170.fw firmware file not found, trying old firmware...

It looks like we have a race condition here.  Two processes try to load
the firmware.

I remember vaguely that it was discussed before.  Google search for
"firmware_loading_store race" finds some interesting links, but I cannot
find a fix.  Likewise, search for "firmware_loading_store: unexpected
value" finds a lot of stuff in the Linux 2.6.13 timeframe.

It looks like a race condition.  Adding dump_stack() to the beginning of
firmware_loading_store() makes the problem disappear.

-- 
Regards,
Pavel Roskin
