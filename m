Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57675 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955AbXHHGCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 02:02:30 -0400
Message-ID: <46B95C75.8060404@lwfinger.net>
Date: Wed, 08 Aug 2007 01:02:29 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Larry Finger <larry.finger@lwfinger.net>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] Fix handling of failure to create debugfs directory
References: <20070808051710.3902.43211.stgit@dv.roinet.com> <46B95A15.1080202@lwfinger.net>
In-Reply-To: <46B95A15.1080202@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Pavel Roskin wrote:
>> This can happen if CONFIG_BCM43XX_MAC80211_DEBUG is enabled, but
>> CONFIG_DEBUG_FS is not.
>>
>> Signed-off-by: Pavel Roskin <proski@gnu.org>
>> ---
>>
> With this patch installed, and the DEBUG configuration set as above, I get a kernel panic on an 
> x86_64 SMP system. The reason for the panic scrolled off the screen, but the complete stack dump 
> (hand copied) is as follows:
> 
> lock_acquire+0x85/0x31
> bcm43xx_mac80211: bcm43xx_debugfs_log_txstat+0x5a/099
> _spin_lock+0x25/0x31

Ignore the noise above. I had failed to get the right patch. The crash confirms the problem 
_without_ the patch. Getting it in properly fixes the problem

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

