Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:38125 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaH2LP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 07:15:58 -0400
Received: by mail-we0-f182.google.com with SMTP id w62so2037275wes.13
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2014 04:15:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409310350.4577.14.camel@jlt4.sipsolutions.net>
References: <1406553419-16196-1-git-send-email-michal.kazior@tieto.com>
	<1407769505.9844.8.camel@jlt4.sipsolutions.net>
	<CA+BoTQk-iR2aAsgioZY+CgjV3JkvQf3pakiAzsw-o65ogDYHRA@mail.gmail.com>
	<1409310350.4577.14.camel@jlt4.sipsolutions.net>
Date: Fri, 29 Aug 2014 13:15:57 +0200
Message-ID: <CA+BoTQmOr9AmqV1St8+2yAHnUaMwFSR-8F5yCOV0ynh18OU5DA@mail.gmail.com> (sfid-20140829_131602_148430_FF8843AD)
Subject: Re: [PATCH] mac80211: fix chantype recalc warning
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 August 2014 13:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-08-18 at 15:07 +0200, Michal Kazior wrote:
[...]
>> Another way to fix this would probably be to change
>> ieee80211_remove_interfaces() to remove all interfaces one-by-one
>> (instead of in bulk). It seems iflist_mtx can be temporarily released
>> while iterating over interfaces for the sake of calling
>> unregister_netdevice() for each one because RTNL is held all the time
>> guaranteeing no new interfaces are added in the meantime. I'm not sure
>> if it's perfectly safe to replace unregister_netdevice_many() just
>> like that though. I can look more into it.
>
> Well, it's safe, but it's more efficient to call the _many() because
> otherwise you require rcu_synchronize() for each one.
>
> I'll apply this, to -next for now, later we can decide if we want to
> send it to stable or so?

Thanks. As far as I'm aware the splat was harmless so I'm unsure if it
qualifies for stable.


Michał
