Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:37573 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3JCRFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 13:05:43 -0400
Message-ID: <524DA3DC.6060806@einfach.org> (sfid-20131003_190547_221799_31ABC0BE)
Date: Thu, 03 Oct 2013 18:05:32 +0100
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org, sujith@msujith.org
CC: Ingo Randolf <ingo.randolf@qupik.com>
Subject: Re: ath9k AR9287 status?
References: <52492FB0.3010201@einfach.org> <5249443E.3080700@rempel-privat.de> <524954BE.8060603@einfach.org> <52497C2E.1060406@rempel-privat.de> <5249A2F7.5090908@einfach.org>
In-Reply-To: <5249A2F7.5090908@einfach.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2013 05:12 PM, Bruno Randolf wrote:
> On 09/30/2013 02:27 PM, Oleksij Rempel wrote:
>>>> Check:
>>>> - PCIe related power managment - ASPM.
>
> Hmm, disabling ASPM in the BIOS and per kernel command line
> (pcie_aspm=off) did not help.
>
>> I use 3.11 right now. In case of PCIe issue, backport wont help you.
>> Test completely new kernel.
>
> I'll try 3.11 later.

I just tried current wireless-testing (3.12.0-rc3-wl) and it shows the 
same problems.

For reference:

Card:  Unex DNXA-97 (AR9287) http://unex.com.tw/product/dnxa-97
Board: Advantech MIO-2261N (Atom N260)

ASPM is disabled in the BIOS and by pcie_aspm=off. Scanning seems to 
work, but when I start up hostapd (v2.0, simple AP config) nothing 
happens (no AP is found by clients). When I stop hostapd the system 
freezes with "BUG: soft lockup - CPU#3 stuck for 23s! (hostapd:2250)"

bruno

