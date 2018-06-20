Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:42626 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754530AbeFTDFA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 23:05:00 -0400
Received: by mail-ot0-f196.google.com with SMTP id 92-v6so2070400otw.9
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 20:05:00 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [BUG] mac80211: Using smp_processor_id() in preemptible code: iwd
From: Denis Kenzior <denkenz@gmail.com>
In-Reply-To: <1529065843.10037.22.camel@sipsolutions.net>
Date: Tue, 19 Jun 2018 22:04:58 -0500
Cc: "McGinn, Dan" <dan.mcginn@imperial.ac.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-Id: <C7853888-5B20-4695-BD6F-4438B7ADF58D@gmail.com> (sfid-20180620_050521_368541_E2C0FA8F)
References: <DB5PR06MB106451FE83810B8A129CE1E4A47C0@DB5PR06MB1064.eurprd06.prod.outlook.com>
 <1529065843.10037.22.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> On Jun 15, 2018, at 7:30 AM, Johannes Berg <johannes@sipsolutions.net> =
wrote:
>=20
> On Fri, 2018-06-15 at 11:09 +0000, McGinn, Dan wrote:
>> Hi, I'm newly trying out Intel iwd daemon but I experience regular =
kernel errors in 4.17, although WPA2-PSK connection remains stable.  =
These errors don't seem to be experienced with wpa_supplicant.  The =
errors reliably appear around the following events:
>> netdev_unicast_notify()
>> netdev_control_port_frame_event()
>> netdev_set_rekey_offload()
>> netdev_set_gtk()
>>=20
>> @Denkenz in IRC helpfully suggests Johannes could follow the finger =
of suspicion to this commit:
>> =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D911806491425d79107cadddbde11b42bbdfe38c8
>=20
> It's his code ;-)

Right, but you=E2=80=99re much more aware of all the locking issues than =
I am.

>=20
> Clearly this comes from cfg80211 without any locking other than rtnl, =
so
> you don't have preemption disabled. That's the minimum needed to get =
rid
> of the warning you found.

In my defense, I did ask you whether there are any potential locking =
issues in the RFC and you didn=E2=80=99t think there were any.

I posted a fix for this.  Could you please review?

Regards,
-Denis
