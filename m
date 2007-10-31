Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:3709 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbXJaTG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 15:06:58 -0400
Received: by wa-out-1112.google.com with SMTP id v27so289909wah
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 12:06:56 -0700 (PDT)
Message-ID: <8e8340660710311206pefafa6bw5cc022637265f4b6@mail.gmail.com> (sfid-20071031_190702_112463_3845A495)
Date: Wed, 31 Oct 2007 12:06:55 -0700
From: "Luis Carlos Cobo" <luisca@cozybit.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 5/7] o80211s: (zd1211rw-mac80211) support for mesh interface
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1193832127.23775.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4727de15.0abd720a.7b07.ffffb1f7@mx.google.com>
	 <1193832127.23775.26.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/07, Dan Williams <dcbw@redhat.com> wrote:
> Awesome to see this work.  I assume you're developing on zd1211 then?

Yes, we started with this device because it's cheap and easy to find,
so more people can test this and contribute. We intend to support any
softmac device with a driver using mac80211.

> Would similar changes be necessary to support other devices?

Yes, basically support the mesh interface type and make sure mesh (WDS
type) frames are not filtered out and are acknowledged (otherwise you
get tons of duplicates).

Apart from that, this driver did not support beaconing, so we had to
add that too. Fortunately the GPL vendor driver is quite complete so
we could port the features from there.

Thanks for the comments, I will include them as well as Johannes' and
resend the patches.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.
