Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34418 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbbIAOM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 10:12:59 -0400
Received: by pabzx8 with SMTP id zx8so178396906pab.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2015 07:12:58 -0700 (PDT)
Message-ID: <55E5B257.6070205@quarksecurity.com> (sfid-20150901_161339_667924_50F33846)
Date: Tue, 01 Sep 2015 10:12:39 -0400
From: Joshua Brindle <brindle@quarksecurity.com>
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>,
	David Howells <dhowells@redhat.com>,
	Peter Jones <pjones@redhat.com>,
	"selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Kees Cook <keescook@chromium.org>,
	=?ISO-8859-1?Q?Vojtech_Pavl=EDk?= <vojtech@suse.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joey Lee <jlee@suse.de>, Kyle McMartin <kyle@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux Firmware Signing
References: <1440462367.2737.4.camel@linux.vnet.ibm.com> <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com> <1440464705.2737.36.camel@linux.vnet.ibm.com> <14540.1440599584@warthog.procyon.org.uk> <31228.1440671938@warthog.procyon.org.uk> <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org> <20150827212907.GF8051@wotan.suse.de> <CAHC9VhQFDcMtvn1JU3E1rJ=9CCXT7ibUocgGS4tzfcy8oVUUMA@mail.gmail.com> <476DC76E7D1DF2438D32BFADF679FC560105ABD6@ORSMSX103.amr.corp.intel.com> <CAHC9VhRF-39ZbwawkM-aR+th2nRPEVF9-nR1NEHDPDmakpt4FQ@mail.gmail.com> <20150829020301.GM8051@wotan.suse.de> <CAHC9VhTTRr7N2bqU-7jm2oG72t5wgqH_SmXk4icqs3h3_=EMzg@mail.gmail.com>
In-Reply-To: <CAHC9VhTTRr7N2bqU-7jm2oG72t5wgqH_SmXk4icqs3h3_=EMzg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul Moore wrote:
<snip>
>
> Yes, there are lots of way we could solve the signed policy format
> issue, I just don't have one in mind at this moment.  Also, to be
> honest, there are enough limitations to signing SELinux policies that
> this isn't very high onmy personal SELinux priority list.
>

The fact that there are so many userspace specific parts of the policy 
that never make it into the kernel precludes any meaningful verification 
anyway.

And SELinux already has a mechanism for raising the integrity of a 
process to do things like signature checking in userspace, the domain 
transition. If someone wants validation of the SELinux policy they just 
need to eliminate every domains ability to load policy except for a 
trusted policy loader that does signature checking.
