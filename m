Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:48509 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaCKNdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 09:33:05 -0400
Received: by mail-ob0-f172.google.com with SMTP id wm4so8455436obc.31
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 06:33:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394543770.30155.4.camel@jlt4.sipsolutions.net>
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
	<1394191196-6425-3-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQkke050EMs0Nnz3O3XM6U2uRRVrxffVdwKJrWua+iapFw@mail.gmail.com>
	<1394543770.30155.4.camel@jlt4.sipsolutions.net>
Date: Tue, 11 Mar 2014 14:33:04 +0100
Message-ID: <CA+BoTQnnWfNxeo6rtATU8qgj=dk9Kkx36GVewDr7p8OVFfcxNA@mail.gmail.com> (sfid-20140311_143310_551237_6A438BFE)
Subject: Re: [PATCH 3/3] mac80211: compute chanctx refcount dynamically
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 March 2014 14:16, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-03-11 at 08:46 +0100, Michal Kazior wrote:
>
>> Self-NACK.
>
> Heh.
>
>> I totally missed how ieee80211_remove_interfaces() works. It removes
>> all interfaces from the list in one go before each is actually
>> stopped. This means refcount computes 0. IOW If you unload a driver
>> with multiple interfaces running you get a nice general protection
>> fault (multiple ieee80211_free_chanctx calls).
>
> Ok, that seems like a problem :)
>
>> I'm planning on adding `struct list_head` to sdata and chanctx to be
>> able to iterate over assigned (and reserved, in the future) chanctx.
>> What do you think? Do you have other ideas?
>
> I guess that seems reasonable - not sure why you'd want the reserved
> one? Some of the maintenance there might be tricky?

For multi-vif we need to be able to track list of interfaces that have
a reservation. This is needed for example for chandef calculation
(e.g. to see if you can start a new vif on given chanctx that is part
of a reservation already, etc).

It's also necessary so you can synchronize CSA across interfaces with
the chanctx reservation that happen "in place" when you're out of
max_num_different_channels. In that case you must unassign all
interfaces, free chanctx, create new chanctx, and then assign the
reservation interfaces.

Actually I think there's also one thing that might benefit from
chanctx-vif list tracking: ieee80211_recalc_chanctx_chantype(). It
seems to complain with WARN_ON splat when I reload driver when more
than 1 vif is running because it doesn't find a non-NULL `compat`
chandef (rightfully so as local->interfaces is empty at that point due
to ieee80211_remove_interfaces).


Michał
