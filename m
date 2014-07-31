Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:54776 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbaGaUF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:05:26 -0400
Date: Thu, 31 Jul 2014 23:05:22 +0300
From: Jouni Malinen <j@w1.fi>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
Message-ID: <20140731200522.GA8868@w1.fi> (sfid-20140731_220529_563376_1EB03CEC)
References: <5338F1B8.5040305@candelatech.com>
 <3302077.5sUEMiqNRr@debian64>
 <53D82540.5060403@candelatech.com>
 <2968058.2zJHmYrLUV@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2968058.2zJHmYrLUV@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 30, 2014 at 08:59:33PM +0200, Christian Lamparter wrote:
> If you have disabled rx-decrypt logic of ath10k, then why isn't _aesni_dec1
> or aes_decrypt listed in the perf top result? I think they should be. Have you
> removed them from the "perf top results" or are they really absent 
> altogether? 
> 
> Because, from this perf result, it looks like your CPU is not burden by the
> incoming RX at all?! Instead it is busy with the encryption of frames
> it will be transmitting (in case of tcp, this could be tcp acks).

Keep in mind that this is CCMP, i.e., AES in CCM (Counter with CBC-MAC)
mode. The CCM mode uses only the block cipher encryption function, i.e.,
you won't be seeing aes_decrypt or _aesni_dec1 for this even on the RX
path (AES encryption operations are used to generate the key stream
blocks for CCM decryption).

-- 
Jouni Malinen                                            PGP id EFC895FA
