Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64168 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaJEQxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2014 12:53:37 -0400
Received: by mail-ob0-f177.google.com with SMTP id uy5so2818262obc.36
        for <linux-wireless@vger.kernel.org>; Sun, 05 Oct 2014 09:53:37 -0700 (PDT)
Date: Sun, 5 Oct 2014 11:53:34 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFT] iwlwifi: dvm: drop non VO frames when flushing
Message-ID: <20141005165334.GB5691@ubuntu-mba51> (sfid-20141005_185349_743394_A3EB5B79)
References: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412517432-16309-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 05, 2014 at 04:57:12PM +0300, Emmanuel Grumbach wrote:
> When mac80211 wants to ensure that a frame is sent, it calls
> the flush() callback. Until now, iwldvm implemented this by
> waiting that all the frames are sent (ACKed or timeout).
> In case of weak signal, this can take a significant amount
> of time, delaying the next connection (in case of roaming).
> Many users have reported that the flush would take too long
> leading to the following error messages to be printed:
> 
> iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
> iwlwifi 0000:03:00.0: Current SW read_ptr 161 write_ptr 201
> iwl data: 00000000: 00 00 00 00 00 00 00 00 fe ff 01 00 00 00 00 00
> [snip]
> iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
> [snip]
> iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [9,9]
> [snip]
> 
> Instead of waiting for these packets, simply drop them. This
> significantly improves the responsiveness of the network.
> Note that all the queues are flushed, but the VO one. This
> is not typically used by the applications and it likely
> contains management frames that are useful for connection
> or roaming.
> 
> This bug is tracked here:
> https://bugzilla.kernel.org/show_bug.cgi?id=56581
> 
> But it is duplicated in distributions' trackers.
> A simple search in Ubuntu's database led to these bugs:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux-firmware/+bug/1270808
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1305406
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1356236
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1360597
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1361809
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
> I am trying here to fix an issues that has been affecting many users on dvm.
> A few users in bugzilla already reported that this patch helped them a lot.
> I am trying to get more testers :)

I'll post test builds to the Ubuntu bugs and see if I can get any
testing.

Thanks,
Seth

