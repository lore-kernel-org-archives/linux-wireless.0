Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50454 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932951AbcLMQGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 11:06:47 -0500
Message-ID: <1481645205.20412.32.camel@sipsolutions.net> (sfid-20161213_170736_856579_4D15868A)
Subject: Re: [PATCH] RFC: Universal scan proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Shmidt <dimitrysh@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2016 17:06:45 +0100
In-Reply-To: <CAH7ZN-wGseBVzV3Vuq+6=kgaSL7e0UnndGXPdu4PQKZw8H47YQ@mail.gmail.com> (sfid-20161208_233506_851319_5A9AD163)
References: <94eb2c110db85c2379054172dad0@google.com>
         <1480948100.31788.15.camel@sipsolutions.net>
         <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
         <1481093061.4092.17.camel@sipsolutions.net>
         <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com>
         <93d4475c-58bd-d497-3347-a988d551f374@broadcom.com>
         <CAH7ZN-wGseBVzV3Vuq+6=kgaSL7e0UnndGXPdu4PQKZw8H47YQ@mail.gmail.com>
         (sfid-20161208_233506_851319_5A9AD163)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Supporting requests (or more precisely requests and results)
> differentiated by user-space entity can be tricky. Right now we are
> not checking current caller pid, right? Maybe it is also good idea -
> or maybe we can just make result filtering per user-space caller?

Could be done.

You seem to be very worried about the partial results - I'm not too
worried about that I guess, the connection manager itself will always
be able to wait for the full scan to finish before making a decision,
but it may not even want to (see the separate discussion on per-channel 
"done" notifications etc.)

I'm much more worried about the "bucket reporting" since that doesn't
fit into the current full BSS reporting model at all. What's your
suggestion for this?

johannes
