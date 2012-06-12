Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58778 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2FLOwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 10:52:05 -0400
Received: by dady13 with SMTP id y13so6967204dad.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 07:52:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ipew63b2.fsf@purkki.adurom.net>
References: <1339497630-31589-1-git-send-email-eyal@wizery.com> <87ipew63b2.fsf@purkki.adurom.net>
From: Eyal Shapira <eyal@wizery.com>
Date: Tue, 12 Jun 2012 17:51:45 +0300
Message-ID: <CAF8O4-xur15soj2Emedz3YO2Dp82n6f-QPEj8=HkBFDD2S7agQ@mail.gmail.com> (sfid-20120612_165209_552402_1A55C1F3)
Subject: Re: [PATCH] mac80211: handle auth failure returned with unmatching
 auth algo
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 June 2012 16:57, Kalle Valo <kvalo@adurom.com> wrote:
> Eyal Shapira <eyal@wizery.com> writes:
>
>> Some Netgear APs like WNAP210 have a quirk behavior when
>> configured for WEP Shared. They send an auth response with algo
>> SHARED and status code NOT_SUPPORTED_AUTH_ALG (13) when being
>> sent a request made with auth algo OPEN. Enable such response to
>> propagate to userspace instead of discarding it so wpa_s can
>> reattempt to auth with SHARED.
>>
>> Reported-by: Noam Shaked <noams@ti.com>
>> Signed-off-by: Eyal Shapira <eyal@wizery.com>
>
> [...]
>
>> -     if (auth_alg != ifmgd->auth_data->algorithm ||
>> +     if ((auth_alg != ifmgd->auth_data->algorithm &&
>> +          status_code != WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG) ||
>
> I think a small comment in the code would be nice, like
> "WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG is a workaround for Netgear
> WNAPxxx".
>
Sure. I'll add that in v2.

> --
> Kalle Valo
