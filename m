Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ssl.serverraum.org ([88.198.40.39]:49499 "EHLO
	ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbbBTSMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 13:12:15 -0500
Message-ID: <54E778F9.1000500@m-labs.hk> (sfid-20150220_191224_510510_13707D9F)
Date: Fri, 20 Feb 2015 11:12:09 -0700
From: Sebastien Bourdeauducq <sb@m-labs.hk>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Simon Raffeiner (SCC)" <simon.raffeiner@kit.edu>
Subject: Re: brcmfmac43241b4-sdio / Thinkpad Tablet 10 issues
References: <54E2E1CD.5020203@m-labs.hk> <54E31CD5.70901@broadcom.com>
In-Reply-To: <54E31CD5.70901@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, February 17, 2015 03:49 AM, Arend van Spriel wrote:
> So it is a one-off and not showing the issue you are seeing. Your issue
> seems to be due to failing firmware so you may need b5 firmware.

Making some progress :)

I have extracted the firmwares from the Lenovo Windows driver, which 
contains:

43241b4rtecdc.bin  4324b5rtecdc.bin  4330b2rtecdc.bin  43341b0rtecdc.bin

I have used 4324b5rtecdc.bin in place of brcmfmac43241b4-sdio.bin in 
/lib/firmware. This time it goes further, and I can scan for networks, 
associate (only tried without encryption so far), and transmit packets 
(which are correctly received by another device in monitor mode).

However, the MAC address reported by ifconfig does not match the one in 
brcmfmac43241b4-sdio.txt, and the brcmfmac device fails to correctly 
receive packets.

The RX packets fall in three categories:
1) dropped at a lower level
2) reported as "dropped" by ifconfig
3) received but corrupted, shown with ethertype 0x886c and containing 
the string "wl0" which I guess is related to the firmware and should not 
be there.

I guess that the driver has bugs with decoding some of the data sent by 
the card.

I'm sending you privately a log with debug=0x1416 (association + DHCP) 
and a pcap trace showing packets of category 3.

Sebastien
