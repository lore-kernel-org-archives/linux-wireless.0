Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4793 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab2EXQoG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 12:44:06 -0400
Message-ID: <4FBE654C.2040206@broadcom.com> (sfid-20120524_184411_807664_7C144681)
Date: Thu, 24 May 2012 18:43:56 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Mourad De Clerck" <bugs-wireless@aquazul.com>,
	linux-wireless@vger.kernel.org
Subject: Re: firmware loading fails for b43 using linux 3.4?
References: <4FBD7772.6070305@aquazul.com>
 <4FBDA4FE.6040603@lwfinger.net> <4FBDBB48.8080004@aquazul.com>
 <4FBE36B8.8020208@lwfinger.net>
In-Reply-To: <4FBE36B8.8020208@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2012 03:25 PM, Larry Finger wrote:
> It may be a while before I sort out all the details of this fix. Until
> then, you can use either the temporary fix or compile b43 as a module.
> To increase the robustness, change the end of the for loop from "i < 10"
> to "i < 5000". I could never do that in final code as it would delay
> forever if the firmware were really missing, but it will delay long
> enough to handle an fsck on root, your entering of the password for the
> encrypted fs, or whatever slows the starting of userland.

Is there no event that you can use to determine when user-space is
available? In the original udev discussion it was suggested to use
IFF_UP, but I did not find anyone saying what the equivalent mac80211
callback should be.

Also this issue can occur when the firmware is only available on the
real root, but the ramdisk contains the b43 module.

Gr. AvS

