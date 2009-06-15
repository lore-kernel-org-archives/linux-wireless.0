Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:57639 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZFOODS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 10:03:18 -0400
Message-ID: <4A3654A4.1070700@tuffmail.co.uk>
Date: Mon, 15 Jun 2009 15:03:16 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-pm@lists.linux-foundation.org, linux-pci@vger.kernel.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [linux-pm] PCI hotplug v.s. suspend
References: <Pine.LNX.4.44L0.0906150956360.2928-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906150956360.2928-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Stern wrote:
> On Mon, 15 Jun 2009, Alan Jenkins wrote:
>
>   
>> Hi,
>>
>> I triggered a WARNING while hacking on eeepc-laptop's 
>> rfkill-by-pci-hotplug.  I saw "Trying to free already-free IRQ" in 
>> ath5k_pci_remove(), because the IRQ was already freed by 
>> ath5k_pci_suspend().  My changes to eeepc-laptop had allowed the PCI 
>> device to be removed while suspended.
>>
>> Are PCI drivers supposed to handle remove() while suspended?
>>     
>
> Yes.  You found a bug in the driver.  However it's not clear (to me at
> least) whether the bug is that the IRQ is freed in the suspend method
> or that there's no check for already-freed in the remove method.  My 
> guess is the latter.
>
> Alan Stern
>   

The example in Documentation/power/pci.txt shows free_irq() being called
in suspend (and request_irq() in resume).  So the problem is in remove().

Perhaps I will try hacking fakephp to simulate this case, and see if I
can find bugs in any other drivers :-).

Thanks!
Alan
