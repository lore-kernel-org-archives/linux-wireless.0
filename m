Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57810 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755377AbdJQGDI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 02:03:08 -0400
Message-ID: <1508220186.10607.47.camel@sipsolutions.net> (sfid-20171017_080324_414996_AC7B9A1B)
Subject: Re: [PATCH] iw: add command to register and capture mgmt frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Avinash Patil <avinashp@quantenna.com>,
        Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 17 Oct 2017 08:03:06 +0200
In-Reply-To: <844c4931-f513-773b-21db-f8e5455088b9@quantenna.com>
References: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
         <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com>
         <20171015095133.prxuuukv6osx52td@bars>
         <1508138777.10607.14.camel@sipsolutions.net>
         <20171016084810.plzog2dtzakra4ae@bars>
         <1508145899.10607.30.camel@sipsolutions.net>
         <844c4931-f513-773b-21db-f8e5455088b9@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Maybe we could add an additional nl attribute to 
> NL80211_CMD_REGISTER_FRAME command to allow applications to
> advertise 
> what is their intention, something like
> NL80211_ATTR_MGMT_LISTENER_TYPE. 
> Only allow to register more then one listener if it explicitly
> specifies 
> that it will not try to answer (TYPE_LISTEN_ONLY or smth like that).
> This will preserve behavior for existing userspace.

We could, in theory, but I don't like using this API for monitoring
purposes. We really should just come up with more generic and flexible
ways of doing that, and I think the eBPF thing is pretty good there.

johannes
