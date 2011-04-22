Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:37126 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab1DVRBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:01:05 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id p3MH12VG020825
	for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 10:01:02 -0700
Received: from wwe15 (wwe15.prod.google.com [10.241.242.15])
	by wpaz33.hot.corp.google.com with ESMTP id p3MH0eq6010455
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 10:01:00 -0700
Received: by wwe15 with SMTP id 15so677160wwe.21
        for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 10:01:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303464039-11574-1-git-send-email-rmanoharan@atheros.com>
References: <1303464039-11574-1-git-send-email-rmanoharan@atheros.com>
Date: Fri, 22 Apr 2011 10:00:59 -0700
Message-ID: <BANLkTimGAg4nYcW=SW_T-1b06nZbyBvNJA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath9k_hw: Fix Tx IQ Calibration hang issue in AR9003 chips
From: Sam Leffler <sleffler@google.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 22, 2011 at 2:20 AM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> On AR9003 chips, doing three IQ calibrations will possibly cause chip
> in stuck state. In noisy environment, chip could receive
> a packet during the middle of three calibrations and it causes
> the conflict of HW access and the eventual failure. It also
> causes IQ calibration outliers which results in poor Tx EVM.
> During the issue kernel log was filled with following message
>
> ath: timeout (100000 us) on reg 0xa640: 0x00000001 & 0x00000001 != 0x00000000
> ath: timeout (100000 us) on reg 0xa2c4: 0x00158dd9 & 0x00000001 != 0x00000000
> ath: Unable to reset channel (2412 MHz), reset status -5
> ath: Unable to set channel
>
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

Please indicate the specific parts where this issue has been seen.  Is
this specific to 9485 or has it been observed on 93xx devices too?

-Sam
