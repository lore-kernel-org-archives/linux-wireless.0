Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34390 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbbFKDzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 23:55:47 -0400
Received: by igbhj9 with SMTP id hj9so47804846igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 20:55:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433944180-17321-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1433944180-17321-1-git-send-email-emmanuel.grumbach@intel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 11 Jun 2015 13:55:26 +1000
Message-ID: <CAGRGNgX6CGEPJj6UGiryYWZ8FjaC6NHSbRNvL=dAJL9Cvw+bpg@mail.gmail.com> (sfid-20150611_055551_976886_F91D3715)
Subject: Re: [PATCH] mac80211: Disable U-APSD if connected to a SISO or non-HT AP
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Avri Altman <avri.altman@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel / Avri,

On Wed, Jun 10, 2015 at 11:49 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Avri Altman <avri.altman@intel.com>
>
> There are a few APs our there that advertise U-APSD
> capabilities but don't implement it right which leads to
> poor traffic. These APs don't support MIMO or don't even
> support HT. Use this heuristic to detect them and disable
> U-APSD accordingly.
>
> Signed-off-by: Avri Altman <avri.altman@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/scan.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 7bb6a93..3791c8a 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -39,6 +39,28 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
>                          container_of((void *)bss, struct cfg80211_bss, priv));
>  }
>
> +/*
> + * An incompatible AP workaround:
> + * if the AP does not advertise MIMO capabilities disable U-APSD.
> + * iPhones, among others, advertise themselves as U-APSD capable when
> + * they aren't. Avoid connecting to those devices in U-APSD enabled.
> + */
> +static bool broken_uapsd_workarounds(struct ieee802_11_elems *elems)

Would a better name for this function be something like
is_uapsd_broken()? We're not actually working around anything here,
just checking whether it's broken or not.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
