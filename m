Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:14683 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbcBYXgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 18:36:41 -0500
In-Reply-To: <1456442667-19751-1-git-send-email-colin.king@canonical.com>
References: <1456442667-19751-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH][V3] mt7601u: do not free dma_buf when ivp allocation fails
From: Kuba Kicinski <kubakici@wp.pl>
Date: Thu, 25 Feb 2016 18:36:31 -0500
To: Colin King <colin.king@canonical.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Message-ID: <286FE43B-A725-4BE0-B490-E91A107F8D0B@wp.pl> (sfid-20160226_003644_288332_0D2FED32)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 February 2016 18:24:27 GMT-05:00, Colin King <colin.king@canonical.com> wrote:
>From: Colin Ian King <colin.king@canonical.com>
>
>If the allocation of ivp fails the error handling attempts to
>free an uninitialized dma_buf; this data structure just contains
>garbage on the stack, so the freeing will cause issues when the
>urb, buf and dma fields are free'd. Fix this by not free'ing the
>dma_buf if the ivp allocation fails.
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>

LGTM, thanks.

