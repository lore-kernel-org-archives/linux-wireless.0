Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34197 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab0K3S3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 13:29:43 -0500
Date: Tue, 30 Nov 2010 13:27:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH 2.6.37 v2 1/2] ath9k_hw: fix endian issues with CTLs on
 AR9003
Message-ID: <20101130182715.GD2341@tuxdriver.com>
References: <1291131338-93870-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291131338-93870-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 04:35:37PM +0100, Felix Fietkau wrote:
> Parsing data using bitfields is messy, because it makes endian handling
> much harder. AR9002 and earlier got it right, AR9003 got it wrong.
> This might lead to either using too high or too low tx power values,
> depending on frequency and eeprom settings.
> Fix it by getting rid of the CTL related bitfields entirely and use
> masks instead.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@kernel.org
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  314 ++++++++++++------------
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    9 +-
>  drivers/net/wireless/ath/ath9k/eeprom.c        |    6 +-
>  drivers/net/wireless/ath/ath9k/eeprom.h        |   13 +-
>  4 files changed, 167 insertions(+), 175 deletions(-)

patching file drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
Hunk #1 FAILED at 57.
Hunk #2 FAILED at 296.
Hunk #3 succeeded at 568 (offset -14 lines).
Hunk #4 FAILED at 873.
Hunk #5 FAILED at 1159.
Hunk #6 FAILED at 1451.
Hunk #7 FAILED at 1737.
Hunk #8 FAILED at 2029.
Hunk #9 FAILED at 2315.
Hunk #10 FAILED at 2606.
Hunk #11 FAILED at 2892.
Hunk #12 succeeded at 1827 (offset -2536 lines).
Hunk #13 succeeded at 1847 (offset -2536 lines).
10 out of 13 hunks FAILED -- saving rejects to file drivers/net/wireless/ath/ath9k/ar9003_eeprom.c.rej
patching file drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
Hunk #1 succeeded at 261 with fuzz 1 (offset -9 lines).
patching file drivers/net/wireless/ath/ath9k/eeprom.c
patching file drivers/net/wireless/ath/ath9k/eeprom.h

Please base the patch against this tree:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
