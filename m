Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54345 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab2BCObX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 09:31:23 -0500
Received: by qcqw6 with SMTP id w6so2104256qcq.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 06:31:23 -0800 (PST)
Message-ID: <4F2BEFB0.9050208@gmail.com> (sfid-20120203_153127_518709_0111FC29)
Date: Fri, 03 Feb 2012 09:31:12 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] cleanup modprobe calls
References: <1328237302-13423-1-git-send-email-sidhayn@gmail.com>  <1328237302-13423-2-git-send-email-sidhayn@gmail.com>  <1328248669.3626.328.camel@cumari>  <4F2BEB9D.20909@gmail.com> <1328278711.3626.367.camel@cumari>
In-Reply-To: <1328278711.3626.367.camel@cumari>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/12 09:18, Luciano Coelho wrote:
> On Fri, 2012-02-03 at 09:13 -0500, Richard Farina wrote: 
>> On 02/03/12 00:57, Luciano Coelho wrote:
>>> On Thu, 2012-02-02 at 21:48 -0500, Rick Farina wrote: 
>>>> There were a lot of needless calls to "modprobe -l <drivername>" and even more confusingly $(MODPROBE).
>>>> None of this is needed on a modern distro, and it errors on when modprobe -l is removed (such as KMOD in Arch Linux)
>>>>
>>>> Signed-of-By: Rick Farina <sidhayn@gmail.com>
>>>> ---
>>> I agree with this.  The modprobes are just there in order to list which
>>> of the relevant modules you have in your system.  There is little value
>>> in this and, if considered really necessary, there surely must be other
>>> ways to find out?
>>>
>> Although I've never liked all this scrolling, I would have recoded it
>> rather than removed it if I knew how.  At the present time there is no
>> way which I know to replicate this functionality. I suppose a find
>> statement could be added but honestly I just don't see it as necessary,
>> or any cleaner.
> Well, at least we should use something else then $(MODPROBE) -l.  It
> would be nice to make it more generic.  "-l" is a modprobe specific
> option, maybe it could be moved to the variable itself so it could be
> changed for another command with the same effect? Maybe change it to
> $(FINDMODULE) and assign it to "modprobe -l" by default?
I still don't think all that output has any use at all, but if you find
a way to replicate the behavior of modprobe -l you are certainly welcome
to use that in place of one or both of my patches.  The command run in
patch 1 is the closest I was able to come to replicating modprobe -l and
the output is huge (hence the > /dev/null) so I just read the exit code.

The patchset I sent is one possible solution, and in my eyes the
cleanest one.  Please feel free to push these fixes, use my patches as a
base for a changeset of your own, or completely ignore my patches and
solve the issue completely as you see fit :-)  I take no offense in any
of these cases, but I lack the ability to (even remotely) cleanly
replicate the modprobe -l functionality so I simply removed all the
(useless in my eyes) print statements.

Thanks,
Rick Farina

