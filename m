Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab0B0HDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 02:03:12 -0500
Subject: Re: Using asynchonous block cipher for CCMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1267249474.6278.23.camel@mj>
References: <1267249474.6278.23.camel@mj>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 08:03:08 +0100
Message-ID: <1267254188.3851.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-02-27 at 00:44 -0500, Pavel Roskin wrote:
> Hello!
> 
> I'm looking for ways to accelerate CCMP on Intel IXP425.
> 
> drivers/crypto/ixp4xx_crypto.c implements only asynchronous block
> ciphers, and the reason appears to be that the crypto processor uses DMA
> and interrupts to communicate with the CPU, which would make synchronous
> encryption ineffective.
> 
> It turns out that mac80211 uses plain AES for CCMP.  However, it uses an
> asynchronous block cipher "ecb(arc4)" for WEP and TKIP.
> 
> I'd like to make CCMP use an asynchronous block cipher.  Has anyone
> attempted that?  Are there any issues I should be aware of?

Well the issue is going to be having to interrupt the flow there and
then pick it back up after crypto. Or you can stick it after the entire
flow and treat it like hw crypto in the card.

johannes

