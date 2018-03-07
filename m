Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:45367 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbeCGF72 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 00:59:28 -0500
Received: by mail-qk0-f174.google.com with SMTP id r140so1292237qke.12
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2018 21:59:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADsGw2ZBPK1hBY-a+v_1mVUOaFP3Uu5A4euyTc-070E4vSUrBg@mail.gmail.com>
References: <CADsGw2ZBPK1hBY-a+v_1mVUOaFP3Uu5A4euyTc-070E4vSUrBg@mail.gmail.com>
From: Thomas Pedersen <thomas@eero.com>
Date: Tue, 6 Mar 2018 21:59:26 -0800
Message-ID: <CADjYELzsP37RWTqJOSoevNy32E38e4=bkjDkY6A4F3exnDYadQ@mail.gmail.com> (sfid-20180307_065932_457549_DB3D46B3)
Subject: Re: Query on queues in mesh mode
To: Phani Siriki <yvsg.phanis@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 1, 2018 at 7:27 AM, Phani Siriki <yvsg.phanis@gmail.com> wrote:
> Hi All
>
> I am trying to understand the queuing mechanism wireless mesh networks.
>
> As per AP mode is concerned, there are four queues (BK, BE, Vi, VO)
> and traffic is controlled based on CWmin, CWmax, AIFS and TxOP.
>
> Does, mesh mode also involve these queues? Does mesh mode have any
> queue or it is just a single queue?

mesh mode maps to the different ACs like AP mode. The only additional
queue in mesh is the mpath->frame_queue, which may be used if an
active mpath for a given RA can't be found.

-- 
thomas
