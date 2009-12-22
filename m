Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:53687 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbZLVAWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 19:22:24 -0500
Message-ID: <4B30113E.7050906@gmail.com>
Date: Tue, 22 Dec 2009 01:22:22 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Pavel Roskin <proski@gnu.org>, Markus Baier <Markus_Baier@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [BISECTED] [PATCH v2 8/8] rt2x00: Properly request tx headroom
 for alignment operations.
References: <1259012694-14869-4-git-send-email-gwingerde@gmail.com> <1259012694-14869-5-git-send-email-gwingerde@gmail.com> <1259012694-14869-6-git-send-email-gwingerde@gmail.com> <1259012694-14869-7-git-send-email-gwingerde@gmail.com> <1259012694-14869-8-git-send-email-gwingerde@gmail.com> <1259012694-14869-9-git-send-email-gwingerde@gmail.com> <loom.20091220T163829-137@post.gmane.org> <4B2E8729.7050501@gmail.com> <20091221013316.nm9belnhywwwsc0w-cebfxv@webmail.spamcop.net> <4B2FA1CF.1010903@gmail.com> <20091221191725.GF4979@tuxdriver.com>
In-Reply-To: <20091221191725.GF4979@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/09 20:17, John W. Linville wrote:
> On Mon, Dec 21, 2009 at 05:26:55PM +0100, Gertjan van Wingerde wrote:
>> On 12/21/09 07:33, Pavel Roskin wrote:
> 
>>> My debugging shows that the headroom is 0 with the "patch".  Without it,
>>> the headroom is 17 (13 from IEEE80211_TX_STATUS_HEADROOM plus 4 from
>>> RT2X00_ALIGN_SIZE).
>>>
>>> Perhaps non-zero headroom is not handled correctly?
>>>
>>
>> Hmmm, perhaps the problem is that the headroom is not a multiple of 4.
>> Can you check what happens when you set the extra_tx_headroom fixed to e.g. 20?
>>
>> The driver should be able to handle this, but maybe there is something wrong
>> with the alignment.
> 
> For the record, I have dropped this patch.  Please feel free to
> resubmit a working version.
> 

Thanks. I was about to suggest the same.

---
Gertjan.

