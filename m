Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39402 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964918AbdAIKpb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 05:45:31 -0500
Message-ID: <1483958725.17582.18.camel@sipsolutions.net> (sfid-20170109_114857_270907_3E66EA31)
Subject: Re: [PATCH] RFC: Universal scan proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Shmidt <dimitrysh@google.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 09 Jan 2017 11:45:25 +0100
In-Reply-To: <CAH7ZN-w6KF2ReeU2=a7qafQBknEDqR1KLvv3gmgOY2tf70MM2w@mail.gmail.com> (sfid-20170105_214533_895914_59A2BE93)
References: <94eb2c110db85c2379054172dad0@google.com>
         <1480948100.31788.15.camel@sipsolutions.net>
         <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
         <1481093061.4092.17.camel@sipsolutions.net>
         <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com>
         <93d4475c-58bd-d497-3347-a988d551f374@broadcom.com>
         <CAH7ZN-wGseBVzV3Vuq+6=kgaSL7e0UnndGXPdu4PQKZw8H47YQ@mail.gmail.com>
         <1481645205.20412.32.camel@sipsolutions.net>
         <CAH7ZN-zm-CUv=QzoUojdyrcONRAHtTG18PiwGZ4sYY0qqft1BA@mail.gmail.com>
         <1483536510.7312.5.camel@sipsolutions.net>
         <CAH7ZN-zenL8SsqUAzMH5-Hb1RmUDDwgqqUKWEbPX=qaPV7e3TA@mail.gmail.com>
         <1483616763.4394.8.camel@sipsolutions.net>
         <CAH7ZN-w6KF2ReeU2=a7qafQBknEDqR1KLvv3gmgOY2tf70MM2w@mail.gmail.com>
         (sfid-20170105_214533_895914_59A2BE93)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-05 at 12:45 -0800, Dmitry Shmidt wrote:
> 
> > Oh, then again, maybe you're thinking of full-MAC devices - does a
> > roam/autojoin scan really already *imply* a new connection? And if
> > so, do we have to do it that way, or can we remove that type of
> > action and make a connection decision in higher layers, so it's
> > really the same as "report when suitable results are found"?
> 
> We need to consider case when FW may do some actions like connection
> during roaming/autojoin.

Ok. I was unsure if that was happening. So you're saying that the scan
parameters are determined by the host, and the scan is triggered from
there, but the action (like roaming) is taken by the firmware?

How does that differ to

 1) the scan being started by the firmware, possibly based on the BSS
    selection configuration Arend added?

 2) the scan result being reported to the host, and BSS selection done
    there?

> It depends how we want to make it flexible. For example we
> may allow to FW to report even usual scan results not one by one
> but as a chunk.

Firmware can do that, but is there any point in doing that in the
cfg80211 API? If it properly has full results, the driver can always
unbundle them and call the report function for each BSS and everything
should work just fine, no?

> > There's a bit more complication wrt. the level of detail in results
> > though - sometimes the result may include all IEs (normal/sched
> > scan), sometimes it may not ("history scan") - are we sure we
> > really only need one new get_scan_results()?
> 
> Maybe not - it is possible I missed something. 

I was hoping you could clarify the requirements :-)

> Also looking at our
> conversation I think we should consider separate command pair
> for history scan.

Perhaps, yes. Although perhaps having it triggered through the same
(new or extended) command, but results reported depending on the
"report type" would make sense. I think we need to clarify the exact
requirements before we make that call.

johannes
