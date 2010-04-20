Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:58750
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751566Ab0DTIfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 04:35:48 -0400
Date: Tue, 20 Apr 2010 10:35:46 +0200
From: Johan Hovold <johan.hovold@lundinova.se>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: Johan Hovold <johan.hovold@lundinova.se>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC][PATCH 2/6] ath9k: do not mark frames with
 RXKEY_IX_INVALID as decrypted
Message-ID: <20100420083546.GC5288@lundinova.se>
References: <20100416104850.GA13329@lundinova.se>
 <1271415135-18317-2-git-send-email-johan.hovold@lundinova.se>
 <1271417561.8066.4.camel@jm-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271417561.8066.4.camel@jm-desktop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 02:32:41PM +0300, Jouni Malinen wrote:
> On Fri, 2010-04-16 at 03:52 -0700, Johan Hovold wrote:
> > Frames tagged by hardware with ATH9K_RXKEYIX_INVALID should not
> > incorrectly be marked decrypted (even if key index in frame is valid).
> 
> Have you tested this with static WEP configuration? Or broadcast RX with
> WPA? There must be a reason for that odd looking code being there in the
> first place and I can now only think of it being needed when the default
> keys are used.

You are correct. That piece of code is indeed required for WEP
(KeyIdxValid is not set and sometimes also KeyMiss is set even though
frame has been decrypted).

I just posted a patch which seems to catch the corrupt frames without
messing anything else up. Perhaps you could take a quick look at it?

Thanks,
Johan

