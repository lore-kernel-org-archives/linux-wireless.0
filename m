Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaFJJIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 05:08:24 -0400
Date: Tue, 10 Jun 2014 11:06:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: IvDoorn@gmail.com, helmut.schaa@googlemail.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rt2800usb: scheduling while atomic
Message-ID: <20140610090655.GF1720@redhat.com> (sfid-20140610_110836_235782_115E486A)
References: <5396C150.6030601@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
In-Reply-To: <5396C150.6030601@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2014 at 10:26:56AM +0200, Pontus Fuchs wrote:
> I have a reproducible sleep in atomic when I set up hostapd with
> TKIP on a rt2800 based USB dongle. As soon as a client connects I
> see this. I guess get_tkip_seq may not sleep.

Someone else reported that already, but fails to test provided patch:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2014-January/006538.html

Does attached patch make the problem gone for you?

Thanks
Stanislaw


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2x00_disable_tkip_on_usb.patch"

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 2183e79..87d7938 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -489,6 +489,8 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	crypto.cipher = rt2x00crypto_key_to_cipher(key);
 	if (crypto.cipher == CIPHER_NONE)
 		return -EOPNOTSUPP;
+	if (crypto.cipher == CIPHER_TKIP && rt2x00_is_usb(rt2x00dev))
+		return -EOPNOTSUPP;
 
 	crypto.cmd = cmd;
 

--2fHTh5uZTiUOsy+g--
