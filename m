Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35604 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755170AbcLBUOI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Dec 2016 15:14:08 -0500
Received: by mail-wm0-f48.google.com with SMTP id a197so27286059wmd.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Dec 2016 12:14:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
From: Thomas Pedersen <thomas@eero.com>
Date: Fri, 2 Dec 2016 12:07:18 -0800
Message-ID: <CADjYELx0ts7B8A2cAtpCjuH7b-AFFm_fqC=hnyhQBmVtu7ewzA@mail.gmail.com> (sfid-20161202_211414_818075_D80221EF)
Subject: Re: [PATCH] mac80211: Remove invalid flag operations in mesh TSF synchronization
To: Masashi Honma <masashi.honma@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        me@bobcopeland.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 30, 2016 at 2:44 PM, Masashi Honma <masashi.honma@gmail.com> wrote:
> mesh_sync_offset_adjust_tbtt() implements Extensible synchronization
> framework ([1] 13.13.2 Extensible synchronization framework). It shall
> not operate the flag "TBTT Adjusting subfield" ([1] 8.4.2.100.8 Mesh
> Capability), since it is used only for MBCA ([1] 13.13.4 Mesh beacon
> collision avoidance, see 13.13.4.4.3 TBTT scanning and adjustment
> procedures for detail). So this patch remove the flag operations.

802.11-2012 13.13.2.2.3:

The mesh STA checks if the transmitter of the Beacon frame or Probe
Response frame is in the
process of the TBTT adjustment (see 13.13.4.4.3). If the received
frame contains the Mesh
Configuration element and the TBTT Adjusting subfield in the Mesh
Configuration field is 1, the
mesh STA shall invalidate the T offset value for this neighbor STA and
shall not perform the
following steps.

so, no? I think we need to indicate a TSF adjustment is taking place.

-- 
thomas
