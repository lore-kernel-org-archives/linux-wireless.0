Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:18022 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517AbXHMWsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 18:48:18 -0400
Received: by ug-out-1314.google.com with SMTP id j3so30835ugf
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2007 15:48:17 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when software WEP encryption is used
Date: Tue, 14 Aug 2007 00:54:22 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net>
In-Reply-To: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708140054.22845.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 August 2007, Larry Finger wrote:
> For drivers that do no hardware encryption/decryption, WEP encryption
> works as long as IEEE80211_HW_INCLUDE_IV is not set in the flags variable.
> With WPA encryption and IEEE80211_HW_INCLUDE_IV not set, the logs are full
> of TKIP decrypt failure messages. Despite the messages, RX is working.
> This patch turns off the message for this case.

Not a question regarding the patch itself, but more about the comment
regarding IEEE80211_HW_WEP_INCLUDE_IV and WEP encryption. ;)

You mean the drivers that require mac80211 to do the encryption/decryption
must make sure the IEEE80211_HW_WEP_INCLUDE_IV is _not_ set?
I figured that when device requires software encryption they should set the flag
since they do not touch the frame and pass it through completely to the stack
this would also mean that the IV is passed on. Which should suggest that the
flag should be set to tell mac80211 it can use the IV.

I might be too ignorant about the specifics of the encryption steps, so I am a bit
confused about this. :S

Thanks,

Ivo
