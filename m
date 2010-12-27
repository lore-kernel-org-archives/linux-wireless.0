Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46359 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0L0Vxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 16:53:52 -0500
Received: by ywl5 with SMTP id 5so3691485ywl.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 13:53:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293455515.19215.3052.camel@powerslave>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-10-git-send-email-arik@wizery.com> <1293455515.19215.3052.camel@powerslave>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 27 Dec 2010 23:46:09 +0200
Message-ID: <AANLkTikJEugD5QGikqEYm2FNbCmye-Xt5Uk4AVd43wgE@mail.gmail.com>
Subject: Re: [PATCH v2 09/18] wl1271: Configure AP on BSS info change
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 27, 2010 at 15:11, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
>> Configure AP-specific beacon and probe response templates.
>> Start the AP when beaconing is enabled.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>>  static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>> @@ -1898,73 +1900,84 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>
> This whole wl1271_op_bss_info_changed() function was already quite long
> and hard to read.  Now, with support for AP and STA, it got even worse.
> I think this should be broken down into smaller functions.  No need to
> clean the whole function up now, but would it be possible to separate at
> least the AP and STA parts into separate functions?

Sounds like a good idea. I'll separate it into 3 functions - common,
ap and sta/ibss.

>
>
>> @@ -1983,11 +2018,11 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>>                                                 bss_conf->cqm_rssi_thold,
>>                                                 bss_conf->cqm_rssi_hyst);
>>               if (ret < 0)
>> -                     goto out;
>> +                     goto out_sleep;
>
> Hmmm, nice catch.  We were going out without sleeping in case of error
> here.  But this is a cross-patch change, could you separate it and send
> as a standalone patch?

Sure.

Regards,
Arik
