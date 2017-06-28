Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55476 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbdF1HV6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 03:21:58 -0400
Message-ID: <1498634512.12531.1.camel@sipsolutions.net> (sfid-20170628_092240_947951_23386F85)
Subject: Re: [PATCH 05/14] mwifiex: re-register wiphy across reset
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Norris <briannorris@chromium.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 28 Jun 2017 09:21:52 +0200
In-Reply-To: <20170627195003.GA93674@google.com> (sfid-20170627_215010_204503_7ACDE0D1)
References: <20170525001119.64791-1-briannorris@chromium.org>
         <20170525001119.64791-5-briannorris@chromium.org>
         <87fufk2hmm.fsf@purkki.adurom.net> <20170601173954.GA138807@google.com>
         <87inka77md.fsf@codeaurora.org> <20170621174829.GA92340@google.com>
         <1498136389.2246.7.camel@sipsolutions.net>
         <20170627195003.GA93674@google.com> (sfid-20170627_215010_204503_7ACDE0D1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> Wow, that's not exactly simple code; I expect it could be pretty
> difficult to get that right today on mwifiex. 

Yeah, I have no doubt. You'd probably have to track a lot of state that
you just pass down to the firmware too, and possibly can't even track
some state that the firmware derives itself (like for example PNs for
keys)

> The current approach
> actually should be *easier* (for the kernel side) to avoid bugs, as
> it should be basically the same thing as 'rmmod'. Nonetheless, there
> are plenty of bugs.

:-)

johannes
