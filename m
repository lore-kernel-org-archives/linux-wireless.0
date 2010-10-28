Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:57559 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934169Ab0J1Vfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 17:35:53 -0400
Date: Thu, 28 Oct 2010 19:13:05 -0200
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	seno <senada@t-online.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Message-ID: <20101028191305.2960c83b@gotham.conectiva>
In-Reply-To: <20101026185341.GA4608@barata.holoscopio.com>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com>
	<4C798080.8010002@lwfinger.net>
	<20100830141218.GB30864@tuxdriver.com>
	<4C7BC4D9.1010108@lwfinger.net>
	<20100830152841.GB2950@barata.holoscopio.com>
	<loom.20101026T200014-691@post.gmane.org>
	<4CC71CFF.8050004@lwfinger.net>
	<20101026185341.GA4608@barata.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 26 Oct 2010 16:53:42 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
> On Tue, Oct 26, 2010 at 01:25:03PM -0500, Larry Finger wrote:
> > On 10/26/2010 01:03 PM, seno wrote:
> > > I tried that patch on compat-wireless-2010-10-25 (Kernel 2.6.33.7).
> > > 
> > > Performance improves minimal, but thousands of errors occur in iwconfig output.
> > > (Tx excessive retries, Invalid misc, Missed beacon).
> > > 
> > > The router also shows lots of errors 
> > > (for Received (RX) / Transmitted (TX) packets)
> > 
> > I no longer remember the details of why this patch was abandoned, but I suspect
> > you found the answer.
> > 
> 
> It was because of the bad wording in the commit description. I was
> expecting some more testing from my client before posting it again with
> the wording fixed. They've been testing it and there is enough
> improvement they require the patch. I don't get the thousands of errors
> in iwconfig output. I can try to reproduce it here if I get more
> details.

The excessive retries etc. should be another issue. The patch from Thadeu
really improves the driver. In last days I got back a RTL8187B device for
testing, and for me it also improved the range and throughput doing some
scps or with iperf. And looking at newer realtek drivers for 8187B, they
also started to clear the flags. In fact, while doing a printk to see the
contents of the register after chip reset, it's already cleared, but I don't
see any problem to make sure we already have all *TX_AGC_CTL* flags cleared.
Also for 8180 and 8187L they are cleared. Unfortunately we don't have details
(documentation) on what these flags are exactly supposed to do...

But I really think the patch should go in, Thadeu can you post it again with
commit description fixed?

> 
> Thanks,
> Cascardo.
> 
> > Larry
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
[]'s
Herton
