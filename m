Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37900 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751570AbdABMVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 07:21:50 -0500
Message-ID: <1483359705.21014.0.camel@sipsolutions.net> (sfid-20170102_132212_994207_4FFA7191)
Subject: Re: [PATCH v3] rfkill: Add rfkill-any LED trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82_K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
        "David S . Miller" <davem@davemloft.net>
Cc: =?UTF-8?Q?=D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=BB_?=
         =?UTF-8?Q?=D0=9A=D1=80=D0=B8=D0=BD=D0=BA=D0=B8=D0=BD?=
        <krinkin.m.u@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Jan 2017 13:21:45 +0100
In-Reply-To: <1483355533.4596.11.camel@sipsolutions.net> (sfid-20170102_121239_821112_5D7AEC4A)
References: <20161221084533.27006-1-kernel@kempniu.pl>
         (sfid-20161221_094622_545524_B00A9AE7) <1483355533.4596.11.camel@sipsolutions.net>
         (sfid-20170102_121239_821112_5D7AEC4A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I'm not super happy with this conditional locking - can't we instead
> defer the necessary work to a workqueue, or so, for purposes of the
> LED?

Actually, since you can sleep in here, and do various other things like
scheduling etc. this can't even be correct as is - one thread might be
in the probe and another might also attempt to do some operations that
require the lock but now don't take it.

johannes
