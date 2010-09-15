Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55591 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab0IOVFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 17:05:10 -0400
Received: by yxp4 with SMTP id 4so206458yxp.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 14:05:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100915203133.GA14541@jm.kir.nu>
References: <4C8EB03D.7070808@candelatech.com> <20100915030316.GB30253@jm.kir.nu>
 <4C9059DC.7060009@candelatech.com> <20100915203133.GA14541@jm.kir.nu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 15 Sep 2010 14:04:49 -0700
Message-ID: <AANLkTik=47CCXUz9NdDYXKzzgtfqPHFDGkUid0+6y7kw@mail.gmail.com>
Subject: Re: RFC: mac80211/ath9k: allow scanning single channel if other VIF
 is associated.
To: Jouni Malinen <j@w1.fi>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 1:31 PM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Sep 14, 2010 at 10:30:04PM -0700, Ben Greear wrote:
>> I think for the multi-VIF scenario, it should scan the single associated
>> channel by default, but it would be nice to allow full scans on demand.
>> (I would very much like to work with standard wpa_supplicant, but if hacking it
>> is the only way, then I can attempt that.)
>
> "Standard wpa_supplicant" needs to become more aware of multiple users
> of the same radio, so it is certainly fine to add changes there. For
> example, a mechanism for noticing that interfaces are sharing a radio
> would be useful. With that, it should also be possible to share the BSS
> table and scan results (and requests!) within wpa_supplicant.

Depending on how this is implementing, sharing of the physical radio
may require some kernel synchronization between the different
interfaces using the same radio. It may also be possible to share the
same radio between an 802.11 device and a wimax device, for example.
Long ago we thought up of a frequency broker [1] but never really
wrote it as we have had no usage case for it yet. If we implement the
frequency broker we could also technically add a scheduler to sharing
the same radio between separate interfaces / technologies, this could
just be done in userspace as well, although I am not sure if the
timing considerations for doing it in userspace would suffice.

[1] http://wireless.kernel.org/en/developers/FrequencyBroker

  Luis

> Sure, mac80211 could potentially do some of merging and reusing, too,
> but as far as wpa_supplicant use cases (including hostapd and AP mode in
> Wi-Fi P2P like use cases here) are concerned, mac80211 changes may not
> be needed for handling the scanning part.
>
> --
> Jouni Malinen                                            PGP id EFC895FA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
