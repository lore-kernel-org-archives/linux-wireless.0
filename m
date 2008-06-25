Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:44001 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbYFYSYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 14:24:32 -0400
Message-ID: <48628D9A.5090502@lwfinger.net> (sfid-20080625_202434_996532_36ED50E8)
Date: Wed, 25 Jun 2008 13:25:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linville@tuxdriver.com, hintak_leung@yahoo.co.uk,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] rtl8187: Realtek 8187B wireless support with	product	id0x8197/0x8189
References: <4862796a.pmrQX9GXIZ1wDm2k%Larry.Finger@lwfinger.net>	 <1214415411.7901.25.camel@dv>  <4862840F.4030409@lwfinger.net> <1214416662.9237.6.camel@dv>
In-Reply-To: <1214416662.9237.6.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Wed, 2008-06-25 at 12:44 -0500, Larry Finger wrote:

> I'm not sure I can stand behind that patch quality-wise.   It's 40k of
> intrusive changes that I could not even test on an old rtl8187.  If I
> had more time and a original rtl8187 device, I would try to split more
> parts or restructure the code first.
> 
> Also, the startup time (ifconfig up) is over 20 seconds, which is
> absolutely unacceptable.  Either some delays are over-conservative, or
> we are doing something wrong.
> 

For the review process, I have split the patch into 5 parts. Each step 
compiles, thus bisection will be preserved. With this change, the 
largest of the pieces is a little under 15KiB. Is this small enough? 
Further splitting would be a lot more difficult.

As to the quality of the patch, it barely works on my device. RX seems 
to be OK except for the wireless statistics, but I can associate only 
about 1 try in 10. Once I get that problem squared away, then I can 
work on the timing. I really would like to get this into 
wireless-testing ASAP.

I don't have an 8187 device either, and will have to rely on someone 
else for that part of the testing.

Larry
