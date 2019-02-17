Return-Path: <SRS0=gO0h=QY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E3BC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 15:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC9DB2195D
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 15:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfBQPrJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Feb 2019 10:47:09 -0500
Received: from xatko.vsos.ethz.ch ([192.33.91.153]:49838 "HELO
        xatko.vsos.ethz.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728202AbfBQPrJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Feb 2019 10:47:09 -0500
Received: (qmail 32162 invoked by uid 0); 17 Feb 2019 15:47:06 -0000
Received: from 84-73-53-63.dclient.hispeed.ch (HELO localhost) (dominik@84.73.53.63)
  by xatko.vsos.ethz.ch with ESMTPA; 17 Feb 2019 15:47:06 -0000
Date:   Sun, 17 Feb 2019 16:47:05 +0100
From:   Dominik Schmidt <dominik@schm1dt.ch>
Subject: Re: Kernel hangs on regulatory.db X.509 key initialization
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     james.morris@microsoft.com, linux-wireless@vger.kernel.org
References: <1549746752.q02fowo7n3.astroid@I7-2600.none>
        <0ce6546d-0f1d-922c-0acd-796966c98aab@maciej.szmigiero.name>
In-Reply-To: <0ce6546d-0f1d-922c-0acd-796966c98aab@maciej.szmigiero.name>
MIME-Version: 1.0
User-Agent: NO U
Message-Id: <1550408911.l8h2wv2mil.astroid@I7-2600.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Excerpts from Maciej S. Szmigiero's message of Februar 17, 2019 1:29 pm:
> Hi,
> 
> On 17.02.2019 10:38, Dominik Schmidt wrote:
>> Hi there!
>> 
>> I'm running a Gentoo Linux on an APU2C2-Board (AMD Jaguar GX-412TC x86_64), with
>> an Atheros QCA9882 (ath10k) and an Atheros AR9280 (ath9k) card.
>> 
>> The kernels after 4.18 do not reach userspace any longer. 
> 
> Did you test a more recent kernel like 4.20?

Yes, up to 4.20.7, yielding the same fault

>> They just somehow
>> "freeze" without emitting any oops or kernel panic. I've tracked the issue
>> down to the cfg80211 subsystem and a change in the X.509 parser:
>> 
>> * If I do not compile cfg80211 into the kernel, it starts perfectly (minus wireless)
>> 
>> * Bisecting the issue shows that it starts with
>> 	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b65c32ec5a942ab3ada93a048089a938918aba7f
>> 
>> * The last message I see in the logs is this one:
>> 	cfg80211: Loading compiled-in X.509 certificates for regulatory database
>>   defined at
>> 	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/wireless/reg.c#n770
>> 
>> * If I add another pr_notice to the end of that function, it is never displayed.
>> 
>> * It seems to get stuck at the call to key_create_or_update, here:
>> 	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/wireless/reg.c#n735
>> 
>> * If I throw more pr_notices at key_create_or_update, the last one I see 
>>   is before this memset:
>> 	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/security/keys/key.c#n843
>> 
>> * As an additional hindrance, this problem occurs only on the APU2 board,
>>   and not when running the same kernel in a Qemu-VM
>> 
>> Any idea what could be the cause of this, or hints as to how to
>> debug this further?
> 
> I see that you are using an AMD CPU-based board, with AMD CCP enabled
> in your kernel config.
> 
> Before my patch, that you bisected your problem to, such configuration
> would fail (early) in-kernel X.509 certificate signature verification
> as its length wasn't exactly correct.

Yes, it did/does actually fail with:

[    7.376473] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    7.388090] cfg80211: Problem loading in-kernel X.509 certificate (-22)
[    7.406107] cfg80211: failed to load regulatory.db

> Now, when this was fixed the CCP RSA implementation actually gets
> exercised (however, it works for me without problems on Ryzen).

In deed it seems that CCP might be the culprit here, nice catch.
If I remove the option, the kernel starts up nicely with:

[    7.097244] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    7.109893] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    7.117763] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[    7.129880] cfg80211: failed to load regulatory.db

> You can temporarily change CONFIG_CFG80211 in your kernel config to
> 'm' and compile the kernel with KASAN.
> Don't load any wireless modules at startup, this should at least
> defer the crash until you load them manually later when the system is
> idle and you can monitor it.
> 
> If you are lucky KASAN will give you information then where the bug
> might be.

Oh, this works marvellously:

[   23.301826] ==================================================================
[   23.309463] BUG: KASAN: slab-out-of-bounds in ccp_rsa_crypt+0x84/0x250
[   23.316092] Write of size 296 at addr ffff88805ba00c40 by task swapper/0/1
[   23.323030]
[   23.324633] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G                T 4.20.7 #38
[   23.332121] Hardware name: PC Engines apu2/apu2, BIOS v4.9.0.1 01/09/2019
[   23.339051] Call Trace:
[   23.341610]  dump_stack+0xd1/0x160
[   23.345123]  ? dump_stack_print_info.cold.0+0x1b/0x1b
[   23.350321]  ? kmsg_dump_rewind_nolock+0x60/0x60
[   23.355093]  print_address_description.cold.3+0x9/0x26a
[   23.360465]  kasan_report.cold.4+0x65/0xa3
[   23.364662]  ? ccp_rsa_crypt+0x84/0x250
[   23.368605]  memset+0x2d/0x50
[   23.371681]  ccp_rsa_crypt+0x84/0x250
[   23.375506]  ? ccp_rsa_exit_tfm+0x10/0x10
[   23.379651]  pkcs1pad_verify+0x254/0x2c0
[   23.383706]  public_key_verify_signature+0x385/0x5b0
[   23.388800]  ? software_key_query+0x2f0/0x2f0
[   23.393285]  ? ret_from_fork+0x27/0x50
[   23.397157]  ? sha256_base_init+0xa0/0xa0
[   23.401319]  ? match_held_lock+0xb8/0x380
[   23.405485]  ? __lock_acquire+0x2d30/0x2d30
[   23.409807]  ? x509_get_sig_params+0x223/0x280
[   23.414385]  ? kasan_unpoison_shadow+0x3b/0x60
[   23.418931]  ? kasan_kmalloc+0xee/0x100
[   23.422929]  ? asymmetric_key_generate_id+0x3e/0xa0
[   23.427925]  x509_check_for_self_signed+0x183/0x20c
[   23.432919]  ? asymmetric_key_generate_id+0x77/0xa0
[   23.437930]  x509_cert_parse+0x315/0x3c0
[   23.441958]  x509_key_preparse+0x47/0x3a0
[   23.446084]  asymmetric_key_preparse+0x60/0x90
[   23.450648]  key_create_or_update+0x3aa/0x8b0
[   23.455107]  ? key_type_lookup+0x90/0x90
[   23.459195]  ? key_instantiate_and_link+0x250/0x2c0
[   23.464144]  ? key_user_put+0x50/0x50
[   23.467943]  regulatory_init_db+0x20d/0x386
[   23.472245]  ? regulatory_init+0x201/0x201
[   23.476471]  do_one_initcall+0xd5/0x458
[   23.480436]  ? perf_trace_initcall_level+0x370/0x370
[   23.485499]  ? strlen+0x5/0x40
[   23.488697]  ? next_arg+0x19c/0x220
[   23.492291]  ? strlen+0x1e/0x40
[   23.495508]  ? rcu_is_watching+0xa5/0xf0
[   23.499532]  ? __lock_is_held+0x38/0xd0
[   23.503472]  ? rcu_gpnum_ovf+0x210/0x210
[   23.507499]  ? rcu_read_lock_sched_held+0x70/0x80
[   23.512328]  ? trace_initcall_level+0x15b/0x1bc
[   23.516964]  ? do_one_initcall+0x400/0x458
[   23.521192]  ? up_write+0xcf/0x180
[   23.524674]  ? down_read_non_owner+0xb0/0xb0
[   23.529105]  ? kasan_unpoison_shadow+0x3b/0x60
[   23.533654]  kernel_init_freeable+0x511/0x60e
[   23.538103]  ? rest_init+0x2df/0x2df
[   23.541782]  kernel_init+0x7/0x121
[   23.545263]  ? rest_init+0x2df/0x2df
[   23.548912]  ret_from_fork+0x27/0x50
[   23.552583]
[   23.554173] Allocated by task 1:
[   23.557564]  kasan_kmalloc+0xee/0x100
[   23.561325]  __kmalloc+0x123/0x280
[   23.564859]  public_key_verify_signature+0x157/0x5b0
[   23.569893]  x509_check_for_self_signed+0x183/0x20c
[   23.574899]  x509_cert_parse+0x315/0x3c0
[   23.578913]  x509_key_preparse+0x47/0x3a0
[   23.582993]  asymmetric_key_preparse+0x60/0x90
[   23.587565]  key_create_or_update+0x3aa/0x8b0
[   23.592047]  regulatory_init_db+0x20d/0x386
[   23.596332]  do_one_initcall+0xd5/0x458
[   23.600273]  kernel_init_freeable+0x511/0x60e
[   23.604714]  kernel_init+0x7/0x121
[   23.608228]  ret_from_fork+0x27/0x50
[   23.611928]
[   23.613522] Freed by task 0:
[   23.616497] (stack is not available)
[   23.620158]
[   23.621740] The buggy address belongs to the object at ffff88805ba00b40
[   23.621740]  which belongs to the cache kmalloc-256 of size 256
[   23.634410] The buggy address is located 0 bytes to the right of
[   23.634410]  256-byte region [ffff88805ba00b40, ffff88805ba00c40)
[   23.646599] The buggy address belongs to the page:
[   23.651537] page:ffffea00016e8000 count:1 mapcount:0 mapping:ffff88805f803200 index:0x0 compound_mapcount: 0
[   23.661500] flags: 0x4000000000010200(slab|head)
[   23.666272] raw: 4000000000010200 dead000000000100 dead000000000200 ffff88805f803200
[   23.674178] raw: 0000000000000000 0000000080190019 00000001ffffffff 0000000000000000
[   23.682028] page dumped because: kasan: bad access detected
[   23.687724]
[   23.689329] Memory state around the buggy address:
[   23.694255]  ffff88805ba00b00: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
[   23.701593]  ffff88805ba00b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   23.708926] >ffff88805ba00c00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
[   23.716304]                                            ^
[   23.721725]  ffff88805ba00c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   23.729058]  ffff88805ba00d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   23.736370] ==================================================================
[   23.743664] Disabling lock debugging due to kernel taint

I will investigate further and start a new thread in linux-crypto once I find out more
(sorry about abusing linux-wireless :/)

Anyways, many thanks Maciej for looking into it, your help is much appreciated!

>> Cheers
>> Dominik
>> 
> 
> Maciej
> 
