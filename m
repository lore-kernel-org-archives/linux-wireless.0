Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54621 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2HIReY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 13:34:24 -0400
Date: Thu, 9 Aug 2012 10:34:35 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath9k: decrypt_error flag issue
Message-ID: <20120809173435.GQ3745@lenteja.do-not-panic.com> (sfid-20120809_193428_091392_EFF9B535)
References: <CAA2SeNJmaHs5fMHrG65HWbe5Y-ytz2qvuzNGKvhBKgvZ15KoVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAA2SeNJmaHs5fMHrG65HWbe5Y-ytz2qvuzNGKvhBKgvZ15KoVw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 09, 2012 at 05:47:47PM +0200, Lorenzo Bianconi wrote:
> From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> 
> After the hw reports a decryption error, the flag decrypt_error is set to
> true in ath9k_rx_accept.
> Since this flag is initialized to false just outside ath_rx_tasklet while cycle,
> all subsequent frames are marked as corrupted until ath_rx_tasklet ends.
> Fix the issue initializing decrypt_error flag at the begging of the cycle.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

Thanks! In practice what issues did you see ?

  Luis
