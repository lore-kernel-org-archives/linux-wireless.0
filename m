Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:56866 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbYHHO3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 10:29:07 -0400
Message-ID: <489C5833.2080009@lwfinger.net> (sfid-20080808_162927_341875_AA02AF73)
Date: Fri, 08 Aug 2008 09:29:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
 from commit 741b4fbc44
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808081026.49041.chunkeey@web.de>
In-Reply-To: <200808081026.49041.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> ??? 
> What is this for? The firmware does the sequence number counting
> and will simply override this field without looking at it... Are you sure this
> really fixes anything?
>  
> That said: the firmware will always report the sequence number of every
> tx'ed frame as a part of p54_frame_sent_hdr in the _free_ tx callback...

Without this patch, my p54usb would go offline every 2-3 hours. To recover, the 
driver had to be unloaded and reloaded. With it, the device has never gone 
offline for as long as I have tested. I have no idea what the firmware does, but 
it has helped my system.

Larry
