Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58755 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab3KRXeG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 18:34:06 -0500
Message-ID: <528AA3E3.1080601@openwrt.org> (sfid-20131119_003409_857074_E212A7F8)
Date: Tue, 19 Nov 2013 00:33:55 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/2] ath9k_hw: fix TSF save/restore around chip reset
References: <1384802084-55082-1-git-send-email-nbd@openwrt.org> <21130.39398.379492.921373@gargle.gargle.HOWL>
In-Reply-To: <21130.39398.379492.921373@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-18 23:51, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> A cold reset can be triggered because of DMA stop issues, and this leads
>> to TSF being cleared on all chipsets. To properly deal with this, always
>> save the TSF.
> 
> I think this needs to be done only when we are in operational state.
> There is no need to do this before the station interface is associated
> or the AP interface is up.
Technically yes, but in practice it doesn't really matter, so I'd prefer
to keep the code simple.
For scanning we don't really hit this codepath much anyway: The first
reset skips it because of the transition out of full-sleep, subsequent
resets tend to use fast channel changes most of the time, which also
doesn't do the TSF save/restore.

- Felix

