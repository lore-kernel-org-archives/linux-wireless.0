Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36048 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbdHCJts (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:49:48 -0400
Received: by mail-wm0-f49.google.com with SMTP id t201so10501257wmt.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 02:49:48 -0700 (PDT)
Subject: Re: [PATCH] mwifiex: add module parameter to disable 40MHZ support in
 2.4G band
To: Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
References: <1501751215-12742-1-git-send-email-huxinming820@gmail.com>
 <874ltpovcg.fsf@kamboji.qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f8f01ad4-773d-a83d-7db2-3dbaa26502bc@broadcom.com> (sfid-20170803_114952_374702_E8F52486)
Date: Thu, 3 Aug 2017 11:49:44 +0200
MIME-Version: 1.0
In-Reply-To: <874ltpovcg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03-08-17 11:26, Kalle Valo wrote:
> Xinming Hu <huxinming820@gmail.com> writes:
> 
>> From: Xinming Hu <huxm@marvell.com>
>>
>> This patch provide a new module parameter disable_2g4_40m, with
>> which driver will not report 40M capability for 2.4GHZ to cfg80211.
>>
>> Signed-off-by: Xinming Hu <huxm@marvell.com>
>> Signed-off-by: Cathy Luo <cluo@marvell.com>
>> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>> ---
>>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 22 ++++++++++++++--------
>>  1 file changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
>> index 2be7817..820475a 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
>> @@ -25,6 +25,10 @@
>>  static char *reg_alpha2;
>>  module_param(reg_alpha2, charp, 0);
>>  
>> +static bool disable_2g4_40m;
>> +module_param(disable_2g4_40m, bool, 0000);
> 
> This is bool, good.
> 
>> +MODULE_PARM_DESC(disable_2g4_40m, "2.4G 40M support disable:1, enable:0");
> 
> This is not really a readable description for someone not familiar with
> Wi-Fi, maybe this instead:
> 
> "disable 40 Mhz channels on 2.4 GHz band (disable:1, enable:0)"
> 
>> @@ -2755,7 +2759,7 @@ static void mwifiex_setup_vht_caps(struct ieee80211_sta_vht_cap *vht_info,
>>   */
>>  static void
>>  mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
>> -		      struct mwifiex_private *priv)
>> +		      struct mwifiex_private *priv, int disable_40m)
> 
> But here you use int, that's a bit strange. Why not bool?

Here is what is in net/wireless/core.c:

static bool cfg80211_disable_40mhz_24ghz;
module_param(cfg80211_disable_40mhz_24ghz, bool, 0644);
MODULE_PARM_DESC(cfg80211_disable_40mhz_24ghz,
                 "Disable 40MHz support in the 2.4GHz band");

which seems exactly the same thing and ends up doing:

                /*
                 * Since cfg80211_disable_40mhz_24ghz is global, we can
                 * modify the sband's ht data even if the driver uses a
                 * global structure for that.
                 */
                if (cfg80211_disable_40mhz_24ghz &&
                    band == NL80211_BAND_2GHZ &&
                    sband->ht_cap.ht_supported) {
                        sband->ht_cap.cap &=
~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
                        sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
                }

Regards,
Arend
