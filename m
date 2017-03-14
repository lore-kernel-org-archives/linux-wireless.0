Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39568 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbdCNNvK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 09:51:10 -0400
Message-ID: <1489499461.10872.4.camel@sipsolutions.net> (sfid-20170314_145113_136232_E6561D9F)
Subject: Re: [PATCH] mac80211: Allow multiple listeners for management
 frames.
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        linux-wireless@vger.kernel.org
Cc: simon.wunderlich@openmesh.com,
        Benjamin Berg <benjamin@sipsolutions.net>
Date: Tue, 14 Mar 2017 14:51:01 +0100
In-Reply-To: <20170310093454.27664-1-sven.eckelmann@openmesh.com> (sfid-20170310_103523_108597_73CF7884)
References: <20170310093454.27664-1-sven.eckelmann@openmesh.com>
         (sfid-20170310_103523_108597_73CF7884)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-10 at 10:34 +0100, Sven Eckelmann wrote:
> From: Benjamin Berg <benjamin@sipsolutions.net>
> 
> Previously it was not possible to have multiple listeners for
> management frames in userspace. This is a bit weird as multiple
> processes in userspace might try to request management frame
> reporting but only the first request was accepted.

I vaguely remember discussing this with Benjamin.

> It is currently unknown why Benjamin never forwarded it. I am doing
> this now to have a chance that this private patch doesn't have to be
> rebased anymore by OpenMesh.

I'm not sure I mentioned it to him, or even remembered it when we were
discussing it, but I don't think this patch is a good idea, at least
for action frames.

For non-action frames, I don't see any problem.

However, for action frames, if you subscribe you get the responsibility
to return if unhandled (setting 0x80 in the action code fields).

With multiple subscribers, that becomes impossible.

If you restrict it to non-action I can live with it, but I don't know
what you really want to do with this.

johannes
