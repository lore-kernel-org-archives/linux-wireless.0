Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51943 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab2EXTgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 15:36:39 -0400
Received: by gglu4 with SMTP id u4so161421ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2012 12:36:38 -0700 (PDT)
Message-ID: <4FBE8DC3.9010207@lwfinger.net> (sfid-20120524_213642_995519_009D2538)
Date: Thu, 24 May 2012 14:36:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Mourad De Clerck <bugs-wireless@aquazul.com>,
	linux-wireless@vger.kernel.org
Subject: Re: firmware loading fails for b43 using linux 3.4?
References: <4FBD7772.6070305@aquazul.com> <4FBDA4FE.6040603@lwfinger.net> <4FBDBB48.8080004@aquazul.com> <4FBE36B8.8020208@lwfinger.net> <4FBE654C.2040206@broadcom.com>
In-Reply-To: <4FBE654C.2040206@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2012 11:43 AM, Arend van Spriel wrote:
>
> Is there no event that you can use to determine when user-space is
> available? In the original udev discussion it was suggested to use
> IFF_UP, but I did not find anyone saying what the equivalent mac80211
> callback should be.
>
> Also this issue can occur when the firmware is only available on the
> real root, but the ramdisk contains the b43 module.

The callback from request_firmware_nowait() seems to be about as good an 
indicator as any.

Yes, having the b43 module in the ramdisk would also cause a problem.

Larry
