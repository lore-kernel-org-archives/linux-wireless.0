Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab1FNKIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 06:08:44 -0400
Date: Tue, 14 Jun 2011 12:09:19 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@venema.h4ckr.net, Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	camilo@mesias.co.uk, Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: Re: APSM, AR9285 and bus hangs
Message-ID: <20110614100918.GA4450@redhat.com> (sfid-20110614_120847_828859_419D1655)
References: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
 <20110613132009.GA7133@redhat.com>
 <BANLkTi=eKBcV5OjP0qqLe6n9GsiwhYLejg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTi=eKBcV5OjP0qqLe6n9GsiwhYLejg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 13, 2011 at 07:10:56PM +0530, Mohammed Shafi wrote:
> > I see this commit in 2.6.39, missed in 2.6.38 and 2.6.35 currently.
> > Is possible this is the fix which do not break other things?
> 
> hi,
> no, this fix only affects AR9280 and it does not affects AR9285.

That could be another stupid question, but could we do not touch
these bits on older AR9285s and disable them only on revision, that
was added by bad commit 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index f344cc2..91d99eb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -384,7 +384,7 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 			}
 		}
 
-		if (AR_SREV_9280(ah) || AR_SREV_9285(ah) || AR_SREV_9287(ah)) {
+		if (AR_SREV_9280(ah) || AR_SREV_9285E_20(ah) || AR_SREV_9287(ah)) {
 			/*
 			 * Disable bit 6 and 7 before entering D3 to
 			 * prevent system hang.
