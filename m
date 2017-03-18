Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750712AbdCRIeC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Mar 2017 04:34:02 -0400
Date: Sat, 18 Mar 2017 09:28:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: korgman <korgie@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 bug report (occasionally crashing after suspend)
Message-ID: <20170318082823.GA7356@redhat.com> (sfid-20170318_094026_807137_C1C4869D)
References: <7ae0bf4f-6ea2-1a4c-2e6d-e793cf800c4a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7ae0bf4f-6ea2-1a4c-2e6d-e793cf800c4a@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 16, 2017 at 04:26:10PM +0200, korgman wrote:
> Hello there,
> 
> I have the same problem as reported here.
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1627828
> 
> and here
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1629603

This could be caused by power save, which is disable by default
in the driver but some programs/distribution seems to enable
it without user knowlage. First check: 

$ iw dev wlan0 get power_save

and if PS is enabled, disable by:

$ iw dev wlan0 set power_save off

and check if problem still happen.

> If I understood correctly (form 2nd link) the latest good kernel was 4.4.4 after 4.4.6 we have the problem. (see message #5)
> 
> I quote:
> "Not a full bisection yet but I have narrowed it down:
> 
> I looked at all kernel versions that had changes committed to iwlwifi and tested between them.
> 
> I now have determined that I do not have this issue in the kernel version 4.4.4.
> 
> I do have the issue in 4.4.6 and that is the next kernel version that has changes to iwlwifi so I guess that is the first bad version."

This does not make sense as 3945 device is handled by
iwl3495 (iwlegacy) driver, not by iwlwifi.

Stanislaw
