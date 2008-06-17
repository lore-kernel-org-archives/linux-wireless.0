Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:54809 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbYFQSYT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:24:19 -0400
Date: Tue, 17 Jun 2008 21:23:22 +0300
From: Jouni Malinen <j@w1.fi>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
Message-ID: <20080617182322.GF4974@jm.kir.nu> (sfid-20080617_202423_220197_BE0BBAC0)
References: <20080617154008.883383150@localhost> <1213721067.3803.73.camel@johannes.berg> <20080617174749.GB4974@jm.kir.nu> <200806171952.53183.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200806171952.53183.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 17, 2008 at 07:52:52PM +0200, Michael Buesch wrote:

> Well, as long as the checksum will fail in that case we're OK for b43,
> as the driver will notify the need for software crypto for those packets.

Yes, MIC won't match (or well, in theory it could, but in practice..)
and if the original frame is available after failed hw-decryption
attempt, this is indeed all that's needed here. Some hardware designs
are not able to deliver the unmodified frame due to the way AES hwaccel
is implemented in them and that gets bit tricky to handle in software
for IEEE 802.11w.

-- 
Jouni Malinen                                            PGP id EFC895FA
