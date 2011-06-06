Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1FFUGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 16:06:11 -0400
Received: by wwa36 with SMTP id 36so4187321wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 13:06:09 -0700 (PDT)
Date: Mon, 6 Jun 2011 23:06:01 +0300
From: Ido Yariv <ido@wizery.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] wl12xx: Support routing FW logs to the host
Message-ID: <20110606200601.GK31554@WorkStation> (sfid-20110606_220614_187152_E9E0B68B)
References: <1307361426-7573-1-git-send-email-ido@wizery.com>
 <1307361426-7573-3-git-send-email-ido@wizery.com>
 <87aadv864m.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87aadv864m.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 06, 2011 at 04:02:49PM +0300, Kalle Valo wrote:
> Ido Yariv <ido@wizery.com> writes:
> > A sysfs binary file named "fwlog" was added to support this feature,
> > letting a monitor process read the FW messages. The log is transferred
> > from the FW only when available, so the reading process might block.
> 
> Using a sysfs file sounds ugly, isn't there a better way to do this?
> For example, does ftrace&co provide anything which wireless drivers
> could use?

A sysfs entry is indeed sub-optimal. However, we had two requirements
for this feature:
1. Retrieving logs should be simple and require no non-standard usermode
applications.
2. The on-demand mode could be used on production platforms.
ftrace/debugfs/etc. might not be enabled on such systems.

For now, we chose to stick with a single sysfs entry, as it accomplishes
the above. I agree it looks a bit odd though.

Ido.
