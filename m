Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:33879 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZAJAeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 19:34:10 -0500
Received: by bwz14 with SMTP id 14so29778766bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 16:34:07 -0800 (PST)
Message-ID: <45e8e6c40901091634t66b5ebebr76caeebdab20ecf9@mail.gmail.com> (sfid-20090110_013416_133736_4B4FD9A7)
Date: Fri, 9 Jan 2009 16:34:06 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: libertas: BUG: unable to handle paging request
Cc: libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <45e8e6c40901081441r59112db3i9d5e47dc5fd15f08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <45e8e6c40901071658j6a22fcc7gedcc41d73a61ff2a@mail.gmail.com>
	 <45e8e6c40901071837o56dba8f1w6db5c7e982f698da@mail.gmail.com>
	 <45e8e6c40901071945u27a8de0aqbf2b50f0075a32f3@mail.gmail.com>
	 <20090107225735.J84155@bowser.eecs.harvard.edu>
	 <45e8e6c40901081141s1f0b7be7g36095a4da1819d9@mail.gmail.com>
	 <1231454112.24797.1.camel@localhost.localdomain>
	 <45e8e6c40901081441r59112db3i9d5e47dc5fd15f08@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've found the part of commit 29726d85d7b98558a8bc8e69b859bf12e1347f9f
that breaks libertas.  The netdev macros portion of the patch is
indeed harmless but the OOPS happens when I don't back out the last
portion of the patch, described as:

"Different to readonly reference of netdev->priv, in this driver,
netdev->pri was changed. I use netdev->ml_priv to replace
netdev->priv."

The resulting lines in the patch are as follows and if I revert them
the driver works again.  I am not familiar with ml_priv ("mid-layer
private") and what we're trying to accomplish by the above so, short
of reverting this portion of the patch, can someone place chime in on
what's going on here?  The result is that our priv data gets corrupted
and then, when it's used by WEXT callbacks, we cause a kernel oops.

@@ -1378,7 +1378,7 @@ static int lbs_add_mesh(struct lbs_private *priv)
                ret = -ENOMEM;
                goto done;
        }
-       mesh_dev->priv = priv;
+       mesh_dev->ml_priv = priv;
        priv->mesh_dev = mesh_dev;

        mesh_dev->open = lbs_dev_open;
@@ -1591,7 +1591,7 @@ static int lbs_rtap_hard_start_xmit(struct
sk_buff *skb, struct net_device *dev)

 static struct net_device_stats *lbs_rtap_get_stats(struct net_device *dev)
 {
-       struct lbs_private *priv = dev->priv;
+       struct lbs_private *priv = dev->ml_priv;
        lbs_deb_enter(LBS_DEB_NET);
        return &priv->stats;
 }
@@ -1632,7 +1632,7 @@ static int lbs_add_rtap(struct lbs_private *priv)
        rtap_dev->stop = lbs_rtap_stop;
        rtap_dev->get_stats = lbs_rtap_get_stats;
        rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
-       rtap_dev->priv = priv;
+       rtap_dev->ml_priv = priv;
        SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);

        ret = register_netdev(rtap_dev);


On Thu, Jan 8, 2009 at 2:41 PM, Andrey Yurovsky <andrey@cozybit.com> wrote:
> Ok, also the interface layers (ex: if_usb.c and if_sdio.c) were missed
> in that patch as well.  I'm still getting the OOPS after making
> everyone use the macros consistently so I think there's something else
> going on that's corrupting our priv data.
>
> On Thu, Jan 8, 2009 at 2:35 PM, Dan Williams <dcbw@redhat.com> wrote:
>> On Thu, 2009-01-08 at 11:41 -0800, Andrey Yurovsky wrote:
>>> Hi Dario.  In my case I see the oops when iwconfig issues the
>>> SIOCGIWFREQ icotl and thus lbs_get_freq() is executed.  Pulling out
>>> the CMD_802_11_GET_LOG doesn't change anything in this respect.
>>>
>>> Right now I am trying to understand why the functions in wext.c access
>>> priv with:
>>>
>>> struct lbs_private *priv = dev->priv;
>>
>> They probably just got forgotten or something during the conversion.
>> They should be using the same methods as everything else, really, since
>> it's just a netdev and they are trying to access the private driver
>> data.
>>
>> Dan
>>
>>> while the rest of the driver uses the netdev macros, for example:
>>>
>>> struct lbs_private *priv = netdev_priv(to_net_dev(dev));
>>>
>>> after the commit in question, or
>>>
>>> struct lbs_private *priv = to_net_dev(dev)->priv;
>>>
>>> before the commit in question.  Converting the WEXT callbacks to use
>>> the netdev macros doesn't seem to solve the problem.  Thanks,
>>>
>>>   -Andrey
>>>
>>> On Wed, Jan 7, 2009 at 8:01 PM, Dario Vlah <dario@eecs.harvard.edu> wrote:
>>> > Hi Andrey,
>>> >
>>> > I ran into some trouble with the GET_LOG command on the jax10 device, which
>>> > happens to be called by iwconfig.  Could that be related?  What if you
>>> > disable the GET_LOG call?
>>> >
>>> > In my case issuing that command results in the firmware returning bogus
>>> > values such as negative buffer sizes which end up crashing the kernel.
>>> >
>>> > --dario
>>> >
>>> > On Wed, 7 Jan 2009, Andrey Yurovsky wrote:
>>> >
>>> >> Hmm, I do see the problem start at
>>> >> 29726d85d7b98558a8bc8e69b859bf12e1347f9f and after, but I don't think
>>> >> that I'm right with my analysis, especially since the OOPS happens in
>>> >> wext.c and the functions there (namely lbs_get_freq) use netdev->priv
>>> >> directly.  I apologize for the noise but there is still something
>>> >> wrong here that I'm trying to understand better.
>>> >>
>>> >>  -Andrey
>>> >>
>>> >> On Wed, Jan 7, 2009 at 6:37 PM, Andrey Yurovsky <andrey@cozybit.com>
>>> >> wrote:
>>> >>>
>>> >>> The commit that caused this regression is
>>> >>> 29726d85d7b98558a8bc8e69b859bf12e1347f9f "netdevice libertas: Fix
>>> >>> directly reference of netdev->priv" by Wang Chen.  It probably causes
>>> >>> a problem with netdev->priv's offset and then we get a pointer
>>> >>> dereference problem when lbs_get_freq() tries to use its priv data.
>>> >>>
>>> >>>  -Andrey
>>> >>>
>>> >>> On Wed, Jan 7, 2009 at 4:58 PM, Andrey Yurovsky <andrey@cozybit.com>
>>> >>> wrote:
>>> >>>>
>>> >>>> Hello.  I noticed that the libertas driver causes a kernel oops in
>>> >>>> more recent wireless-testing kernels (I am bisecting right now to
>>> >>>> narrow this down).  To reproduce, load the driver and run iwconfig,
>>> >>>> causing lbs_get_freq() to be called.
>>> >>>>
>>> >>>> So far I know that this problem doesn't exist at the 2.6.28-rc2 tag
>>> >>>> (commit 0173a3265b228da319ceb9c1ec6a5682fd1b2d92)  but I have seen it
>>> >>>> in -rc7 and up through today's wireless-testing.  It seems that
>>> >>>> there's a regression somewhere after -rc2.  I've reproduced this with
>>> >>>> the USB hardware as well as an SDIO board.
>>> >>>>
>>> >>>> [  118.571205] BUG: unable to handle kernel paging request at 00001e01
>>> >>>> [  118.578500] IP: [<c81fddda>] lbs_get_freq+0x1a/0x160 [libertas]
>>> >>>> [  118.585417] *pde = 00000000
>>> >>>> [  118.588877] Oops: 0000 [#1]
>>> >>>> [  118.592092] last sysfs file: /sys/block/ram9/range
>>> >>>> [  118.592385] Modules linked in: usb8xxx libertas lib80211
>>> >>>> [  118.592385]
>>> >>>> [  118.592385] Pid: 2317, comm: iwconfig Not tainted (2.6.28-wl #65)
>>> >>>> Uknown
>>> >>>> [  118.592385] EIP: 0060:[<c81fddda>] EFLAGS: 00010293 CPU: 0
>>> >>>> [  118.592385] EIP is at lbs_get_freq+0x1a/0x160 [libertas]
>>> >>>> [  118.592385] EAX: 00000000 EBX: 00000000 ECX: c6891ef8 EDX: c6891e98
>>> >>>> [  118.592385] ESI: c6891ef8 EDI: c6891ef8 EBP: c7295000 ESP: c6891e10
>>> >>>> [  118.592385]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>>> >>>> [  118.592385] Process iwconfig (pid: 2317, ti=c6890000 task=c7349880
>>> >>>> task.ti=c6890000)
>>> >>>> [  118.592385] Stack:
>>> >>>> [  118.592385]  c8201b4b c6891ef8 00000010 ffffffa1 00008b05 c038aa20
>>> >>>> 00000000 c03c691c
>>> >>>> [  118.592385]  00000000 c04bc7e0 c0301287 b7f01d70 c68ce000 c6895000
>>> >>>> c04c8260 00000c04
>>> >>>> [  118.592385]  c68c7b7c 00000000 c7295000 c6891ee8 c0300325 c6891ee8
>>> >>>> c7295000 c6891ee8
>>> >>>> [  118.592385] Call Trace:
>>> >>>> [  118.592385]  [<c8201b4b>] lbs_get_name+0x2b/0xb0 [libertas]
>>> >>>> [  118.592385]  [<c038aa20>] ioctl_standard_call+0x60/0x3a0
>>> >>>> [  118.592385]  [<c0301287>] netif_receive_skb+0x1d7/0x3e0
>>> >>>> [  118.592385]  [<c0300325>] __dev_get_by_name+0x75/0x90
>>> >>>> [  118.592385]  [<c0300325>] __dev_get_by_name+0x75/0x90
>>> >>>> [  118.592385]  [<c038a687>] wext_handle_ioctl+0x157/0x230
>>> >>>> [  118.592385]  [<c81fddc0>] lbs_get_freq+0x0/0x160 [libertas]
>>> >>>> [  118.592385]  [<c03034c4>] dev_ioctl+0x304/0x4f0
>>> >>>> [  118.592385]  [<c02ffdd2>] net_rx_action+0x92/0x140
>>> >>>> [  118.592385]  [<c027ca89>] pty_write+0x39/0x60
>>> >>>> [  118.592385]  [<c02f4280>] sock_ioctl+0x0/0x260
>>> >>>> [  118.592385]  [<c017e27f>] vfs_ioctl+0x1f/0x70
>>> >>>> [  118.592385]  [<c017e65b>] do_vfs_ioctl+0x24b/0x490
>>> >>>> [  118.592385]  [<c011654e>] update_curr+0x13e/0x190
>>> >>>> [  118.592385]  [<c0117fab>] set_next_entity+0x2b/0x70
>>> >>>> [  118.592385]  [<c0397c64>] schedule+0x1b4/0x350
>>> >>>> [  118.592385]  [<c017e906>] sys_ioctl+0x66/0x70
>>> >>>> [  118.592385]  [<c0103cd2>] syscall_call+0x7/0xb
>>> >>>> [  118.592385] Code: e9 38 ff ff ff 8d b6 00 00 00 00 8d bf 00 00 00
>>> >>>> 00 56 89 ce 53 83 ec 0c 8b 98 a4 01 00 00 a1 80 19 22 c8 83 e0 21 83
>>> >>>> f8 21 74 42 <0f> b6 8b 01 1e 00 00 31 d2 89 d8 e8 a6 fe ff ff 85 c0 0f
>>> >>>> 84 cd
>>> >>>> [  118.592385] EIP: [<c81fddda>] lbs_get_freq+0x1a/0x160 [libertas]
>>> >>>> SS:ESP 0068:c6891e10
>>> >>>> [  118.594153] ---[ end trace f426cd49b2b378f4 ]---
>>> >>>>
>>> >>>
>>> >>
>>> >> _______________________________________________
>>> >> libertas-dev mailing list
>>> >> libertas-dev@lists.infradead.org
>>> >> http://lists.infradead.org/mailman/listinfo/libertas-dev
>>> >>
>>> >
>>>
>>> _______________________________________________
>>> libertas-dev mailing list
>>> libertas-dev@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/libertas-dev
>>
>>
>
