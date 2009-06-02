Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57807 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951AbZFBIdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 04:33:32 -0400
Subject: Re: [PATCH v5] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243930133.20064.8.camel@johannes.local>
References: <1243524688.10632.0.camel@johannes.local>
	 <1243930133.20064.8.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 10:33:09 +0200
Message-Id: <1243931589.3192.66.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

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
> In order to have rfkilld support both kernels with and
> without CONFIG_RFKILL_INPUT (or new kernels after its
> eventual removal) we also add an ioctl (that only exists
> if rfkill-input is present) to disable rfkill-input.
> It is not very efficient, but at least gives the correct
> behaviour in all cases.

looks all good to me. As I said, before this makes sense and now we have
to start working on creating rfkilld for RFKILL policy and input
handling.

John, I would prefer if we start merging this into wireless-testing to
get proper user exposure and so we can start fixing fallouts (if there
are any). We then should merge this into 2.6.31 quickly to finally have
a proper RFKILL subsystem.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


