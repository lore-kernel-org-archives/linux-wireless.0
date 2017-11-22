Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:46283 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdKVS3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 13:29:04 -0500
Received: by mail-wm0-f45.google.com with SMTP id u83so12304604wmb.5
        for <linux-wireless@vger.kernel.org>; Wed, 22 Nov 2017 10:29:03 -0800 (PST)
Subject: Re: kernel BUG at crypto/asymmetric_keys/public_key.c:80
To: Florian Fainelli <f.fainelli@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
References: <d2b989b6-38cf-a04d-0353-3540fdb891ed@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2ef18f35-bb00-2f4b-45fe-1beb3cdd0745@broadcom.com> (sfid-20171122_192921_979381_B4952F6F)
Date: Wed, 22 Nov 2017 19:29:01 +0100
MIME-Version: 1.0
In-Reply-To: <d2b989b6-38cf-a04d-0353-3540fdb891ed@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Johannes

On 22-11-17 18:43, Florian Fainelli wrote:
> Hi,
> 
> (sorry for the cross post)
> 
> I am at v4.14-12995-g0c86a6bd85ff and just met the following, attached
> is my .config file. Is this a known problem? Thanks!
> 
> [    1.798714] cfg80211: Loading compiled-in X.509 certificates for
> regulatory database
> [    1.809390] ------------[ cut here ]------------
> [    1.814020] kernel BUG at crypto/asymmetric_keys/public_key.c:80!
> [    1.820123] Internal error: Oops - BUG: 0 [#1] SMP ARM
> [    1.825273] Modules linked in:
> [    1.828341] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 4.14.0-12995-g0c86a6bd85ff #15
> [    1.836096] Hardware name: Broadcom STB (Flattened Device Tree)
> [    1.842025] task: ee0a0000 task.stack: ee096000
> [    1.846576] PC is at public_key_verify_signature+0x21c/0x260
> [    1.852248] LR is at x509_check_for_self_signed+0xb0/0x10c
> [    1.857743] pc : [<c0525d08>]    lr : [<c0526ee8>]    psr: 60000013
> [    1.864019] sp : ee097cf8  ip : c0a7a3ae  fp : 00000000
> [    1.869252] r10: c248e9d8  r9 : c0b401e0  r8 : ee374040
> [    1.874487] r7 : c0a7a340  r6 : ee374200  r5 : c2404c48  r4 : edac8880
> [    1.881024] r3 : 00000000  r2 : c0b40480  r1 : ee3741c0  r0 : ee374040
> [    1.887563] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
> Segment user
> [    1.894709] Control: 30c5387d  Table: 00003000  DAC: fffffffd
> [    1.900465] Process swapper/0 (pid: 1, stack limit = 0xee096210)
> [    1.906481] Stack: (0xee097cf8 to 0xee098000)
> [    1.910845] 7ce0:
>    60000013 00000000
> [    1.919037] 7d00: 014080c0 c052149c 000011a0 c248e9d8 00000000
> c033dcb8 ee097d98 014000c0
> [    1.927229] 7d20: ffffffff 00000001 ed58622e c0a7a634 00000001
> ed58622e c0a7a634 c0521530
> [    1.935421] 7d40: c052143c ffffffff ed586200 00000000 00000000
> 00000000 c0518bc0 c248e9d8
> [    1.943612] 7d60: 00000000 c02416f8 c244bc28 00000000 ed586200
> ed586388 ed586384 60000013
> [    1.951804] 7d80: 00000000 c0b400d4 c0518bc0 c248e9d8 00000000
> c025de10 00000000 00000000
> [    1.959995] 7da0: 00000000 fffffffe fffffffe 00000000 00000000
> c0b400d4 c0518bc0 c0518c34
> [    1.968187] 7dc0: c0a23498 ee096000 00000000 00040e00 ee374302
> edac8880 edac8880 ee374200
> [    1.976378] 7de0: c0a7a340 000002a8 c0b401e0 c248e9d8 00000000
> c0526ee8 00000000 edac8880
> [    1.984569] 7e00: ee374200 c0525f24 c244d210 ee097e80 c248e9d8
> ee097e80 c244d1ac c0526b74
> [    1.992760] 7e20: c244d210 c244b988 c248e9d8 ee097e80 c244d1ac
> c0b401e0 c248e9d8 c0524f20
> [    2.000952] 7e40: c2404c48 c244b988 c0a7a340 edac8801 ee02c180
> edac8800 00000000 c0511148
> [    2.009143] 7e60: c24b7eda 00000048 60000013 00000000 00000000
> c244d1b4 00000000 00000000
> [    2.017335] 7e80: 00000000 00000000 00000000 00000000 00000000
> c0a7a340 000002a8 00000000
> [    2.025527] 7ea0: 7fffffff 00040e00 c0a7a340 c24df7b4 000002a8
> c0a7a5e8 c0bb10d8 c0b18088
> [    2.033718] 7ec0: 1f030000 c0e47898 000002a8 1f030000 0000000e
> 00000000 00000000 c2404c48
> [    2.041910] 7ee0: ffffe000 c0e4777c 00000000 c0e6583c c0e74f98
> 00000008 00000000 c0201bd8
> [    2.050101] 7f00: 60000013 c025dda4 00000000 c0c05a00 c0e005d8
> 00000000 00000000 00000007
> [    2.058292] 7f20: 00000007 00040e00 00000000 c240d790 00000000
> c2404c48 c0e65818 00000000
> [    2.066483] 7f40: 00000000 00040e00 00000000 00040e00 c24a3100
> c24a3100 c24a3100 00000109
> [    2.074675] 7f60: c0e65838 c0e6583c c0e74f98 c0e00e6c 00000007
> 00000007 00000000 c0e005d8
> [    2.082866] 7f80: c09b47f8 00000000 c09b47f8 00000000 00000000
> 00000000 00000000 00000000
> [    2.091057] 7fa0: 00000000 c09b4800 00000000 c0208920 00000000
> 00000000 00000000 00000000
> [    2.099248] 7fc0: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000
> [    2.107440] 7fe0: 00000000 00000000 00000000 00000000 00000013
> 00000000 60bd36df 5ae9d652
> [    2.115645] [<c0525d08>] (public_key_verify_signature) from
> [<c0526ee8>] (x509_check_for_self_signed+0xb0/0x10c)
> [    2.125842] [<c0526ee8>] (x509_check_for_self_signed) from
> [<c0525f24>] (x509_cert_parse+0x14c/0x1a8)
> [    2.135080] [<c0525f24>] (x509_cert_parse) from [<c0526b74>]
> (x509_key_preparse+0x14/0x18c)
> [    2.143449] [<c0526b74>] (x509_key_preparse) from [<c0524f20>]
> (asymmetric_key_preparse+0x54/0xd4)
> [    2.152430] [<c0524f20>] (asymmetric_key_preparse) from [<c0511148>]
> (key_create_or_update+0x120/0x3c4)
> [    2.161846] [<c0511148>] (key_create_or_update) from [<c0e47898>]
> (regulatory_init_db+0x11c/0x1e4)
> [    2.170828] [<c0e47898>] (regulatory_init_db) from [<c0201bd8>]
> (do_one_initcall+0x54/0x18c)
> [    2.179293] [<c0201bd8>] (do_one_initcall) from [<c0e00e6c>]
> (kernel_init_freeable+0x140/0x1cc)
> [    2.188011] [<c0e00e6c>] (kernel_init_freeable) from [<c09b4800>]
> (kernel_init+0x8/0x110)
> [    2.196210] [<c09b4800>] (kernel_init) from [<c0208920>]
> (ret_from_fork+0x14/0x34)
> [    2.203796] Code: ebf8636b eaffffab e7f001f2 e7f001f2 (e7f001f2)
> [    2.209901] ---[ end trace 4ec242c4e6a05178 ]---
> [    2.214553] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x0000000b
> 

This is the regulatory database stuff that Johannes added. The BUG() 
that triggers is here:

int public_key_verify_signature(const struct public_key *pkey,
                                 const struct public_key_signature *sig)
{
         struct crypto_wait cwait;
         struct crypto_akcipher *tfm;
         struct akcipher_request *req;
         struct scatterlist sig_sg, digest_sg;
         const char *alg_name;
         char alg_name_buf[CRYPTO_MAX_ALG_NAME];
         void *output;
         unsigned int outlen;
         int ret = -ENOMEM;

         pr_devel("==>%s()\n", __func__);

         BUG_ON(!pkey);
         BUG_ON(!sig);
 >>>     BUG_ON(!sig->digest);
         BUG_ON(!sig->s);

         alg_name = sig->pkey_algo;

Regards,
Arend
