Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:35970 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab2BCOSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 09:18:42 -0500
Received: by lbjn8 with SMTP id n8so851127lbj.30
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 06:18:39 -0800 (PST)
Subject: Re: [PATCH 2/2] cleanup modprobe calls
From: Luciano Coelho <coelho@ti.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <4F2BEB9D.20909@gmail.com>
References: <1328237302-13423-1-git-send-email-sidhayn@gmail.com>
	 <1328237302-13423-2-git-send-email-sidhayn@gmail.com>
	 <1328248669.3626.328.camel@cumari>  <4F2BEB9D.20909@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Feb 2012 16:18:30 +0200
Message-ID: <1328278711.3626.367.camel@cumari> (sfid-20120203_151845_557574_3A53E547)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-03 at 09:13 -0500, Richard Farina wrote: 
> On 02/03/12 00:57, Luciano Coelho wrote:
> > On Thu, 2012-02-02 at 21:48 -0500, Rick Farina wrote: 
> >> There were a lot of needless calls to "modprobe -l <drivername>" and even more confusingly $(MODPROBE).
> >> None of this is needed on a modern distro, and it errors on when modprobe -l is removed (such as KMOD in Arch Linux)
> >>
> >> Signed-of-By: Rick Farina <sidhayn@gmail.com>
> >> ---
> > I agree with this.  The modprobes are just there in order to list which
> > of the relevant modules you have in your system.  There is little value
> > in this and, if considered really necessary, there surely must be other
> > ways to find out?
> >
> Although I've never liked all this scrolling, I would have recoded it
> rather than removed it if I knew how.  At the present time there is no
> way which I know to replicate this functionality. I suppose a find
> statement could be added but honestly I just don't see it as necessary,
> or any cleaner.

Well, at least we should use something else then $(MODPROBE) -l.  It
would be nice to make it more generic.  "-l" is a modprobe specific
option, maybe it could be moved to the variable itself so it could be
changed for another command with the same effect? Maybe change it to
$(FINDMODULE) and assign it to "modprobe -l" by default?

-- 
Cheers,
Luca.

