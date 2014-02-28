Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59271 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaB1UyN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 15:54:13 -0500
Message-ID: <5310F773.3000405@openwrt.org> (sfid-20140228_215424_694886_4DB821AB)
Date: Fri, 28 Feb 2014 21:54:11 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k_hw: tweak noise immunity thresholds for older
 chipsets
References: <1393610545-68025-1-git-send-email-nbd@openwrt.org>	<1393610545-68025-2-git-send-email-nbd@openwrt.org> <21264.56017.114049.511221@gargle.gargle.HOWL>
In-Reply-To: <21264.56017.114049.511221@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-28 19:52, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Older chipsets are more sensitive to high PHY error counts, and the
>> current noise immunity thresholds were based on tests run at QCA with
>> newer chipsets.
>> 
>> This patch brings back the values from the old ANI implementation for
>> old chipsets, and it also disables weak signal detection on an earlier
>> noise immunity level, to improve overall radio stability on affected
>> devices.
> 
> Which devices ?
Reproduced on AR913x, suspected on AR928x, probably other affected
devices as well.

> Since the old values were used in the old ANI implementation, I am not sure
> how just retrofitting them into the new ANI algorithm can improve things...
Semantically, the values are compatible. The algorithm is similar enough
that this works just fine. The patch has gone through some testing that
showed a visible stability improvement.

- Felix
