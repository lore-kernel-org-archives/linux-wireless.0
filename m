Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:22692 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYIHQmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 12:42:05 -0400
Received: by yx-out-2324.google.com with SMTP id 8so874848yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 09:42:04 -0700 (PDT)
Message-ID: <1ba2fa240809080942l19ae8deeq7eedd146e8c244c@mail.gmail.com> (sfid-20080908_184210_506769_5A32B5AA)
Date: Mon, 8 Sep 2008 19:42:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1220885742.31304.67.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
	 <1220885742.31304.67.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 5:55 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-08 at 16:31 +0300, Tomas Winkler wrote:
>> From: Ester Kummer <ester.kummer@intel.com>
>>
>> This patch handle scanning on IBSS mode like on STA mode.
>> When queuing the scan work we don't refer to the return value of
>> ieee80211_sta_start_scan so if we are in the last scan period, we will
>> return 0 to ieee80211_ioctl_siwscan and not -EAGAIN, and then iwlist will
>> call ieee80211_ioctl_giwscan to get the scan results and will not fail.
>
>
> Can you explain why? Or can anybody else explain why we do this
> difference at all? And how should mesh behave?
>
>> Signed-off-by: Ester Kummer <ester.kummer@intel.com>
>> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>>  net/mac80211/mlme.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 2564553..72d5fe2 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -4090,7 +4090,8 @@ int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t
>>       struct ieee80211_if_sta *ifsta = &sdata->u.sta;
>>       struct ieee80211_local *local = sdata->local;
>>
>> -     if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
>> +     if (sdata->vif.type != IEEE80211_IF_TYPE_STA ||
>> +         sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
>>               return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
>
> This is wrong.
>
> a != 1 || a != 2
>
> has to be true at all times, I think you mean &&.

It definitely should be &&. Copied it wrongly from the original patch.
Tomas
