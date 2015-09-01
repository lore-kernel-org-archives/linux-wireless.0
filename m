Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33314 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbbIAUq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 16:46:57 -0400
Received: by pary6 with SMTP id y6so2101868par.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2015 13:46:56 -0700 (PDT)
Message-ID: <55E60EAC.5010602@quarksecurity.com> (sfid-20150901_224749_042623_DB0E3B41)
Date: Tue, 01 Sep 2015 16:46:36 -0400
From: Joshua Brindle <brindle@quarksecurity.com>
MIME-Version: 1.0
To: "Roberts, William C" <william.c.roberts@intel.com>
CC: Paul Moore <paul@paul-moore.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>,
	David Howells <dhowells@redhat.com>,
	Peter Jones <pjones@redhat.com>,
	"selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Kees Cook <keescook@chromium.org>,
	=?UTF-8?B?Vm9qdGVjaCBQYXZsw61r?= <vojtech@suse.com>,
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
References: <1440462367.2737.4.camel@linux.vnet.ibm.com> <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com> <1440464705.2737.36.camel@linux.vnet.ibm.com> <14540.1440599584@warthog.procyon.org.uk> <31228.1440671938@warthog.procyon.org.uk> <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org> <20150827212907.GF8051@wotan.suse.de> <CAHC9VhQFDcMtvn1JU3E1rJ=9CCXT7ibUocgGS4tzfcy8oVUUMA@mail.gmail.com> <476DC76E7D1DF2438D32BFADF679FC560105ABD6@ORSMSX103.amr.corp.intel.com> <CAHC9VhRF-39ZbwawkM-aR+th2nRPEVF9-nR1NEHDPDmakpt4FQ@mail.gmail.com> <20150829020301.GM8051@wotan.suse.de> <CAHC9VhTTRr7N2bqU-7jm2oG72t5wgqH_SmXk4icqs3h3_=EMzg@mail.gmail.com> <55E5B257.6070205@quarksecurity.com> <476DC76E7D1DF2438D32BFADF679FC560105E5D3@ORSMSX103.amr.corp.intel.com>
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC560105E5D3@ORSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roberts, William C wrote:
>> From: owner-linux-security-module@vger.kernel.org [mailto:owner-linux-
>> security-module@vger.kernel.org] On Behalf Of Joshua Brindle
>> Sent: Tuesday, September 1, 2015 7:13 AM
>> To: Paul Moore
>> Cc: Luis R. Rodriguez; Takashi Iwai; Ming Lei; David Howells; Peter Jones;
>> selinux@tycho.nsa.gov; Schaufler, Casey; Stephen Smalley; Matthew Garrett;
>> Kees Cook; Vojtech Pavlík; Seth Forshee; james.l.morris@oracle.com; Dmitry
>> Kasatkin; Johannes Berg; Joey Lee; Kyle McMartin; linux-
>> wireless@vger.kernel.org; linux-kernel@vger.kernel.org; Andy Lutomirski; linux-
>> security-module@vger.kernel.org; Greg Kroah-Hartman; Vitaly Kuznetsov; David
>> Woodhouse
>> Subject: Re: Linux Firmware Signing
>>
>> Paul Moore wrote:
>> <snip>
>>> Yes, there are lots of way we could solve the signed policy format
>>> issue, I just don't have one in mind at this moment.  Also, to be
>>> honest, there are enough limitations to signing SELinux policies that
>>> this isn't very high onmy personal SELinux priority list.
>
> Yes I would say this is low on my end. Especially if we can kill off
> Reloadable policy support on Android, my need for this goes away 100%.
>

I'm not sure who "we" is as you are the only person I've heard 
advocating for removing that support.

>> The fact that there are so many userspace specific parts of the policy that never
>> make it into the kernel precludes any meaningful verification anyway.
>
> Yes and no. On Android, if I was able to load a policy I could grant myself capabilities that
> We're not possible via the userspace portions, i.e. relabeling, etc. Granted, not checking the
> userspace portions Is not great. In an ideal world, everything is checked. However, the main
> reason to doing it in the kernel is where you want your trust to be. For instance, If I trust that
> userspace Loader, then I need to trust that + the kernel. In the case of verifying the policy signature
> In the kernel, I need to trust only the kernel.

Especially on Android, userspace files are very important. Changing 
seapp_contexts or property_contexts can easily get you a privilege 
escalation to let you do whatever. Checking only the kernel binary is a 
half-solution and should not even be considered.

>
> As far as the desktop environment, I claim ignorance and have no input there.
>
>> And SELinux already has a mechanism for raising the integrity of a process to do
>> things like signature checking in userspace, the domain transition. If someone
>> wants validation of the SELinux policy they just need to eliminate every domains
>> ability to load policy except for a trusted policy loader that does signature
>> checking.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html

