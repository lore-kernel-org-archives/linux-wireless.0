Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59375 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab1HBVMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 17:12:52 -0400
Received: by fxh19 with SMTP id 19so193198fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 14:12:51 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH 1/2] libertas: add ability to power off card on suspend
Date: Wed, 3 Aug 2011 00:12:19 +0300
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
References: <201108021312.23153.anarsoul@gmail.com> <201108022309.07783.anarsoul@gmail.com> <CAGq3pz6R=8eRNRME-X9e-S12cWvRq_-xvcjCa7KXyRfE0sJ8gw@mail.gmail.com>
In-Reply-To: <CAGq3pz6R=8eRNRME-X9e-S12cWvRq_-xvcjCa7KXyRfE0sJ8gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108030012.20241.anarsoul@gmail.com> (sfid-20110802_231255_564605_EF9E5C4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 August 2011 23:32:27 Daniel Drake wrote:
> On 2 August 2011 21:09, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> > Because no one puts interface down before suspend?
> > I just re-tested - if interface is up - kernel does not put it down
> > before suspend, so I got a lot of timeouts and errors on dmesg after
> > resume.
> 
> I can't see how this would have been influenced by my work.

Now generic libertas driver controls power, not if_spi. So it should be able 
to turn off card before going suspend. Messing with power in if_* and generic 
part does not look like a good idea to me.

> Your resume handler should already be fixing up the hardware state so
> that it can be operated (regardless of any power saving that might
> come into effect), or otherwise your suspend handler should cause the
> device to be removed so that it can be reprobed completely during
> resume.

My resume handler calls lbs_suspend to detach device, and it expects that 
lbs_suspend will disable card power.
 
> Daniel

Regards
Vasily
