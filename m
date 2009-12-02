Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:50862 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbZLBRcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 12:32:04 -0500
Received: by iwn1 with SMTP id 1so274572iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 09:32:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259049205-32596-1-git-send-email-lrodriguez@atheros.com>
References: <1259049205-32596-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 2 Dec 2009 09:31:51 -0800
Message-ID: <43e72e890912020931g6d1da103s10d8197bbb9a307a@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix processing of TX PS null data frames
To: linville@tuxdriver.com, Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2009 at 11:53 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> When mac80211 was telling us to go into Powersave we listened
> and immediately turned RX off. This meant hardware would not
> see the ACKs from the AP we're associated with and hardware
> we'd end up retransmiting the null data frame in a loop
> helplessly.
>
> Fix this by keeping track of the transmitted nullfunc frames
> and only when we are sure the AP has sent back an ACK do we
> go ahead and shut RX off.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Signed-off-by: Vivek Natarajan <Vivek.Natarajan@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

BTW this was a bit large and I cannot say for sure if this is a
regression fix at this point -- but I still do consider this a stable
fix and will be supporting it for customers as a cherry picked patch.

  Luis
