Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45424 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762266Ab3DHWbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 18:31:47 -0400
Received: by mail-oa0-f42.google.com with SMTP id i18so6879740oag.29
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 15:31:46 -0700 (PDT)
Message-ID: <51634550.3090300@lwfinger.net> (sfid-20130409_003150_424430_80DB1D2A)
Date: Mon, 08 Apr 2013 17:31:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: seanm@seanm.ca, gregkh@suse.de, viro@ZenIV.linux.org.uk,
	awong1@novell.com, linux-wireless@vger.kernel.org
Subject: Re: The rtl8192e procfs-based debug interface seems very broken
References: <17570.1365415364@warthog.procyon.org.uk>
In-Reply-To: <17570.1365415364@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2013 05:02 AM, David Howells wrote:
> The procfs-based debug interface in:
>
> 	drivers/staging/rtl8192e/rtl8192e/rtl_debug.c
>
> seems to be very broken because:
>
>   (1) proc_get_stats_ap() walks ieee->network_list with no locking.
>
>   (2) There is no locking against normal driver operations whilst we wangle the
>       device registers.  Admittedly, this may not modify the device state since
>       all the pages appear memory-mapped rather than bank-swapped - but if
>       there are any read-to-ack type regs, then this is bad.
>
>   (3) We send the device commands and await replies - again without locking
>       against the normal driver (eg. proc_get_cam_register_*()).

David,

That whole driver is quite broken.

My initial response would be to delete the whole procfs structure. I have one of 
those devices, but I never use it. At the moment, I do not have time to add 
locking and test the changes.

Larry

