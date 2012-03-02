Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1414 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab2CBKj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 05:39:58 -0500
Message-ID: <4F50A372.2020608@broadcom.com> (sfid-20120302_114018_554677_7A4CEA71)
Date: Fri, 2 Mar 2012 11:39:46 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rafal Milecki" <zajec5@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"b43 developer list" <b43-dev@lists.infradead.org>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for
 SPROM storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
 <4F48D997.1060400@hauke-m.de> <4F4B571E.7040704@broadcom.com>
 <4F4FE989.3090108@broadcom.com> <4F4FF0A4.8080308@hauke-m.de>
In-Reply-To: <4F4FF0A4.8080308@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2012 10:56 PM, Hauke Mehrtens wrote:
> On 03/01/2012 10:26 PM, Arend van Spriel wrote:
>> On 02/27/2012 11:12 AM, Arend van Spriel wrote:
>>> On 02/25/2012 01:52 PM, Hauke Mehrtens wrote:
>>>> On 02/23/2012 10:52 PM, Arend van Spriel wrote:
>>>>> Wireless Broadcom chips can have either their SPROM data stored
>>>>> on either external SPROM or on-chip OTP memory. Both are accessed
>>>>> through the same register space. This patch adds support for the
>>>>> on-chip OTP memory.
>>>>>
>>>>> Tested with:
>>>>> BCM43224 OTP and SPROM
>>>>> BCM4331 SPROM
>>>>> BCM4313 OTP
>>>>
>>>> Does bcma now support the same features regarding sprom and otp as
>>>> brcmsamc expect it does not read out all the attributes brcmsmac reads
>>>> out or are there any features still missing? I am just asking because
>>>> the code used in brcmsmac is ~4 times longer.
>>>
>>> I started on using bcma sprom content in brcmsmac and indeed there are
>>> some entries missing. The change in this patch only provides read-access
>>> to the srom data. As the chip comes up for read-access there is not much
>>> programming need to accomplish that. The only feature that is not there
>>> is that on some chips OTP can be powered down for power-saving. The
>>> current chips supported by BCMA don't have that.
>>
>> With BCMA retrieving the SPROM data correctly, regardless how/where it
>> is stored I went to change brcmsmac to make use of it. However, it
>> turned out several attributes were missing.
>>
>> Now I could go and extend the ssb_sprom structure, but there I got
>> confused. The structure is filled by BCMA in the function
>> bcma_sprom_extract_r8(). The name suggest it deals with SROM revision 8
>> attributes, but:
>>
>>      for (i = 0; i<  3; i++) {
>>          v = sprom[SPOFF(SSB_SPROM8_IL0MAC) + i];
>>          *(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
>>      }
>>
>>      SPEX(board_rev, SSB_SPROM8_BOARDREV, ~0, 0);
>>
>>      SPEX(txpid2g[0], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G0,
>>           SSB_SPROM4_TXPID2G0_SHIFT);
>>      SPEX(txpid2g[1], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G1,
>>           SSB_SPROM4_TXPID2G1_SHIFT);
>>
>> The attributes txpid2g that are filled here are deprecated for srom
>> revision 8. Is b43 using these fields for boards with srom rev 8?
> The code filling txpid2g is probably wrong or dated and should be
> removed. It could be that the spec b43 is written on was based on an old
> version of the Broadcom wl driver and they used txpid2g in n-phy code.
> txpid2g is used by b43 (b43_nphy_tx_power_fix()), but brcmsmac
> (wlc_phy_txpwr_fixpower_nphy()) uses 0 where b43 used the sprom values.

Take your word for it. Only looked at brcmsmac code and at a glance for 
n-phy it seems hardcoded and determined by the phy revision.

>> I propose to move to BCMA having its own sprom structure definition.
>> Srom revision 10 is upcoming and it does only apply to BCMA-based cards.
> Doesn't this also apply for srom rev 9, or are there any ssb based
> devices with srom rev 9 out there?

You are right. The overlap is for revision 8, which is found in both ssb 
and bcma based cards. For bcm4331 it is more subtle as there are cards 
with srom rev 8 and srom rev 9. Not sure if and how b43 is dealing with 
that.

I will prepare a RFC patch with a new bcma_sprom structure, but I would 
prefer someone from b43 to provide the patch for the b43 driver to use 
the new structure as I am not familiar with that driver.

Gr. AvS

