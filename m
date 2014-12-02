Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065AbaLBXck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 18:32:40 -0500
Message-ID: <1417563128.32003.8.camel@dcbw.local> (sfid-20141203_003243_577567_31F6D47B)
Subject: Re: Laptop disassociating by local choice (reason=17)
From: Dan Williams <dcbw@redhat.com>
To: Brent Taylor <motobud@gmail.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 02 Dec 2014 17:32:08 -0600
In-Reply-To: <CAP+RiCC4KmgNMGCiCzDeL_0-frGw7acoZf5FDv4OTmauQPU5Hw@mail.gmail.com>
References: <CAP+RiCBDAi7e6vj5vvrcEpt17JicdmPwq16zhG9Fun11HfnBkw@mail.gmail.com>
	 <CAP+RiCDMerG_8EYi=0Ta3BvAwuWinNPYuNevjF85w08HsX4f2Q@mail.gmail.com>
	 <CABPxzY+oxDH7QysFNWQg6fMWpsQDSFm5YgOusaz0KibEnH++yQ@mail.gmail.com>
	 <CAP+RiCCD7EefqNKKXonrvd9T3G=+4aKZQXe0QbXBKKCzHvgAzQ@mail.gmail.com>
	 <CABPxzY+Eimssqcxs0W79_5zGBHmFnrTc5+qeTnmYr_UH_9ti6A@mail.gmail.com>
	 <CAP+RiCC4KmgNMGCiCzDeL_0-frGw7acoZf5FDv4OTmauQPU5Hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-02 at 16:35 -0600, Brent Taylor wrote:
> 1417557229.339147: WPA: RSN IE in EAPOL-Key - hexdump(len=22): 30 14
> 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
> 1417557229.339179: WPA: RSN IE in Beacon/ProbeResp - hexdump(len=26):
> 30 18 01 00 00 0f ac 04 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac
> 02 00 00
> 1417557229.339192: WPA: RSN IE in 3/4 msg - hexdump(len=22): 30 14 01
> 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00

On the STA side:

The RSN IE in the EAPOL-Key and the 3/4msg are the same, and contain
only the CCMP pairwise suite.  The RSN IE in the Beacon/ProbeResp debug
message contains both CCMP and TKIP pairwise suites.

Earlier in the run we have:

1417557228.979261: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00
00 0f ac 04 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 00 00
1417557228.979342: WPA: Set own WPA IE default - hexdump(len=22): 30
14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00

which is where the extra TKIP bit comes from.  I'm guessing this is from
wpa_supplicant_set_suites() because of the closely paired AP RSN IE/own
WPA IE calls.

Brent, is there any chance you can run the supplicant on the laptop with
"-dddt" to get *all* the debug messages?  It seems the logs are missing
quite a few that could tell us where wpa_supplicant_set_suites() is
getting called.

Dan

