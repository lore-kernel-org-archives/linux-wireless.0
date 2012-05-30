Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58403 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2E3Op1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 10:45:27 -0400
Received: by qadb17 with SMTP id b17so1909231qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 07:45:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338385542.4511.19.camel@jlt3.sipsolutions.net>
References: <1338385542.4511.19.camel@jlt3.sipsolutions.net>
Date: Wed, 30 May 2012 17:45:26 +0300
Message-ID: <CAB3XZEdXbxnKVXkvtHASVhFj+M1u6iA636dF0oyc=SEt+=AP5g@mail.gmail.com> (sfid-20120530_164531_083470_672E435B)
Subject: Re: [RFC] cfg80211: don't allow WoWLAN support without CONFIG_PM
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 30, 2012 at 4:45 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When CONFIG_PM is enabled, no device can possibly
> support WoWLAN since it can't go to sleep to start
> with. Due to this, mac80211 had even rejected the
> hardware registration. By making all the code and
> data for WoWLAN depend on CONFIG_PM we can promote
> this runtime error to a compile-time error.
>
> Add #ifdef around all WoWLAN code to remove it in
> systems that don't need it as they never suspend.
>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Luciano Coelho <coelho@ti.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index acef933..d7cd9b5 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -5301,6 +5301,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
>                goto out_free_hw;
>        }
>
> +#ifdef CONFIG_PM
>        ret = enable_irq_wake(wl->irq);
>        if (!ret) {
>                wl->irq_wake_enabled = true;
> @@ -5315,6 +5316,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
>                }
>        }
>        disable_irq(wl->irq);
> +#endif

i think disable_irq should be outside the ifdef.

Eliad.
