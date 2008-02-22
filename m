Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.clemson.edu ([130.127.28.87]:51778 "EHLO CLEMSON.EDU"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761381AbYBVAU7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 19:20:59 -0500
Received: from localhost.localdomain (adsl-4-146-92.gsp.bellsouth.net [65.4.146.92])
	(authenticated bits=0)
	by CLEMSON.EDU (8.13.6/8.13.1) with ESMTP id m1M0Adun003972
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 19:10:40 -0500 (EST)
Message-ID: <47BE12FF.7030808@clemson.edu> (sfid-20080222_002105_118668_1EFB7E8A)
Date: Thu, 21 Feb 2008 19:10:39 -0500
From: Bill Moss <bmoss@CLEMSON.EDU>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compile issues compat-wireless-2.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

Compile issues for Fedora 8 kernel-2.6.24.2-7.fc8.x86_64.

For a successful compile, I had to

Add to ieee80211_sta.c
#define CONFIG_MAC80211_IBSS_DEBUG 1

Add to compat-wireless-2.6/drivers/net/wireless/ipw2200.h
static inline void le32_add_cpu(__le32 *var, u32 val)
{
        *var = cpu_to_le32(le32_to_cpu(*var) + val);
}

The first looks like a compatibility fix.

A recent kernel patch has moved byteorder definitions such as this one

from  /usr/src/kernels/2.6.24.2-7.fc8-x86_64/fs/ocfs2/endian.h (missing 
in Fedora kernels)

to  /usr/include/linux/byteorder/generic.h (in Fedora kernels)

But this patch has not made it to Fedora 8 and 9 kernels.

-- 
Bill Moss
Alumni Distinguished Professor
Mathematical Sciences
Clemson University

