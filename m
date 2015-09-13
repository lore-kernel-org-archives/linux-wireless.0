Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:52303 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbbIMWQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 18:16:15 -0400
Subject: Re: [PATCH 4.3] ath10k: fix DMA related firmware crashes on multiple
 devices
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
References: <1442176540-34973-1-git-send-email-nbd@openwrt.org>
 <55F5F3D9.8090005@candelatech.com>
Cc: kvalo@codeaurora.org
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <55F5F5A7.9090006@openwrt.org> (sfid-20150914_001637_203416_9D3C10AC)
Date: Mon, 14 Sep 2015 00:16:07 +0200
MIME-Version: 1.0
In-Reply-To: <55F5F3D9.8090005@candelatech.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-09-14 00:08, Ben Greear wrote:
> 
> 
> On 09/13/2015 01:35 PM, Felix Fietkau wrote:
>> Some platforms really don't like DMA bursts of 256 bytes, and this
>> causes the firmware to crash when sending beacons.
>> Also, changing this based on the firmware version does not seem to make
>> much sense, so use 128 bytes for all versions.
> 
> Is there any good reason to allow users to enable this with
> module-param or similar on platforms that do support it?
> 
> Like better performance perhaps?
Maybe, though I expect the performance gain to be small.

- Felix
