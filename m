Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61393 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2DJBsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 21:48:18 -0400
Received: by iagz16 with SMTP id z16so6667655iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2012 18:48:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd9WPiPr2z310eRuXxueQwDRKL_m7YqSKD=y5Fn3t2Gkww@mail.gmail.com>
References: <1333957617-13732-1-git-send-email-yeohchunyeow@gmail.com>
	<CAPjQAd9WPiPr2z310eRuXxueQwDRKL_m7YqSKD=y5Fn3t2Gkww@mail.gmail.com>
Date: Tue, 10 Apr 2012 09:48:17 +0800
Message-ID: <CAEFj985DuwSb5hSnu77UGwOxYu7K9pqn==Ln6_cW1+JQga-=7Q@mail.gmail.com> (sfid-20120410_034849_753606_EAF8D765)
Subject: Re: [PATCH] mac80211: fix the assignment of PREQ's MAC address for
 Proactive RANN
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Javier

> 1. I would suggest rewording the description.  Maybe something like:
>
> "Record the RANN sender's address only for RANNs that meet the
> acceptance criteria (per sections 13.10.12.4.2)."

Noted, your description is clearer.

> 2. Also, to properly review the patch, I had to find your earlier
> patch (http://lists.open80211s.org/pipermail/devel/2012-March/003113.html)
> that's still in John's queue.  Maybe merge the two patches and
> resubmit?

I have found out that the previous patches are merged upstream 5 hours ago.

> 3. Before your patch, the address in rann_snd_addr was always valid if
> mpath->is_root == true.  This is why elsewhere in the code you could
> safely do things like:
>
> da = (mpath && mpath->is_root) ? mpath->rann_snd_addr : broadcast_addr;
>
> This is no longer the case, at least not evidently.  Can you double
> check that the possibility where mpath->is_root == true and
> mpath->rann_snd_addr is uninitialized is correctly addressed?  Maybe
> by initializing mpath->rann_snd_addr to be the broadcast address?
>

Ok, I will take a look on this. Perhaps, adding it on the mesh_path_add routine.

> 4. The comment  /* Using individually addressed PREQ for root node */
> does not make sense there.  I think it's ok to remove, or reword as /*
> Recording RANNs sender address to send individually addressed PREQs
> destined for root node */

Noted.

Regards,
Chun-Yeow
