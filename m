Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45792 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaHRNHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 09:07:39 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so3656786wiv.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2014 06:07:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407769505.9844.8.camel@jlt4.sipsolutions.net>
References: <1406553419-16196-1-git-send-email-michal.kazior@tieto.com>
	<1407769505.9844.8.camel@jlt4.sipsolutions.net>
Date: Mon, 18 Aug 2014 15:07:38 +0200
Message-ID: <CA+BoTQk-iR2aAsgioZY+CgjV3JkvQf3pakiAzsw-o65ogDYHRA@mail.gmail.com> (sfid-20140818_150744_469033_9A68A495)
Subject: Re: [PATCH] mac80211: fix chantype recalc warning
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 August 2014 17:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-07-28 at 15:16 +0200, Michal Kazior wrote:
>> When a device driver is unloaded local->interfaces
>> list is cleared. If there was more than 1
>> interface running and connected (bound to a
>> chanctx) then chantype recalc was called and it
>> ended up with compat being NULL causing a call
>> trace warning.
>>
>> Warn if compat becomes NULL as a result of
>> incompatible bss_conf.chandef of interfaces bound
>> to a given channel context only.
>
> Err, this slipped my radar - where does this need to go?

No big deal. The warning is just a small nuisance with multi-vif. You
won't see this on a typical system.


>
> Also - is this really the right thing? Why does this happen in this
> situation? Shouldn't they all be not connected or not have a chanctx or
> be compatible?

If you eject, e.g. plug a usb wifi device out, its driver will call
ieee80211_unregister_hw() which calls ieee80211_remove_interfaces().
If there are still running interfaces that have a netdev (probably to
avoid a deadlock on iflist_mtx?) each interface is *moved* to a
temporary list for a later call to unregister_netdevice_many(). While
unregister_netdevice_many() executes the local->interfaces is empty.
ieee80211_recalc_chanctx_chantype() is called whenever a chanctx is
unassigned from a vif as long as there are still references to that
chanctx. If there is just 1 interface when device is ejected, then
ieee80211_recalc_chanctx_chantype() is not called. If there is more
than 1 running interfaces then the removal of each but the last one
calls to ieee80211_recalc_chanctx_chantype(). Since local->interfaces
is empty compat pointer stays NULL and this triggers WARN_ON_ONCE (but
only the first one effectively dumps a trace).

Another way to fix this would probably be to change
ieee80211_remove_interfaces() to remove all interfaces one-by-one
(instead of in bulk). It seems iflist_mtx can be temporarily released
while iterating over interfaces for the sake of calling
unregister_netdevice() for each one because RTNL is held all the time
guaranteeing no new interfaces are added in the meantime. I'm not sure
if it's perfectly safe to replace unregister_netdevice_many() just
like that though. I can look more into it.


Michał
