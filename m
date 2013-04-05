Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:38917 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162806Ab3DEWNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 18:13:37 -0400
Received: by mail-qe0-f54.google.com with SMTP id s14so2277867qeb.41
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 15:13:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
References: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
Date: Fri, 5 Apr 2013 16:13:36 -0600
Message-ID: <CAMLZHHRcTgQ66fucR09SEyjCCRiZixigM=cDwnfKB5yWYk4PQw@mail.gmail.com> (sfid-20130406_001342_397440_8BB3A12E)
Subject: Re: mwifiex frequent "not allowed while suspended" crash on resume
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 19, 2013 at 12:43 AM, Bing Zhao <bzhao@marvell.com> wrote:
> I will think about how to serialize the resume/interrupt sequence.

As we haven't heard back from you in a while, and this is blocking
several things on our end, I had a quick look myself.

The problem seems to be TX soon after resume, and there does seem to
be a bit of a lack of synchronization here (i.e. mwifiex_main_process
should maybe avoid doing TX while the interface is suspended).

As a quick hack I added netdev_device_detach() early in suspend, and
netdev_device_attach() late in resume, and that seems to serialize
things. But I don't think its a good fix. Hopefully you can find a
solution that flows better with the mwifiex design.

Thanks
Daniel
