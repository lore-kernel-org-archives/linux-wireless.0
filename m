Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35837 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab2JBNdk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 09:33:40 -0400
Message-ID: <506AED28.4050903@openwrt.org> (sfid-20121002_153457_652313_4344CEA4)
Date: Tue, 02 Oct 2012 15:33:28 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Sven Eckelmann <sven@narfation.org>, lindner_marek@yahoo.de,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL
 on AR9003
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <1349174009-16496-1-git-send-email-sven@narfation.org> <CAJ-VmontNVV4TyRO5kEM30T=OmfEN8YUciJSW=j_0HnbadF4JA@mail.gmail.com>
In-Reply-To: <CAJ-VmontNVV4TyRO5kEM30T=OmfEN8YUciJSW=j_0HnbadF4JA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-02 3:13 PM, Adrian Chadd wrote:
> .. well, the rule here is "You shouldn't get PERR/FATAL interrupts."
> 
> Haven't I posted a summary of what those errors are?
> 
> Ok. So they're signals from the PCIe core (named host1_fatal and
> host1_perr. Helpfully.) Those errors occured during a DMA transfer.
> 
> So the question is why you're seeing PERR interrupts when creating an
> adhoc interface. That hints to me that something odd is going on..
> 
> I've seen these issues creep up when the NIC is in some way behaving
> very, very badly (lots of timeouts and sync errors with little to no
> traffic at all), which resulted in all kinds of odd and weird,
> unstable behaviour. After replacing the NIC with another NIC (in my
> case, an AR9280 -> AR9280 NIC :-) the errors went away and things
> continued swimmingly.
> 
> I'd have to go digging through the PCIe core source to figure out
> exactly what host1_peer and host1_fatal mean. I can if you'd like,
> it'll just take some time as I'm not familiar at all with the PCIe
> host interface.
According to the datasheet, AR_INTR_SYNC_HOST1_PERR is triggered by an
invalid register access, and AR_INTR_SYNC_HOST1_FATAL is triggered by
corrupt descriptors or other DMA issues.
Maybe you can get some information on the source of this PERR error if
you record the last register accesses outside of the irq context and
print them once this IRQ comes in.

- Felix

