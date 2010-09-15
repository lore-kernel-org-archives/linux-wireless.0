Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60616 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab0IOPXj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 11:23:39 -0400
Message-ID: <4C90E4F6.1090403@openwrt.org>
Date: Wed, 15 Sep 2010 17:23:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] ath9k: Paprd calibration should be per channel
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com> <1284560528-8934-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1284560528-8934-2-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-15 4:22 PM, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
NACK. The point of the caldata struct is to keep calibration data for
the operating channel and reset it whenever that changes (but not just
for off-channel activity).
Since the PAPRD data uses quite a bit of memory and doesn't take that
long to generate, we don't really need to make it per-channel.

- Felix
