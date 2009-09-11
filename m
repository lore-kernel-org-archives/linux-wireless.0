Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:50681 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZIKFSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 01:18:45 -0400
Date: Thu, 10 Sep 2009 22:13:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-input@vger.kernel.org, linux-wireless@vger.kernel.org,
	marcel@holtmann.org
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Message-ID: <20090911051259.GC23210@core.coreip.homeip.net>
References: <1252603292-20830-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1252603292-20830-1-git-send-email-mjg@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 06:21:31PM +0100, Matthew Garrett wrote:
> Most laptops have keys that are intended to toggle all device state, not
> just wifi. These are currently generally mapped to KEY_WLAN. As a result,
> rfkill will only kill or enable wifi in response to the key press. This
> confuses users and can make it difficult for them to enable bluetooth
> and wwan devices.
> 
> This patch adds a new keycode, KEY_RFKILL_ALL. It indicates that the

The new name in description does not match the code...

> system should toggle the state of all rfkillable devices.

Hmm, rfkill changes usually go through net tree so unless they want me
to push it though I'll just ACK the new keycode.

> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

> ---
>  include/linux/input.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 8b3bc3e..20a622e 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -595,6 +595,8 @@ struct input_absinfo {
>  #define KEY_NUMERIC_STAR	0x20a
>  #define KEY_NUMERIC_POUND	0x20b
>  
> +#define KEY_RFKILL		0x20c /* Key that controls all radios */
> +
>  /* We avoid low common keys in module aliases so they don't get huge. */
>  #define KEY_MIN_INTERESTING	KEY_MUTE
>  #define KEY_MAX			0x2ff

-- 
Dmitry
