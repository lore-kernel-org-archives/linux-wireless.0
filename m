Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:32922 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab0ELQ2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 12:28:40 -0400
Received: by pxi5 with SMTP id 5so111234pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 09:28:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005121720.50514.br1@einfach.org>
References: <1273526650-26282-1-git-send-email-hauke@hauke-m.de>
	<1273526650-26282-2-git-send-email-hauke@hauke-m.de> <201005121720.50514.br1@einfach.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 12 May 2010 09:28:18 -0700
Message-ID: <AANLkTinkg1lG6Zc-9CfxABp0DVpTsym1YFKlcFCHTMTE@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: make patches apply again
To: Bruno Randolf <br1@einfach.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 12, 2010 at 1:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Tuesday 11 May 2010 06:24:10 Hauke Mehrtens wrote:
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  patches/07-change-default-rate-alg.patch |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/patches/07-change-default-rate-alg.patch
>> b/patches/07-change-default-rate-alg.patch index af65207..f0ccbce 100644
>> --- a/patches/07-change-default-rate-alg.patch
>> +++ b/patches/07-change-default-rate-alg.patch
>> @@ -21,7 +21,7 @@ at compilation time.
>>   module_param(ieee80211_default_rc_algo, charp, 0644);
>>   MODULE_PARM_DESC(ieee80211_default_rc_algo,
>>                "Default rate control algorithm for mac80211 to use");
>> -@@ -118,8 +118,8 @@ ieee80211_rate_control_ops_get(const cha
>> +@@ -119,8 +119,8 @@ ieee80211_rate_control_ops_get(const cha
>>               ops =
> ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
>>
>>       /* try built-in one if specific alg requested but not found */
>> @@ -29,6 +29,6 @@ at compilation time.
>>  -            ops =
> ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
>>  +    if (!ops && strlen(CONFIG_COMPAT_MAC80211_RC_DEFAULT))
>>  +            ops =
>> ieee80211_try_rate_control_ops_get(CONFIG_COMPAT_MAC80211_RC_DEFAULT); +
>>       kparam_unblock_sysfs_write(ieee80211_default_rc_algo);
>>
>>       return ops;
>> - }
>
> this is somehow messed up and doesn't apply. here is a fixed version of the
> patch (not a patch for a patch)...

Odd, it applied, here with git am and all. Hm, oh well.

  Luis
