Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33530 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdH2ITM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 04:19:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Jiri Kosina <jikos@kernel.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxwifi@intel.com,
        rui.zhang@intel.com, edubezval@gmail.com, linux-pm@vger.kernel.org,
        david.weinehall@intel.com, johannes.berg@intel.com,
        sara.sharon@intel.com, emmanuel.grumbach@intel.com
Subject: Re: [PATCH v2] iwlwifi: pcie: move rx workqueue initialization to iwl_trans_pcie_alloc()
References: <alpine.LSU.2.20.1708171537380.3581@cbobk.fhfr.pm>
        <20170822073729.4856-1-luca@coelho.fi>
        <1503554432.15969.415.camel@coelho.fi>
        <alpine.LSU.2.20.1708242153000.3581@cbobk.fhfr.pm>
        <1503604818.15969.433.camel@coelho.fi>
Date: Tue, 29 Aug 2017 11:19:04 +0300
In-Reply-To: <1503604818.15969.433.camel@coelho.fi> (Luca Coelho's message of
        "Thu, 24 Aug 2017 23:00:18 +0300")
Message-ID: <87inh6vlaf.fsf@kamboji.qca.qualcomm.com> (sfid-20170829_101935_779659_FCCEC5DF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Thu, 2017-08-24 at 21:56 +0200, Jiri Kosina wrote:
>> On Thu, 24 Aug 2017, Luca Coelho wrote:
>> 
>> > > Work queues cannot be allocated when a mutex is held because the mutex
>> > > may be in use and that would make it sleep.  Doing so generates the
>> > > following splat with 4.13+:
>> > > 
>> > > [   19.513298] ======================================================
>> > > [   19.513429] WARNING: possible circular locking dependency detected
>> > > [   19.513557] 4.13.0-rc5+ #6 Not tainted
>> > > [   19.513638] ------------------------------------------------------
>> > > [   19.513767] cpuhp/0/12 is trying to acquire lock:
>> > > [ 19.513867] (&tz->lock){+.+.+.}, at: [<ffffffff924afebb>]
>> > > thermal_zone_get_temp+0x5b/0xb0
>> > > [   19.514047]
>> > > [   19.514047] but task is already holding lock:
>> > > [ 19.514166] (cpuhp_state){+.+.+.}, at: [<ffffffff91cc4baa>]
>> > > cpuhp_thread_fun+0x3a/0x210
>> > > [   19.514338]
>> > > [   19.514338] which lock already depends on the new lock.
>> > > 
>> > > This lock dependency already existed with previous kernel versions,
>> > > but it was not detected until commit 49dfe2a67797 ("cpuhotplug: Link
>> > > lock stacks for hotplug callbacks") was introduced.
>> > > 
>> > > Reported-by: David Weinehall <david.weinehall@intel.com>
>> > > Reported-by: Jiri Kosina <jikos@kernel.org>
>> > > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> > 
>> > Jiri, did you have a chance to try this out? I'm about to ask Kalle to
>> > merge this so it gets in in time for 4.13-rc7.
>> 
>> Sorry, I am almost completely offline for one more week (vacation), and 
>> will not have access to the affected system before that.
>
> Sounds good! Enjoy! ;)
>
>
>>  But this indeed 
>> looks like a correct fix to me, so feel free to add
>> 
>> 	Acked-by: Jiri Kosina <jkosina@suse.cz>
>> 
>> I'll be able to provide my Tested-by: eventually only in ~10 days.
>
>
> Kalle already picked it up in wireless-drivers and this should make it's
> way to 4.13-rc7 (we hope).

It (10a54d8196d1) didn't make it to -rc7 but it's in net tree now and
should make it to the next release on Sunday (either -rc8 or the final).

-- 
Kalle Valo
