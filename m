Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:46397 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYLPPWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 10:22:42 -0500
Received: by ewy10 with SMTP id 10so3720763ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 07:22:40 -0800 (PST)
Message-ID: <b6c5339f0812160722nab8516cj1ed4e6d397060d9d@mail.gmail.com> (sfid-20081216_162248_341305_691B3AA2)
Date: Tue, 16 Dec 2008 10:22:39 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: "Benoit PAPILLAULT" <benoit.papillault@free.fr>
Subject: Re: [PATCH] ath5k: Updated padding stuff for the RX and TX side. TX side has been 100%
Cc: "Jouni Malinen" <j@w1.fi>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
In-Reply-To: <4946C6D9.1060101@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr>
	 <20081215170613.GA22627@jm.kir.nu> <4946C6D9.1060101@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 4:06 PM, Benoit PAPILLAULT
<benoit.papillault@free.fr> wrote:

> frames. To me, the bug we have seen when receiving a ACK frame in
> monitor mode was not because "ACK is a small control frame", it was
> because the header length we computed was smaller than what the hardware
> considered.

It's because data frames have a payload and ACKs do not.

> To reply to Bob as well, we need to compute the number of padded bytes +
> the position at which the padding occurs, so proper "header" length is
> required.

Well, anyway John already picked up your earlier (better, IMHO) patch.
Now we just need to fix the tx descriptors :)

-- 
Bob Copeland %% www.bobcopeland.com
