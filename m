Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:21180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYDERa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 13:30:27 -0400
Received: by fg-out-1718.google.com with SMTP id l27so607126fgb.17
        for <linux-wireless@vger.kernel.org>; Sat, 05 Apr 2008 10:30:25 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: mac80211 hardware encryption
Date: Sat, 5 Apr 2008 19:31:58 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804051931.58895.IvDoorn@gmail.com> (sfid-20080405_183035_742466_18F9841F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm investigating hardware encryption support for the rt2x00 drivers,
Support for rt61pci and rt73usb should be the easiest to do so currently I'm
only focussing on that, and decide later if rt2500pci and rt2500usb should
also be implemented.

What I am currently facing is the following problem:
For each TX frame the device needs 2 fields in the descriptor namely the
IV and the EIV. From what I can gather from mac80211 those 2 fields are
created by mac80211 with the following code in wpa.c:

ieee80211_tkip_add_iv(pos, key,
		      (u8) (key->u.tkip.iv16 >> 8),
		      (u8) (((key->u.tkip.iv16 >> 8) | 0x20) &
			    0x7f),
		      (u8) key->u.tkip.iv16);

And the following function in tkip.c:

u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
			   u8 iv0, u8 iv1, u8 iv2)
{
	*pos++ = iv0;
	*pos++ = iv1;
	*pos++ = iv2;
	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
	*pos++ = key->u.tkip.iv32 & 0xff;
	*pos++ = (key->u.tkip.iv32 >> 8) & 0xff;
	*pos++ = (key->u.tkip.iv32 >> 16) & 0xff;
	*pos++ = (key->u.tkip.iv32 >> 24) & 0xff;
	return pos;
}

If I understand correctly mac80211 is inserting the values just after
the ieee80211 header in the frame. Now there are 2 ways rt2x00 can
handle this.
	1) copy the frame to the DMA in 2 steps, skipping the inserted IV by mac80211
	    and copy the IV into the descriptor.
	2) Add flag to mac80211 to provide the IV and EIV seperately to the driver
	    so there won't be overhead by mac80211 to insert the IV after the ieee80211
	    header when the driver doesn't want it to.

Thanks,

Ivo
