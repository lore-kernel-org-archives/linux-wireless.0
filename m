Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45505 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1FFNCv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 09:02:51 -0400
To: Ido Yariv <ido@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] wl12xx: Support routing FW logs to the host
References: <1307361426-7573-1-git-send-email-ido@wizery.com>
	<1307361426-7573-3-git-send-email-ido@wizery.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 06 Jun 2011 16:02:49 +0300
In-Reply-To: <1307361426-7573-3-git-send-email-ido@wizery.com> (Ido Yariv's message of "Mon\,  6 Jun 2011 14\:57\:06 +0300")
Message-ID: <87aadv864m.fsf@purkki.adurom.net> (sfid-20110606_150254_787068_FC67DB45)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ido Yariv <ido@wizery.com> writes:

> A recently added feature to the firmware enables the driver to retrieve
> firmware logs via the host bus (SDIO or SPI).
>
> There are two modes of operation:
> 1. On-demand: The FW collects its log in an internal ring buffer. This
>    buffer can later be read, for example, upon recovery.
> 2. Continuous: The FW pushes the FW logs as special packets in the RX
>    path.
>
> Reading the internal ring buffer does not involve the FW. Thus, as long
> as the HW is not in ELP, it should be possible to read the logs, even if
> the FW crashes.

I have been thinking something similar and hence my interest.

> A sysfs binary file named "fwlog" was added to support this feature,
> letting a monitor process read the FW messages. The log is transferred
> from the FW only when available, so the reading process might block.

Using a sysfs file sounds ugly, isn't there a better way to do this?
For example, does ftrace&co provide anything which wireless drivers
could use?

-- 
Kalle Valo
