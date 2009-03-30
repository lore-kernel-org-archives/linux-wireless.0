Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:59024 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbZC3JiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 05:38:16 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2494237wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 02:38:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2da21fe50903271208m1c369c88lba8399416dace43a@mail.gmail.com>
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
	 <87ljqr58oa.fsf@litku.valot.fi>
	 <2da21fe50903271208m1c369c88lba8399416dace43a@mail.gmail.com>
Date: Mon, 30 Mar 2009 15:08:15 +0530
Message-ID: <8e92b4100903300238p4b0cbd3fh754a3dddbf904fa7@mail.gmail.com> (sfid-20090330_113819_546844_7051C606)
Subject: Re: ath9k and power management
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>, mcgrof@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 28, 2009 at 12:38 AM, Davide Pesavento <davidepesa@gmail.com> wrote:

>>> I'm running a 2.6.29-wl kernel, using ath9k and wpa_supplicant 0.6.9
>>> (with -Dnl80211).
>>> Enabling power management when connected (i.e. 'iwconfig wlan0 power
>>> on'), causes the currently established connection to break and the
>>> machine is no longer able to reconnect to the AP.

Patch has been sent to wireless-testing. Please report if the issue
still exists after
applying the patch.
The commit log of the patch is

ath9k: No need to abort Rx path when autosleep is enabled.
				
For chipsets supporting autosleep feature, there is no need to abort
Rx engine since they are capable of automatically going back to sleep
after receiving a packet.


Thanks a lot for reporting the issue
Vivek.
