Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38507 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2KTIWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 03:22:18 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5668145oag.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 00:22:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353348860.10872.131.camel@cumari.coelho.fi>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-2-git-send-email-eliad@wizery.com>
	<1353348860.10872.131.camel@cumari.coelho.fi>
Date: Tue, 20 Nov 2012 10:22:18 +0200
Message-ID: <CAB3XZEcnbAErr57F9KePq4Lfc+q=H5S3L7kNFEm9YVr3fM_MLw@mail.gmail.com> (sfid-20121120_092222_311111_440A0D7B)
Subject: Re: [PATCH 01/15] wlcore: start sta role on CHANGED_BSSID
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 8:14 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
>> Make the connection flow simpler by starting
>> sta role on bssid change.
>>
>> Currently, we start dev role when going idle-off,
>> and start the sta role only after association
>> indication. This complicates the connection
>> flow with some possible intermediate states.
>>
>> Make it simpler by starting sta role on bssid change,
>> which now happens *before* auth req get sent.
>>
>> Update the handling of mac80211's notifications
>> and change wl1271_join/unjoin accordingly -
>> * Split wl1271_join() into wlcore_join (tuning on
>>   a channel/bssid) and wlcore_set_assoc (configure
>>   sta after association).
>> * Rename wl1271_unjoin() to wlcore_disconnect(), as
>>   it is no longer the inversion of wl1271_join()
>>   (now it's only used to disconnect associated sta /
>>   joined ibss, without stopping the role).
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> [...]
>
>> -static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>> +static void wlcore_disconnect(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>
> Why not wlcore_unset_assoc()? Or change the wlcore_set_assoc() to
> wlcore_connect()?
>
i'll pick the first option.

>> +                     if (wl->sched_scanning) {
>> +                             wl1271_scan_sched_scan_stop(wl, wlvif);
>> +                             ieee80211_sched_scan_stopped(wl->hw);
>> +                     }
>> +
>>                       ret = wl1271_acx_sta_rate_policies(wl, wlvif);
>>                       if (ret < 0)
>>                               goto out;
>>
>> +                     ret = wl12xx_cmd_build_null_data(wl, wlvif);
>> +                     if (ret < 0)
>> +                             goto out;
>> +
>> +                     ret = wl1271_build_qos_null_data(wl, vif);
>> +                     if (ret < 0)
>> +                             goto out;
>> +
>> +                     /* Need to update the BSSID (for filtering etc) */
>> +                     set_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
>> +                     do_join = true;
>> +             } else {
>> +                     /* revert back to minimum rates for the current band */
>> +                     wl1271_set_band_rate(wl, wlvif);
>> +                     wlvif->basic_rate =
>> +                             wl1271_tx_min_rate_get(wl,
>> +                                                    wlvif->basic_rate_set);
>> +                     ret = wl1271_acx_sta_rate_policies(wl, wlvif);
>> +                     if (ret < 0)
>> +                             goto out;
>> +
>> +                     if (!is_ibss &&
>> +                         test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags)) {
>> +                             ret = wl12xx_cmd_role_stop_sta(wl, wlvif);
>> +                             if (ret < 0)
>> +                                     goto out;
>> +                     }
>> +                     clear_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
>> +             }
>> +     }
>
> It would be nice to keep all this stuff in a separate function instead
> of bringing it back into this already-huge wl1271_bss_info_changed_sta()
> function.
>
sure.
i'll give this function some more overhaul.
this applies also for the other similar comments.

Eliad.
