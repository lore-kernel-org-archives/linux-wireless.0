Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0100.outbound.protection.outlook.com ([104.47.1.100]:35808
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752420AbeFNGQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 02:16:52 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [2/3] wireless-drivers: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
Date: Wed, 13 Jun 2018 11:46:34 +0000
Message-ID: <VI1PR02MB3631730EBE30CA24447203339A7E0@VI1PR02MB3631.eurprd02.prod.outlook.com> (sfid-20180614_081656_678962_0DC10BC4)
References: <1528273621-28116-2-git-send-email-omer.efrat@tandemg.com>,<20180613113507.B5F646074D@smtp.codeaurora.org>
In-Reply-To: <20180613113507.B5F646074D@smtp.codeaurora.org>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> wrote:

> Omer Efrat <omer.efrat@tandemg.com> wrote:
>
>> Since 'filled' member in station_info changed to u64, BIT_ULL macro
>> should be used with NL80211_STA_INFO_* attribute types instead of BIT.
>>=20
>> The BIT macro uses unsigned long type which some architectures handle as=
 32bit
>> and this results in compilation warnings such as:
>>=20
>> net/mac80211/sta_info.c:2223:2: warning: left shift count >=3D width of =
type
>>   sinfo->filled |=3D BIT(NL80211_STA_INFO_TID_STATS);
>>   ^
>>=20
>> Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>
>
> Can I take this patch 2 or is it going via some other tree?

Yes.


--
https://patchwork.kernel.org/patch/10449829/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
