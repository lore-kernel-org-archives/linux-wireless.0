Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:41880 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdJCF1W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 01:27:22 -0400
Date: Tue, 3 Oct 2017 13:26:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andy Lutomirski <luto@kernel.org>
Cc: Jia-Ju Bai <baijiaju1990@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, vyasevich@gmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] Fix a sleep-in-atomic bug in shash_setkey_unaligned
Message-ID: <20171003052643.GB22750@gondor.apana.org.au> (sfid-20171003_072726_444820_8E271EFF)
References: <1506997522-26684-1-git-send-email-baijiaju1990@163.com>
 <CALCETrWdXjTTTywbb3duCEsLYNxkeGx7bf3SM4PYKeErCyiUNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALCETrWdXjTTTywbb3duCEsLYNxkeGx7bf3SM4PYKeErCyiUNQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 02, 2017 at 09:18:24PM -0700, Andy Lutomirski wrote:
> > On Oct 2, 2017, at 7:25 PM, Jia-Ju Bai <baijiaju1990@163.com> wrote:
> >
> > The SCTP program may sleep under a spinlock, and the function call path is:
> > sctp_generate_t3_rtx_event (acquire the spinlock)
> >  sctp_do_sm
> >    sctp_side_effects
> >      sctp_cmd_interpreter
> >        sctp_make_init_ack
> >          sctp_pack_cookie
> >            crypto_shash_setkey
> >              shash_setkey_unaligned
> >                kmalloc(GFP_KERNEL)
> 
> I'm going to go out on a limb here: why on Earth is out crypto API so
> full of indirection that we allocate memory at all here?

The crypto API operates on a one key per-tfm basis.  So normally
tfm allocation and key setting is done once only and not done on
the data path.

I have looked at the SCTP code and it appears to fit this paradigm.
That is, we should be able to allocate the tfm and set the key when
the key is actually generated via get_random_bytes, rather than every
time the key is used which is not only a waste but as you see runs
into API issues.

Usually if you're invoking setkey from a non-sleeping code-path
you're probably doing something wrong.

As someone else noted recently, there is no single forum for
reviewing code that uses the crypto API so buggy code like this
is not surprising.

> We're synchronously computing a hash of a small amount of data using
> either HMAC-SHA1 or HMAC-SHA256 (determined at runtime) if I read it
> right.  There's a sane way to do this that doesn't need kmalloc,
> alloca, or fancy indirection.  And then there's crypto_shash_xyz().

There are some legitimate cases where you want to use a different
key for every hashing operation.  But so far these are uses have
been very few so there has been no need to provide an API for them.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
