Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37236 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584Ab1FINto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 09:49:44 -0400
To: Ido Yariv <ido@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] wl12xx: Support routing FW logs to the host
References: <1307361426-7573-1-git-send-email-ido@wizery.com>
	<1307361426-7573-3-git-send-email-ido@wizery.com>
	<87aadv864m.fsf@purkki.adurom.net>
	<20110606200601.GK31554@WorkStation>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 09 Jun 2011 16:49:42 +0300
In-Reply-To: <20110606200601.GK31554@WorkStation> (Ido Yariv's message of "Mon\, 6 Jun 2011 23\:06\:01 +0300")
Message-ID: <87oc276rnt.fsf@purkki.adurom.net> (sfid-20110609_154947_590534_2A33BD33)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ido Yariv <ido@wizery.com> writes:

> On Mon, Jun 06, 2011 at 04:02:49PM +0300, Kalle Valo wrote:
>> Ido Yariv <ido@wizery.com> writes:
>> > A sysfs binary file named "fwlog" was added to support this feature,
>> > letting a monitor process read the FW messages. The log is transferred
>> > from the FW only when available, so the reading process might block.
>> 
>> Using a sysfs file sounds ugly, isn't there a better way to do this?
>> For example, does ftrace&co provide anything which wireless drivers
>> could use?
>
> A sysfs entry is indeed sub-optimal. However, we had two requirements
> for this feature:
> 1. Retrieving logs should be simple and require no non-standard usermode
> applications.
> 2. The on-demand mode could be used on production platforms.
> ftrace/debugfs/etc. might not be enabled on such systems.
>
> For now, we chose to stick with a single sysfs entry, as it accomplishes
> the above. I agree it looks a bit odd though.

So basically the user can just do 'cp /sys/.../fwlog
kvalos-fw-crash-log' and send it for analysis? Makes sense.

-- 
Kalle Valo
