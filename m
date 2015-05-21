Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp104.biz.mail.bf1.yahoo.com ([98.139.221.63]:35775 "EHLO
	smtp104.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbbEUXWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 19:22:07 -0400
Message-ID: <555E670C.6080901@schaufler-ca.com> (sfid-20150522_012235_143431_1964BE89)
Date: Thu, 21 May 2015 16:15:24 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	LSM List <linux-security-module@vger.kernel.org>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	James Morris <james.l.morris@oracle.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Michal Marek <mmarek@suse.cz>,
	Abelardo Ricart III <aricart@memnix.com>,
	Sedat Dilek <sedat.dilek@gmail.com>, keyrings@linux-nfs.org,
	Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
References: <20150519200232.GM23057@wotan.suse.de> <555BA438.2070802@kernel.org> <CAGRGNgX5h7mPyE93DEjEOuSdJUocBjHJacntnje9h02u7=5AMw@mail.gmail.com> <CALCETrX1YrdwfPJxVbzE0MQK=HChK8sDztt6MZcJiCvTEDCn7Q@mail.gmail.com> <20150520003917.GV23057@wotan.suse.de> <CALCETrVpwvpeGD=3iDw_2cTPfnvLsasMT2OV4jcE1bRs5cgDuA@mail.gmail.com> <20150521222626.GI23057@wotan.suse.de>
In-Reply-To: <20150521222626.GI23057@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/21/2015 3:26 PM, Luis R. Rodriguez wrote:
> On Tue, May 19, 2015 at 05:41:37PM -0700, Andy Lutomirski wrote:
>> On Tue, May 19, 2015 at 5:39 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>>> On Tue, May 19, 2015 at 04:42:05PM -0700, Andy Lutomirski wrote:
>>>> On Tue, May 19, 2015 at 4:30 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>>>>> Hi All,
>>>>>
>>>>> On Wed, May 20, 2015 at 6:59 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>>>>> [added cc's from the other thread]
>>>>>>
>>>>>> On 05/19/2015 01:02 PM, Luis R. Rodriguez wrote:
>>>>>>> David Howells has posted v4 of his series of supporting PKCS#7 for module
>>>>>>> signing. I'm in my v3 series now on RFCs for firmware PKCS#7 support, and
>>>>>>> after
>>>>>>> some review and patch shuffling I think this is ready for patch form.  My
>>>>>>> own
>>>>>>> series however depend on quite a bit of other pending changes, one series
>>>>>>> which
>>>>>>> will go through Rusty's tree, another series of fixes on firmware_class
>>>>>>> which
>>>>>>> should go through Greg's tree. I'll wait until all this and David's own
>>>>>>> patches
>>>>>>> get merged before posting firmware PKCS#7 support. Before all this though
>>>>>>> in
>>>>>>> preparation for fw signing one thing we should start to talk about more
>>>>>>> broadly
>>>>>>> however is how linux-firmware binary file signing would work in practice
>>>>>>> and
>>>>>>> what we need, and make sure folks are OK with all this.
>>>>>>>
>>>>>>> First, firmware signing will be completely optional as with module
>>>>>>> signing.
>>>>>>>
>>>>>> ...
>>>>>>
>>>>>>> Other than this last nitpick, any other concerns or recommendations ?
>>>>>>
>>>>>> A couple.  Some of these are general concerns with the existing
>>>>>> infrastructure, but #1 is a specific problem that gets much worse if we add
>>>>>> firmware signing.  Feel free to ignore 2-4.
>>>>>>
>>>>>> 1. We should get the signature semantics right.  I think that, for modules,
>>>>>> we currently sign literally the module payload.  For modules, in my
>>>>>> semi-amateurish crypto universe [1], this is fine *as long as the key in
>>>>>> question is used for no other purpose*.  For firmware, it's dangerous, since
>>>>>> it would be vulnerable to substitution attacks in which the adversary
>>>>>> convinces us to interpret one firmware file as firmware for another device
>>>>>> or purpose entirely.
>>>>>>
>>>>>> We should be signing something that's semantically equivalent to "This is a
>>>>>> valid module: xyz", "This is a valid 'regulatory.bin': xyz", or "This is a
>>>>>> valid kexec image: xyz".
>>>>> Something that occurred to me (as a complete bystander) was: would it
>>>>> make sense to have keys able to be restricted to particular "types" of
>>>>> signable data? I.e. the key that can sign a valid regulatory.bin file
>>>>> cannot be used to sign a module or a kexec image. - This could remove
>>>>> the need to have multiple keyrings. (Also, UEFI keys unless otherwise
>>>>> tagged could be restricted to only signing bootloaders or kernels)
>>>> Seems sensible to me.
>>> As for having keys for fw signing be specific to fw data without a keyring,
>>> if that is desirable I think we can devise a way to do that. For instance
>>> if we wanted to we can have FW_SIG by default trust first keys on
>>> system_trusted_keyring just as module signature works -- or if we wanted to
>>> just trust, say a Kyle key. Not sure if the later is possible yet, but htat
>>> would require some changes. Then as an evolution if we wanted to enable a
>>> specific request fw to be mapped to a specific fw file the new APIs I was
>>> looking to add could easily enable this provided that we first decide we
>>> do want to trust say one key perhaps not on system_trusted_keyring for fw
>>> signing. That'd need to be decided first.
>>>
>>> As for the UEFI stuff -- from what I gather its too late there. We could
>>> certainly go with something else for fw signing though, just lemme hear it
>>> hard and clear.
>>>
>>>> FWIW, I'm starting to think that UEFI-based validation of kexec images
>>>> should be totally separate.  It uses a nasty PE format with a hideous
>>>> PKCS #7 formatted signature.  Maybe that should be a completely
>>>> separate piece of code.
>>> LSM'ify it I guess? Again, if that's reasonable then I think we'll need
>>> stacking and that's still not merged.
>> Isn't stacking backwards for this, though?  The semantics we'd want is
>> accept if any verifiers accept, not accept if all verifiers accept,
>> right?
> That can be added, and if stacking is not yet merged perhaps Casey can
> consider it?

So long as the net result coming out of an module is a yes/no answer,
and so long as you're not using any of the security blobs there's no
reason you can't stack exactly like Yama. Within your module you can
enforce an aggressive grant policy if you like, returning -EACCES only
if all your verifiers fail.


>
>   Luis
>

