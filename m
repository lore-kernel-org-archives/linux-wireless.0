Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:5727 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbYDLNkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 09:40:16 -0400
Received: by yw-out-2324.google.com with SMTP id 5so357561ywb.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 06:40:12 -0700 (PDT)
Message-ID: <4800BBAF.7000609@gmail.com> (sfid-20080412_144023_643919_8FFFD65F)
Date: Sat, 12 Apr 2008 08:39:59 -0500
From: "Jory A. Pratt" <geekypenguin@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] b43: Fixes injection speed (up to 350 pps)
Content-Type: multipart/mixed;
 boundary="------------000808060704020208020204"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000808060704020208020204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------000808060704020208020204
Content-Type: text/plain;
 name="b43-injection-wireless-testing.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="b43-injection-wireless-testing.patch"

# Fixes injection speed (up to 350 pps)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 345c34b..d3a5535 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2841,6 +2841,11 @@ static int b43_op_tx(struct ieee80211_hw *hw,
                goto out;
        if (unlikely(b43_status(dev) < B43_STAT_STARTED))
                goto out;
+
+       if (ctl->type == IEEE80211_IF_TYPE_MNTR) {
+               ctl->flags |= IEEE80211_TXCTL_NO_ACK;
+       }
+
        /* TX is done without a global lock. */
        if (b43_using_pio_transfers(dev))
                err = b43_pio_tx(dev, skb, ctl);
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 19aefbf..85e446b 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -318,7 +318,8 @@ int b43_generate_txhdr(struct b43_wldev *dev,
        /* MAC control */
        if (!(txctl->flags & IEEE80211_TXCTL_NO_ACK))
                mac_ctl |= B43_TXH_MAC_ACK;
-       if (!(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
+       if ( (txctl->type != IEEE80211_IF_TYPE_MNTR) &&
+             !(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
              ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)))
                mac_ctl |= B43_TXH_MAC_HWSEQ;
        if (txctl->flags & IEEE80211_TXCTL_FIRST_FRAGMENT)

--------------000808060704020208020204--
