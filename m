Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm18-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.138]:38434 "HELO
	nm18-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754352Ab2FNQgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:36:10 -0400
Message-ID: <1339691433.76573.YahooMailClassic@web161705.mail.bf1.yahoo.com> (sfid-20120614_183614_098557_9F4F0A6D)
Date: Thu, 14 Jun 2012 09:30:33 -0700 (PDT)
From: hong zhang <henryzhang62@yahoo.com>
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
To: Andreas Kemnade <andreas@kemnade.info>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	dsd@laptop.org, libertas-dev@lists.infradead.org
In-Reply-To: <1339690266.19412.YahooMailClassic@web161704.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually, you have to check SDIO driver done by TI.
There are 5 SDIO pins need to check. 4 data pins and one clock pin.

Double check the SDIO pins muxs and clock rate using TI reference manual.

By performance issues.
1. bit modes 1 or 4
2. interrupt/PIO
3. SDIO clock rate

Command 52 and 53 are important.
See this link for SDIO reference.
http://www.sandisk.com/Assets/File/OEM/Manuals/SD_SDIO_specsv1.pdf

--- On Thu, 6/14/12, hong zhang <henryzhang62@yahoo.com> wrote:

> From: hong zhang <henryzhang62@yahoo.com>
> Subject: Re: poor performance with W2CBW003 (Marvell 8686)
> To: "Andreas Kemnade" <andreas@kemnade.info>
> Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org, dsd@laptop.org, libertas-dev@lists.infradead.org
> Date: Thursday, June 14, 2012, 11:11 AM
> bit mode and interrupt or PIO are
> configured in SDIO hoster side.
> Not in driver side.
> 
> --- On Thu, 6/14/12, Andreas Kemnade <andreas@kemnade.info>
> wrote:
> 
> > From: Andreas Kemnade <andreas@kemnade.info>
> > Subject: Re: poor performance with W2CBW003 (Marvell
> 8686)
> > To: "hong zhang" <henryzhang62@yahoo.com>
> > Cc: "Dan Williams" <dcbw@redhat.com>,
> linux-wireless@vger.kernel.org,
> dsd@laptop.org, libertas-dev@lists.infradead.org
> > Date: Thursday, June 14, 2012, 12:45 AM
> > Hi,
> > 
> > On Wed, 13 Jun 2012 11:39:08 -0700 (PDT)
> > hong zhang <henryzhang62@yahoo.com>
> > wrote:
> > 
> > > You have to identify problem caused by 
> > > SDIO host controller or wifi driver.
> > > 
> > > If driver is working well in x86 with Roch SDIO,
> that
> > means wifi driver is ok. 
> > > 
> > > You have to find out
> > > 1. SDIO interface if using Interrupt or PIO
> > 
> > Hmm, very interesting point, of course, there are
> > interrupts. But after reading
> > the commit logs in the patched 2.6.32 kernel I see
> there is
> > a patch enabling
> > asynchronous *sdio* interrupts. That looks clearly
> > suspicious. 
> > 
> > > 2. 1 bit or 4 bit
> > 
> > Hmm, 4bit.
> > 
> > Greetings
> > Andreas Kemnade
> > 
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
> 
