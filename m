Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51498 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804AbaE2OKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 10:10:40 -0400
Received: by mail-wi0-f179.google.com with SMTP id bs8so725691wib.6
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 07:10:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53873A58.1070209@candelatech.com>
References: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
	<53873A58.1070209@candelatech.com>
Date: Thu, 29 May 2014 16:10:39 +0200
Message-ID: <CACKGw+FT0GTRF+tn_Odi0KQvEFL93Oyjj4x=SKgNP1aayB4-QA@mail.gmail.com> (sfid-20140529_161045_717744_C111DDA1)
Subject: Re: [PATCH] ath10k: fix vdev map size for 10.x firmware
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 May 2014 15:47, Ben Greear <greearb@candelatech.com> wrote:
>
>
> On 05/29/2014 06:36 AM, Bartosz Markowski wrote:
>>
>> Firmware 10.x supports up to 8 virtual AP interfaces
>> (comparing to 7 for main firmware). Previous vdev map
>> initialization was missing enough space for 8 + 1 vdevs
>> (we may spent one for mac monitor), due to wrong define used.
>>
>> Use correct one - TARGET_10X_NUM_VDEVS - for 10.x firmware.
>
>
> You are bumping total vdevs up to 16 with that patch...have you
> actually tested that many?  The stock firmware has quite a bit of
> deficiencies in the concurrency handling, at least for stations.

No, I have never tested it with so many. I'm running tests with 8 at
most. And by this patch I just aimed to support 8 VAPS we advertise in
iface_combinations to mac80211 (.max_interfaces = 8). I was managed to
get only 7 before, since 1 vdev was being allocated as monitor.

[  219.960000] ath10k: mac monitor refs: promisc 1 monitor 0 cac 0
[  219.960000] ath10k: mac monitor vdev 1 created

I agree the 10X_NUM_VDEVS is a bit unfortunate with its 16 value, but
that's what was there from FW APIs for a long time and I do not know
exactly if it's still valid (from firmware point of view).

> For what it's worth, my firmware will only work on stock kernels
> because I ignore the request for 16 vdevs in the firmware and knock
> it down to 8 to match the kernel driver (before your change below).

Do you encode your firmware with the FW IE (wmi-10x) also? If som then
it's a bit weird to have different firmware tracks that introduce
themselves as 10.x.

-Bartosz
