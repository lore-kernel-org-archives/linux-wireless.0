Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54390
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab0IVTSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 15:18:42 -0400
Date: Wed, 22 Sep 2010 12:19:02 -0700 (PDT)
Message-Id: <20100922.121902.71115228.davem@davemloft.net>
To: chunkeey@googlemail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2010-09-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <201009222054.05469.chunkeey@googlemail.com>
References: <201009221158.13806.chunkeey@googlemail.com>
	<20100922.092252.116390431.davem@davemloft.net>
	<201009222054.05469.chunkeey@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christian Lamparter <chunkeey@googlemail.com>
Date: Wed, 22 Sep 2010 20:54:05 +0200

> Only the structs which deal with hardware (hw.h, eeprom.h, wlan.h)
> or firmware (fwcmd.h, fwdesc.h & wlan.h) interface have the
> __packed attribute. And there are several good reasons.

There is a cost in being lazy and just stabbing __packed to every
structure shared with firmware or hardware.

And that cost is that every larger-than-byte sized element will be
loaded with a disgustingly expensive series of byte loads, shifts,
and masks.

Every access.

This is because GCC is not allowed to assume the alignment of any
structure marked with __packed.  Therefore only byte sized loads are
safe on architectures that require types be aligned to their size.

This really is a performance issue, otherwise I frankly wouldn't
care where you put __packed.

So please minimize the annotations to only the structures that
actually require __packed, not those that "might."
