Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:43982 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751954AbYJQUqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 16:46:25 -0400
Date: Fri, 17 Oct 2008 22:44:23 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrey Borzenkov <arvidjaar@newmail.ru>
Cc: Dave <kilroyd@googlemail.com>, orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic
	loading firmware with PCMCIA adapter
Message-ID: <20081017204423.GB25568@comet.dominikbrodowski.net> (sfid-20081017_224629_077029_75DD47A0)
References: <200810091722.56812.arvidjaar@newmail.ru> <200810102114.55663.arvidjaar@newmail.ru> <48EF8E01.2060709@gmail.com> <200810102126.32246.arvidjaar@newmail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810102126.32246.arvidjaar@newmail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Oct 10, 2008 at 09:26:30PM +0400, Andrey Borzenkov wrote:
> On Friday 10 October 2008, Dave wrote:
> > 
> > Andrey Borzenkov wrote:
> > > On Friday 10 October 2008, Dave wrote:
> > >> You're right. pda_size is supposed to be the maximum size of the PDA (in bytes) that we expect with the firmware. It should be set to 0x200.
> > >>
> > > 
> > > Do you want me to send a patch?
> > 
> > Could you fix it as part of the patch you submitted?
> > 
> 
> Attached. As other entries use decimal I thought it is more logical
> to use 512 as well.

> Subject: [PATCH] orinoco: reduce stack usage in firmware download path
> From: Andrey Borzenkov < arvidjaar@mail.ru>
> 
> orinoco_dl_firmware and symbol_dl_mage allocate large local
> variables (1K); at least orinoco fails with panic or hung
> kernel if 4K stacks is enabled.
> 
> Allocate large buffers dynamically at run time.
> 
> Tested-By: Andrey Borzenkov <arvidjaar@mail.ru> for Agere case
> 
> Signed-off-by: Andrey Borzenkov < arvidjaar@mail.ru>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>

I assmue this is to be merged via wireless and net, and not via pcmcia?

Best,
	Dominik
