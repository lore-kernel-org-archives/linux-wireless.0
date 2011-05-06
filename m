Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:56151 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab1EFN3S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 09:29:18 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-66-79-239-161.nexicom.net [66.79.239.161])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p46DTGhf009831
	for <linux-wireless@vger.kernel.org>; Fri, 6 May 2011 09:29:17 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id B0E651E015F
	for <linux-wireless@vger.kernel.org>; Fri,  6 May 2011 09:29:15 -0400 (EDT)
Message-ID: <4DC3F7CB.5070905@lockie.ca> (sfid-20110506_152923_287580_F2B58116)
Date: Fri, 06 May 2011 09:29:47 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: scan not working or limited
References: <4DC386BB.4010106@lockie.ca> <BANLkTinc_raEdwm-uxSKWHBMoB92V5fxgw@mail.gmail.com>
In-Reply-To: <BANLkTinc_raEdwm-uxSKWHBMoB92V5fxgw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/11 01:49, Mohammed Shafi wrote:
> On Fri, May 6, 2011 at 10:57 AM, James <bjlockie@lockie.ca> wrote:
>> I get the errors:
>> ath: Failed to stop TX DMA in 100 msec after killing last frame
>> ath: Failed to stop TX DMA!
>> on all the kernels that my scans don't work right.
>>
>> I did:
>> $ git clone
>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
>> $ cd linux-2.6.37.y
>> $ git bisect start
>> $ git bisect good v2.6.36
>> $ git bisect bad v2.6.37.6
>> It said 3044100e58c84e133791c8b60a2f5bef69d732e4 is the first bad commit.
>>
>> I typed that number. :-(
>> How do I make git print it again?
>> How do I find the details of that commit?
> git show 3044100e58c84e133791c8b60a2f5bef69d732e4
>
>> How do I reverse what that commit did?
> git revert 3044100e58c84e133791c8b60a2f5bef69d732e4
>
> but that commit is not related to the problem you have
$ git checkout v2.6.37.6

$ git revert 3044100e58c84e133791c8b60a2f5bef69d732e4
fatal: Commit 3044100e58c84e133791c8b60a2f5bef69d732e4 is a merge but no
-m option was given.

