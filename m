Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55728 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828AbcFCF7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 01:59:44 -0400
Message-ID: <1464933580.11694.44.camel@coelho.fi> (sfid-20160603_075952_637763_ED43C617)
From: Luca Coelho <luca@coelho.fi>
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>,
	"me@bobcopeland.com" <me@bobcopeland.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Fri, 03 Jun 2016 08:59:40 +0300
In-Reply-To: <CAAA5faEJuydHyOgoB=R3HrucRLr4mhbwJPp=29SzmaJOzw9Gdw@mail.gmail.com>
References: <20160529214059.GA15677@localhost>
	 <CAAA5faFNa1sQrj6Yfq+hrXfUOi0Lek4qL8Zzpdv27-4+Z4n6mQ@mail.gmail.com>
 <20160601125453.GB12977@localhost> <1464787139.2554.74.camel@intel.com>
 <CAAA5faFaPow=Rw-1btgag9wRV-ub8=np2FgpRsoF99MPyb7row@mail.gmail.com>
 <1464841636.11694.10.camel@intel.com>
	 <CAAA5faGpjybA63PMp5pzGOxbw8Zjy+vK1HwnQA4-jGGk8XWJvA@mail.gmail.com>
 <1464855365.11694.35.camel@coelho.fi>
	 <CAAA5faEJuydHyOgoB=R3HrucRLr4mhbwJPp=29SzmaJOzw9Gdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: wireless-testing on 4.7
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-06-02 at 23:09 -0600, Reinoud Koornstra wrote:
> On Thu, Jun 2, 2016 at 2:16 AM, Luca Coelho <luca@coelho.fi> wrote:
> > This shows that you have iwlwifi-7260-16.ucode in your file system.
> >  But here we are reading it much later.  So it's possible that the
> > kernel cannot access the firmware at a very early stage (because
> > the
> > filesystem that contains it is not mounted yet) when you use in-
> > kernel.
> > 
> > So, first of all, please make sure they're built as modules.  We
> > can
> > continue from there then.
> 
> Your suggestion worked. When it's compiled as module, the
> iwlwifi-7260-16.ucode loads fine.
> No problems detected so far.

Great! :)


> It does make me think whether this is desired behavior though that
> due
> to the later reading we cannot have iwlwifi build in the kernel.

It should work, but then you have to make sure the firmware is
available at very early stages of boot.  If you add it to the proper
place in your initrd, the kernel should find it when the driver
requests it.

I didn't want to go into the details of this, because in most cases the
best option is to have the driver as a module.  If you really need it
in-kernel, then you need to make sure all the needed pieces are
available very early as well.

--
Cheers,
Luca.
