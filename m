Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48366 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab3EWNci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 09:32:38 -0400
Received: by mail-ie0-f181.google.com with SMTP id x12so8729679ief.12
        for <linux-wireless@vger.kernel.org>; Thu, 23 May 2013 06:32:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130522144224.4c95fa04@north>
References: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
	<20130521171018.238056b2@north>
	<CAGXE3d_HQzN5NNJ5tbDXhoeFdobpSJnvxrqAP5+T8DfyEoV_Uw@mail.gmail.com>
	<20130522144224.4c95fa04@north>
Date: Thu, 23 May 2013 15:32:37 +0200
Message-ID: <CAGXE3d_EtCUEW7ZLrdncR9=jHWip9tBTe4=mV0W5-1qD=Luecw@mail.gmail.com> (sfid-20130523_153241_350219_2EF38B9E)
Subject: Re: [PATCH] mac80211: Allow single vif mac address change with addr_mask
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: =?ISO-8859-2?Q?Jakub_Kici=F1ski?= <moorray3@wp.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ivo Van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"stf_xl@wp.pl" <stf_xl@wp.pl>,
	Alessandro Lannocca <alessandro.lannocca@gmail.com>,
	Bruno Randolf <br1@thinktube.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 22, 2013 at 2:42 PM, Jakub Kiciński <moorray3@wp.pl> wrote:
> Perhaps you could incorporate the change to assign_pem_addr
> into your patch and send v2 adding my Sign-off?

Will do.

>> > @@ -1479,7 +1483,17 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
>> >                         break;
>> >                 }
>> >
>> > +               /*
>> > +                * Pick address of existing interface in case user changed
>> > +                * MAC address manually, default to perm_addr.
>> > +                */
>> >                 m = local->hw.wiphy->perm_addr;
>> > +               list_for_each_entry(sdata, &local->interfaces, list) {
>> > +                       if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
>> > +                               continue;
>> > +                       m = sdata->vif.addr;
>> > +                       break;
>> > +               }
>> >                 start = ((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
>> >                         ((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
>> >                         ((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
>>
>> This is only relevant if the driver registered a addr_mask with mac80211.
>> So, maybe you could only select a new address (!=perm_addr) if the
>> perm_addr is not covered by the addr_mask?
>
> I'm not sure I understand all the internal logic, but if
> driver doesn't set addr_mask it will always get one of
> wiphy->addresses or perm_addr and leave on line 1468 [1]
> before reaching this code.

My fault. This is indeed correct.

Johannes, please drop this patch. I'll respin.

Thanks,
Helmut
