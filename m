Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33010 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0IOQWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 12:22:05 -0400
Received: by gyd8 with SMTP id 8so103565gyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 09:22:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284560528-8934-1-git-send-email-vasanth@atheros.com>
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 15 Sep 2010 09:21:43 -0700
Message-ID: <AANLkTim5xPKBsitVut-74BNM9riL0C95Nqnyj7M5Bg87@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: Fix regression in starting ANI after association
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 7:22 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Sat Jul 31 00:11:59 2010 +0200
>
>    ath9k: prevent calibration during off-channel activity
>
> The above patch checks for off-channel before starting ANI,
> but when the operating channel is set right after association,
> IEEE80211_CONF_OFFCHANNEL would be set as still local->tmp_channel
> is non-NULL. This would result in not starting calibration after
> the association.

Why not fix this in mac80211 then?

 Luis
