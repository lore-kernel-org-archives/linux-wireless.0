Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34983 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbbEUQ4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:56:05 -0400
Received: by labbd9 with SMTP id bd9so107997606lab.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 09:56:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150521165101.GI18164@localhost>
References: <20150519200232.GM23057@wotan.suse.de> <555BA438.2070802@kernel.org>
 <20150519221128.GP23057@wotan.suse.de> <9567.1432223509@warthog.procyon.org.uk>
 <CALCETrX3krCsqCLvLYx1QdnjFK=R8FF7ta=vozDcGYSTUHvSrA@mail.gmail.com> <20150521165101.GI18164@localhost>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 21 May 2015 09:55:42 -0700
Message-ID: <CALCETrU3biPZEY4hxPfUavNUP1EmBeT2H2tSfiCXw+NJmxoYqg@mail.gmail.com> (sfid-20150521_185625_802966_B4780479)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
To: Andy Lutomirski <luto@amacapital.net>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>, Joey Lee <jlee@suse.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Kyle McMartin <kyle@kernel.org>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	LSM List <linux-security-module@vger.kernel.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Michal Marek <mmarek@suse.cz>,
	Seth Forshee <seth.forshee@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	David Woodhouse <david.woodhouse@intel.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	James Morris <james.l.morris@oracle.com>,
	keyrings@linux-nfs.org, Abelardo Ricart III <aricart@memnix.com>,
	"Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2015 at 9:51 AM, Petko Manolov <petkan@mip-labs.com> wrote:
> On 15-05-21 09:39:50, Andy Lutomirski wrote:
>>
>> It's also a performance cost because the average user of this signature stuff
>> doesn't actually want IMA, and IMA is checking the wrong think anyway.
>> IMA/EVM tells us "this file validly belongs in /lib/modules/whatever according
>> to whomever we trust for the filesystem".  We want to check "is this data,
>> regardless of where it was read from, a trusted module".
>
> IMA-appraise does not care where the file comes from (although it may be
> persuaded to) and verifies file's data and meta-data against a signature.  I
> guess you should actually read the code. :)
>

I read plenty of the code.  I said "data" not "file" for a reason.
I'll quote some code:

int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
                             struct file *file, const unsigned char *filename,
                             struct evm_ima_xattr_data *xattr_value,
                             int xattr_len, int opened)

There is no struct file in init_module.

{
        static const char op[] = "appraise_data";
        char *cause = "unknown";
        struct dentry *dentry = file->f_path.dentry;
        struct inode *inode = dentry->d_inode;
        enum integrity_status status = INTEGRITY_UNKNOWN;
        int rc = xattr_len, hash_start = 0;

        if (!inode->i_op->getxattr)
                return INTEGRITY_UNKNOWN;

Even for finit_module, which does have a struct file, there is
absolutely no reason to require that the file's inode has a getxattr
operation.

I maintain my claim that IMA is not appropriate for module signing in
general.  It might make sense for the kind of thing that Chromium does
(approving of modules using finit_module based on their source instead
of their payload and verifying the payload indirectly using IMA or
dm-verity), but that's not the problem that David and Luis are trying
to solve.

Also, especially for firmware on regular distros, IMA is ridiculous.
IIRC there is no general support for xattrs in initramfs, and there is
no reason to start requiring such support just to allow firmware to
live in initramfs.

I think that using IMA for this has a similar problem to using PKCS#7:
it's a big hammer that is much more complex than necessary to solve
the problem at hand.

--Andy
