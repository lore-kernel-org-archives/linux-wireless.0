Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33592 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbETB3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 21:29:44 -0400
Received: by lagr1 with SMTP id r1so51025101lag.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 18:29:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432084019.4510.242.camel@linux.vnet.ibm.com>
References: <20150519200232.GM23057@wotan.suse.de> <1432072117.4510.180.camel@linux.vnet.ibm.com>
 <20150519221902.GQ23057@wotan.suse.de> <1432078625.4510.207.camel@linux.vnet.ibm.com>
 <CAB=NE6WZ8YW=C7a=MWgMS4T6Nmgs1NcKKsUY6XPtPC9B4JZu=Q@mail.gmail.com> <1432084019.4510.242.camel@linux.vnet.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 19 May 2015 18:29:22 -0700
Message-ID: <CALCETrU_Jw0diMneXo8+OQTwp4=Ta3NbU2jYapkipimxMCWgjw@mail.gmail.com> (sfid-20150520_033000_879195_E68469AF)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	James Morris <james.l.morris@oracle.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 6:06 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Tue, 2015-05-19 at 17:22 -0700, Luis R. Rodriguez wrote:
>> On Tue, May 19, 2015 at 4:37 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> > On Wed, 2015-05-20 at 00:19 +0200, Luis R. Rodriguez wrote:
>> >> On Tue, May 19, 2015 at 05:48:37PM -0400, Mimi Zohar wrote:
>> >> > On Tue, 2015-05-19 at 22:02 +0200, Luis R. Rodriguez wrote:
>
>> > In this case, not only is there a
>> > security hook, but the IMA hook exists as well.  To appraise firmware,
>> > add a line to the IMA policy containing "appraise func=FIRMWARE_CHECK".
>> > Similarly, to add a measurement to the measurement list, add a line to
>> > the IMA policy containing "measure func=FIRMWAE_CHECK".
>>
>> I have a series of reasons find IMA unsuitable for the current goals at hand:
>>
>>   1) IMA is a pretty big kitchen sink, we want this to work well for
>> even embedded systems, or architectures that do not have or require
>> TPMs
>
> There are different aspects to IMA.  One aspect is collecting file
> measurements and extending the TPM with those measurements.  The other
> aspect is appraising file integrity.  For that aspect, IMA-appraisal
> does not use a TPM.
>
>>   2) The appraisal is also done for to account for a specific state of
>> affairs, you appraise to the user of the integrity of the system at a
>> specific point in time,
>
> True, IMA can be used to attest to the integrity of a system.
>
>>  firmware signing can provide integrity /
>> authorship vetting of files directly from the authors.
>
> It can also be used to appraise the integrity of a file, be it an
> executable, a kernel module, configuration file or firmware in a
> consistent manor, based on a file hash or signature.
>
>> In the case of
>> regulatory.bin that was the whole point of it, and firmware signing as
>> is being provided is intended to generalize that but by sharing code
>> in-kernel with module signing infrastructure
>
> The underlying code used to verify the file signatures is the same.
> The difference being where/how the file signatures are stored and which
> keys to trust.
>
>> I am in hopes some others might be able to chime in more on point 2) here.
>>
>> Don't get me wrong IMA is nice, but its a big chunky requirement to
>> have, more than what module signing provides and what it requires
>> today to replace subsystem file signing requirements.
>
>> Now, LSM hooks -- that's more aligned with something we can start IMHO
>> reasonably arguing we should shift module signing code to be punted
>> into. But I've heard stories of LSM having issues with some virtual
>> environments, and LSM stacking is also pretty new, and IMHO that'd be
>> one way to compartmentalize all this module signing code. IMHO that
>> *should happen* but can only be taken seriously once LSM stacking is
>> merged in and baked. Its not, but I'm excited for it.
>
> Have you even looked at IMA-appraisal?

I just looked extremely briefly.  It seems to be much simpler than the
PKCS#7 thing.  OTOH, it seems to hardcode some rather scary
assumptions that it's using RSA in digsig_asymmetric.c, specifically:

        pks.rsa.s = mpi_read_raw_data(hdr->sig, siglen);

This bit in ima_appraise_measurement ignores trailing junk.  Why?

                if (xattr_len - sizeof(xattr_value->type) - hash_start >=
                                iint->ima_hash->length)
                        /* xattr length may be longer. md5 hash in previous
                           version occupied 20 bytes in xattr, instead of 16
                         */
                        rc = memcmp(&xattr_value->digest[hash_start],
                                    iint->ima_hash->digest,
                                    iint->ima_hash->length);

I got confused around here:

                        /* Replace RSA with HMAC if not mounted readonly and
                         * not immutable
                         */
                        if (!IS_RDONLY(dentry->d_inode) &&
                            !IS_IMMUTABLE(dentry->d_inode))
                                evm_update_evmxattr(dentry, xattr_name,
                                                    xattr_value,
                                                    xattr_value_len);

Huh?

Anyway, AFAICT IMA is about tracking the integrity of an FS that's
being actively modified, not about distributing signed things.  Also,
I couldn't spot what part of IMA detects an attacker replacing one
signed file with a different one from the same filesystem but a
different name.

--Andy
