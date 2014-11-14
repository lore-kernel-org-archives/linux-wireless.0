Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:46031 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933794AbaKNN37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 08:29:59 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] wil6210: atomic I/O for the card memory
References: <1412165125-30435-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1412165125-30435-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Fri, 14 Nov 2014 15:29:52 +0200
In-Reply-To: <1412165125-30435-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Wed, 1 Oct 2014 15:05:25 +0300")
Message-ID: <87fvdlsyen.fsf@kamboji.qca.qualcomm.com> (sfid-20141114_143002_643642_366E38C2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> Introduce netdev IOCTLs, to be used by the debug tools.
>
> Allows to read/write single dword value or
> memory block, aligned to dword
> Different address modes supported:
> - BAR offset
> - Firmware "linker" address
> - target's AHB bus
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

An ioctl interface for a wireless driver? IMHO that would have been ok
in 2004, but not in 2014. Isn't there really better way to implement
this?

> +/* Numbers SIOCDEVPRIVATE and SIOCDEVPRIVATE + 1
> + * are used by Android devices to implement PNO (preferred network offload).
> + * Albeit it is temporary solution, use different numbers to avoid conflicts
> + */

Comments like this make me even more worried that that this is just yet
another way to implement wext iwpriv interface.

-- 
Kalle Valo
