Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32798 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966471AbdAKNOz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:14:55 -0500
Message-ID: <1484140490.29931.3.camel@sipsolutions.net> (sfid-20170111_141717_185072_C86DEBF8)
Subject: Re: [PATCH] RFC: Universal scan proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Dmitry Shmidt <dimitrysh@google.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 11 Jan 2017 14:14:50 +0100
In-Reply-To: <eb6a9c5e-0817-3b63-1e2f-d6bbff867b05@broadcom.com> (sfid-20170109_130750_105699_82BBA235)
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
         <cd31be64-579a-a702-c642-b80690aac5b2@broadcom.com>
         <1483623882.4394.20.camel@sipsolutions.net>
         <ac6c15d8-5d4f-722c-7d7e-c43f6a118b53@broadcom.com>
         <1483958921.17582.20.camel@sipsolutions.net>
         <eb6a9c5e-0817-3b63-1e2f-d6bbff867b05@broadcom.com>
         (sfid-20170109_130750_105699_82BBA235)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Well, we might not even need different commands. We need different
> > storage internally, but if you request the results for a given scan
> > ID then you might get a totally different result format? Though
> > that wouldn't lend itself well to query "everything you have" which
> > is also useful. But even then, it could be done by passing the
> > appropriate "report type" attribute to the dump command - we need
> > that anyway for trigger.
> 
> True. With "report type" attribute you do not mean the actual
> report_type thing, right. Hopefully you mean the parameter attribute
> that implicitly relates to a "report type". 

Right, I wasn't really thinking in terms of attributes while writing
this. OTOH, something like an attribute *would* be needed, no?

> The risk here is that it
> requires careful description of what user-space needs to look for if
> it gets a notification. I think having separate
> notification/retrieval commands lowers the risk of misinterpretation.

Yeah, fair point.

> Not sure if we're getting ahead of ourselves. Yes, we have to
> determine attributes for each scan "report type", but it is not a
> prerequisite for the other topic. 

We'll also have to figure out which report types we need at all :)

> I guess to answer the question about the partial results attributes
> we need to know what the possible higher-level use-cases are. Other
> source of information would be to look what is done for g-scan in
> Android "M" or "N", but not sure if that is best approach as we may
> not consider all use-cases.

Right.

johannes
