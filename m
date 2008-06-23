Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:5413 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYFWN6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 09:58:32 -0400
Received: by ug-out-1314.google.com with SMTP id h2so525597ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 06:58:31 -0700 (PDT)
Message-ID: <485FABE9.9000400@gmail.com> (sfid-20080623_155836_682826_9DFD9B19)
Date: Mon, 23 Jun 2008 16:58:01 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [BUG] Two bugs in monitor mode, iwl3945
References: <485F687C.1050407@gmail.com> <69e28c910806230553k6c878126s1f8ee15770bada57@mail.gmail.com>
In-Reply-To: <69e28c910806230553k6c878126s1f8ee15770bada57@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefanik G=E1bor wrote:
> On Mon, Jun 23, 2008 at 11:10 AM, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
>> I noticed two bugs:
>>
>> 1) Monitor mode hangs the system randomly, and what is interesting t=
hat this
>> bug disappears if I patch the driver with packet injection patch fro=
m G=E1bor
>> Stefanik.
>> I noticed this bug, after I removed his patch to see if it caused so=
me
>> problems.
>> Always reproducible, usually hangs just after airodump launch.
>=20
> Something tries to transmit on the monitor interface, which is
> impossible without the injection patch. However, the method used for
> preventing TX in monitor mode is incorrect (it just drops the packet
> silently, without notifying mac80211, which, in the absence of an ACK=
,
> tries to retransmit the packet - an obvious infinite loop). This is
> what causes the freeze. (Do you have networkmanager running? That
> often tends to interfere with monitor interfaces.)
I have it running, I will test without it.
>=20
>> 2) If I enable monitor mode regardless of injection patch, the scann=
ing
>> results got garbaged,
>> iwlist scan reports > 100 quality on most APs, or 0% quality on my r=
outer,
>> shows extremely low and hi power levels, like
>> -127dBm or 160 dBm, and those levels change rapidly.
>> This why I removed the injection patch, I suspected it, but this bug=
 appears
>> to be not related to it.
>=20
> Does this also happen if you create an extra managed or AP (AP
> requires a patch to mac80211) interface, or is it specific to monitor
> interfaces?
If I create any interface, managed/ibss/monitor nothing bad happens.
But when I turn the mon0 up (ifconfig mon0 up), this happens.

I can't turn on other interfaces (managed/ibss), ifconfig complains tha=
t interface is busy
I think that it isn't allowed to run two managed interfaces in same tim=
e, don't know why.


Best regards,
	Maxim Levitsky
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
