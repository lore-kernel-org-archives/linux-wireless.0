Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:42739 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab0ASVGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 16:06:38 -0500
Received: by pzk28 with SMTP id 28so276123pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 13:06:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B560D44.4080500@openwrt.org>
References: <4B560D44.4080500@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Jan 2010 13:06:18 -0800
Message-ID: <43e72e891001191306m36984dc4o7f302612a071982c@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix beacon slot/buffer leak
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2010 at 11:51 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> When cleaning up beacon buffers and slots, ath9k currently checks if
> sc->ah->opmode is set to a beacon related mode before cleaning up
> buffers.
> An unfortunate ordering of interface up/down commands can lead to
> sc->ah->opmode being set to monitor mode, while there are AP interfaces
> present on the same wiphy.
> Always cleaning up beacon buffers if present fixes this issue.
>

CC stable?
