Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37324 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbbICVOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 17:14:19 -0400
Received: by igbni9 with SMTP id ni9so1882421igb.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2015 14:14:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150902213717.GJ8051@wotan.suse.de>
References: <1440464705.2737.36.camel@linux.vnet.ibm.com>
	<14540.1440599584@warthog.procyon.org.uk>
	<31228.1440671938@warthog.procyon.org.uk>
	<36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
	<20150827212907.GF8051@wotan.suse.de>
	<CAGXu5jKF6CBAADoybZHRCzYAepcZYqpbck1gTAeV1p7iuOVAvw@mail.gmail.com>
	<20150902000915.GW8051@wotan.suse.de>
	<1441164905.17898.86.camel@linux.vnet.ibm.com>
	<20150902184604.GB8051@wotan.suse.de>
	<CAGXu5jKGbb3M-qhodp1DVzhxn3ckae+mD9_HBNp2PdVHXb893A@mail.gmail.com>
	<20150902213717.GJ8051@wotan.suse.de>
Date: Thu, 3 Sep 2015 14:14:18 -0700
Message-ID: <CAGXu5jLCNaBd8GsVwCn_9jqnz247X6wG1dqyaSsLbc9DQ05kXQ@mail.gmail.com> (sfid-20150903_231424_827731_D0DC5EDC)
Subject: Re: Linux Firmware Signing
From: Kees Cook <keescook@chromium.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@parisplace.org>,
	SE Linux <selinux@tycho.nsa.gov>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>, Joey Lee <jlee@suse.de>,
	=?UTF-8?B?Vm9qdMSbY2ggUGF2bMOtaw==?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[removed bounced email addresses]

On Wed, Sep 2, 2015 at 2:37 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Wed, Sep 02, 2015 at 01:54:43PM -0700, Kees Cook wrote:
>> On Wed, Sep 2, 2015 at 11:46 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> > On Tue, Sep 01, 2015 at 11:35:05PM -0400, Mimi Zohar wrote:
>> >> > OK great, I think that instead of passing the actual routine name we should
>> >> > instead pass an enum type for to the LSM, that'd be easier to parse and we'd
>> >> > then have each case well documented. Each LSM then could add its own
>> >> > documetnation for this and can switch on it. If we went with a name we'd have
>> >> > to to use something like __func__ and then parse that, its not clear if we need
>> >> > to get that specific.
>> >>
>> >> Agreed.  IMA already defines an enumeration.
>> >>
>> >> /* IMA policy related functions */
>> >> enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK,
>> >>                  FIRMWARE_CHECK, POLICY_CHECK, POST_SETATTR };
>> >>
>> >
>> > We want something that is not only useful for IMA but any other LSM,
>> > and FILE_CHECK seems very broad, not sure what BPRM_CHECK is even upon
>> > inspecting kernel code. Likewise for POST_SETATTR. POLICY_CHECK might
>> > be broad, perhaps its best we define then a generic set of enums to
>> > which IMA can map them to then and let it decide. This would ensure
>> > that the kernel defines each use caes for file inspection carefully,
>> > documents and defines them and if an LSM wants to bunch a set together
>> > it can do so easily with a switch statement to map set of generic
>> > file checks in kernel to a group it already handles.
>> >
>> > For instance at least in the short term we'd try to unify:
>> >
>> > security_kernel_fw_from_file()
>> > security_kernel_module_from_file()
>> >
>> > to perhaps:
>> >
>> > security_kernel_from_file()
>> >
>> > As far, as far as I can tell, the only ones we'd be ready to start
>> > grouping immediately or with small amount of work rather soon:
>> >
>> > /**
>> >  *
>> >  * enum security_filecheck - known kernel security file checks types
>> >  *
>> >  * @__SECURITY_FILECHECK_UNSPEC: attribute 0 reserved
>> >  * @SECURITY_FILECHECK_MODULE: the file being processed is a Linux kernel module
>> >  * @SECURITY_FILECHECK_SYSDATA: the file being processed is either a firmware
>> >  *      file or a system data file read from /lib/firmware/* by firmware_class
>>
>> I'd prefer a distinct category for firmware, as it carries an
>> implication that it is an executable blob of some sort (I know not all
>> are, though).
>
> The ship has sailed in terms of folks using frimrware API for things
> that are not-firmware per se. The first one I am aware of was the
> EEPROM override for the p54 driver. The other similar one was CPU
> microcode, but that's a bit more close to home with "firmware". We
> could ask users on the new system data request API I am building
> to describe the type of file being used, as I agree differentiating
> this for security purposes might be important. So other than just
> file type we could have sub type category, then we could have,
>
> SECURITY_FILECHECK_SYSDATA, and then:

I object to executable code being called data. :)

> SECURITY_FILE_SYSDATA_FW
> SECURITY_FILE_SYSDATA_MICROCODE
> SECURITY_FILE_SYSDATA_EEPROM
> SECURITY_FILE_SYSDATA_POLICY (for 802.11 regulatory I suppose)

The exception to the firmware loading is data, so the primary name
should be firmware. Regardless, if we want distinct objects, just name
them:

SECURITY_FILE_FIRMWARE
SECURITY_FILE_SYSDATA

Do we need finer-grain sub types?

>
> If we do this then we could juse have:
>
> SECURITY_FILECHECK_KEXEC and on that have substypes:
>
> SECURITY_FILE_KEXEC_KERNEL
> SECURITY_FILE_KEXEC_INITRAMFS
>
> Would that be desirable and help grow this to be easily extensible?
>
>   Luis

-Kees

-- 
Kees Cook
Chrome OS Security
