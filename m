Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:36132 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbESWkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 18:40:25 -0400
Received: by lagv1 with SMTP id v1so47485024lag.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 15:40:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150519221128.GP23057@wotan.suse.de>
References: <20150519200232.GM23057@wotan.suse.de> <555BA438.2070802@kernel.org>
 <20150519221128.GP23057@wotan.suse.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 19 May 2015 15:40:03 -0700
Message-ID: <CALCETrWqu79S6V9GKoBbv7H3EtxRfh8bjYA3s8hQfEe1K9AiPg@mail.gmail.com> (sfid-20150520_004048_224896_161899F0)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	LSM List <linux-security-module@vger.kernel.org>,
	James Morris <james.l.morris@oracle.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
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

On Tue, May 19, 2015 at 3:11 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Tue, May 19, 2015 at 01:59:36PM -0700, Andy Lutomirski wrote:
>> [added cc's from the other thread]
>>
>> On 05/19/2015 01:02 PM, Luis R. Rodriguez wrote:
>> >David Howells has posted v4 of his series of supporting PKCS#7 for module
>> >signing. I'm in my v3 series now on RFCs for firmware PKCS#7 support, and after
>> >some review and patch shuffling I think this is ready for patch form.  My own
>> >series however depend on quite a bit of other pending changes, one series which
>> >will go through Rusty's tree, another series of fixes on firmware_class which
>> >should go through Greg's tree. I'll wait until all this and David's own patches
>> >get merged before posting firmware PKCS#7 support. Before all this though in
>> >preparation for fw signing one thing we should start to talk about more broadly
>> >however is how linux-firmware binary file signing would work in practice and
>> >what we need, and make sure folks are OK with all this.
>> >
>> >First, firmware signing will be completely optional as with module signing.
>> >
>>
>> ...
>>
>> >Other than this last nitpick, any other concerns or recommendations ?
>>
>> A couple.  Some of these are general concerns with the existing
>> infrastructure, but #1 is a specific problem that gets much worse if
>> we add firmware signing.  Feel free to ignore 2-4.
>>
>> 1. We should get the signature semantics right.  I think that, for
>> modules, we currently sign literally the module payload.  For
>> modules, in my semi-amateurish crypto universe [1], this is fine *as
>> long as the key in question is used for no other purpose*.
>
> Indeed, that's not the only issue. For instance I recently found out that
> system_trusted_keyring includes the keys under the UEFI key db, even though I
> cannot see how that is done. This does ultimately mean that if MS or vendors
> who have embedded keys on the UEFI key db get compromised their compromised key
> can be used to sign arbitrary modules / firmware themselves. As bad as that is
> I'm assured we can clear out the UEFI key db, so paranoid folks can do
> that. I however do not think that this issue on trusting the keys in
> the UEFI key db was readily known, or was it?.
>
>> For
>> firmware, it's dangerous, since it would be vulnerable to
>> substitution attacks in which the adversary convinces us to
>> interpret one firmware file as firmware for another device or
>> purpose entirely.
>
> Agreed fully and I'm glad you bring this up. As-is with today's firmware_class
> API we cannot allow custom keys if they are desired, but if we do want this we
> can easily make this happen. Just let me know. With the last set of patches I
> had developed my goal was to allow customizations by the callers on the key
> requirements. I had this planned out because regulatory.bin used its own simple
> RSA key with no x509 juju magic. I also envisioned it being easier for Kyle for
> instance to use his own PGP key to sign linux-firmware files to start off with
> than some complex x509 thing. Based on discussions with David, Seth, and Kyle
> though it seems we were going to be happy with trusting Kyle's key for regulatory.bin,
> since that will be done Kyle might as well sign all linux-firmware files and folks
> who trust that can use it. If we want to override it should be easy to later.
>
> For now then I'd be happy for us to start off with Kyle's key and
> since I am adding extensions to the firmware_class API to customize
> firmware signing requirements it should be fairly trivial to enable
> device drivers to say they want their own firmware to be signed with
> a specific key if they wanted that. I think that if we want this we
> should evolve to this though as I think the complexity should be
> optional.
>
>> We should be signing something that's semantically equivalent to
>> "This is a valid module: xyz", "This is a valid 'regulatory.bin':
>> xyz", or "This is a valid kexec image: xyz".
>
> Sure.
>
>> 2. Why on earth does the magic signing script reference things like
>> commonName?  Please keep X.509 silliness as far from the kernel as
>> possible.
>
> I asked the same thing. I'm hinted that Red Hat originally came up with PGP
> support for module signing and then someone asked for x509 to be used.  I was
> not aware of this so originally in my approach for firmware I was trying to
> target regular PGP keys. In my last review of the firmware patches I asked
> to see what folks preferred and it seems that the issue with supporting
> PGP for firmware and PKCS#7 for modules would be that we'd have different
> entry paths to support. That means complexity, etc. Another point raised
> was that we can convert PGP keys to x509 with gpgpsm, so if we really
> needed that we could go about it that way.
>
> I ended up being convinced that the simplicity over sharing code path for both
> module signing and firmware signing with the flexibility to be paranoid and
> using one own's PGP key and doing away with all possible evil-doers certs and
> practices would suffice those who do not even trust their own parents. That is
> of course unless using x509 stuff alone could jeopardize PGP keys... that'd
> be a big problem, of course.
>
>> 3. PKCS#1 v1.5, really?  PKCS#1 v1.5 is known to be insecure unless
>> very cafefully validated.  For example:
>>
>> https://www.imperialviolet.org/2014/09/26/pkcs1.html
>>
>> Could we please consider using a signature scheme with a security proof?
>
> I'm fine with going with some other alternative, now what do you have in mind?
> I'm in hopes David can chime in here as I'm just relying on what new thing we
> end up replacing for module signing.

RSA-PSS, ECDSA over P-256, or Ed25519.  The IRTF CFRG is expected to
publish an RFC for a modern signature scheme any day^Wmonth^Wyear now,
too.

>
> Ideally we want to have the option to pick and choose or just stick to one
> solution which we decide we'll vet for carefully for now.
>
>> 4. As hashed to death in another thread:
>
> "Hashed to death" is strong for something just discussed yesterday :)
>
>> http://lkml.kernel.org/g/555A88FB.7000809@kernel.org
>>
>> I think that the verifier should be a dynamically loadable thing.
>
> Did you just volunteeer?

Not intentionally.  It would be easy, though.  Hmm.

Also, good point about key purposes.  Sigh, more ways that the current
system is complicated and inflexible.

--Andy
