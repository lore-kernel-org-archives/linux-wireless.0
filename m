Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:43961 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab1HRKYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 06:24:17 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id 615813403E6
	for <linux-wireless@vger.kernel.org>; Thu, 18 Aug 2011 11:11:58 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Sq0t773yFsbI for <linux-wireless@vger.kernel.org>;
	Thu, 18 Aug 2011 11:11:58 +0100 (BST)
Received: from Ed-Wildgooses-MacBook-Pro.local (unknown [212.69.38.73])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id 1AEDE3403E5
	for <linux-wireless@vger.kernel.org>; Thu, 18 Aug 2011 11:11:57 +0100 (BST)
Message-ID: <4E4CE56D.2060007@wildgooses.com> (sfid-20110818_122421_186818_59A5A9CE)
Date: Thu, 18 Aug 2011 11:11:57 +0100
From: Ed W <lists@wildgooses.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Possible Makefile minor glitch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, in compat-wireless (bleeding edge) ./net/wireless/Makefile I see the
following:

$(obj)/regdb.c: $(src)/db.txt $(src)/genregdb.awk
        @$(AWK) -f $(srctree)/$(src)/genregdb.awk < $< > $@

My guess is that the "$(srctree)/" should not be there?

For me at least it causes problems when building against a non-installed
kernel tree like this:

    make KLIB=/usr/src/linux KLIB_BUILD=/usr/src/linux

End result is:

awk: fatal: can't open source file
`/usr/src/linux-2.6.38.4-2.2.2-201105021909-aufs-ipset//usr/src/compat-wireless-2011-08-08/net/wireless/genregdb.awk'
for reading (No such file or directory)

Deleting the additional patch works for me, but not sure of the wider
implications?

Many thanks

Ed W
