Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:48077 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752537AbYGEUZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 16:25:40 -0400
Message-ID: <486FD8AF.5050001@sbcglobal.net> (sfid-20080705_222543_334498_42979422)
Date: Sat, 05 Jul 2008 13:25:19 -0700
From: Bryan Batten <BryanBatten@sbcglobal.net>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error in adhoc/master
 mode
References: <200807051511.57995.IvDoorn@gmail.com> <486FBE75.5040100@sbcglobal.net> <200807052042.47008.IvDoorn@gmail.com>
In-Reply-To: <200807052042.47008.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
...
> That is interesting, have you tried controlling CSR14 and more
> specifically the TBCN or BeaconGen fields?

No. It turns out that if I set the RT2500's CSR14 to zero (the default 
power on state according to the data sheet) at driver initialization, 
there are no beacon interrupts until enabled in AsicEnableIbssSync(). 
I deem this a bug, the fix for which in now in CVS.

Thanks,
-- 
Bryan
-
"Beyond the point of no return, there's no going back."

Narration to "Mars Rising" on the Science Channel
