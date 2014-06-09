Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:42484 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaFIFew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 01:34:52 -0400
Received: by mail-vc0-f179.google.com with SMTP id id10so3992556vcb.38
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2014 22:34:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402080365-15462-1-git-send-email-luca@coelho.fi>
References: <1402068423-23359-1-git-send-email-luca@coelho.fi>
	<1402080365-15462-1-git-send-email-luca@coelho.fi>
Date: Mon, 9 Jun 2014 07:34:50 +0200
Message-ID: <CA+BoTQkX=ZpDc=R+nWxsrj026XyaaEiwrosaB2buRVif2aOnxQ@mail.gmail.com> (sfid-20140609_073506_684708_48D3D980)
Subject: Re: [RFC option 2] mac80211: introduce refcount for queue_stop_reasons
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 June 2014 20:46, Luca Coelho <luca@coelho.fi> wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
>
> Sometimes different vifs may be stopping the queues for the same
> reason (e.g. when several interfaces are performing a channel switch).
> Instead of using a bitmask for the reasons, use an integer that holds
> a refcount instead.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
>
> This looks much simpler now.  The only thing is that we need to make
> sure the bitmask never gets out of sync with the refcounts, which
> shouldn't be too difficult, as long as we keep the refcounts usage
> restricted to the queues start/stopping functions.

I think you need to make sure all stop/wake calls are balanced
everywhere (including device drivers). Otherwise you risk breaking
things silently in some cases.

It might also be worth to update exported stop/wake symbol documentation too.


Michał
