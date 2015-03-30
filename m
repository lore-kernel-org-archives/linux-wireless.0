Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45603 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbbC3Ii1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:38:27 -0400
Message-ID: <1427704704.26117.9.camel@sipsolutions.net> (sfid-20150330_103832_913146_3F2B0A5D)
Subject: Re: [PATCH] mac80211: Fix misplaced return in AES-GMAC key setup
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Mar 2015 10:38:24 +0200
In-Reply-To: <1427118075-30959-1-git-send-email-jouni@qca.qualcomm.com>
References: <1427118075-30959-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-23 at 15:41 +0200, Jouni Malinen wrote:
> Commit 8ade538bf39b ("mac80111: Add BIP-GMAC-128 and BIP-GMAC-256
> ciphers") had the success return in incorrect place before the
> crypto_aead_setauthsize() call which practically ended up skipping that
> call unconditionally.
> 
> The missing call did not actually change any functionality since
> GMAC_MIC_LEN (16) is identical to the maxauthsize in gcm(aes) and as
> such, the default value used for the authsize parameter.

Applied.

johannes

