Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36511 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbaKUNOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 08:14:00 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so6445855wgg.21
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2014 05:13:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <546DFF95.6030804@openwrt.org>
References: <1416490300-6451-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1416490300-6451-3-git-send-email-lorenzo.bianconi83@gmail.com>
	<546DFF95.6030804@openwrt.org>
Date: Fri, 21 Nov 2014 14:07:47 +0100
Message-ID: <CAA2SeNKB4e+CcZj6ujtMZJOrM6mO3xH2fMD_46sy7WBT_xD7mA@mail.gmail.com> (sfid-20141121_141405_391017_617756F4)
Subject: Re: [RFC 2/3] ath9k: add TX power per-rate per-chain tables
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2014-11-20 14:31, Lorenzo Bianconi wrote:
>> Add TX power per-rate per-chain tables for different MIMO modes (e.g STBC) in
>> order to cap the maximum TX power value per-rate in the TX descriptor path.
>> Cap TX power for self generated frames (ACK, RTS/CTS).
>> Currently TPC is supported just by AR9003 based chips
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> I think you should make the ah->txpower array one-dimensional and store
> it for the current chainmask only - this will simplify the code.
> The chainmask cannot be changed while the interface is up, so there's no
> need to make this dynamically switchable.
>
> - Felix

Ack. In this way I can drop patch 1/3 and simplify the code. Thx :)

Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
