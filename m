Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:40220 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3FYUGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 16:06:10 -0400
Received: by mail-bk0-f52.google.com with SMTP id d7so4598171bkh.25
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jun 2013 13:06:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51C93538.4050304@rempel-privat.de>
References: <51C52E79.30104@rempel-privat.de> <CAG6hwVOCfDK9nkh3e0fFMGcWp8XLQnPC8TzQb9eET2fwFPq3SA@mail.gmail.com>
 <51C93538.4050304@rempel-privat.de>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 25 Jun 2013 13:05:48 -0700
Message-ID: <CAG6hwVMa+i=wXRyfcwaXH8NesCXgKXW6Ad4dzgd9DZONGYA=xQ@mail.gmail.com> (sfid-20130625_220613_933336_C5862ABD)
Subject: Re: regression after, " ath9k_htc: Add support for mesh interfaces"
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 24, 2013 at 11:14 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 25.06.2013 02:54, schrieb Thomas Pedersen:
>
>> On Fri, Jun 21, 2013 at 9:56 PM, Oleksij Rempel <linux@rempel-privat.de>
>> wrote:
>>>
>>> Hi Javier,
>>>
>>> i warning after patch "ath9k_htc: Add support for mesh interfaces".
>>> I get this warning only on pc with CONFIG_MAC80211_MESH not set. Probably
>>> you missed config check some where.
>>
>>
>> Where do you hit the warning?
>>
>
> on adapter init.
> see attachment.

That warning is triggered by wiphy_verify_combinations():

                        if (WARN_ON((wiphy->interface_modes & types) != types))
                                return -EINVAL;

But before that, the mesh iftype bit is cleared in ieee80211_register_hw():

#ifndef CONFIG_MAC80211_MESH
        /* mesh depends on Kconfig, but drivers should set it if they want */
        local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
#endif

It seems the intention was to avoid an #ifdef CONFIG_MAC80211_MESH in
every driver, but then mac80211 also has to clear the MESH_POINT bit
for each ieee80211_iface_limit? I don't really see a cleaner way of
resolving this.

Johannes?

--
Thomas
