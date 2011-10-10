Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45321 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1JJTVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 15:21:35 -0400
Received: by gyg10 with SMTP id 10so5664748gyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 12:21:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318270806.9690.373.camel@cumari>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	<1318234397-21081-6-git-send-email-eliad@wizery.com>
	<1318270806.9690.373.camel@cumari>
Date: Mon, 10 Oct 2011 21:21:35 +0200
Message-ID: <CAB3XZEejP2iELFGd+s+-4fBPTxDk_iuNPhU1AZdmCxneBKGF-Q@mail.gmail.com> (sfid-20111010_212139_019757_1B7123A2)
Subject: Re: [PATCH 05/29] wl12xx: move bitrate_masks into wlvif
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 10, 2011 at 8:20 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
>> move bitrate_masks into the per-interface data, rather than
>> being global.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
>> index 102a8a5..ff653e8 100644
>> --- a/drivers/net/wireless/wl12xx/cmd.c
>> +++ b/drivers/net/wireless/wl12xx/cmd.c
>> @@ -1111,15 +1111,16 @@ out:
>>       return ret;
>>  }
>>
>> -int wl1271_cmd_build_probe_req(struct wl1271 *wl,
>> +int wl1271_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>>                              const u8 *ssid, size_t ssid_len,
>>                              const u8 *ie, size_t ie_len, u8 band)
>
> If struct wl12xx_vif contains a pointer to wl, can't you pass only wlvif
> to all these functions instead of passing both?
>
yes, it's possible.
but maybe leave it for some future overhaul?

Eliad.
