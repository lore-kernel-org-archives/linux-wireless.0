Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59472 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2E3IX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 04:23:29 -0400
Received: by yhmm54 with SMTP id m54so3020078yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 01:23:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336554519.4323.7.camel@jlt3.sipsolutions.net>
References: <1336554519.4323.7.camel@jlt3.sipsolutions.net>
Date: Wed, 30 May 2012 10:23:28 +0200
Message-ID: <CAGXE3d_iBznfsKBQr5ES3m5cYmrGQ+kZW+cb7-cvd8pCh48-3Q@mail.gmail.com> (sfid-20120530_102336_802142_F8561F2D)
Subject: Re: [RFC] mac80211: add time synchronisation with BSS for assoc
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, May 9, 2012 at 11:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Some drivers (iwlegacy, iwlwifi and rt2x00) today use the
> bss_conf.last_tsf value. By itself though that value is
> completely worthless since it may be ancient. What really
> is needed is synchronisation between some device time and
> the TSF.
>
> To clarify this, rename bss_conf.last_tsf to sync_tsf and
> add sync_device_ts which is obtained from rx_status which
> gets a new field device_timestamp for this purpose. This
> is intentionally not using the mactime field since that
> is used for other things and in IBSS is expected to sync
> with the IBSS's TSF which isn't necessarily true for the
> device timestamp.
>
> Also, since we have the information and it's useful even
> before the connection has been established, give all the
> timing details to the driver before authenticating.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> I note that rt2x00 is completely broken since it mixes last_tsf (now
> sync_tsf) with jiffies ... what??

Thanks for coming up with this Johannes,  that looks indeed strange.

Ivo, that was introduced with your "rt2x00: Add autowake support for
USB hardware" patch as far as I can tell.

Since the last_beacon value is updated within rt2x00 already we should
be able to just remove the assignment in rt2x00lib_config_erp. Ivo, could
you please recheck?

This would also remove rt2x00's dependency on the last_tsf
field as provided by mac80211.

Thanks,
Helmut

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c
b/drivers/net/wireless/rt2x00/rt2x00config.c
index 96db933..b2d2ad3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -102,7 +102,6 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,

        /* Update the AID, this is needed for dynamic PS support */
        rt2x00dev->aid = bss_conf->assoc ? bss_conf->aid : 0;
-       rt2x00dev->last_beacon = bss_conf->last_tsf;

        /* Update global beacon interval time, this is needed for PS support */
        rt2x00dev->beacon_int = bss_conf->beacon_int;
