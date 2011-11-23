Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab1KWPLr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:11:47 -0500
Date: Wed, 23 Nov 2011 16:14:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Amir Hedayaty <hedayaty@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
Message-ID: <20111123151414.GC7943@redhat.com> (sfid-20111123_161150_538620_301961CC)
References: <20111116100915.GA2191@redhat.com>
 <20111122214940.GH8452@tuxdriver.com>
 <20111123080506.GB9833@redhat.com>
 <CAGXE3d-HE8MWV5Xv9e407iDn83UFvjua52mYGEJuJnQuQvnyog@mail.gmail.com>
 <20111123105106.GA7943@redhat.com>
 <CAN6fvj2=EhimZUy-DKtpzAKq1mpvBt03KtX9vCi0dBTCXWVsRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN6fvj2=EhimZUy-DKtpzAKq1mpvBt03KtX9vCi0dBTCXWVsRg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amir

On Wed, Nov 23, 2011 at 04:33:27AM -0800, Amir Hedayaty wrote:
> [amir@amir-client ~]$ cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:        379          0          0         13   IO-APIC-edge      timer
>   1:         12          0          0          2   IO-APIC-edge      i8042
>   7:          1          0          0          0   IO-APIC-edge
>   8:          0          0          0          1   IO-APIC-edge      rtc0
>   9:          7          0          0          1   IO-APIC-fasteoi   acpi
>  12:         18          0          0          4   IO-APIC-edge      i8042
>  14:          0          0          0          0   IO-APIC-edge
> pata_atiixp
>  15:          0          0          0          0   IO-APIC-edge
> pata_atiixp
>  16:     632032      28450      81705      16199   IO-APIC-fasteoi
> ohci_hcd:usb3, ohci_hcd:usb4, snd_hda_intel
>  17:   22153190     140306   13063918   91518105   IO-APIC-fasteoi
> ehci_hcd:usb1, 0000:02:00.0
>  18:          0          0          0          3   IO-APIC-fasteoi
> ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
>  19:       2076          0          0          0   IO-APIC-fasteoi
> ehci_hcd:usb2
>  22:     221936     131775     149195     162901   IO-APIC-fasteoi   ahci
>  43:    6097940         40        572     254483   PCI-MSI-edge      radeon
>  44:          0          0          0         73   PCI-MSI-edge
> snd_hda_intel
>  45:          0          0          0          1   PCI-MSI-edge      em1
I'm seeing rt2800pci anywhere, is module loaded? Anyway, I'm asking
you to try to configure your system (by disabling USB in BIOS or kernel
options, etc) to force rt2800pci do not share interrupt line. Hence we
could see if for spurious interrupts come from rt2800pci, or maybe from
some other device, i.e. usb controller.

> I have not dealt with interrupts since MSDOS!
Well, problem you are hitting is generally a hardware issue, and we
need to find out how deal with that in software. The way this is
done in vendor driver (and what I did in my patch) is wrong.

> I think the green line is for
> rt2860 device, which seems unique to me.
Hmm, not sure what is green line?

> BTW the (original) patch did not 100% solve the issue (it is a major
> improvement though) when the issue happens I remove
> the module and insert it again and so far after this patch that has not
> failed.
> 
> About the recent patch, do you mean reverse patching the previous one and
> patching the new one?
> Second I tried applying the patch it gets rejected, here is the situation:
> I have build a kernel applying previous patch using rpmbuild
> sine I do not want to through the long process of building kernel, reversed
> the previous patch
> and tried to apply the recent one. maybe it is being messed up during
> copy/paste can you attach
> that file? The kernel I am trying the patch is 3.1.1-2.
I'll do koji kernel build with the patch, that would be easiest, I'll
provide link shortly.

Stanislaw
