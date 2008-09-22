Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59852 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYIVTdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 15:33:46 -0400
Received: by gxk9 with SMTP id 9so3513338gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 12:33:45 -0700 (PDT)
Message-ID: <43e72e890809221233l4dc446e9hdf71fc94270020dc@mail.gmail.com> (sfid-20080922_213349_977364_DF7C63D6)
Date: Mon, 22 Sep 2008 12:33:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: Progress on aggregation
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080922174103.GF6048@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080922174103.GF6048@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 10:41 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Just a quick note on the progress of aggregation. It works but we still
> need to hanld the rtnl_lock() in a sane way. Johannes we proposing we
> use a workqueue for this.
>
> * iwl4965 has been tested to work
> * ath9k *does* xmit aggregate frames but throughput is low
>
> Since ath9k still needs some work we are looking into it.
> Tomas, have you had a chance to consider the workqueue usage
> for the rtnl_lock()? I figure to leave that to you as we
> are still looking into the throughput issues with aggreation with
> ath9k.

Also, we currently handle aggregation buffering internally in our
driver so the whole amdpu_queue stuff is not required for us as we
don't have internal aggregation schedulers in hardware. For now we'll
use it though as we just want to get it working and for 2.6.27 we have
not alternative. For us, what will the ampdu_queues represent then? We
don't exactly have a limit on this except for the standard limitations
of 16 TIDs per station so what do you recommend to set this to?

  Luis
