Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:46125 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZKTOvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 09:51:48 -0500
Received: by gxk26 with SMTP id 26so3009802gxk.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 06:51:54 -0800 (PST)
Message-ID: <4B06AD07.7090705@lwfinger.net>
Date: Fri, 20 Nov 2009 08:51:51 -0600
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
> Ok, I think this is getting ugly :)
> The problem with all this is that if you change the harddisk, or change the partitioning,
> the wireless mac address would change. That would surely lead to confusion.
> 
> I think we probably have to drop this patch and instead do a mechanism that
> fetches the sprom from userspace, if the card doesn't have one. This way we
> can have a script in userspace that generates the image based on the PCI ID
> information and just randomizes the MAC address once. The firmware loading
> mechanism would be useful for that.
> In case of an embedded device with the MAC in the nvram, the kernel can still
> override the mac address provided by userspace.

Perhaps we could have fwcutter generate pseudo-SPROM contents for the necessary
revisions and write them to /lib/firmware/b43 with randomized MAC. In fact, one
might only want to randomize the serial number part. That way ethereal would get
the vendor right.

Larry

