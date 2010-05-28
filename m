Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:53518 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0E1SZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:25:24 -0400
Message-ID: <20100528212523.213125g8t0an4mn4@hayate.sektori.org>
Date: Fri, 28 May 2010 21:25:23 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Pavel Roskin" <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable ASPM
References: <20100528100901.14580.1322.stgit@fate.lan>
	<1275063576.15168.14.camel@mj>
In-Reply-To: <1275063576.15168.14.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Pavel Roskin" <proski@gnu.org>:

> On Fri, 2010-05-28 at 13:09 +0300, Jussi Kivilinna wrote:
>> +static void		__ath5k_disable_aspm(struct pci_dev *pdev, u16 state);
>> +static void		ath5k_disable_aspm(struct pci_dev *pdev, u16 state);
>
> Forward declarations should not be needed unless the functions are
> called before their implementations, which is not the case here.

Ok.

>
>> @@ -424,6 +427,47 @@ module_exit(exit_ath5k_pci);
>>  * PCI Initialization *
>>  \********************/
>>
>> +#ifdef CONFIG_PCIEASPM
>> +static void __ath5k_disable_aspm(struct pci_dev *pdev, u16 state)
>> +{
>> +	pci_disable_link_state(pdev, state);
>> +}
>> +#else
>> +static void __ath5k_disable_aspm(struct pci_dev *pdev, u16 state)
>> +{
>
> It looks like a replacement for pci_disable_link_state() if
> CONFIG_PCIEASPM is disabled.  I guess it should be in the PCI code, not
> in ath5k.  At least the PCI developers should have a look at the
> replacement code.

I used code from e1000e which does this same way, which now suddenly  
reminds me of that ath5k is dual lisenced, right? Can I even reuse  
code from GPL driver in ath5k?

-Jussi

