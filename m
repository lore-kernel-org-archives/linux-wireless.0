Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63436 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0KLR2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 12:28:48 -0500
Received: by fxm6 with SMTP id 6so302168fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 09:28:47 -0800 (PST)
Message-ID: <4CDD7945.70005@lwfinger.net>
Date: Fri, 12 Nov 2010 11:28:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Robie Basak <rb-oss-3@justgohome.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8187se panic
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk>
In-Reply-To: <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2010 11:00 AM, Robie Basak wrote:
> On 2010-11-12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> Apply the new patch and the "change panic to warning" patch and redo your case
>> B. Send me the dmesg output and a description of what happened. That data you
>> can send directly. No need to spam the list with the lengthy dmesg output.
> 
> OK this is with change_panic_to_warn and fix_proc_entry_warning. I
> forgot to mention that I'm applying all these patches to Ubuntu's stock
> 10.10 kernel, since module symbols etc. come with the build - and then
> just compiling the one kernel module and copying it over (not much space
> or CPU power on the netbook and the keyboard is tiny!).
> 
> Behaviour is the same as case B from before. To clarify, after step 3 in
> case B, wireless has always reconnected no problem. It is after a few
> seconds after removing AC power that it loses connection (or perhaps it
> takes a few seconds for Network Manager to notice). Once it has lost
> connection it does seem to occasionally associate and then loses it
> again (according to Network Manager).
> 
> Reloading the kernel module doesn't fix it, but then toggling the
> wireless switch after the reload does.
> 
> I reproduced it a second time, this time not reloading the module but
> just toggling the wireless switch afterwards. This seemed to fix it as
> well, so it seems that reloading the module is not required.

What does the following log entry signify?

Nov 12 16:29:03 tiny kernel: [  160.306731]
=>>>>>>>>>>=============================>set power:0,0!

On my system, switching to battery does not affect the rtl8187se at all.

I will be working on a patch that improves the error handling of the read routines.

Larry
