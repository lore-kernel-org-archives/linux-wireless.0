Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:27095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbXHDMUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2007 08:20:55 -0400
Received: by ug-out-1314.google.com with SMTP id j3so535367ugf
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2007 05:20:54 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow drivers to indicate failed FCS/PLCP checksum
Date: Sat, 4 Aug 2007 14:25:28 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
References: <1186177475.13315.10.camel@johannes.berg>
In-Reply-To: <1186177475.13315.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708041425.29112.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> @@ -241,6 +241,8 @@ struct ieee80211_rx_status {
>  #define RX_FLAG_MMIC_ERROR	(1<<0)
>  #define RX_FLAG_DECRYPTED	(1<<1)
>  #define RX_FLAG_RADIOTAP	(1<<2)
> +#define RX_FLAG_FAILED_FCS_CRC	(1<<3)
> +#define RX_FLAG_FAILED_PLCP_CRC	(1<<4)
>  	int flag;
>  };

This looks good, but there is a slight problem for rt2x00.
The package descriptor knows 3 kind of errors for a received frame:

	CRC error
	Physical error
	Cipher error

For the CRC error I don't know if that is the FCS or PLCP error..
And should the other 2 be also passed to mac80211 or should those
be stopped?
For the cipher error it could perhaps be possible to send it to mac80211
without the RX_FLAG_DECRYPTED bit set. (At the moment rt2x00 doesn't
see this error yet, because hardware encryption is not yet implemented).

Ivo
