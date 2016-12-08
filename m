Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:33509 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932976AbcLHBYe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 20:24:34 -0500
Received: by mail-pg0-f48.google.com with SMTP id 3so167946663pgd.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 17:23:57 -0800 (PST)
Subject: Re: [PATCH] mac80211: Remove invalid flag operations in mesh TSF
 synchronization
To: Bob Copeland <me@bobcopeland.com>
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
 <CADjYELx0ts7B8A2cAtpCjuH7b-AFFm_fqC=hnyhQBmVtu7ewzA@mail.gmail.com>
 <20161202211351.GA5571@localhost>
 <59d30c75-4eb5-cdc8-c762-b62b22664b51@gmail.com>
 <CADjYELw=-LEqDra0pM+3FjtJDve+NiNYEMz5=F0i5Ge-5k3LaA@mail.gmail.com>
 <1481102652.4092.33.camel@sipsolutions.net>
 <9197b711-3d48-071a-57d8-53e2a11c26de@gmail.com>
 <20161207133315.GD7524@localhost>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Thomas Pedersen <thomas@eero.com>,
        linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <92b3fe4f-66b6-8b35-8f35-fe19c61f6597@gmail.com> (sfid-20161208_022438_122020_9A076EE0)
Date: Thu, 8 Dec 2016 10:16:39 +0900
MIME-Version: 1.0
In-Reply-To: <20161207133315.GD7524@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年12月07日 22:33, Bob Copeland wrote:
> This mesh_sync_offset_adjust_tbtt is definitely doing offset
> synchronization, so probably "tbtt" should be renamed "tsf" here.

Right. I will send a patch for this.

> Actually, looking at the code now it doesn't make a lot of sense to set
> this flag for offset sync because TOFFSET_KNOWN flag is completely cleared
> whenever that is set, so we have to be forgetting the current t_offset all
> the time?

Right, TOFFSET_KNOWN flag looks not need to be cleared when 
TBTT_ADJUSTING flag is on. Because the t_offset is received when 
TBTT_ADJUSTING flag is off. The t_offset is expected to have valid 
value. I will remove the code by next patch.

Masashi Honma.
