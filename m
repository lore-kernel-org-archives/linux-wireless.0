Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:45935 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYFXKy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:54:26 -0400
Received: by py-out-1112.google.com with SMTP id p76so1321929pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 03:54:25 -0700 (PDT)
Message-ID: <1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com> (sfid-20080624_125430_977914_3A0878DA)
Date: Tue, 24 Jun 2008 13:54:25 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <200806241242.11727.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-5-git-send-email-tomas.winkler@intel.com>
	 <200806241242.11727.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2008 at 1:42 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 24 June 2008 12:38:01 Tomas Winkler wrote:
>> This patch add phy information to giwname. Currently
>> 802.11b is not treated.
>>
>> Quoting:
>> It's not useless, it's supposed to tell you about the protocol
>> capability of the device, like "IEEE 802.11b" or "IEEE 802.11abg"
>
> Well, I think it _is_ pretty useless.
> However...
>
Still many people are using wireless extension and this is probably
most convenient way to get this info.
For example 4956 comes with 3 combinations g, ag, and agn.
It's displayed upon iwconfig

>> @@ -135,7 +135,24 @@ static int ieee80211_ioctl_giwname(struct net_device *dev,
>>                                  struct iw_request_info *info,
>>                                  char *name, char *extra)
>>  {
>> +     struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>> +     struct ieee80211_supported_band *sband;
>> +     u8 is_ht = 0;
>> +
>>       strcpy(name, "IEEE 802.11");
>> +     sband = local->hw.wiphy->bands[IEEE80211_BAND_5GHZ];
>> +
>> +     if (sband) {
>> +             strcat(name, "a");
>> +             is_ht |= sband->ht_info.ht_supported;
>> +     }
>> +     sband = local->hw.wiphy->bands[IEEE80211_BAND_2GHZ];
>> +     if (sband) {
>> +             strcat(name, "g");
>> +             is_ht |= sband->ht_info.ht_supported;
>
> What about b-only devices?

See the log message...(known issue). Currently you have to loop over
rates to get this info. I wasn't sure if they are any b-only NICs
under mac80211 so I didn't run to implement it.
>
>> +     }
>> +     if (is_ht)
>> +             strcat(name, "n");
>>
>>       return 0;
>>  }
>
>
>
> --
> Greetings Michael.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
