Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:53762 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbbFAOXm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 10:23:42 -0400
Message-ID: <556C6AEB.9070407@neratec.com> (sfid-20150601_162345_309420_15E143F0)
Date: Mon, 01 Jun 2015 16:23:39 +0200
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Fix double locking on CSA counter update
References: <1433166856-3285-1-git-send-email-Wojciech.Dubowik@neratec.com> <CAGRGNgW=qy2TuojGt5CDE0sATkKeMTHCtBJnFQOjJ=3pP7Kzzw@mail.gmail.com>
In-Reply-To: <CAGRGNgW=qy2TuojGt5CDE0sATkKeMTHCtBJnFQOjJ=3pP7Kzzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/15 16:13, Julian Calaby wrote:
> Hi Wojciech,
>
> On Mon, Jun 1, 2015 at 11:54 PM, Wojciech Dubowik
> <Wojciech.Dubowik@neratec.com> wrote:
>> We call rcu locked ieee80211_csa_update_counter from
>> already locked section. Fix it by decrementing counter
>> directly instead of calling ieee80211_csa_update_counter.
> Stupid question: wouldn't it be better to split the work from
> ieee80211_csa_update_counter() into a separate function without
> locking and call that instead?
Yes. It would be better for maintenance. It's just that they will
have different input parameters

ieee80211_csa_update_counter(struct ieee80211_vif *
__ieee80211_csa_update_counter(struct beacon_data *

as it doesn't make sense to dereference beacon twice.

I guess it's not a problem?
Wojtek
>
> Thanks,
>

