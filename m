Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35312 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbbESXm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 19:42:27 -0400
Received: by labbd9 with SMTP id bd9so49224717lab.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 16:42:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgX5h7mPyE93DEjEOuSdJUocBjHJacntnje9h02u7=5AMw@mail.gmail.com>
References: <20150519200232.GM23057@wotan.suse.de> <555BA438.2070802@kernel.org>
 <CAGRGNgX5h7mPyE93DEjEOuSdJUocBjHJacntnje9h02u7=5AMw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 19 May 2015 16:42:05 -0700
Message-ID: <CALCETrX1YrdwfPJxVbzE0MQK=HChK8sDztt6MZcJiCvTEDCn7Q@mail.gmail.com> (sfid-20150520_014245_361538_B0FF0542)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	LSM List <linux-security-module@vger.kernel.org>,
	James Morris <james.l.morris@oracle.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Michal Marek <mmarek@suse.cz>,
	Abelardo Ricart III <aricart@memnix.com>,
	Sedat Dilek <sedat.dilek@gmail.com>, keyrings@linux-nfs.org,
	Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 4:30 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi All,
>
> On Wed, May 20, 2015 at 6:59 AM, Andy Lutomirski <luto@kernel.org> wrote:
>> [added cc's from the other thread]
>>
>> On 05/19/2015 01:02 PM, Luis R. Rodriguez wrote:
>>>
>>> David Howells has posted v4 of his series of supporting PKCS#7 for module
>>> signing. I'm in my v3 series now on RFCs for firmware PKCS#7 support, and
>>> after
>>> some review and patch shuffling I think this is ready for patch form.  My
>>> own
>>> series however depend on quite a bit of other pending changes, one series
>>> which
>>> will go through Rusty's tree, another series of fixes on firmware_class
>>> which
>>> should go through Greg's tree. I'll wait until all this and David's own
>>> patches
>>> get merged before posting firmware PKCS#7 support. Before all this though
>>> in
>>> preparation for fw signing one thing we should start to talk about more
>>> broadly
>>> however is how linux-firmware binary file signing would work in practice
>>> and
>>> what we need, and make sure folks are OK with all this.
>>>
>>> First, firmware signing will be completely optional as with module
>>> signing.
>>>
>>
>> ...
>>
>>> Other than this last nitpick, any other concerns or recommendations ?
>>
>>
>> A couple.  Some of these are general concerns with the existing
>> infrastructure, but #1 is a specific problem that gets much worse if we add
>> firmware signing.  Feel free to ignore 2-4.
>>
>> 1. We should get the signature semantics right.  I think that, for modules,
>> we currently sign literally the module payload.  For modules, in my
>> semi-amateurish crypto universe [1], this is fine *as long as the key in
>> question is used for no other purpose*.  For firmware, it's dangerous, since
>> it would be vulnerable to substitution attacks in which the adversary
>> convinces us to interpret one firmware file as firmware for another device
>> or purpose entirely.
>>
>> We should be signing something that's semantically equivalent to "This is a
>> valid module: xyz", "This is a valid 'regulatory.bin': xyz", or "This is a
>> valid kexec image: xyz".
>
> Something that occurred to me (as a complete bystander) was: would it
> make sense to have keys able to be restricted to particular "types" of
> signable data? I.e. the key that can sign a valid regulatory.bin file
> cannot be used to sign a module or a kexec image. - This could remove
> the need to have multiple keyrings. (Also, UEFI keys unless otherwise
> tagged could be restricted to only signing bootloaders or kernels)

Seems sensible to me.

FWIW, I'm starting to think that UEFI-based validation of kexec images
should be totally separate.  It uses a nasty PE format with a hideous
PKCS #7 formatted signature.  Maybe that should be a completely
separate piece of code.

>
> Also, are multiple signatures a sensible thing? E.g. regulatory.bin
> gets signed by Seth, then Kyle, then $DISTRO and any one key is enough
> to validate it.

That might further complicate matters.

--Andy
