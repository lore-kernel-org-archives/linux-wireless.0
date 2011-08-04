Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45345 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1HDU4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 16:56:12 -0400
Received: by fxh19 with SMTP id 19so2110944fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Aug 2011 13:56:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com>
References: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com>
 <CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com>
 <4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com> <CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Thu, 4 Aug 2011 13:55:51 -0700
Message-ID: <CALSq=BYY8-fAqATwJaFNvzwpSo4WWXbH=pRXn0oknqKXH=4X2A@mail.gmail.com> (sfid-20110804_225616_431111_1FADD567)
Subject: Re: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv pointer
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I may have spoken too soon. I didn't try until today, and I get the
following on remove module:

Aug  4 13:51:42 testbed11 kernel: [   45.321809] iwlwifi: connector
callback deregistered
Aug  4 13:51:42 testbed11 kernel: [   45.550202] *pde = 00000000
Aug  4 13:51:42 testbed11 kernel: [   45.550249] Modules linked in:
arc4 iwlagn(-) mac80211 cfg80211 i915 fbcon tileblit font bitblit
softcursor drm_kms_helper drm i2c_algo_bit cfbcopyarea i2c_core
intel_agp intel_gtt dcdbas loop video cfbimgblt cfbfillrect agpgart
evdev sg sr_mod sd_mod cdrom usbhid hid e1000e ahci libahci uhci_hcd
Aug  4 13:51:42 testbed11 kernel: [   45.550488]
Aug  4 13:51:42 testbed11 kernel: [   45.550501] Pid: 1022, comm:
rmmod Tainted: G        W   3.0.0-csitool+ #46 Dell Inc. Inspiron
530/0RY007
Aug  4 13:51:42 testbed11 kernel: [   45.550558] EIP:
0060:[<c032cf08>] EFLAGS: 00010202 CPU: 0
Aug  4 13:51:42 testbed11 kernel: [   45.550588] EIP is at
pci_disable_msi+0x18/0x40
Aug  4 13:51:42 testbed11 kernel: [   45.550613] EAX: 00000001 EBX:
fddfe000 ECX: 000017db EDX: 000017da
Aug  4 13:51:42 testbed11 kernel: [   45.550647] ESI: f3ec6350 EDI:
f3ec6360 EBP: f4201e98 ESP: f4201e94
Aug  4 13:51:42 testbed11 kernel: [   45.550680]  DS: 007b ES: 007b
FS: 00d8 GS: 0033 SS: 0068
Aug  4 13:51:42 testbed11 kernel: [   45.550760]  f3ec6340 f4201eac
f85036af f4d53460 f4d53400 f4d53518 f4201ecc c0323394
Aug  4 13:51:42 testbed11 kernel: [   45.550824]  f8516010 f8515fe0
f4201ecc f4d53460 f8516010 f4d53494 f4201edc c039281b
Aug  4 13:51:42 testbed11 kernel: [   45.550887]  f4d53460 f8516010
f4201ef0 c03928f7 00000000 f8516010 c06167a0 f4201f04
Aug  4 13:51:42 testbed11 kernel: [   45.550973]  [<f85036af>]
iwl_pci_remove+0x27/0x7f [iwlagn]
Aug  4 13:51:42 testbed11 kernel: [   45.551005]  [<c0323394>]
pci_device_remove+0x44/0x100
Aug  4 13:51:42 testbed11 kernel: [   45.551036]  [<c039281b>]
__device_release_driver+0x5b/0xb0
Aug  4 13:51:42 testbed11 kernel: [   45.551066]  [<c03928f7>]
driver_detach+0x87/0x90
Aug  4 13:51:42 testbed11 kernel: [   45.551093]  [<c0391b43>]
bus_remove_driver+0x63/0xa0
Aug  4 13:51:42 testbed11 kernel: [   45.551121]  [<c0392fa9>]
driver_unregister+0x49/0x80
Aug  4 13:51:42 testbed11 kernel: [   45.551150]  [<c0254a04>] ?
sysfs_remove_file+0x14/0x20
Aug  4 13:51:42 testbed11 kernel: [   45.551179]  [<c0323672>]
pci_unregister_driver+0x32/0x80
Aug  4 13:51:42 testbed11 kernel: [   45.551216]  [<f84f27e2>]
iwl_pci_unregister_driver+0x12/0x20 [iwlagn]
Aug  4 13:51:42 testbed11 kernel: [   45.551257]  [<f8503475>]
iwl_exit+0xd/0x14 [iwlagn]
Aug  4 13:51:42 testbed11 kernel: [   45.551286]  [<c01752d1>]
sys_delete_module+0x121/0x1d0
Aug  4 13:51:42 testbed11 kernel: [   45.551316]  [<c01e2052>] ?
do_munmap+0x212/0x2a0
Aug  4 13:51:42 testbed11 kernel: [   45.551344]  [<c04871cc>]
sysenter_do_call+0x12/0x22
Aug  4 13:51:42 testbed11 kernel: [   45.551726] ---[ end trace
cdd7f97709a5fcfb ]---


On Mon, Aug 1, 2011 at 11:39 PM, Daniel Halperin
<dhalperi@cs.washington.edu> wrote:
>
> ACK, you're right.
>
> 2011/8/1 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
> >>
> >> On Mon, Aug 1, 2011 at 12:46 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> >> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> >> >
> >> > This bug has been introduced by:
> >> > d593411084a56124aa9d80aafa15db8463b2d8f7
> >> > Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> >> > Date:   Mon Jul 11 10:48:51 2011 +0300
> >> >
> >> >    iwlagn: simplify the bus architecture
> >> >
> >>
> >> Believe this fix needs to go to 3.0-stable too.
> >>
> >
> > The buggy patch hasn't made it to 3.0. The bug was introduced in 3.1
> > ---------------------------------------------------------------------
> > Intel Israel (74) Limited
> >
> > This e-mail and any attachments may contain confidential material for
> > the sole use of the intended recipient(s). Any review or distribution
> > by others is strictly prohibited. If you are not the intended
> > recipient, please contact the sender and delete all copies.
> >
