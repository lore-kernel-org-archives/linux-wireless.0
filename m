Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36435 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755458AbdLVSe5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 13:34:57 -0500
Received: by mail-qk0-f178.google.com with SMTP id g123so3866128qka.3
        for <linux-wireless@vger.kernel.org>; Fri, 22 Dec 2017 10:34:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1513677938.26145.12.camel@sipsolutions.net>
References: <39d50d91-ac83-611d-6709-021757686206@altermundi.net> <1513677938.26145.12.camel@sipsolutions.net>
From: Thomas Pedersen <thomas@eero.com>
Date: Fri, 22 Dec 2017 10:34:56 -0800
Message-ID: <CADjYELy-Mh=-p=EgdqeG5AshsODhKjLzTiTTwcLfgnMpQbusjQ@mail.gmail.com> (sfid-20171222_193501_917392_BF787D06)
Subject: Re: oops on cloned-mac 802.11s stations
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Gui Iribarren <gui@altermundi.net>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 19, 2017 at 2:05 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2017-12-18 at 03:44 +0100, Gui Iribarren wrote:
>> Steps to reproduce:
>> join a 802.11s mesh with a nodeA, and then join the same 802.11s mesh
>> with another nodeB, so that both nodes MAC addresses are exactly the
>> same (i.e. nodeB is "cloning" nodeA MAC)
>>
>> Expected result:
>> nodeA and nodeB coexist in a conflicting state, silently
>> (not saying that this is a desired scenario, of course; just came across
>> this while testing radios that accidentally had the same (fake) address.
>> the warning might ring a bell to someone, so reporting it here just for
>> the record)
>>
>> What actually happens:
>> both on nodeA and nodeB, the log is flooded with these warnings:
>
> That's hardly an "oops", but yeah, not nice.
>
> Somewhere we should drop packets if they appear to come from ourselves.
> Perhaps like this:
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index b3cff69bfd66..fd580614085b 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -3625,6 +3625,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
>                 }
>                 return true;
>         case NL80211_IFTYPE_MESH_POINT:
> +               if (ether_addr_equal(sdata->vif.addr, hdr->addr2))
> +                       return false;
>                 if (multicast)
>                         return true;
>                 return ether_addr_equal(sdata->vif.addr, hdr->addr1);

Makes sense.

-- 
thomas
