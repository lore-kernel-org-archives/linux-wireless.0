Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52519 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYKSWMY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 17:12:24 -0500
Subject: Re: [PATCH] orinoco: indicate it is using dBm in wireless_stats
	and spy
From: Pavel Roskin <proski@gnu.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200811151715.17150.arvidjaar@mail.ru>
References: <200811151715.17150.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 17:12:22 -0500
Message-Id: <1227132742.3571.29.camel@dv> (sfid-20081119_231237_247434_3B02BF02)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-11-15 at 17:15 +0300, Andrey Borzenkov wrote:
> Subject: [PATCH] orinoco: indicate it is using dBm in wireless_stats and spy
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> Since WE7 /proc/net/wireless checks whether level and noise  are in dBm
> and shows them accordingly. Indicate that we return signal and noice
> levels in dBm.

I believe the formula we are using is not exact.  Intersil firmware has
a separate register (HERMES_RID_DBMCOMMSQUALITY_INTERSIL) that provides
the dBm data.  It relates to the data we are using
(HERMES_RID_COMMSQUALITY) in a linear way, but the multiplier is not 1.
I remember I tried to recover the formula but didn't have time to
complete it.  Besides, different brands and version of the firmware do
it differently.

Anyway, we are using the same formula everywhere, yet we are
inconsistent.  In some places the code uses IW_QUAL_DBM, in some places
is doesn't.  It's better to be consistent.  We can improve the formula
later.  The numbers are in the reasonable range.

> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

(with some hesitation)
Signed-off-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
