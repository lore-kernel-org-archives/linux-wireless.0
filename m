Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from twosheds.infradead.org ([90.155.92.209]:59357 "EHLO
	twosheds.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbbH0MEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 08:04:07 -0400
Message-ID: <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org> (sfid-20150827_140426_371701_2606131B)
In-Reply-To: <31228.1440671938@warthog.procyon.org.uk>
References: <20150826232622.GC8051@wotan.suse.de>
    <20150824210234.GI8051@wotan.suse.de>
    <476DC76E7D1DF2438D32BFADF679FC5601057D32@ORSMSX103.amr.corp.intel.com>
    <20150824225713.GJ8051@wotan.suse.de>
    <CAGXu5jLDHCgygaVNHpuvszN6SXNKAjRW83q3-D2ZfRpO4uAmdw@mail.gmail.com>
    <476DC76E7D1DF2438D32BFADF679FC5601058E78@ORSMSX103.amr.corp.intel.com>
    <CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
    <1440462367.2737.4.camel@linux.vnet.ibm.com>
    <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
    <1440464705.2737.36.camel@linux.vnet.ibm.com>
    <14540.1440599584@warthog.procyon.org.uk>
    <31228.1440671938@warthog.procyon.org.uk>
Date: Thu, 27 Aug 2015 10:57:23 -0000
Subject: Re: Linux Firmware Signing
From: "David Woodhouse" <dwmw2@infradead.org>
To: "David Howells" <dhowells@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>, dhowells@redhat.com,
	"Mimi Zohar" <zohar@linux.vnet.ibm.com>,
	"Andy Lutomirski" <luto@amacapital.net>,
	"Kees Cook" <keescook@chromium.org>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	"Vitaly Kuznetsov" <vkuznets@redhat.com>,
	"Paul Moore" <paul@paul-moore.com>,
	"Eric Paris" <eparis@parisplace.org>, selinux@tycho.nsa.gov,
	"Stephen Smalley" <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"Dmitry Kasatkin" <dmitry.kasatkin@gmail.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	"Peter Jones" <pjones@redhat.com>, "Takashi Iwai" <tiwai@suse.de>,
	dwmw2@infradead.org, "Ming Lei" <ming.lei@canonical.com>,
	"Joey Lee" <jlee@suse.de>,
	=?utf-8?B?IlZvanTEm2NoIFBhdmzDrWsi?= <vojtech@suse.com>,
	"Kyle McMartin" <kyle@kernel.org>,
	"Seth Forshee" <seth.forshee@canonical.com>,
	"Matthew Garrett" <mjg59@srcf.ucam.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

See http://www.infradead.org/rpr.html


> Luis R. Rodriguez <mcgrof@suse.com> wrote:
>
>> "PKCS#7: Add an optional authenticated attribute to hold firmware name"
>> https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=fwsign-pkcs7&id=1448377a369993f864915743cfb34772e730213good
>>
>>         1.3.6.1.4.1.2312.16     Linux kernel
>>         1.3.6.1.4.1.2312.16.2   - PKCS#7/CMS SignerInfo attribute types
>>         1.3.6.1.4.1.2312.16.2.1   - firmwareName
>>
>> I take it you are referring to this?
>
> Yes.
>
>> If we follow this model we'd then need something like:
>>
>>         1.3.6.1.4.1.2312.16.2.2   - seLinuxPolicyName
>>
>> That should mean each OID that has different file names would need to be
>> explicit about and have a similar entry on the registry. I find that
>> pretty
>> redundant and would like to avoid that if possible.
>
> firmwareName is easy for people to understand - it's the name the kernel
> asks
> for and the filename of the blob.  seLinuxPolicyName is, I think, a lot
> more
> tricky since a lot of people don't use SELinux, and most that do don't
> understand it (most people that use it aren't even really aware of it).
>
> If you can use the firmwareName as the SELinux/LSM key, I would suggest
> doing
> so - even if you dress it up as a path (/lib/firmware/<firmwareName>).
>
> David
>

In conversation with Mimi last week she was very keen on the model where
we load modules & firmware in such a fashion that the kernel has access to
the original inode -- by passing in a f2f, or in the firmware case by
doing the rd lookup directly. So surely you have all the SELinux labelling
you need?

-- 
dwmw2

