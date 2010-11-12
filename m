Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42095 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0KLRAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 12:00:43 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PGwzR-0005Qc-Fx
	for linux-wireless@vger.kernel.org; Fri, 12 Nov 2010 18:00:41 +0100
Received: from function.justgohome.co.uk ([217.169.15.243])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 18:00:41 +0100
Received: from rb-oss-3 by function.justgohome.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 18:00:41 +0100
To: linux-wireless@vger.kernel.org
From: Robie Basak <rb-oss-3@justgohome.co.uk>
Subject: Re: r8187se panic
Date: Fri, 12 Nov 2010 17:00:29 +0000 (UTC)
Message-ID: <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk>
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk>
 <4CDC9FA5.10002@lwfinger.net>
 <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk>
 <4CDD3BC4.7070102@lwfinger.net>
 <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk>
 <4CDD66C4.10603@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Apply the new patch and the "change panic to warning" patch and redo your case
> B. Send me the dmesg output and a description of what happened. That data you
> can send directly. No need to spam the list with the lengthy dmesg output.

OK this is with change_panic_to_warn and fix_proc_entry_warning. I
forgot to mention that I'm applying all these patches to Ubuntu's stock
10.10 kernel, since module symbols etc. come with the build - and then
just compiling the one kernel module and copying it over (not much space
or CPU power on the netbook and the keyboard is tiny!).

Behaviour is the same as case B from before. To clarify, after step 3 in
case B, wireless has always reconnected no problem. It is after a few
seconds after removing AC power that it loses connection (or perhaps it
takes a few seconds for Network Manager to notice). Once it has lost
connection it does seem to occasionally associate and then loses it
again (according to Network Manager).

Reloading the kernel module doesn't fix it, but then toggling the
wireless switch after the reload does.

I reproduced it a second time, this time not reloading the module but
just toggling the wireless switch afterwards. This seemed to fix it as
well, so it seems that reloading the module is not required.

(dmesg output sent directly to Larry)

Thanks,

Robie

