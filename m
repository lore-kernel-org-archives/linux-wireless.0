Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936184Ab3DHKDd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 06:03:33 -0400
From: David Howells <dhowells@redhat.com>
To: seanm@seanm.ca, gregkh@suse.de, viro@ZenIV.linux.org.uk
cc: dhowells@redhat.com, awong1@novell.com,
	linux-wireless@vger.kernel.org
Subject: The rtl8192e procfs-based debug interface seems very broken
Date: Mon, 08 Apr 2013 11:02:44 +0100
Message-ID: <17570.1365415364@warthog.procyon.org.uk> (sfid-20130408_120341_877252_80DD0858)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The procfs-based debug interface in:

	drivers/staging/rtl8192e/rtl8192e/rtl_debug.c

seems to be very broken because:

 (1) proc_get_stats_ap() walks ieee->network_list with no locking.

 (2) There is no locking against normal driver operations whilst we wangle the
     device registers.  Admittedly, this may not modify the device state since
     all the pages appear memory-mapped rather than bank-swapped - but if
     there are any read-to-ack type regs, then this is bad.

 (3) We send the device commands and await replies - again without locking
     against the normal driver (eg. proc_get_cam_register_*()).

David
