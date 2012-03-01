Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2133 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708Ab2CAV0q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 16:26:46 -0500
Message-ID: <4F4FE989.3090108@broadcom.com> (sfid-20120301_222653_549353_1452F3D6)
Date: Thu, 1 Mar 2012 22:26:33 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	"Rafal Milecki" <zajec5@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for
 SPROM storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
 <4F48D997.1060400@hauke-m.de> <4F4B571E.7040704@broadcom.com>
In-Reply-To: <4F4B571E.7040704@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2012 11:12 AM, Arend van Spriel wrote:
> On 02/25/2012 01:52 PM, Hauke Mehrtens wrote:
>> On 02/23/2012 10:52 PM, Arend van Spriel wrote:
>>> Wireless Broadcom chips can have either their SPROM data stored
>>> on either external SPROM or on-chip OTP memory. Both are accessed
>>> through the same register space. This patch adds support for the
>>> on-chip OTP memory.
>>>
>>> Tested with:
>>> BCM43224 OTP and SPROM
>>> BCM4331 SPROM
>>> BCM4313 OTP
>>
>> Does bcma now support the same features regarding sprom and otp as
>> brcmsamc expect it does not read out all the attributes brcmsmac reads
>> out or are there any features still missing? I am just asking because
>> the code used in brcmsmac is ~4 times longer.
>
> I started on using bcma sprom content in brcmsmac and indeed there are
> some entries missing. The change in this patch only provides read-access
> to the srom data. As the chip comes up for read-access there is not much
> programming need to accomplish that. The only feature that is not there
> is that on some chips OTP can be powered down for power-saving. The
> current chips supported by BCMA don't have that.

With BCMA retrieving the SPROM data correctly, regardless how/where it 
is stored I went to change brcmsmac to make use of it. However, it 
turned out several attributes were missing.

Now I could go and extend the ssb_sprom structure, but there I got 
confused. The structure is filled by BCMA in the function 
bcma_sprom_extract_r8(). The name suggest it deals with SROM revision 8 
attributes, but:

	for (i = 0; i < 3; i++) {
		v = sprom[SPOFF(SSB_SPROM8_IL0MAC) + i];
		*(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
	}

	SPEX(board_rev, SSB_SPROM8_BOARDREV, ~0, 0);

	SPEX(txpid2g[0], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G0,
	     SSB_SPROM4_TXPID2G0_SHIFT);
	SPEX(txpid2g[1], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G1,
	     SSB_SPROM4_TXPID2G1_SHIFT);

The attributes txpid2g that are filled here are deprecated for srom 
revision 8. Is b43 using these fields for boards with srom rev 8?

I propose to move to BCMA having its own sprom structure definition. 
Srom revision 10 is upcoming and it does only apply to BCMA-based cards.

Gr. AvS

