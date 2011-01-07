Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36158 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab1AGSDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 13:03:14 -0500
Received: by fxm20 with SMTP id 20so17161499fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 10:03:13 -0800 (PST)
Message-ID: <4D27556C.3010901@lwfinger.net>
Date: Fri, 07 Jan 2011 12:03:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Odd behavior of ssb, b43, b43legacy, and b44
References: <4D262109.20504@lwfinger.net>	 (sfid-20110106_210800_770742_63AA2C67) <1294371276.15564.0.camel@maggie>	 <4D269711.1040003@lwfinger.net> (sfid-20110107_053108_647486_0233929A) <1294411555.18385.1.camel@maggie>
In-Reply-To: <1294411555.18385.1.camel@maggie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2011 08:45 AM, Michael Büsch wrote:
> On Thu, 2011-01-06 at 22:31 -0600, Larry Finger wrote: 
>> On 01/06/2011 09:34 PM, Michael Büsch wrote:
>>>
>>> Does one of these wireless cards have a dangling ethernet core? I would
>>> not be surprised...
>>
>> Yes. The core scan for the BCM4303 is as follows:
>>
>> ssb: Core 0 found: IEEE 802.11 (cc 0x812, rev 0x02, vendor 0x4243)
>> ssb: Core 1 found: PCMCIA (cc 0x80D, rev 0x00, vendor 0x4243)
>> ssb: Core 2 found: Fast Ethernet (cc 0x806, rev 0x02, vendor 0x4243)
>> ssb: Core 3 found: V90 (cc 0x807, rev 0x01, vendor 0x4243)
>> ssb: Core 4 found: PCI (cc 0x804, rev 0x03, vendor 0x4243)
>> ssb: Sonics Silicon Backplane found on PCI device 0000:01:09.0
>>
>> Larry
>>
> 
> Can you please try this patch?
> 
> 
> Index: linux-2.6.37/drivers/ssb/scan.c
> ===================================================================
> --- linux-2.6.37.orig/drivers/ssb/scan.c	2011-01-07 15:35:10.518000002 +0100
> +++ linux-2.6.37/drivers/ssb/scan.c	2011-01-07 15:45:54.231998930 +0100
> @@ -420,6 +420,16 @@
>  			bus->pcicore.dev = dev;
>  #endif /* CONFIG_SSB_DRIVER_PCICORE */
>  			break;
> +		case SSB_DEV_ETHERNET:
> +			if (bus->bustype == SSB_BUSTYPE_PCI) {
> +				if (bus->host_pci->vendor == PCI_VENDOR_ID_BROADCOM &&
> +				    (bus->host_pci->device & 0xFF00) == 0x4300) {
> +					/* This is a dangling ethernet core on a
> +					 * wireless device. Ignore it. */
> +					continue;
> +				}
> +			}
> +			break;
>  		default:
>  			break;
>  		}
> 
> 

That patch fixes the problem. Thanks.

Larry

