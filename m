Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42933 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3HLMVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 08:21:24 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx10so1934221pab.13
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 05:21:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374827327-3464-29-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net> <1374827327-3464-29-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 12 Aug 2013 15:21:08 +0300
Message-ID: <CA+XVXfeoHkOwrj76MwSC9ad5igffng8QueT6cKu9ytsLu=C+Cw@mail.gmail.com> (sfid-20130812_142135_085114_9D3C45B7)
Subject: Re: [PATCH 28/30] iwlwifi: mvm: Change beacon abort escape time value
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Alexander Bondar <alexander.bondar@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 11:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
>
> Set beacon abort escape timer values - 6 beacons in D0 state,
> 9 beacons in D3 and D0i3.
>
> Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 3 ++-
>  drivers/net/wireless/iwlwifi/mvm/power.c        | 3 +++
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
> index 149347d..060e630 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
> +++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
> @@ -285,7 +285,8 @@ struct iwl_beacon_filter_cmd {
>  #define IWL_BF_ESCAPE_TIMER_MAX 1024
>  #define IWL_BF_ESCAPE_TIMER_MIN 0
>
> -#define IWL_BA_ESCAPE_TIMER_DEFAULT 3
> +#define IWL_BA_ESCAPE_TIMER_DEFAULT 6
> +#define IWL_BA_ESCAPE_TIMER_D3 6

Did you mean 9 here?
(Sorry for the late review)
