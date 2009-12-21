Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:61317 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbZLUQ06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 11:26:58 -0500
Message-ID: <4B2FA1CF.1010903@gmail.com>
Date: Mon, 21 Dec 2009 17:26:55 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Markus Baier <Markus_Baier@web.de>, linux-wireless@vger.kernel.org
Subject: Re: [BISECTED] [PATCH v2 8/8] rt2x00: Properly request tx headroom
 for alignment operations.
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>	<1259012694-14869-2-git-send-email-gwingerde@gmail.com>	<1259012694-14869-3-git-send-email-gwingerde@gmail.com>	<1259012694-14869-4-git-send-email-gwingerde@gmail.com>	<1259012694-14869-5-git-send-email-gwingerde@gmail.com>	<1259012694-14869-6-git-send-email-gwingerde@gmail.com>	<1259012694-14869-7-git-send-email-gwingerde@gmail.com>	<1259012694-14869-8-git-send-email-gwingerde@gmail.com>	<1259012694-14869-9-git-send-email-gwingerde@gmail.com>	<loom.20091220T163829-137@post.gmane.org> <4B2E8729.7050501@gmail.com> <20091221013316.nm9belnhywwwsc0w-cebfxv@webmail.spamcop.net>
In-Reply-To: <20091221013316.nm9belnhywwwsc0w-cebfxv@webmail.spamcop.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/09 07:33, Pavel Roskin wrote:
> Quoting Gertjan van Wingerde <gwingerde@gmail.com>:
> 
>> On 12/20/09 16:42, Markus Baier wrote:
>>> After my latest git pull to the kernel version 2.6.33-rc1-wl
>>> no client was able to connect to my hostapd (v0.6.9) AP.
>>> I found a lot of the following entries in the syslog:
>>>
>>> wlan0: STA xx:xx:xx:xx:xx:xx
>>> IEEE 802.11: did not acknowledge authentication response
> 
> I'm also having problems with rt2x00 support the current
> wireless-testing, but in the station mode.  The device is using rt61pci
> driver.  Association to an AP with WEP fails.
> 
> [  147.930019] wlan2: direct probe to AP 00:11:6b:28:0b:92 (try 1)
> [  148.130010] wlan2: direct probe to AP 00:11:6b:28:0b:92 (try 2)
> [  148.330009] wlan2: direct probe to AP 00:11:6b:28:0b:92 (try 3)
> [  148.530008] wlan2: direct probe to AP 00:11:6b:28:0b:92 timed out
> [  152.942516] wlan2: direct probe to AP 00:11:6b:28:0b:92 (try 1)
> [  153.142512] wlan2: direct probe to AP 00:11:6b:28:0b:92 (try 2)
> [  153.340011] wlan2: direct probe to AP 00:11:6b:28:0b:92 (try 3)
> [  153.540008] wlan2: direct probe to AP 00:11:6b:28:0b:92 timed out
> 
> It worked fine with wireless-testing when it was 2.6.32 based.
> 
>>> After I removed the lines below in rt2x00dev.c:
> 
> That "patch" is helping me too!  The association is working now.
> 
>> That is very strange as this patch was meant to send TX statuses of
>> frames
>> towards monitor interfaces (which is what hostapd is using).
> 
> I'm not using monitor mode.  I only have one vif in the station mode.
> 
> My debugging shows that the headroom is 0 with the "patch".  Without it,
> the headroom is 17 (13 from IEEE80211_TX_STATUS_HEADROOM plus 4 from
> RT2X00_ALIGN_SIZE).
> 
> Perhaps non-zero headroom is not handled correctly?
> 

Hmmm, perhaps the problem is that the headroom is not a multiple of 4.
Can you check what happens when you set the extra_tx_headroom fixed to e.g. 20?

The driver should be able to handle this, but maybe there is something wrong
with the alignment.

---
Gertjan.
