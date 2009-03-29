Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:37981 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbZC2VXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 17:23:11 -0400
Received: by ewy9 with SMTP id 9so1816368ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 14:23:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903292204.44260.rossi.f@inwind.it>
References: <20090315202035.GC5246@makis>
	 <200903292109.55033.rossi.f@inwind.it>
	 <40f31dec0903291335j2befd3b4r1b4f4619ae634113@mail.gmail.com>
	 <200903292204.44260.rossi.f@inwind.it>
Date: Mon, 30 Mar 2009 00:23:07 +0300
Message-ID: <40f31dec0903291423s384a98b5l8f86b317aeb5c9a4@mail.gmail.com> (sfid-20090329_232330_178819_C7F88B85)
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
From: Nick Kossifidis <mickflemm@gmail.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/29 Fabio Rossi <rossi.f@inwind.it>:
> On Sunday 29 March 2009, Nick Kossifidis wrote:
>
>> I can understand how this patch may have resulted a noise floor
>> calibration timeout but i can't understand how it broke everything
>> else. I've tested it with a very similar card (same MAC and PHY chips
>> but from a different vendor) and it worked just fine. Also i know
>> there is still something more to fix for RF5112 while setting rf
>> buffer settings and we have 2 curves but i don't think that's related.
>
> I was using wireless-testing when I have experienced the problem. Then after
> the bisectioning procedure I removed the entire patch solving the problem with
> the authentication-association process.
>
> Does also your board support 802.11abg? I don't understand why the noise
> calibration process remains stuck @ 5.18GHz.
>

Yup i have exactly the same phy chip as you.

> Is it possible to split your patch in shorter pieces to isolate the problem?
>

This patch introduces a function (and some helpers) to set 2 tables on
hardware, it doesn't mess with the rest of the driver. I've tested it
both on sta and ap scenarios with all the cards i have available and
it worked fine. If you want to make more tests just disable parts of
hw_txpower on phy.c, you can start by commenting out everything  below

ath5k_setup_rate_powertable(ah, txpower, &rate_info, ee_mode);

to skip the setting of tx power, if you comment out the whole function
you'll disable the functionality that this patch adds.

>> This is even more weird, do you have an SMP system ? That warning you
>> get is from the periodic calibration function, it seems you run this
>> function too often...
>
> Unfortunately I don't have a SMP system but a very old processor, an Athlon
> Thunderbird 900MHz :-( I have to manually reboot the system (hardware button,
> the software procedure doesn't work).
>

My initial thought was that one of the cpus was stuck, running the
calibration function again and again which would result what you
describe.

Check this out...

Mar 29 11:08:45 kernel: udev: renamed network interface wlan0 to ath0
Mar 29 11:09:03 kernel: ath5k phy0: noise floor calibration timeout (5180MHz)
Mar 29 11:09:36 last message repeated 3 times
Mar 29 11:10:43 last message repeated 6 times
Mar 29 11:11:48 last message repeated 6 times
Mar 29 11:12:54 last message repeated 6 times
Mar 29 11:14:00 last message repeated 6 times
Mar 29 11:15:06 last message repeated 6 times
Mar 29 11:16:12 last message repeated 6 times

Calibration functions runs almost 6 times /min which makes sense (we
run it each 10 secs) but...

a) It always fails
b) It's always called with the same channel

> Tell me if you need other information, I'll test possible patches to solve the
> problem.

How about scanning or monitor mode, does it work ?



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
