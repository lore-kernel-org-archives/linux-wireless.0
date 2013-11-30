Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:46344 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3K3N6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 08:58:10 -0500
Received: by mail-ob0-f179.google.com with SMTP id wm4so11048717obc.10
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 05:58:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385817282.5056.0.camel@jlt4.sipsolutions.net>
References: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com>
	<1385817282.5056.0.camel@jlt4.sipsolutions.net>
Date: Sat, 30 Nov 2013 15:58:10 +0200
Message-ID: <CAGXs5wVt3okeE6oA_pNV5WnQLv51+bf+n+52s5d7tQkXq_qvNw@mail.gmail.com> (sfid-20131130_145813_960762_E3D8462E)
Subject: Re: wireless network interfaces and network namespaces
From: Kevin Wilson <wkevils@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks!
Running:
iw phy phy0 set netns 3433
indeed moved wlan0 to the network namespace I created, where process 3433 ran.
I did not see a way to specify the network namespace name for moving
wlan0 in this command (at least iw help does not show it and  I am
using iw 3.4-1 on ubuntu). I did not looked into the source code of iw
though.




On Sat, Nov 30, 2013 at 3:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2013-11-30 at 14:12 +0200, Kevin Wilson wrote:
>> Hello,
>> I am trying to move a wireless interface to a network namespace I
>> created and I get an error:
>>
>> ip link set wlan0 netns ns1
>> RTNETLINK answers: Invalid argument
>>
>> I do it with latest iproute2 git sources,  on 3.8 kernel.
>>
>> I want to verify this: all wireless interfaces do no support
>> network namespace. Is this true ? what in fact is the reason for this ?
>
> At least mac80211-based wireless interfaces *do* support namespaces, but
> you have to change the entire wireless NIC's namespace using iw --
> having different virtual interfaces of the same NIC in different
> namespaces is not supported.
>
> johannes
>
