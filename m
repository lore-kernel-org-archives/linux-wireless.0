Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:61333 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZEaNvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 09:51:09 -0400
Received: by bwz22 with SMTP id 22so6992727bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 06:51:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <1243524688.10632.0.camel@johannes.local>
References: <1243524688.10632.0.camel@johannes.local>
Date: Sun, 31 May 2009 14:51:09 +0100
Message-ID: <9b2b86520905310651g41babab2hb05729b0699dd81f@mail.gmail.com>
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/28/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> The new code added by this patch will make rfkill create
> a misc character device /dev/rfkill that userspace can use
> to control rfkill soft blocks and get status of devices as
> well as events when the status changes.
>
> Using it is very simple -- when you open it you can read
> a number of times to get the initial state, and every
> further read blocks (you can poll) on getting the next
> event from the kernel. The same structure you read is
> also used when writing to it to change the soft block of
> a given device, all devices of a given type, or all
> devices.
>
> This also makes CONFIG_RFKILL_INPUT selectable again in
> order to be able to test without it present since its
> functionality can now be replaced by userspace entirely
> and distros and users may not want the input part of
> rfkill interfering with their userspace code. We will
> also write a userspace daemon to handle all that and
> consequently add the input code to the feature removal
> schedule.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

How should userspace test CONFIG_RFKILL_INPUT to determine whether
it's safe to start the daemon?  With the old core, debian-eeepc
scripts check if the module rfkill-input exists (which should work
even if it's built in).  If it exists, the scripts don't perform any
rfkill actions.  (Yeah, according to the doc this is not allowed
because the scripts don't use "claim", but you can see how it's
useful).

The new rfkill-input isn't a module, so I'm not sure how your daemon
would test for it.

Thanks
Alan
