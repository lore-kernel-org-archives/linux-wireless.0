Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53129
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbXLVEwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 23:52:41 -0500
Date: Fri, 21 Dec 2007 20:52:40 -0800 (PST)
Message-Id: <20071221.205240.186733706.davem@davemloft.net> (sfid-20071222_045249_847391_3BFE70A5)
To: linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org
Subject: [WEXT 0/12]: Un-crapify compat handling.
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This set of 12 patches pulls all of the existing compat
handling for WEXT ioctls out of fs/compat_ioctl.c and
allows implementations down in the driver layers to
handle compat issues properly when necessary.

In particular it fixes the bug where iw_point objects
were not being size translated properly in scan
streams and similar.

Currently I've only made sure this compiles properly.
I'm half-way done with a dummy wireless driver that
can be used purely to validate WEXT ioctl handling
correctness in the core wireless layers.
