Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35749 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbcLBVPR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Dec 2016 16:15:17 -0500
Received: by mail-io0-f193.google.com with SMTP id h133so2241575ioe.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Dec 2016 13:15:16 -0800 (PST)
Date: Fri, 2 Dec 2016 16:13:51 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Thomas Pedersen <thomas@eero.com>
Cc: Masashi Honma <masashi.honma@gmail.com>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Remove invalid flag operations in mesh TSF
 synchronization
Message-ID: <20161202211351.GA5571@localhost> (sfid-20161202_221644_951079_38843706)
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
 <CADjYELx0ts7B8A2cAtpCjuH7b-AFFm_fqC=hnyhQBmVtu7ewzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADjYELx0ts7B8A2cAtpCjuH7b-AFFm_fqC=hnyhQBmVtu7ewzA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 02, 2016 at 12:07:18PM -0800, Thomas Pedersen wrote:
> On Wed, Nov 30, 2016 at 2:44 PM, Masashi Honma <masashi.honma@gmail.com> wrote:
> > mesh_sync_offset_adjust_tbtt() implements Extensible synchronization
> > framework ([1] 13.13.2 Extensible synchronization framework). It shall
> > not operate the flag "TBTT Adjusting subfield" ([1] 8.4.2.100.8 Mesh
> > Capability), since it is used only for MBCA ([1] 13.13.4 Mesh beacon
> > collision avoidance, see 13.13.4.4.3 TBTT scanning and adjustment
> > procedures for detail). So this patch remove the flag operations.
> 
> 802.11-2012 13.13.2.2.3:
[snip]
> so, no? I think we need to indicate a TSF adjustment is taking place.

I think so too.

I must ask, what is the prompt for removing it, are you (Masashi)
trying to implement MBCA and this is interfering?

-- 
Bob Copeland %% http://bobcopeland.com/
