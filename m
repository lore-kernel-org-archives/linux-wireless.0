Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62931 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0GCAxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 20:53:23 -0400
Received: by iwn7 with SMTP id 7so3795998iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jul 2010 17:53:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278022192-83277-6-git-send-email-nbd@openwrt.org>
References: <1278022192-83277-1-git-send-email-nbd@openwrt.org>
	<1278022192-83277-2-git-send-email-nbd@openwrt.org>
	<1278022192-83277-3-git-send-email-nbd@openwrt.org>
	<1278022192-83277-4-git-send-email-nbd@openwrt.org>
	<1278022192-83277-5-git-send-email-nbd@openwrt.org>
	<1278022192-83277-6-git-send-email-nbd@openwrt.org>
Date: Sat, 3 Jul 2010 02:53:12 +0200
Message-ID: <AANLkTim0QXRVcOcl8gZFEh7JC8G8npuhw7oxf7X6w1Fg@mail.gmail.com>
Subject: Re: [PATCH 6/6] ath9k: fix false positives in the baseband hang check
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 2, 2010 at 12:09 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> ath9k_hw_check_alive() occasionally returns false, as the hardware
> is still processing data in a specific state. Fix this issue by
> repeating the test a few times with longer delay inbetween attempts.
> This gets rid of excessive hardware resets that appear frequently on
> some AR9132 based devices, but could also happen on AR9280.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Reported-by: Björn Smedman <bjorn.smedman@venatech.se>
> Cc: stable@kernel.org

Tested-by: Björn Smedman <bjorn.smedman@venatech.se>

No false positives.

By the way, ath9k has never felt so solid on AR9100 as after this
patch series. Huge thanx, especially for the initvals update! :)

/Björn
