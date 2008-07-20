Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:55943 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbYGTAjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 20:39:17 -0400
Received: by wf-out-1314.google.com with SMTP id 27so888355wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 17:39:16 -0700 (PDT)
Message-ID: <3ace41890807191739t5969f38au170e4b73a3d0b7de@mail.gmail.com> (sfid-20080720_023921_480798_4D6C9EAE)
Date: Sun, 20 Jul 2008 01:39:16 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] rtl8187: Improve wireless statistics for RTL8187B
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <48816A43.1050903@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807182142.59921.herton@mandriva.com.br>
	 <48816A43.1050903@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 19, 2008 at 5:14 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Herton Ronaldo Krzesinski wrote:
>>
>> I did some tests here and statistics are better now. I only couldn't use
>> latest wireless-testing because something of latest changes broke
>> communication, I couldn't scan/associate anymore, but using wireless-testing
>> head at d61f20889de4978ed87d2a37d6f27147faec22d1 plus later anaparam*off
>> change, with your patch I can confirm the better statistics, later I'll try
>> to find what in wireless-testing broke here, I didn't have time to look into
>> this today.
>
> What platform are you using? I'm on x86_64 and the latest one works for me.
> At least you won't have that many commits to bisect.

I am on x86_64 and I am on a similar situation - I am using the
rawhide kernels from:
http://koji.fedoraproject.org/koji/packageinfo?packageID=8
and the last one that worked for me is kernel-2.6.25.11-92.fc9 - something in
kernel-2.6.25.11-93.fc9 broke connectivity. Apparently the difference
is this set of changes:
http://marc.info/?l=linux-wireless&m=121606436000705&w=2

I just don't feel like mentioning it earlier because I had mistakenly
complained about Herton's
last patch and I don't want to make the same mistake - and I did test
it. Beside Herton's
 ANAPARAM*_OFF patch (which I don't think is the source of the
problem), there is
only one other "rtl8187: Fixed section mismatch in rtl8187_dev.c"
change - but that's is also
obviously right, and besides, its nature shouldn't affect association
anyway; but there is
a lot of mac80211 changes elsewhere, and I wonder.

My symptom is that I can authenticate and associate (apparently,
according to dmesg)
but cannot get an ip address via dhcp. I have tried and just alternate
between the two kernels,
identical steps, etc and one works and the other doesn't.
