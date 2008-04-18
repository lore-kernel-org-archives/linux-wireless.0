Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:39219 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYDRP5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 11:57:53 -0400
Received: by wf-out-1314.google.com with SMTP id 28so482319wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 08:57:53 -0700 (PDT)
Message-ID: <f6ca9fed0804180857n3fb80c1i4c5537b14cb2a37d@mail.gmail.com> (sfid-20080418_165759_021235_1089F485)
Date: Fri, 18 Apr 2008 17:57:53 +0200
From: drago01 <drago01@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10471] New: iwl3945 in 2.6.25 ignores state of hardware RF kill switch
Cc: "=?ISO-8859-1?Q?Thoralf_Da=DFler?=" <thoralf.dassler@gmail.com>,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080418020142.18bf9f31.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <bug-10471-10286@http.bugzilla.kernel.org/>
	 <20080417142934.be2bdd27.akpm@linux-foundation.org>
	 <48086F6E.10901@gmail.com>
	 <20080418020142.18bf9f31.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 18, 2008 at 11:01 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 18 Apr 2008 09:52:46 +0000 Thoralf Da__ler <thoralf.dassler@gmail.com> wrote:
>
>  > Yeah, it seems dumb that the init scripts pause, but I don't understand why this started with the 2.6.25 kernel, whereas it was fine before.
>
>  You have removed from Cc: the people who can explain it.  I restored them.
>
>  > Andrew Morton wrote:(switched to email.  Please respond via emailed reply-to-all, not via the
>
> > bugzilla web interface).

iwl3945 was loading the ucode (firmware) during probe but then changed
to do this on ifup.
for 4965 this does not cause such problems because the rfkill state is
reported via an interrupt; while for 3965 its an ucode event...
no ucode means no ucode event ;) (but it should be able to read the
current state after an ifup)
