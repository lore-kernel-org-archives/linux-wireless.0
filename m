Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:57613 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3EVIG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 04:06:28 -0400
Received: by mail-we0-f175.google.com with SMTP id p60so927729wes.6
        for <linux-wireless@vger.kernel.org>; Wed, 22 May 2013 01:06:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130521171018.238056b2@north>
References: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
	<20130521171018.238056b2@north>
Date: Wed, 22 May 2013 10:06:26 +0200
Message-ID: <CAGXE3d_HQzN5NNJ5tbDXhoeFdobpSJnvxrqAP5+T8DfyEoV_Uw@mail.gmail.com> (sfid-20130522_100632_641358_BB82BED0)
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

On Tue, May 21, 2013 at 5:10 PM, Jakub Kiciński <moorray3@wp.pl> wrote:
> On Tue, 21 May 2013 14:54:53 +0200, Helmut Schaa wrote:
>> When changing the MAC address of a single vif mac80211 will check if the new
>> address fits into the address mask specified by the driver. This only needs
>> to be done when using multiple BSSIDs. Hence, check the new address only
>> against all other vifs.
>
> Oh, I see that you already posted this patch for review!
>
> I think we should also take care of the way addresses for new
> interfaces are chosen otherwise they'll just pick up
> perm_addr and we will end up with incompatible MACs.

Maybe you could send the assign_pem_addr changes as a follow up patch?

[...]

> @@ -1479,7 +1483,17 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
>                         break;
>                 }
>
> +               /*
> +                * Pick address of existing interface in case user changed
> +                * MAC address manually, default to perm_addr.
> +                */
>                 m = local->hw.wiphy->perm_addr;
> +               list_for_each_entry(sdata, &local->interfaces, list) {
> +                       if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
> +                               continue;
> +                       m = sdata->vif.addr;
> +                       break;
> +               }
>                 start = ((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
>                         ((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
>                         ((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);

This is only relevant if the driver registered a addr_mask with mac80211.
So, maybe you could only select a new address (!=perm_addr) if the
perm_addr is not covered by the addr_mask?

Helmut
