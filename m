Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:41528 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbXHTRsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 13:48:51 -0400
Message-ID: <46C9D3F6.7020306@lwfinger.net>
Date: Mon, 20 Aug 2007 12:48:38 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: Lock problem with latest b43 patches
References: <46C7CACC.2000000@lwfinger.net> <1187609202.6090.93.camel@johannes.berg>
In-Reply-To: <1187609202.6090.93.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2007-08-18 at 23:45 -0500, Larry Finger wrote:
> 
>> -> #1 (&inode->i_mutex){--..}:
>>         [<ffffffff80252d52>] __lock_acquire+0xad4/0xcf0
>>         [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
>>         [<ffffffff80252ff3>] lock_acquire+0x85/0xa9
>>         [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
>>         [<ffffffff803fe34a>] __mutex_lock_slowpath+0xef/0x290
>>         [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
>>         [<ffffffff88600d7d>] nfs_revalidate_mapping+0x6d/0xac [nfs]
>>         [<ffffffff885fe7e1>] nfs_file_mmap+0x4d/0x65 [nfs]
> 
> Are you running on NFS? This is a bit weird but not related to wireless
> at all, seems to be dnotify/NFS interaction.

My / and /home partitions are local, but I do have mounted NFS partitions. Whatever happened here 
has been a one-time only event, at least so far. Until it happens again, I'll assume that an 
electron got crosswise somewhere. :)

Larry
