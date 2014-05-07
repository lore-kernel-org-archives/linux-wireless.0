Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49931 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbaEGHEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 03:04:47 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so766192wiv.15
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 00:04:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399382148.4218.28.camel@jlt4.sipsolutions.net>
References: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	<1397049062-24177-1-git-send-email-michal.kazior@tieto.com>
	<1399382148.4218.28.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 09:04:46 +0200
Message-ID: <CA+BoTQnx8EzBGwYKV-ZmR+zf=iv3YOaT7BPPsYKrrNG=tJkXmQ@mail.gmail.com> (sfid-20140507_090450_825641_9D2DDE53)
Subject: Re: [PATCH v4 0/4] mac80211/cfg80211: CSA fixes/cleanups
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 May 2014 15:15, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-04-09 at 15:10 +0200, Michal Kazior wrote:
>> Hi,
>>
>> The patchset fixes CSA tx queue locking and
>> introduces interface teardown upon CSA failure
>> during finalization.
>
> Applied (with the rename Luca suggested), thanks.
>
> However, there's one more thing - one caller of ieee80211_csa_finalize()
> doesn't check the return value now, I think it probably should. Mind
> taking a look at that? It should *probably* be the same as the other
> caller (and not propagate the error), I'd say, so maybe that should be
> rolled into the function?

Right - the return value of ieee80211_csa_finalize() in
__ieee80211_channel_switch() should be checked against. I think it
should be like:

 err = ieee80211_csa_finalize(sdata);
 if (err) {
  sdata_info(sdata, "failed to finalize immediate CSA, disconnecting\n");
  cfg80211_stop_iface(local->hw.wiphy, &sdata->wdev, GFP_KERNEL);

  /* don't propagate the error here - stop the iface instead since
there's no way to revert CS now */
  err = 0;
 }

Should I re-post the patch(set?), post a follow up, or are you going
to update the patch yourself?

I'm not sure what you mean by rolling "that" into the function. You
want to put the stop_iface() in csa_finalize()? I think it's going to
look a bit ugly that way.


Michał
