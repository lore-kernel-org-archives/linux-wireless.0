Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57461 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030278AbbJ3Jh1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:37:27 -0400
Message-ID: <1446197844.3261.18.camel@sipsolutions.net> (sfid-20151030_103730_834743_EB240C7A)
Subject: Re: Undocumented Sleep Requirements for ieee80211_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Oct 2015 10:37:24 +0100
In-Reply-To: <CABPxzYJNCFzCWgbRYxGbkrf1x6BPupC8+O5R7167FDL1rK+4mA@mail.gmail.com> (sfid-20151029_074633_916410_0CB28043)
References: <CABPxzYJNCFzCWgbRYxGbkrf1x6BPupC8+O5R7167FDL1rK+4mA@mail.gmail.com>
	 (sfid-20151029_074633_916410_0CB28043)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-10-29 at 12:16 +0530, Krishna Chaitanya wrote:
> Hi,
> 
> From the documentation:(mac80211.h) For the ieee80211_ops
> (un)assign_vif_chanctx, there is no mention of explicit sleep
> requirements (allowed/disallwoed) for the callback.

Same goes for drv_switch_vif_chanctx().

> From a quick glance at the code calling the OP, looks like we can
> sleep (mutexes are used). So how should we handle such OPS? is it ok
> to sleep in the callback?
> 

You can sleep, and I'd appreciate if you sent a patch to add
might_sleep() to the code and the appropriate documentation.

johannes
