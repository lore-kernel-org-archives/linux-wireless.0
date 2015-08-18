Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20824 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbbHRJMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 05:12:23 -0400
Date: Tue, 18 Aug 2015 12:12:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Tony Cho <tony.cho@atmel.com>, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	jude.lee@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 5/5] staging: wilc1000: use id value as argument
Message-ID: <20150818091224.GM5558@mwanda> (sfid-20150818_111226_637094_0DCBB668)
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
 <1439440883-16061-6-git-send-email-tony.cho@atmel.com>
 <20150813144907.GA4484@mwanda>
 <55D2A23D.2080209@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55D2A23D.2080209@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2015 at 12:10:53PM +0900, Johnny Kim wrote:
> Hello Dan.
> 
> On 2015년 08월 13일 23:49, Dan Carpenter wrote:
> >On Thu, Aug 13, 2015 at 01:41:23PM +0900, Tony Cho wrote:
> >>+static u32 get_id_from_handler(tstrWILC_WFIDrv *handler)
> >>+{
> >>+	u32 id;
> >>+
> >>+	if (!handler)
> >>+		return 0;
> >>+
> >>+	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
> >>+		if (wfidrv_list[id] == handler) {
> >>+			id += 1;
> >>+			break;
> >>+		}
> >>+	}
> >>+
> >>+	if (id > NUM_CONCURRENT_IFC)
> >>+		return 0;
> >>+	else
> >>+		return id;
> >>+}
> >>+
> >This still has an off by one bug.  Just use zero offset arrays
> >throughout.
> >
> >static int get_id_from_handler(tstrWILC_WFIDrv *handler)
> >{
> >	int id;
> >
> >	if (!handler)
> >		return -ENOBUFS;
> >
> >	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
> >		if (wfidrv_list[id] == handler)
> >			return id;
> >	}
> >
> >	return -ENOBUFS;
> >}
> Thanks for your review. The return value of this function has from 0 till 2.
> 1 and 2 value is real ID value. only 0 value is reserved to remove a
> registered id.
> But I also think that error handling should be added about the
> overflowed value
> as your opinion.

I thought we had created "id" here in this patch so we don't have to
pass function pointers through a u32 value (which can't fit a 64 bit
pointer).  What do you mean it is a "real ID value"?  Is it there in
the hardware spec?

Anyway, this code is buggy and messy.  Please find a different way to
write it.

regards,
dan carpenter
