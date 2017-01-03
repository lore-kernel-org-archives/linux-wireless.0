Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33945 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965898AbdACUqB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 15:46:01 -0500
Received: by mail-io0-f169.google.com with SMTP id p42so439982971ioo.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 12:46:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1481645205.20412.32.camel@sipsolutions.net>
References: <94eb2c110db85c2379054172dad0@google.com> <1480948100.31788.15.camel@sipsolutions.net>
 <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
 <1481093061.4092.17.camel@sipsolutions.net> <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com>
 <93d4475c-58bd-d497-3347-a988d551f374@broadcom.com> <CAH7ZN-wGseBVzV3Vuq+6=kgaSL7e0UnndGXPdu4PQKZw8H47YQ@mail.gmail.com>
 <1481645205.20412.32.camel@sipsolutions.net>
From: Dmitry Shmidt <dimitrysh@google.com>
Date: Tue, 3 Jan 2017 12:45:59 -0800
Message-ID: <CAH7ZN-zm-CUv=QzoUojdyrcONRAHtTG18PiwGZ4sYY0qqft1BA@mail.gmail.com> (sfid-20170103_214604_828687_5EED7314)
Subject: Re: [PATCH] RFC: Universal scan proposal
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 13, 2016 at 8:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> Supporting requests (or more precisely requests and results)
>> differentiated by user-space entity can be tricky. Right now we are
>> not checking current caller pid, right? Maybe it is also good idea -
>> or maybe we can just make result filtering per user-space caller?
>
> Could be done.
>
> You seem to be very worried about the partial results - I'm not too
> worried about that I guess, the connection manager itself will always
> be able to wait for the full scan to finish before making a decision,
> but it may not even want to (see the separate discussion on per-channel
> "done" notifications etc.)

Probably you are right.

> I'm much more worried about the "bucket reporting" since that doesn't
> fit into the current full BSS reporting model at all. What's your
> suggestion for this?
>
> johannes

We can either use alternative structure in kernel wireless stack,
or alternative structure in userspace (in wpa_supplicant), and we will
most likely need special command for this case at least to retrieve
results.
