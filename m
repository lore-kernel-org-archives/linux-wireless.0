Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58034 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1DYNFL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 09:05:11 -0400
Message-ID: <4DB57180.40208@hauke-m.de> (sfid-20110425_150532_150043_846CE7A2)
Date: Mon, 25 Apr 2011 15:05:04 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>
CC: ath9k-devel@lists.ath9k.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k: Regression in 2.6.38 (30% package losses, ~20KBit/s throughput)
 with AR9285
References: <4DB56E5B.4090101@hauke-m.de>
In-Reply-To: <4DB56E5B.4090101@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2011 02:51 PM, Hauke Mehrtens wrote:
> Hi,
> 
> with kernel 2.6.38 the wifi connection with my Atheros AR9285 is
> unusable when the distance from the AP is more that 3 meters. (30%
> package losses, ~20K/s throughput compared to ~3M/s) Tested with two
> cards on different devices. With kernel 2.6.35 or kernel 2.6.38 +
> compat-wireless 15 meters distance is no problem. The problem only
> occurs in 2.6.38-rc1 to 2.6.38.4 but not in any more recent versions. I
> did a git bisect and found the commit fixing the problem.
> 
> commit 115dad7a7f42e68840392767323ceb9306dbdb36
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Fri Jan 14 00:06:27 2011 +0100
> 
>     ath9k_hw: partially revert "fix dma descriptor rx error bit parsing"
> 
> http://www.spinics.net/lists/linux-wireless/msg62742.html
> 
> Please send this commit to the stable series for 2.6.38.
> 
> The problem is also described at the Ubuntu launchpad:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/735431
> 
> Hauke

I linked to a wrong Ubuntu Launchpad bug report. This is a correct one,
but there many many:
https://bugs.launchpad.net/archlinux/+source/linux/+bug/735171

Here is also a description in the kernel bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=31452

Hauke
