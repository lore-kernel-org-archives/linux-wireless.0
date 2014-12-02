Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:44828 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282AbaLBXnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 18:43:55 -0500
Received: by mail-qg0-f54.google.com with SMTP id q107so9992218qgd.41
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 15:43:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417563128.32003.8.camel@dcbw.local>
References: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com>
	<CAP+RiCDMerG_8EYi=0Ta3BvAwuWinNPYuNevjF85w08HsX4f2Q@mail.gmail.com>
	<CABPxzY+oxDH7QysFNWQg6fMWpsQDSFm5YgOusaz0KibEnH++yQ@mail.gmail.com>
	<CAP+RiCCD7EefqNKKXonrvd9T3G=+4aKZQXe0QbXBKKCzHvgAzQ@mail.gmail.com>
	<CABPxzY+Eimssqcxs0W79_5zGBHmFnrTc5+qeTnmYr_UH_9ti6A@mail.gmail.com>
	<CAP+RiCC4KmgNMGCiCzDeL_0-frGw7acoZf5FDv4OTmauQPU5Hw@mail.gmail.com>
	<1417563128.32003.8.camel@dcbw.local>
Date: Tue, 2 Dec 2014 17:43:55 -0600
Message-ID: <CAP+RiCD2vtZyVOTykKwBcm12g8mpPKc8ZBWUgFL90TU0C5ciUw@mail.gmail.com> (sfid-20141203_004436_932556_2DABE1B2)
Subject: Re: Laptop disassociating by local choice (reason=17)
From: Brent Taylor <motobud@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2014 at 5:32 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2014-12-02 at 16:35 -0600, Brent Taylor wrote:
>> 1417557229.339147: WPA: RSN IE in EAPOL-Key - hexdump(len=22): 30 14
>> 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
>> 1417557229.339179: WPA: RSN IE in Beacon/ProbeResp - hexdump(len=26):
>> 30 18 01 00 00 0f ac 04 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac
>> 02 00 00
>> 1417557229.339192: WPA: RSN IE in 3/4 msg - hexdump(len=22): 30 14 01
>> 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
>
> On the STA side:
>
> The RSN IE in the EAPOL-Key and the 3/4msg are the same, and contain
> only the CCMP pairwise suite.  The RSN IE in the Beacon/ProbeResp debug
> message contains both CCMP and TKIP pairwise suites.
>
> Earlier in the run we have:
>
> 1417557228.979261: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00
> 00 0f ac 04 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 00 00
> 1417557228.979342: WPA: Set own WPA IE default - hexdump(len=22): 30
> 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
>
> which is where the extra TKIP bit comes from.  I'm guessing this is from
> wpa_supplicant_set_suites() because of the closely paired AP RSN IE/own
> WPA IE calls.
>
> Brent, is there any chance you can run the supplicant on the laptop with
> "-dddt" to get *all* the debug messages?  It seems the logs are missing
> quite a few that could tell us where wpa_supplicant_set_suites() is
> getting called.
>
> Dan
>

Dan,
   I actually ran the wpa_supplicant with -ddddt as the parameter not
knowing how many 'd's I could put there before I hit the limit of the
debugging.  The wpa_supplicant on the ubuntu laptop is v0.7.3.  I'll
change the -ddddt to just -dddt and re-run the test again.

-- Brent
