Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38870 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbbIGJyL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 05:54:11 -0400
Message-ID: <1441619646.1940.2.camel@sipsolutions.net> (sfid-20150907_115414_364095_4E2B440B)
Subject: Re: using dev_coredumpv
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 07 Sep 2015 11:54:06 +0200
In-Reply-To: <55ED5D28.8000309@broadcom.com> (sfid-20150907_114727_883458_63EE9237)
References: <55ED5D28.8000309@broadcom.com>
	 (sfid-20150907_114727_883458_63EE9237)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-09-07 at 11:47 +0200, Arend van Spriel wrote:
> Hi Johannes,
> 
> I am looking at devcoredump subsystem and I was wondering about the
> lifetime of the devcd folder. With dev_coredumpm() the description says:
> "If a previous one hasn't been read yet, the new coredump is
> discarded.". I am wondering what "read" means here. For testing I call
> dev_coredumpv() every second, but when I hexdump the data file it does
> not create a new devcd folder. That only occurs after 5 minutes. Is that
> expected?

I suppose "read" should say "discarded by userspace", but I always
assumed userspace would read the file and then discard the coredump by
writing (anything iirc) to the file.

IOW - yes, this is expected, you should write to the data file which
makes it (and the folder) disappear and allows creating a new one.

johannes
