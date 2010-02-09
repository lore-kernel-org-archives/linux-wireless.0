Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:46515 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0BIObB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 09:31:01 -0500
Received: by pzk17 with SMTP id 17so437178pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 06:30:59 -0800 (PST)
Date: Tue, 9 Feb 2010 22:30:48 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, stable@kernel.org
Subject: Re: [PATCH] ath9k: fix keycache leak in split tkip case
Message-ID: <20100209223048.0f51a774@tom-lei>
In-Reply-To: <1265701908.3783.13.camel@johannes.berg>
References: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com>
	<43e72e891002081338q466d9747p10a61b5e1aca4c6d@mail.gmail.com>
	<20100209093612.08d9ae17@tom-lei>
	<1265701908.3783.13.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>From 67b0faf7e7a57c3e6a971ff43d1f03f8e939429b Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Sat, 6 Feb 2010 22:30:53 +0800
Subject: [PATCH] ath9k: fix keycache leak in split tkip case

If split tkip key is used, ath_delete_key should delete
rx key and rx mic key. This patch fixes the leak of hw
keycache in the case.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: stable@kernel.org
---

The patch is against the latest wireless test tree.
Thanks for the comments of Luis and johannes.

---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6796d5c..928402b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -809,6 +809,7 @@ static void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf
 
 	clear_bit(key->hw_key_idx + 64, common->keymap);
 	if (common->splitmic) {
+		ath9k_hw_keyreset(ah, key->hw_key_idx + 32);
 		clear_bit(key->hw_key_idx + 32, common->keymap);
 		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
 	}
-- 
1.6.2.5



On Tue, 09 Feb 2010 08:51:48 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Tue, 2010-02-09 at 09:36 +0800, Ming Lei wrote:
> > From 67b0faf7e7a57c3e6a971ff43d1f03f8e939429b Mon Sep 17 00:00:00
> > 2001 From: Ming Lei <tom.leiming@gmail.com>
> > Date: Sat, 6 Feb 2010 22:30:53 +0800
> > Subject: [PATCH] ath9k: fix keycache leak in split tkip case
> > 
> > If split tkip key is used, ath_delete_key should delete
> > rx key and rx mic key. This patch fixes the leak of hw
> > keycache in the case.
> > 
> > ---
> > The patch is against the latest wireless test tree.
> > 
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> > Cc: stable@kernel.org
> 
> This is ordered wrong, it needs to be
> 
> ----------
> From: foo
> 
> If split ...
> 
> Signed-off-by: ...
> Cc: stable...
> ---
> The patch is against...
> (everything after --- is removed from the commit log when committing)
> ----------
> 
> johannes
> 

