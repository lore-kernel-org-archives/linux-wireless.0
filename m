Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:60974 "EHLO
        resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752581AbeEGSyn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 14:54:43 -0400
Subject: Re: Possible Regression in Wireless Driver Affecting Intel
 Corporation Wireless 7265 (rev 59)
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
Cc: emmanuel.grumbach@intel.com
References: <1b91c09e-d20b-bcb2-5961-7c7b400a78d9@comcast.net>
 <24f6604b3d45c04c2dd15b2c47855a739c8ced1a.camel@coelho.fi>
From: Jape Person <japers@comcast.net>
Message-ID: <0b2d5c82-896b-ba61-60f1-c771a92b36bf@comcast.net> (sfid-20180507_205447_582857_3BC2E1EE)
Date: Mon, 7 May 2018 14:54:18 -0400
MIME-Version: 1.0
In-Reply-To: <24f6604b3d45c04c2dd15b2c47855a739c8ced1a.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2018 03:58 AM, Luca Coelho wrote:
> On Mon, 2018-04-30 at 18:01 -0400, Jape Person wrote:
>> Two recent kernel upgrades seem to have both affected the
>> Intel Corporation Wireless 7265 (rev 59) adapters on our
>> systems in a manner which causes their network transfer rates
>> to be reduced dramatically. File transfers which normally
>> require a few minutes are now taking several hours.
>> 
>> These systems are running the Debian testing distribution with 
>> the iwilwifi drivers from Debian's testing/contrib. The
>> altered behavior came when the Debian linux-image version
>> advanced to 4.15.*.
>> 
>> I looked online for similar reports and didn't find anything 
>> that seemed directly applicably. I finally got lucky when I 
>> experimented with the net.ipv4.tcp_congestion_control setting.
>> 
>> I understand that in version 4.15 of the kernel the default
>> was changed from cubic to bbr. I used
>> 
>> # sysctl net.ipv4.tcp_congestion_control=cubic
>> 
>> to revert to the previous default on all of the systems. This 
>> has caused all of the systems to return to their normal file 
>> transfer speeds.
>> 
>> Please let me know by direct reply (I'm not subscribed.) if I 
>> can supply more information.
> 
> Do you see anything in dmesg? SYSASSERT messages or something?
> Please send your dmesg so we can take a look.
> 
> Are you by any chance using NFS? Emmanuel has recently fixed a
> problem that was occurring with NFS (but probably happens with
> other protocols too).  Can you apply the patch included in the
> following bugzilla report and see if it helps?
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=199209#c18
> 
> -- Cheers, Luca.
> 

I must apologize for sending you noise instead of data, and for my
delay in replying. I felt the need to do further research before
responding.

I was not seeing any indicators whatsoever in dmesg, just very slow
file transfers. (And, no, no NFS on this network.)

I mistakenly thought my "clever" change in the
net.ipv4.tcp_congestion_control setting had "fixed" the issue
because our periodic large file transfers went without a hitch after
I applied it. The improvement was temporary.

When the next cycle of transfers was attempted a few days ago I saw
the slowdown recur.

The recurrence plus the lack of local indicators in any of the
systems' logs clued me in to the probability that this issue was
caused by network infrastructure. (I work from home and hardly ever
see it.) The router this LAN uses has always been connected to the
Internet through a DMZ on an edge router. An examination of that
edge router proved that someone had switched the LAN router
connection on the edge router from DMZ to regular client status.
This happened on the day that a field service rep from Verizon
replaced an ONT. Whether it was the rep or one of our guys, I'll be
standing there with a hammer in my hand the next time anyone works
on the infrastructure.

So, this (probably) was one of those abominable intermittent routing
issues caused by someone hooking up a router in
dumb-but-semi-workable way.

I'm back from cubic to bbr, and no slowdowns on some really big file
transfers running all day yesterday and overnight.

Again, sorry for the noise.

Best,
JP
