Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42372 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab1JJUr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 16:47:26 -0400
Received: by iabz25 with SMTP id z25so748070iab.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 13:47:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318279138.9690.421.camel@cumari>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	<1318234397-21081-22-git-send-email-eliad@wizery.com>
	<1318279138.9690.421.camel@cumari>
Date: Mon, 10 Oct 2011 22:47:26 +0200
Message-ID: <CAB3XZEf+YgQMdsduXb1eL5r_E+A-Y0EdyP-4map4ZqmQbLTweA@mail.gmail.com> (sfid-20111010_224735_323302_4FCEDED6)
Subject: Re: [PATCH 21/29] wl12xx: add band field to wlvif
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 10, 2011 at 10:38 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2011-10-10 at 10:13 +0200, Eliad Peller wrote:
>> add band field into the per-interface data.
>>
>> mac80211 configures some values (e.g. band, channel)
>> globally, while we configure them per-interface.
>>
>> In order to make it easier to keep track of the
>> configured value for each value while keeping sync
>> with mac80211, save these values both globally
>> and per-vif.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> [...]
>
>
>> -static int wl12xx_cmd_roc(struct wl1271 *wl, u8 role_id)
>> +static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>> +                       u8 role_id)
>
> [...]
>
>> -int wl12xx_roc(struct wl1271 *wl, u8 role_id)
>> +int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id)
>
> Seems like wl12xx_roc(), which is the only caller of wl12xx_cmd_roc(),
> is always called with wlvif->role_id as the role, so it seems a bit
> useless to pass role_id separately all the way.
>
in fact, it's usually being called with wlvif->dev_role_id, so we do
need this param.

(otoh, wl12xx_roc is usually get called along with start_role_dev. i
have some pending patch that couples them together and cleans the code
a bit. i'll send it soon).

Eliad.
