Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms.dension.com ([195.56.193.33]:48989 "EHLO ms.dension.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab3CMPvt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 11:51:49 -0400
Date: Wed, 13 Mar 2013 16:51:45 +0100
From: "Patrik, Kluba" <pkluba@dension.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: bug: deadlock in rtl8192cu
Message-ID: <20130313165145.09a8e7ce.pkluba@dension.com> (sfid-20130313_165152_727850_487ADD9F)
In-Reply-To: <5140977D.2040403@lwfinger.net>
References: <20130312163020.67f9532b.pkluba@dension.com>
	<513F5931.6040509@lwfinger.net>
	<20130313152505.7dc3466c.pkluba@dension.com>
	<5140977D.2040403@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 13 Mar 2013 10:13:01 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> 
> I think that is the problem that was fixed in wireless-testing commit 
> 664899786cb4. In that case, we got a scheduling while atomic when the
> debug level was 3 or higher. Check routine
> rtl92cu_update_hal_rate_table() to see in the following statement is
> the last one in that routine.
> 
>         RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, "%x\n",
>                 rtl_read_dword(rtlpriv, REG_ARFR0));
> 
> The patch in question removed that RT_TRACE statement.
> 

Yep, that helped.

> Yesterday, Jussi Kivilinna and I found a problem that prevented
> rtl8192cu from reconnecting once it disconnected. That patch is
> attached.

And this one too, thanks.

Regards,
Patrik

-- 
Patrik KLUBA
Software Developer at

DENSION Audio Systems Ltd.
H-1116 Budapest, Sztregova u. 1
Phone: +36 1 463 0470
Fax:   +36 1 463 0479
Web:   www.dension.com
