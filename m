Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26967 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab1J0ILN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 04:11:13 -0400
Message-ID: <4EA9121A.1090109@qca.qualcomm.com> (sfid-20111027_101118_541744_B152D971)
Date: Thu, 27 Oct 2011 11:11:06 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: Implement support for listen interval from
 userspace
References: <1319588789-17632-1-git-send-email-rpanjwan@qca.qualcomm.com> <1319588789-17632-2-git-send-email-rpanjwan@qca.qualcomm.com>
In-Reply-To: <1319588789-17632-2-git-send-email-rpanjwan@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2011 03:26 AM, Rishi Panjwani wrote:
> In order to allow user space based control of listen interval, we use
> available debugfs infrastructure. Listen interval implies how frequently
> we want the WLAN chip to wake up and synchronize the beacons in case it
> is in sleep mode. The command requires two parameters in the following order:
> 
> 1) listen_interval_time
> 2) listen_interval_beacons
> 
> The user has to write the listen interval_time (in msecs) and
> listen_interval_beacons (in no. of beacons) to the listen_interval file in
> ath6kl debug directory.
> 
> Example:
> 
> echo "30 1" > listen_interval

Applied, thanks. I had to add vif index to the wmi call due to multi vif
changes. Please check my changes.

Kalle
