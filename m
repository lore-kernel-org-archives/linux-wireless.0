Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53887 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab1JYKNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:13:53 -0400
Received: by iaby12 with SMTP id y12so384184iab.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2011 03:13:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111021142428.470831999@sipsolutions.net>
References: <20111021142322.229128720@sipsolutions.net>
	<20111021142428.470831999@sipsolutions.net>
Date: Tue, 25 Oct 2011 12:13:53 +0200
Message-ID: <CAB3XZEf3LXek34LprEts0m0EZb5nHwDDE40PKQ32Q6aoczR=AQ@mail.gmail.com> (sfid-20111025_122049_806844_45F46A46)
Subject: Re: [RFC v2 05/12] nl80211: advertise device AP SME
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 21, 2011 at 4:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Add the ability to advertise that the device
> contains the AP SME and what features it can
> support.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]
> --- a/include/linux/nl80211.h   2011-10-21 12:07:39.000000000 +0200
> +++ b/include/linux/nl80211.h   2011-10-21 12:07:41.000000000 +0200
> @@ -1122,6 +1122,11 @@ enum nl80211_commands {
>  *     %NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
>  *     used for asking the driver to perform a TDLS operation.
>  *
> + * @NL80211_ATTR_DEVICE_AP_SME: This u32 attribute may be listed for devices
> + *     that have AP support to indicate that the have the AP SME integrated
s/the/they

> + *     with support for the features listed in this attribute, see
> + *     &enum nl80211_ap_sme_features.
> + *

>  * @NL80211_ATTR_MAX: highest attribute number currently defined
>  * @__NL80211_ATTR_AFTER_LAST: internal use
>  */
> @@ -1350,6 +1355,8 @@ enum nl80211_attrs {
>        NL80211_ATTR_TDLS_SUPPORT,
>        NL80211_ATTR_TDLS_EXTERNAL_SETUP,
>
> +       NL80211_ATTR_DEVICE_AP_MLME,
> +

the attribute name is different from the documented one (SME/MLME)

Eliad.
