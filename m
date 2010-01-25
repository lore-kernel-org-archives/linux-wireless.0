Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55421 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab0AYRpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 12:45:16 -0500
Received: by bwz27 with SMTP id 27so2868293bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 09:45:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f1001250939r6d136927q51bba86f7102d826@mail.gmail.com>
References: <4B5CD1FF.4090209@twilightblue.net> <b6c5339f1001250939r6d136927q51bba86f7102d826@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 25 Jan 2010 18:44:51 +0100
Message-ID: <69e28c911001250944h2cbd5d6eia6d78b652d10f135@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, associating with WEP128 AP is unreliable
To: Bob Copeland <me@bobcopeland.com>
Cc: Don Darling <darling.don@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 25, 2010 at 6:39 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sun, Jan 24, 2010 at 6:04 PM, Don Darling <darling.don@gmail.com> wrote:
>> Hello folks,
>>
>> I recently tried upgrading to kernel version 2.6.32, but after this upgrade
>> my wireless card became flaky when making connections. In cases where a
>> connection can be established it is  stable, but there are problems when
>> making wireless associations. Downgrading to kernel version 2.6.31 resolves
>> this issue.  I'm not sure at the moment which versions of the ath5k driver
>> maps to these kernel versions.
>
> The (vanilla) kernel version is sufficient to know which driver it is.
>
>> I'm assuming this issue is related to the ath5k driver itself -- the network
>> I'm using is only WEP128, and doesn't need wpa_supplicant.
>
> Huh, I didn't think any mac80211 driver supported WEP 128.  Are you sure you
> weren't using madwifi before?  Or maybe WEP 104?
>
> Are you using any modparams with ath5k?
>
>> In fact, I have
>> fewer problems when I connect to WPA+TKIP networks with wpa_supplicant.
>
> This is somewhat more secure, so I'd recommend it, or better CCMP.
>
>> Reverting to 2.6.31 resolves this issue. It will connect the first time, and
>> I can disconnect/re-connect several times without issue.
>
> I can't think of anything that changed in this time frame with ath5k
> specifically
> having to do with crypto.  If you were using nohwcrypt=1, it could be a problem
> with mac80211.  Otherwise, bisecting might be the best route to pin it down.

One more important detail: wpa_supplicant can use both wext and
nl80211, while iwconfig and networkmanager are wext-only.

Don: do you use -d wext or -d nl80211 with wpa_supplicant?

>
> Also on the off-chance that it's not crypto related, you may try the suggestions
> in the following to get a better picture of whwat is going on:
>
> http://wireless.kernel.org/en/users/Documentation/Reporting_bugs
>
> --
> Bob Copeland %% www.bobcopeland.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
