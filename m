Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33268 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbcBYL2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 06:28:43 -0500
Received: by mail-wm0-f50.google.com with SMTP id g62so27627344wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2016 03:28:43 -0800 (PST)
MIME-Version: 1.0
From: Simon Malthieu <simon.malthieu@gmail.com>
Date: Thu, 25 Feb 2016 12:28:22 +0100
Message-ID: <CAN8KuOP6qd1RQC09wgruF=CosyMUhzccPoT-37Ep2na8CB3YJg@mail.gmail.com> (sfid-20160225_122854_580711_DD1A692B)
Subject: ath9k keymap ccmp
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have two devices connected in AP client mode, driver used is ath9k.
WPA CCMP crypto is used.

When I switch to IBSS mode, the broadcast frames are not well decrypted,
they are not decrypted at all, but I can see them with tcpdump (no
monitor mode).

I found that in fact, the keymap used by ath9k hw encryption is not
entirely cleared
when the interface go down in client mode.

In consequences the broadcast frames sent by the ibss node using the keyid
of the not cleared key (from precedent configuration) is set as decrypted,
though is should be done in software in IBSS mode (hw encryption disabled) :

if (test_bit(keyix, common->keymap))
rxs->flag |= RX_FLAG_DECRYPTED;

from ath9k/common.c

The keymap is not cleared at the end of Client mode because the hw_key_idx
is less than IEEE80211_WEP_NKID (=4) :

if (key->hw_key_idx < IEEE80211_WEP_NKID)
return;

in ath_key_delete (ath/key.c)

The hw_key_idx is keyidx from the ath_key_config code, so it is = 1 or = 2
... So less than IEEE80211_WEP_NKID.

Is it normal behaviour ? I have not understand the whole key slot algorithm and
why STA can't get a key cache slot like AP and IBSS mode.

And if all this is normal, why the keymap is not cleared ?

Thanks,
Simon
