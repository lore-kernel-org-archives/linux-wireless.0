Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3027 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1LJLFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 06:05:00 -0500
Message-ID: <4EE33CCB.80309@broadcom.com> (sfid-20111210_120508_489495_78FA33DE)
Date: Sat, 10 Dec 2011 12:04:43 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Francesco Gringoli" <francesco.gringoli@ing.unibs.it>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Performance of BCM43224 (14e4:4353)
References: <4EE15A4E.1090500@lwfinger.net>
 <4EE1E2AC.8030002@broadcom.com> <4EE23AF5.8000400@lwfinger.net>
 <4EE24615.9020003@broadcom.com> <4EE2509D.6020501@lwfinger.net>
 <4EE269CF.2000608@broadcom.com> <4EE29171.9060608@lwfinger.net>
 <CACna6rzQuw+oMvYjN6+7SsTqqW=vFFj8W1iuwDY8x+p+GgJ6jA@mail.gmail.com>
In-Reply-To: <CACna6rzQuw+oMvYjN6+7SsTqqW=vFFj8W1iuwDY8x+p+GgJ6jA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2011 10:18 AM, Rafał Miłecki wrote:
> 2011/12/9 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 12/09/2011 02:04 PM, Arend van Spriel wrote:
>>>
>>>
>>> Indeed. What is more strange is that this looks like value from
>>> enumeration rom. 0x4bf is BCMA_MANUF_BCM, 0x800 is BCMA_CORE_CHIPCOMMON.
>>> It seems the BAR window is wrong. Can you read PCI_BAR window in the
>>> ai_doattach() before reading the chip id.
>>
>>
>> I would like a hint on how to do this. I tried some things that failed.
> 
> Have you tried
> u32 value;
> pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN, &value);
> pr_info();
> pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN2, &value);
> pr_info();
> 
> You should also hack bcma_bus_scan to display addr and wrap.
> pr_info("Core %d addr: 0x%X, wrap 0x%X\n", core->core_index,
> core->addr, core->wrap);
> (put is inside the while, after existing pr_info)
> 

Obviously it should be a pci_read_config_dword(). I found out that I can
reproduce the problem over here so I added the print statements:

[61359.893254] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
[61359.897801] core[2] id=0x820 addr=18002000 wrap=18102000
[61359.897808] core[1] id=0x812 addr=18001000 wrap=18101000
[61359.897814] core[0] id=0x800 addr=18000000 wrap=18100000
[61359.897822] PCI_BAR0_WIN=18107000

Not sure how it got programmed to this value, but it definitely is wrong.

Gr. AvS

