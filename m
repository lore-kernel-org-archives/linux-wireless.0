Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1773 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZGaNTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 09:19:36 -0400
Message-ID: <4A72EF60.1090501@tpi.com>
Date: Fri, 31 Jul 2009 07:19:28 -0600
From: Tim Gardner <timg@tpi.com>
Reply-To: timg@tpi.com
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-acpi@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Fix rfkill state queries
References: <1249007138-27354-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1249007138-27354-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Garrett wrote:
> The current code in dell-laptop is confused about the hardware rfkill
> state. Fix it up such that it's always reported correctly.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/platform/x86/dell-laptop.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
> index 74909c4..9061111 100644
> --- a/drivers/platform/x86/dell-laptop.c
> +++ b/drivers/platform/x86/dell-laptop.c
> @@ -197,8 +197,8 @@ static void dell_rfkill_query(struct rfkill *rfkill, void *data)
>  	dell_send_request(&buffer, 17, 11);
>  	status = buffer.output[1];
>  
> -	if (status & BIT(bit))
> -		rfkill_set_hw_state(rfkill, !!(status & BIT(16)));
> +	rfkill_set_sw_state(rfkill, !!(status & BIT(bit)));
> +	rfkill_set_hw_state(rfkill, !(status & BIT(16)));
>  }
>  
>  static const struct rfkill_ops dell_rfkill_ops = {

This works on an Inspiron 1420 and XPS1330 as far as I was able to test.
The physical rfkill switch sets 'Hard blocked: yes' for 'phy0: Wireless
LAN', and everything returns to normal 'blocked: no' when the switch is
disabled. I was not able to figure out how to get BIT(16) cleared. Is
that a keyboard function? Anyways,

Tested-by: Tim Gardner <tim.gardner@canonical.com>

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
