Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:51321 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbZAPWwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 17:52:34 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Fri, 16 Jan 2009 23:52:31 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <200901162138.51855.chunkeey@web.de> <497105D1.5040906@gmail.com>
In-Reply-To: <497105D1.5040906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901162352.32037.chunkeey@web.de> (sfid-20090116_235240_791173_8F96132E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 January 2009 23:10:25 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Friday 16 January 2009 10:13:07 Johannes Berg wrote:
> >> On Thu, 2009-01-15 at 21:18 -0600, Larry Finger wrote:
> >>
> >>>>>   Object 0xddec18d0:  >69< 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b ikkkkkkkkkkkkkkk
> >>> I too have seen real single bit changes - in my case 6b went to 6=
a,
> >>> and my memory is fine. I wouldn't necessarily blame your hardware=
=2E
> >> 6b to 6a is often the result of a refcounting bug that happens to =
unref
> >> a value _after_ it has been freed. But that doesn't explain 6b to =
69,
> >> unless you happen to have _two_ refcounting bugs. Not that I neces=
sarily
> >> think that memory is bad
> > Well, this idiotic debug patch (kref-kernel-debug-patch) could shed=
 some light into
> > the problem who's using a freed skb.=20
>=20
> didn't trigger anything here, just the usual:
>=20
> BUG kmalloc-4096: Poison overwritten
> ---------------------------------------------------------------------=
--------
>=20
> INFO: 0xdc8161b0-0xdc8161b0. First byte 0x6a instead of 0x6b
> INFO: Allocated in dev_alloc_skb+0x19/0x30 age=3D1762 cpu=3D0 pid=3D3=
530
> INFO: Freed in __kfree_skb+0xf/0x90 age=3D613 cpu=3D0 pid=3D3527
> INFO: Slab 0xc1390200 objects=3D7 used=3D5 fp=3D0xdc816120 flags=3D0x=
400020c2
> INFO: Object 0xdc816120 @offset=3D24864 fp=3D0xdc8140c0
>=20
> but no other warnings...
but the refcount-test-module.c works on your system?

It should produce something like:

[  608.177429] RefTest                                                 =
                                                                    =20
[  608.179753] RefTest - Static                                        =
                                                                    =20
[  608.182861] released ffff8800b767dec8                               =
                                                                    =20
[  608.186760] RefTest - Watermark test                                =
                                                                    =20
[  608.190563] ------------[ cut here ]------------                    =
                                                                    =20
[  608.195412] WARNING: at lib/kref.c:67 kref_put+0x56/0x72()          =
                                                                    =20
[  608.201139] Hardware name: System Product Name                      =
                                                                    =20
[  608.205813] Modules linked in: refcount(+) [...] [last unloaded: ref=
count]                                                                 =
                                                   =20
[  608.288005] Pid: 8793, comm: insmod Tainted: P        W  2.6.29-rc1-=
wl #5                                                               =20
[  608.295036] Call Trace:                                             =
                                                                    =20
[  608.297719]  [<ffffffff80233389>] warn_slowpath+0xd8/0x112          =
                                                                    =20
[  608.304057]  [<ffffffff80233edd>] vprintk+0x28a/0x2b6               =
                                                                    =20
[  608.309546]  [<ffffffffa0089000>] reftst_release+0x0/0x14 [refcount]=
                                                                    =20
[  608.316241]  [<ffffffffa00a5000>] reftst_init+0x0/0xd5 [refcount]   =
                                                                    =20
[  608.322572]  [<ffffffffa00a5000>] reftst_init+0x0/0xd5 [refcount]   =
                                                                    =20
[  608.328904]  [<ffffffffa0089000>] reftst_release+0x0/0x14 [refcount]=
                                                                    =20
[  608.335497]  [<ffffffffa00a5000>] reftst_init+0x0/0xd5 [refcount]   =
                                                                    =20
[  608.341833]  [<ffffffff803b853a>] kref_put+0x56/0x72                =
                                                                    =20
[  608.347034]  [<ffffffffa00a5082>] reftst_init+0x82/0xd5 [refcount]  =
                                                                    =20
[  608.353461]  [<ffffffff80209051>] _stext+0x51/0x120                 =
                                                                    =20
[  608.358576]  [<ffffffff803ba5b2>] __up_read+0x13/0x8d               =
                                                                    =20
[  608.363862]  [<ffffffff8024823d>] __blocking_notifier_call_chain+0x5=
1/0x5f                                                              =20
[  608.370980]  [<ffffffff80256080>] sys_init_module+0xa0/0x1ba        =
                                                                    =20
[  608.376878]  [<ffffffff8020b41b>] system_call_fastpath+0x16/0x1b    =
                                                                    =20
[  608.383116] ---[ end trace e0829545e9e114bf ]---                    =
                                                                    =20
[  608.388194] RefTest - slXb poison test                              =
                                                                    =20
[  608.392223] ------------[ cut here ]------------                    =
                                                                    =20
[  608.397066] WARNING: at lib/kref.c:67 kref_put+0x56/0x72()          =
                                                                    =20
[  608.402783] Hardware name: System Product Name                      =
                                                                    =20
[  608.407454] Modules linked in: refcount(+) [...] ehci_hcd [last unlo=
aded: refcount]                                                        =
                                                            =20
[  608.488299] Pid: 8793, comm: insmod Tainted: P        W  2.6.29-rc1-=
wl #5                                                               =20
[  608.495325] Call Trace:                                             =
                                                                    =20
[  608.498015]  [<ffffffff80233389>] warn_slowpath+0xd8/0x112          =
                                                                    =20
[  608.503735]  [<ffffffff80233edd>] vprintk+0x28a/0x2b6               =
                                                                    =20
[  608.509023]  [<ffffffff80595798>] thread_return+0x3d/0xc2           =
                                                                    =20
[  608.514670]  [<ffffffffa0089000>] reftst_release+0x0/0x14 [refcount]=
                                                                    =20
[  608.521268]  [<ffffffffa00a5000>] reftst_init+0x0/0xd5 [refcount]   =
                                                                    =20
[  608.527601]  [<ffffffffa00a50bd>] reftst_init+0xbd/0xd5 [refcount]  =
                                                                    =20
[  608.534025]  [<ffffffff8029147a>] check_object+0x156/0x205          =
                                                                    =20
[  608.539751]  [<ffffffff80291c89>] __slab_free+0x271/0x2a8           =
                                                                    =20
[  608.545384]  [<ffffffffa0089000>] reftst_release+0x0/0x14 [refcount]=
                                                                    =20
[  608.551980]  [<ffffffffa00a5000>] reftst_init+0x0/0xd5 [refcount]   =
                                                                    =20
[  608.558315]  [<ffffffff803b853a>] kref_put+0x56/0x72                =
                                                                    =20
[  608.563513]  [<ffffffffa00a5000>] reftst_init+0x0/0xd5 [refcount]   =
                                                                    =20
[  608.569849]  [<ffffffffa00a50cc>] reftst_init+0xcc/0xd5 [refcount]  =
                                                                    =20
[  608.576274]  [<ffffffff80209051>] _stext+0x51/0x120                 =
                                                                    =20
[  608.581384]  [<ffffffff803ba5b2>] __up_read+0x13/0x8d               =
                                                                    =20
[  608.586671]  [<ffffffff8024823d>] __blocking_notifier_call_chain+0x5=
1/0x5f                                                              =20
[  608.593789]  [<ffffffff80256080>] sys_init_module+0xa0/0x1ba        =
                                                                    =20
[  608.599685]  [<ffffffff8020b41b>] system_call_fastpath+0x16/0x1b    =
                                                                    =20
[  608.605923] ---[ end trace e0829545e9e114c0 ]---

[[[some delay - until the object is alloced by someone else]]]
                                                                       =
     =20
[  613.331424] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                                         =
      =20
[  613.335408] BUG kmalloc-96: Poison overwritten                      =
                                                                    =20
[  613.335408] --------------------------------------------------------=
---------------------                                               =20
[  613.335408]                                                         =
                                                                    =20
[  613.335408] INFO: 0xffff8800be0aa950-0xffff8800be0aa950. First byte =
0x6a instead of 0x6b                                                =20
[  613.335408] INFO: Allocated in 0xffffffffa00a5093 age=3D1243 cpu=3D0=
 pid=3D8793                                                            =
   =20
[  613.335408] INFO: Freed in 0xffffffffa00a50bd age=3D1244 cpu=3D0 pid=
=3D8793                                                                =
   =20
[  613.335408] INFO: Slab 0xffffe20002992530 objects=3D24 used=3D23 fp=3D=
0xffff8800be0aa930 flags=3D0x40000000000000c3                          =
   =20
[  613.335408] INFO: Object 0xffff8800be0aa930 @offset=3D2352 fp=3D0x(n=
ull)                                                                   =
 =20
[  613.335408]
[  613.335408] Bytes b4 0xffff8800be0aa920:  ec ca 00 00 01 00 00 00 5a=
 5a 5a 5a 5a 5a 5a 5a =EF=BF=BD=EF=BF=BD......ZZZZZZZZ
[  613.335408]   Object 0xffff8800be0aa930:  6b 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  613.335408]   Object 0xffff8800be0aa940:  6b 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  613.335408]   Object 0xffff8800be0aa950:  6a 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b jkkkkkkkkkkkkkkk
[  613.335408]   Object 0xffff8800be0aa960:  6b 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  613.335408]   Object 0xffff8800be0aa970:  6b 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  613.335408]   Object 0xffff8800be0aa980:  6b 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk=EF=BF=BD
[  613.335408]  Redzone 0xffff8800be0aa990:  bb bb bb bb bb bb bb bb   =
                      =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD
[  613.473011]  Padding 0xffff8800be0aa9d0:  5a 5a 5a 5a 5a 5a 5a 5a   =
                      ZZZZZZZZ
[  613.473011] Pid: 1671, comm: kcryptd Tainted: P        W  2.6.29-rc1=
-wl #5
[  613.473011] Call Trace:
[  613.473011]  [<ffffffff802912e8>] check_bytes_and_report+0xb5/0xf1 [=
no sign of refcount test in this backtrace here]
[  613.473011]  [<ffffffff8022a2d7>] update_curr+0x4a/0xcd
[  613.473011]  [<ffffffff802913ec>] check_object+0xc8/0x205
[  613.473011]  [<ffffffff80292af2>] __slab_alloc+0x3cb/0x4ba
[  613.473011]  [<ffffffff804c4b9c>] r1bio_pool_alloc+0x24/0x3d
[  613.473011]  [<ffffffff804c4b9c>] r1bio_pool_alloc+0x24/0x3d
[  613.473011]  [<ffffffff80293381>] __kmalloc+0x98/0xc1
[...]
[  613.473011] FIX kmalloc-96: Restoring 0xffff8800be0aa950-0xffff8800b=
e0aa950=3D0x6b
[  613.473011]
[  613.473011] FIX kmalloc-96: Marking all objects used
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
