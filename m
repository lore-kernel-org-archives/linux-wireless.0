Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40983 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZKTRTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 12:19:21 -0500
Received: by bwz27 with SMTP id 27so3567935bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 09:19:26 -0800 (PST)
Message-ID: <4B06CF9B.4040201@lwfinger.net>
Date: Fri, 20 Nov 2009 11:19:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
References: <200911201212.19588.mb@bu3sch.de> <4B06A233.2070708@lwfinger.net> <200911201511.11042.mb@bu3sch.de>
In-Reply-To: <200911201511.11042.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2009 08:11 AM, Michael Buesch wrote:
> 
> I think we probably have to drop this patch and instead do a mechanism that
> fetches the sprom from userspace, if the card doesn't have one. This way we
> can have a script in userspace that generates the image based on the PCI ID
> information and just randomizes the MAC address once. The firmware loading
> mechanism would be useful for that.
> In case of an embedded device with the MAC in the nvram, the kernel can still
> override the mac address provided by userspace.
> 

Your patch may be OK. You can get the serial number for the system from
/sys/class/dmi/id/product_serial or the UUID from
/sys/class/dmi/id/product_uuid. Either would work as the initialization for the
hash.

Larry

