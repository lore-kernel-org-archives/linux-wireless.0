Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab3HBHir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 03:38:47 -0400
Message-ID: <1375429119.18144.0.camel@jlt4.sipsolutions.net> (sfid-20130802_093850_522172_049FDCBA)
Subject: Re: [3.11 regression?] iwlwifi firmware takes two minutes to load
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Date: Fri, 02 Aug 2013 09:38:39 +0200
In-Reply-To: <CALCETrW6BrCFHjALQVexUy61=f5QXOjiHhvRNGqnN--iZei+RQ@mail.gmail.com> (sfid-20130802_063920_036931_AFA9C3F3)
References: <CALCETrW6BrCFHjALQVexUy61=f5QXOjiHhvRNGqnN--iZei+RQ@mail.gmail.com>
	 (sfid-20130802_063920_036931_AFA9C3F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-01 at 21:38 -0700, Andy Lutomirski wrote:
> At boot, I get:
> [   12.537108] iwlwifi 0000:03:00.0: irq 51 for MSI/MSI-X
> ...
> [  132.676781] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1
> build 25532 op_mode iwldvm
> 
> This sounds familiar, but wasn't it fixed awhile ago?

It wasn't exactly fixed and it's really more of a userspace problem - we
probably request firmware version 8, and then it takes 30 seconds to
time out for each of 8,7,6,5, after which the next request for 4 is
successful.

I don't know why your userspace isn't behaving differently though.

johannes

