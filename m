Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:46711 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934805Ab3E1RCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 13:02:16 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so2771122bkc.30
        for <linux-wireless@vger.kernel.org>; Tue, 28 May 2013 10:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369427550.13623.3.camel@johannes>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
 <1367548442-8229-7-git-send-email-thomas@cozybit.com> <1367934155.8328.21.camel@jlt4.sipsolutions.net>
 <CAG6hwVPah-8FjH=ntFPzxMzXi5ePcmG-UEhdsvEgHkJVE9khYQ@mail.gmail.com> <1369427550.13623.3.camel@johannes>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 28 May 2013 10:01:54 -0700
Message-ID: <CAG6hwVPvRQw64A=-+J0J8ioru8-fze3NuEEA1z2+c_skk5tAdA@mail.gmail.com> (sfid-20130528_190219_947876_EBB81ADB)
Subject: Re: [RFC 06/12] mac80211: notify bridge when leaving mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 24, 2013 at 1:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2013-05-21 at 18:09 -0700, Thomas Pedersen wrote:
>> Hey, Sorry for the late response.
>
> Me too :)
>
>> >>       netif_carrier_off(sdata->dev);
>> >> +     if (sdata->dev->priv_flags & IFF_BRIDGE_PORT)
>> >> +             /* stop bridge transmissions */
>> >> +             call_netdevice_notifiers(NETDEV_CHANGE, sdata->dev);
>> >
>> > Err, this seems like a really bad hack? I don't really think drivers
>> > should call that?
>>
>> Why not? We're just notifying the bridge interface that this port has
>> gone down, to avoid dereferencing a null pointer (on bridge flood
>> traffic) after the mesh_bss has been removed.
>>
>> Is cfg80211_leave_mesh() an acceptable location for this fix?
>
> I'm not really convinced it's an acceptable fix in itself? Why should we
> ever have to call netdev notifiers, that seems odd to me. Also why would
> that prevent a crash? Wouldn't we just drop packets for the mesh if we
> aren't joined in a mesh any more? Or something like that  Accessing the
> priv flags and then calling the netdev notifiers seems really strange to
> me. If this was necessary, then wouldn't netif_carrier_off() do it
> internally?

OK I'll take a look at this and figure out a cleaner solution then. Thanks.

--
Thomas
