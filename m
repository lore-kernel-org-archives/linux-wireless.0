Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39649 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab0LAUJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 15:09:44 -0500
Received: by qwb7 with SMTP id 7so7471951qwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 12:09:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291232151.4199.12.camel@jlt3.sipsolutions.net>
References: <1291168735-3423-1-git-send-email-javier@cozybit.com>
 <1291184383.4199.4.camel@jlt3.sipsolutions.net> <AANLkTikMex0A91Qy=5EwPAEfVWKDVz4_mneWnCvy3soR@mail.gmail.com>
 <1291229642.4199.11.camel@jlt3.sipsolutions.net> <1291232151.4199.12.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 1 Dec 2010 12:09:22 -0800
Message-ID: <AANLkTimgfRvqp=-CDU=G8o-ZfD4fVbf3j-AdXCVtoM6c@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Support beacon configuration via nl80211 for
 mesh interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Wed, Dec 1, 2010 at 11:35 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-12-01 at 19:54 +0100, Johannes Berg wrote:
>
>> If we had a 'start mesh' command, like 'join IBSS', then it'd be natural
>> to have just more attributes in it. Maybe it's time to start thinking
>> about that again, although backward compatibility could be interesting.
>
> Ok I started looking at this ...
>
> I have a feeling I asked this before, but can't remember -- is it
> necessary to be able to change the mesh config on the fly, while the
> mesh is active?

It is convenient to be able to change things like the ttl or the auto
peering without having to bring down the interface.  People might also
want to tune from userspace the different mesh timeouts in response to
changes in operating conditions (e.g. mesh density).
But right now the only parameter that needs the mesh to be active is
plink_action:  one can only block or manually initiate peering after a
beacon has been received from a suitable neighbor.

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
