Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:33091 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3EVBJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 21:09:53 -0400
Received: by mail-bk0-f53.google.com with SMTP id mx1so792965bkb.12
        for <linux-wireless@vger.kernel.org>; Tue, 21 May 2013 18:09:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367934155.8328.21.camel@jlt4.sipsolutions.net>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
 <1367548442-8229-7-git-send-email-thomas@cozybit.com> <1367934155.8328.21.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 21 May 2013 18:09:31 -0700
Message-ID: <CAG6hwVPah-8FjH=ntFPzxMzXi5ePcmG-UEhdsvEgHkJVE9khYQ@mail.gmail.com> (sfid-20130522_030956_397571_44DB9539)
Subject: Re: [RFC 06/12] mac80211: notify bridge when leaving mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey, Sorry for the late response.

On Tue, May 7, 2013 at 6:42 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-05-02 at 19:33 -0700, Thomas Pedersen wrote:
>> After turning carrier off, any parent bridge interface
>> needs to be notified. Otherwise we would see a panic when
>> attempting to transmit frames on a mesh interface which
>> hadn't yet been put down.
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>  net/mac80211/mesh.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
>> index eac9988..271ddc9 100644
>> --- a/net/mac80211/mesh.c
>> +++ b/net/mac80211/mesh.c
>> @@ -993,6 +993,9 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>>       struct beacon_data *bcn;
>>
>>       netif_carrier_off(sdata->dev);
>> +     if (sdata->dev->priv_flags & IFF_BRIDGE_PORT)
>> +             /* stop bridge transmissions */
>> +             call_netdevice_notifiers(NETDEV_CHANGE, sdata->dev);
>
> Err, this seems like a really bad hack? I don't really think drivers
> should call that?

Why not? We're just notifying the bridge interface that this port has
gone down, to avoid dereferencing a null pointer (on bridge flood
traffic) after the mesh_bss has been removed.

Is cfg80211_leave_mesh() an acceptable location for this fix?

--
Thomas
