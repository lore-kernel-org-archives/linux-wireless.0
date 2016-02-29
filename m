Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33492 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbcB2IiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 03:38:16 -0500
Received: by mail-pa0-f42.google.com with SMTP id fl4so88510618pad.0
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 00:38:16 -0800 (PST)
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Reply-To: arend@broadcom.com
Subject: Re: [PATCH V9 1/2] nl80211: add feature for BSS selection support
References: <1456520364-6275-1-git-send-email-arend@broadcom.com>
 <CAB3XZEfO2RvN-YDN8Sf18AK2EvV=rYdVndhUYwnkni3Gp0Ok2A@mail.gmail.com>
To: Eliad Peller <eliad@wizery.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <56D40373.2040502@broadcom.com> (sfid-20160229_093820_191211_5C777C26)
Date: Mon, 29 Feb 2016 09:38:11 +0100
MIME-Version: 1.0
In-Reply-To: <CAB3XZEfO2RvN-YDN8Sf18AK2EvV=rYdVndhUYwnkni3Gp0Ok2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 28-2-2016 12:35, Eliad Peller wrote:
> hi Arend,
> 
> On Fri, Feb 26, 2016 at 10:59 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> Introducing a new feature that the driver can use to
>> indicate the driver/firmware supports configuration of BSS
>> selection criteria upon CONNECT command. This can be useful
>> when multiple BSS-es are found belonging to the same ESS,
>> ie. Infra-BSS with same SSID. The criteria can then be used to
>> offload selection of a preferred BSS.
>>
> [...]
> 
>>
>> +/**
>> + * struct nl80211_bss_select_rssi_adjust - RSSI adjustment parameters.
>> + *
>> + * @band: band of BSS that must match for RSSI value adjustment.
>> + * @delta: value used to adjust the RSSI value of matching BSS.
>> + */
>> +struct nl80211_bss_select_rssi_adjust {
>> +       enum nl80211_band band;
>> +       __s8 delta;
>> +} __attribute__((packed));
>> +
> i think enum can't be considered as fixed-size field, so better use u8 or so.

Yeah. I was wondering about that as it may be affected by compiler
option. Will change it to u8.

>> @@ -626,6 +626,10 @@ int wiphy_register(struct wiphy *wiphy)
>>                      !rdev->ops->set_mac_acl)))
>>                 return -EINVAL;
>>
>> +       if (WARN_ON(wiphy->bss_select_support &&
>> +                   (wiphy->bss_select_support & ~(BIT(__NL80211_BSS_SELECT_ATTR_AFTER_LAST) - 2))))
>> +               return -EINVAL;
>> +
> worth noting that the "-2" counts for the invalid enum value (at least
> it wasn't clear to me)

I did have a comment in here in an earlier patch set or it was just a
thought ;-) Will add a remark here.

>> @@ -7995,6 +8086,21 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
>>                 return -EOPNOTSUPP;
>>         }
>>
>> +       /* only do bss selection when no BSSID is specified. */
>> +       if (!connect.bssid && wiphy->bss_select_support &&
>> +           info->attrs[NL80211_ATTR_BSS_SELECT]) {
> 
> you don't have to check wiphy->bss_select_support here - we actually
> want to fail if NL80211_ATTR_BSS_SELECT was given although the driver
> doesn't support it.

I agree failing would be better than silently ignoring. Will remove it.

>> +               err = parse_bss_select(info->attrs[NL80211_ATTR_BSS_SELECT],
>> +                                      wiphy, &connect.bss_select);
>> +               if (err) {
>> +                       kzfree(connkeys);
>> +                       return err;
>> +               }
>> +               if (!(wiphy->bss_select_support & BIT(connect.bss_select.behaviour))) {
> 
> (it will fail here instead)

Yup.

Thanks for the review.

Regards,
Arend
