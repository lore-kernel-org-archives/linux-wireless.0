Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54065 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0L1FiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 00:38:09 -0500
Received: by gxk9 with SMTP id 9so1101182gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 21:38:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293456859.19215.3072.camel@powerslave>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-13-git-send-email-arik@wizery.com> <1293456859.19215.3072.camel@powerslave>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 28 Dec 2010 07:37:51 +0200
Message-ID: <AANLkTimWEnDo40g6gxkRvGFJHXXgTy2r46HNLBSrZfyo@mail.gmail.com>
Subject: Re: [PATCH v2 12/18] wl1271: AP mode - add STA add/remove ops
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 27, 2010 at 15:34, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
>> Allocate and free host link IDs (HLIDs) for each link. A per-STA
>> data structure keeps the HLID of each STA.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> +static int wl1271_op_sta_add(struct ieee80211_hw *hw,
>> +                          struct ieee80211_vif *vif,
>> +                          struct ieee80211_sta *sta)
>> +{
>> +     struct wl1271 *wl = hw->priv;
>> +     int ret = 0;
>> +     u8 hlid;
>> +
>> +     mutex_lock(&wl->mutex);
>> +
>> +     if (unlikely(wl->state == WL1271_STATE_OFF))
>> +             goto out;
>> +
>> +     if (wl->bss_type != BSS_TYPE_AP_BSS)
>> +             goto out;
>
> Should we ever bump into these two conditions? Shouldn't we warn or
> return errors?

It will happen in IBSS as well, in which case we don't want to do anything.

>
>
>> +static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
>> +                             struct ieee80211_vif *vif,
>> +                             struct ieee80211_sta *sta)
>> +{
>> +     struct wl1271 *wl = hw->priv;
>> +     struct wl1271_station *wl_sta;
>> +     int ret = 0;
>> +
>> +     mutex_lock(&wl->mutex);
>> +
>> +     if (unlikely(wl->state == WL1271_STATE_OFF))
>> +             goto out;
>> +
>> +     if (wl->bss_type != BSS_TYPE_AP_BSS)
>> +             goto out;
>
> Same here...

As in the above :)

>
>
>> +     wl1271_debug(DEBUG_MAC80211, "mac80211 remove sta %d", (int)sta->aid);
>> +
>> +     ret = wl1271_ps_elp_wakeup(wl, false);
>> +     if (ret < 0)
>> +             goto out;
>> +
>> +     wl_sta = (struct wl1271_station *)sta->drv_priv;
>> +     ret = wl1271_cmd_remove_sta(wl, wl_sta->hlid);
>> +     if (ret < 0)
>> +             goto out_sleep;
>
> Would it make sense to check if the sta is really in use (ie. it is
> marked in the ap_sta_map) before trying to remove it?

It does. I'll add the check.

Regards,
Arik
