Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46121 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZE2Kog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 06:44:36 -0400
Subject: Re: [PATCH v4] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243586317.963.1.camel@johannes.local>
References: <1243524688.10632.0.camel@johannes.local>
	 <1243525481.10632.6.camel@johannes.local>
	 <1243526296.10632.7.camel@johannes.local>
	 <1243586317.963.1.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 29 May 2009 12:43:56 +0200
Message-Id: <1243593836.3523.4.camel@localhost.localdomain>
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
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> v4: set default global state from userspace for rfkill hotplug
>     (pointed out by Marcel)

I have tested this patch with a prototype code for ConnMan and it works
fine here.

Acked-by: Marcel Holtmann <marcel@holtmann.org>
Tested-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


