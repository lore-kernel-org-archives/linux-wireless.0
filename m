Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:41286 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab0LQTip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 14:38:45 -0500
Received: by iwn42 with SMTP id 42so507890iwn.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 11:38:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101217063957.GB1381@senthil-lnx.users.atheros.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
 <1292556197-4820-4-git-send-email-lrodriguez@atheros.com> <20101217063957.GB1381@senthil-lnx.users.atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 17 Dec 2010 11:38:24 -0800
Message-ID: <AANLkTimXQ_pk96zF0tC_pBYLzt4wnjGE-cmTsdwpyc7s@mail.gmail.com>
Subject: Re: [RFC 3/8] cfg80211: pass DFS region to drivers through reg_notifier()
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 10:39 PM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
>> diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
>> index 2b14775..426b514 100644
>> --- a/drivers/net/wireless/ath/regd.c
>> +++ b/drivers/net/wireless/ath/regd.c
>> @@ -337,7 +337,8 @@ static void ath_reg_apply_world_flags(struct wiphy *wiphy,
>>
>>  int ath_reg_notifier_apply(struct wiphy *wiphy,
>>                          struct regulatory_request *request,
>> -                        struct ath_regulatory *reg)
>> +                        struct ath_regulatory *reg,
>> +                        u16 dfs_region)
> may be we can maintain consistency of dfs_regsion type. It's u8 everywhere
> except here..???

Good catch yes, that was a typo.

  Luis
