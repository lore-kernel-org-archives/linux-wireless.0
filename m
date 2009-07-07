Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:46116 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbZGGDD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 23:03:56 -0400
Received: by yxe26 with SMTP id 26so6275059yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 20:03:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246930856.4652.11.camel@johannes.local>
References: <1246928780.4652.10.camel@johannes.local>
	 <1246929954-15282-1-git-send-email-javier@cozybit.com>
	 <1246930856.4652.11.camel@johannes.local>
Date: Mon, 6 Jul 2009 20:03:59 -0700
Message-ID: <445f43ac0907062003r3943e374ue9b6c498e76ea0b8@mail.gmail.com>
Subject: Re: [PATCH v2] Fix regression in mesh forwarding path.
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Andrey Yurovsky <andrey@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Mon, Jul 6, 2009 at 6:40 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> Hmm, now I'm confused, why not just do
>
> if (mpath->flags & MESH_PATH_ACTIVE)
>        ieee80211_add_pending_skbs(mpath->sdata->local,
>                                   &mpath->frame_queue);
> ?

Ah, yes, much better.  I had missed the trailing 's' in your previous
e-mail.  See v3 of the patch.

Thanks,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
