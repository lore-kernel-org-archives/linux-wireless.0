Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36179 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbbH0XqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 19:46:11 -0400
Received: by oibi18 with SMTP id i18so15873854oib.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 16:46:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150827193605.GD8051@wotan.suse.de>
References: <20150824225713.GJ8051@wotan.suse.de>
	<CAGXu5jLDHCgygaVNHpuvszN6SXNKAjRW83q3-D2ZfRpO4uAmdw@mail.gmail.com>
	<476DC76E7D1DF2438D32BFADF679FC5601058E78@ORSMSX103.amr.corp.intel.com>
	<CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
	<1440462367.2737.4.camel@linux.vnet.ibm.com>
	<CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
	<1440464705.2737.36.camel@linux.vnet.ibm.com>
	<14540.1440599584@warthog.procyon.org.uk>
	<20150826232622.GC8051@wotan.suse.de>
	<CAHC9VhR9z2WVp+Q1hBkr5jduAH-J1DW12-k7U1eaQGgrP4c1Yw@mail.gmail.com>
	<20150827193605.GD8051@wotan.suse.de>
Date: Thu, 27 Aug 2015 19:46:09 -0400
Message-ID: <CAHC9VhRj4dRGVz9RmjxC9xsV_anKS+LHUW8f2UZ4H63N5J89Jw@mail.gmail.com> (sfid-20150828_014629_124434_5F53A26D)
Subject: Re: Linux Firmware Signing
From: Paul Moore <paul@paul-moore.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Eric Paris <eparis@parisplace.org>, selinux@tycho.nsa.gov,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	dwmw2@infradead.org, Ming Lei <ming.lei@canonical.com>,
	Joey Lee <jlee@suse.de>,
	=?UTF-8?B?Vm9qdMSbY2ggUGF2bMOtaw==?= <vojtech@suse.com>,
	Gary Ching-Pang Lin <glin@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2015 at 3:36 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Wed, Aug 26, 2015 at 10:35:19PM -0400, Paul Moore wrote:
>> On Wed, Aug 26, 2015 at 7:26 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> > On Wed, Aug 26, 2015 at 03:33:04PM +0100, David Howells wrote:
>> > Now let's review the SELinux stuff before we jump back into firmware / system
>> > data stuff again as there is a joint criteria to consider for all of these.
>> > For other people's refrence the enum you quote above was added through your
>> > patch pending on linux-next:
>> >
>> > "PKCS#7: Appropriately restrict authenticated attributes and content type"
>> >
>> > Based on what Roberts seems to want to do for SELinux policy files it would
>> > seems we may also need VERIFYING_SELINUX_POLICY. SELinux policy loading is
>> > unique in the at it uses its own fs and uses a load trigger node (sel_load_ops)
>> > to kick off  security_load_policy(data, count), so its not exactly a
>> > yet-another-API to read arbitrary files from the file system. Its policy files
>> > are also very distribution specific. Because of all this its not really
>> > suitable for /lib/firmware/ or sharing code even futher. It seems its a prime
>> > candidate already to make use of the system_verify_data() APIs you added David,
>> > provided the items below are taken care of as well.
>>
>> One thing to keep in mind is that not only are SELinux policy files
>> distribution specific, they are machine specific as administrators
>> can, and do, customize the policy for their usage.  I really like the
>> idea of providing signed SELinux policies to the kernel but I question
>> how practical it will be for normal users/admins.
>
> Yeah that makes it harder. Possible but harder.
>
>> Some of the Machine Owner Key (MOK) work would likely be necessary for
>> signed SELinux policies to be even remotely practical.
>
> Matthew, Peter and Gary are Cc'd, so they can feel free to chime in.
>
> There are other alternatives as well:
>
>  * Is there wide use of SELinux + IMA ? If so that may be another option.

I'm not aware of any large scale use of SELinux+IMA, although it is
doubtful that IMA will be of use for protecting the SELinux policy
since it is written into the kernel, the kernel doesn't load it
directly.  There is also the issue that the SELinux userspace tends to
manipulate the policy such that the blob that is written into the
kernel isn't the same blob that is read from disk.

I imagine one could use IMA to protect the SELinux policy store, but
that isn't the same as protecting the binary security policy that is
written to the kernel.

-- 
paul moore
www.paul-moore.com
