Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764706AbYHEUV7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 16:21:59 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m75KLrZb010122
	for <linux-wireless@vger.kernel.org>; Tue, 5 Aug 2008 16:21:53 -0400
Received: from mail.boston.redhat.com (mail.boston.redhat.com [10.16.255.12])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m75KLpYb002728
	for <linux-wireless@vger.kernel.org>; Tue, 5 Aug 2008 16:21:52 -0400
Received: from [10.16.3.195] (dhcp-100-3-195.bos.redhat.com [10.16.3.195])
	by mail.boston.redhat.com (8.13.1/8.13.1) with ESMTP id m75KLnUl004986
	for <linux-wireless@vger.kernel.org>; Tue, 5 Aug 2008 16:21:49 -0400
Subject: hostap: handling device renames better
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 05 Aug 2008 16:23:41 -0400
Message-Id: <1217967821.29886.4.camel@localhost.localdomain> (sfid-20080805_222207_764541_7BCED377)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While trying to flash my Prism 2.5 card today, I ran into a problem
that'll probably hit quite a few drivers (mostly older ones).

udev renames the interface after probing, but anything the driver set up
manually at probe/init time (in this case /proc/net/hostap/wifi0/pda)
will still be using the old device name.  Thus the prism2_srec tool
refused to work because it needs both the PDA from /proc/net/hostap/...
as well as some ioctls on the device.  Unfortunately, the device names
are different due to udev's renaming.

How are drivers made aware that their device's name has changed so they
could potentially update things they stick in /proc or wherever?  hostap
and airo come to mind as current users of /proc.

Dan

(ideally this stuff should be migrated to the device's sysfs directory,
not live in /proc/net)

