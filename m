Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab1BWIpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 03:45:50 -0500
Subject: Re: Help about Intel Centrino Advanced-N 6205 wifi card
From: Johannes Berg <johannes@sipsolutions.net>
To: jgq516@gmail.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298444805-27178-1-git-send-email-jgq516@gmail.com>
References: <1298444805-27178-1-git-send-email-jgq516@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 09:45:48 +0100
Message-ID: <1298450748.3747.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-23 at 15:06 +0800, jgq516@gmail.com wrote:
> Hello all,
> 
> I have one Intel Centrino Advanced-N 6205 wifi card which need
> firmware iwlwifi-6000g2a-4.ucode to support it, but in intel website
> http://intellinuxwireless.org/?n=Downloads, only
> iwlwifi-6000g2a-5.ucode firmware exists, where can I download the
> official version 4 firmware? Thanks in advance!

There's no such thing.

> I also got iwlwifi-6000g2a-4.ucode from one website

I'm not aware of any such released version, so this must be a test build
or similar.

>  but maybe it has some problems, this firmware works well with kernel
> 2.6.37-rc1,
> but it seems can't compatible with 2.6.36, there are some "Microcode
> SW error detected" when enable the card, pls see the following
> logs, why this error exist with 2.6.36 kernel but disappeared in
> 2.6.37-rc1 kernel? and unfortunately, I want to work with 2.6.36
> kernel:(.

Since this is a new device, support in 2.6.36 will likely not be
possible. You might be able to modify iwl-6000.c to load a v5 firmware
(set IWL6000G2_UCODE_API_MAX to 5) but we cannot support that and I
don't know that the firmware API didn't change and you'll run into
crashes again.

I believe that the only supported way to get your device working is to
start with 2.6.37 and the latest official -5 firmware image from the
Intel download page.

If you're really stuck on 2.6.36 for some reason, you can use
compat-wireless to backport the driver.

johannes

