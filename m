Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36283 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab0LVMIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 07:08:25 -0500
Received: by qwa26 with SMTP id 26so5038860qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 04:08:24 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101222102032.13401.10967.stgit@localhost6.localdomain6>
References: <20101222102032.13401.10967.stgit@localhost6.localdomain6>
Date: Wed, 22 Dec 2010 13:08:24 +0100
Message-ID: <AANLkTikPBsA5T-Jxzpd09_gihqaP7xTZgLfHEvDMVmfp@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Move mac80211 functions into new file
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 11:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> Move mac80211 functions into new file mac80211-ops.c to have a better
> separation and to make base.c smaller.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/Makefile       |    1
>  drivers/net/wireless/ath/ath5k/base.c         |  763 ++-----------------------
>  drivers/net/wireless/ath/ath5k/mac80211-ops.c |  774 +++++++++++++++++++++++++
>  3 files changed, 825 insertions(+), 713 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath5k/mac80211-ops.c
>

Tested against linux-next (next-20101221) and the following additional
ath5k and mac80211 patches:

$ ls ath5k-fix/*.patch
ath5k-fix/1-5-ath5k-Simplify-powertable-recalculation.patch
ath5k-fix/2-5-ath5k-Separate-powertable-setup-and-writing.patch
ath5k-fix/3-5-ath5k-Track-current-TX-power-separately-from-max-TX-power.patch
ath5k-fix/4-5-ath5k-Remove-ATH5K_INI_RFGAIN-defines-use-band-instead.patch
ath5k-fix/5-5-ath5k-Use-helper-function-to-get-eeprom-mode-from-channel.patch
ath5k-fix/ath5k-Move-mac80211-functions-into-new-file.patc

$ ls mac80211-fix/*.patch
mac80211-fix/mac80211-minstrel-honor-max-retry-counts-from-cfg80211.patch

Feel free to add:

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -
