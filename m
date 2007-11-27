Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:32919 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754997AbXK0Cpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 21:45:51 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/3] ath5k: fix noise floor calibration
Date: Tue, 27 Nov 2007 11:45:52 +0900
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com> <1195815123-22375-2-git-send-email-bruno@thinktube.com> <43e72e890711261628j3aa9325ch8ea4284de18beb30@mail.gmail.com>
In-Reply-To: <43e72e890711261628j3aa9325ch8ea4284de18beb30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711271145.52829.bruno@thinktube.com> (sfid-20071127_024601_953294_AFEE4A09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 November 2007 09:28:02 Luis R. Rodriguez wrote:
> On Nov 23, 2007 5:52 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> > diff --git a/drivers/net/wireless/ath5k/phy.c
> > b/drivers/net/wireless/ath5k/phy.c index 3c2a67c..9b91121 100644
> > --- a/drivers/net/wireless/ath5k/phy.c
> > +++ b/drivers/net/wireless/ath5k/phy.c
> > @@ -1519,6 +1519,51 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct
> > ieee80211_channel *channel) /*****************\
> >    PHY calibration
> >  \*****************/
> > +int
> > +ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
> > +{
>
> Good idea :) Mind adding kdoc for this? I hope we can add kdoc for
> more hw stuff to eventually export this automatically as developer
> documentation.

sure:

>From c6a21193965b1c6467851c0fa2b9a4a7a63ce8bb Mon Sep 17 00:00:00 2001
From: Bruno Randolf <bruno@thinktube.com>
Date: Tue, 27 Nov 2007 11:44:02 +0900
Subject: [PATCH 1/1] ath5k: add kerneldoc for ath5k_hw_noise_floor_calibration


Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/phy.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/phy.c 
b/drivers/net/wireless/ath5k/phy.c
index e12a7e8..4daccc8 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1519,6 +1519,27 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct 
ieee80211_channel *channel)
 /*****************\
   PHY calibration
 \*****************/
+
+/**
+ * ath5k_hw_noise_floor_calibration - perform PHY noise floor calibration
+ *
+ * @ah: struct ath5k_hw pointer we are operating on
+ * @freq: the channel frequency, just used for error logging
+ *
+ * This function performs a noise floor calibration of the PHY and waits for
+ * it to complete. Then the noise floor value is compared to some maximum
+ * noise floor we consider valid.
+ *
+ * Note that this is different from what the madwifi HAL does: it reads the
+ * noise floor and afterwards initiates the calibration. Since the noise 
floor
+ * calibration can take some time to finish, depending on the current channel
+ * use, that avoids the occasional timeout warnings we are seeing now.
+ *
+ * See the following link for an Atheros patent on noise floor calibration:
+ * http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL \
+ * &p=1&u=%2Fnetahtml%2FPTO%2Fsrchnum.htm&r=1&f=G&l=50&s1=7245893.PN.&OS=PN/7
+ *
+ */
 int
 ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
 {
-- 
1.5.3.4

