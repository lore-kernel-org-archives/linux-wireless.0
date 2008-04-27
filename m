Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from be2.wartburg.edu ([216.159.168.186]:19163 "EHLO
	WARTBURG-EVS-01.wartburg.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752122AbYD0OcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 10:32:17 -0400
Message-ID: <48148E6F.3080703@wartburg.edu> (sfid-20080427_163231_994796_A4F7BF7D)
Date: Sun, 27 Apr 2008 09:32:15 -0500
From: Charles Figura <charles.figura@wartburg.edu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [Fwd: Re: Problems loading from compat-wireless-2008-04-24]
Content-Type: multipart/mixed;
 boundary="------------050606010908020706070606"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050606010908020706070606
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I'm running Ubuntu Hardy with the 2.6.24-16-generic kernel.
I've followed the log approach laid out by Luis Rodriguez below,
and attached the corresponding dmesg output.

As you see, the modprobe FAILS due to lots of unknown symbols.

Oh, one other note that I hadn't mentioned before.  I've found
that a 'sudo make uninstall' doesn't get rid of the module - at
least, it doesn't reset the module list.  If I follow a 'sudo make
uninstall' by 'sudo modprobe iwl3945', it tries to insert the same
(faulty) module.  Only by rebooting is the original restored.
How do I update the module list after doing a make uninstall?

Thanks - hope this helps!


-------- Original Message --------
Subject: Re: Problems loading from compat-wireless-2008-04-24
Date: Sat, 26 Apr 2008 11:14:20 -0700
From: Luis R. Rodriguez <mcgrof@gmail.com>
To: Charles Figura <charles.figura@wartburg.edu>
References: <4810F9BC.7030104@wartburg.edu>	 
<43e72e890804252146y600b6b40x738e0826bc492b0@mail.gmail.com>	 
<4813700F.5050108@wartburg.edu>

On Sat, Apr 26, 2008 at 11:10 AM, Charles Figura
<charles.figura@wartburg.edu> wrote:
> Luis -
>
>  Thanks for the response.  I did, actually, do a 'make unload' before
>  loading the new module.  And the error I sent you was actually from
>  loading the single module I need - the iwl3945 module.
>
>  So I'm still back where I started, I think.

Please reply to the list explaining this, Intel reads linux-wireless
so they can help if its their driver.

Do this:

Reboot.

sudo dmesg -c > log1
less log1 # review it to make sure there are no oops
sudo make unload
sudo dmesg -c
sudo modprobe iwl4965
# Try to connect or whatever to try to replicate your oops
sudo dmesg -c > oops.txt

copy and paste the oops.txt into your e-mail, that will give a cleaner
log. Also be sure to mention your kernel you are using.

   Luis



-- 
Charles Figura                      charles.figura@wartburg.edu
Associate Professor of Physics    http://mcsp.wartburg.edu/figura
Director, Wartburg Platte Observatory    (319) 352-8373
                                          (319) 352-8606 (fax)

--------------050606010908020706070606
Content-Type: text/plain;
 name="oops.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="oops.txt"

WyAgMjE5LjA0NjY2OV0gaXdsd2lmaV9tYWM4MDIxMTogZGlzYWdyZWVzIGFib3V0IHZlcnNp
b24gb2Ygc3ltYm9sIHdpcGh5X3JlZ2lzdGVyClsgIDIxOS4wNDY2ODFdIGl3bHdpZmlfbWFj
ODAyMTE6IFVua25vd24gc3ltYm9sIHdpcGh5X3JlZ2lzdGVyClsgIDIxOS4wNDY3NDJdIGl3
bHdpZmlfbWFjODAyMTE6IGRpc2FncmVlcyBhYm91dCB2ZXJzaW9uIG9mIHN5bWJvbCB3aXBo
eV9uZXcKWyAgMjE5LjA0Njc0N10gaXdsd2lmaV9tYWM4MDIxMTogVW5rbm93biBzeW1ib2wg
d2lwaHlfbmV3ClsgIDIxOS4wNDc3NjVdIGl3bHdpZmlfbWFjODAyMTE6IGRpc2FncmVlcyBh
Ym91dCB2ZXJzaW9uIG9mIHN5bWJvbCB3aXBoeV91bnJlZ2lzdGVyClsgIDIxOS4wNDc3NzFd
IGl3bHdpZmlfbWFjODAyMTE6IFVua25vd24gc3ltYm9sIHdpcGh5X3VucmVnaXN0ZXIKWyAg
MjE5LjA0OTA2MF0gaXdsd2lmaV9tYWM4MDIxMTogZGlzYWdyZWVzIGFib3V0IHZlcnNpb24g
b2Ygc3ltYm9sIHdpcGh5X2ZyZWUKWyAgMjE5LjA0OTA2Nl0gaXdsd2lmaV9tYWM4MDIxMTog
VW5rbm93biBzeW1ib2wgd2lwaHlfZnJlZQpbICAyMTkuMDUwNDgzXSBpd2wzOTQ1OiBVbmtu
b3duIHN5bWJvbCBpd2x3aWZpX2llZWU4MDIxMV9yeF9pcnFzYWZlClsgIDIxOS4wNTA2MTZd
IGl3bDM5NDU6IFVua25vd24gc3ltYm9sIGl3bHdpZmlfaWVlZTgwMjExX2dldF9oZHJsZW4K
WyAgMjE5LjA1MDg0N10gaXdsMzk0NTogVW5rbm93biBzeW1ib2wgaXdsd2lmaV9pd2x3aWZp
X2llZWU4MDIxMV90eF9zdGF0dXNfaXJxc2FmZQpbICAyMTkuMDUxMDE1XSBpd2wzOTQ1OiBV
bmtub3duIHN5bWJvbCBpd2x3aWZpX2l3bHdpZmlfaWVlZTgwMjExX3N0b3BfcXVldWVzClsg
IDIxOS4wNTExMTJdIGl3bDM5NDU6IFVua25vd24gc3ltYm9sIGl3bHdpZmlfX19pZWVlODAy
MTFfZ2V0X3J4X2xlZF9uYW1lClsgIDIxOS4wNTEzNTFdIGl3bDM5NDU6IFVua25vd24gc3lt
Ym9sIGl3bHdpZmlfaWVlZTgwMjExX3R4X3N0YXR1cwpbICAyMTkuMDUxNDQwXSBpd2wzOTQ1
OiBVbmtub3duIHN5bWJvbCBpd2x3aWZpX2llZWU4MDIxMV9yYXRlX2NvbnRyb2xfdW5yZWdp
c3RlcgpbICAyMTkuMDUxNzEwXSBpd2wzOTQ1OiBVbmtub3duIHN5bWJvbCBpd2x3aWZpX2ll
ZWU4MDIxMV9zdG9wX3F1ZXVlClsgIDIxOS4wNTE3OTldIGl3bDM5NDU6IFVua25vd24gc3lt
Ym9sIGl3bHdpZmlfc3RhX2luZm9fcHV0ClsgIDIxOS4wNTE5ODldIGl3bDM5NDU6IFVua25v
d24gc3ltYm9sIGl3bHdpZmlfaWVlZTgwMjExX2ZyZWVfaHcKWyAgMjE5LjA1MjA3OV0gaXds
Mzk0NTogVW5rbm93biBzeW1ib2wgaXdsd2lmaV9pZWVlODAyMTFfYmVhY29uX2dldApbICAy
MTkuMDUyMTc5XSBpd2wzOTQ1OiBVbmtub3duIHN5bWJvbCBpd2x3aWZpX3N0YV9pbmZvX2dl
dApbICAyMTkuMDUyMzc0XSBpd2wzOTQ1OiBVbmtub3duIHN5bWJvbCBpd2x3aWZpX2llZWU4
MDIxMV9hbGxvY19odwpbICAyMTkuMDUyNTA0XSBpd2wzOTQ1OiBVbmtub3duIHN5bWJvbCBp
d2x3aWZpX19faWVlZTgwMjExX2dldF90eF9sZWRfbmFtZQpbICAyMTkuMDUyNTkzXSBpd2wz
OTQ1OiBVbmtub3duIHN5bWJvbCBpd2x3aWZpX2llZWU4MDIxMV9zY2FuX2NvbXBsZXRlZApb
ICAyMTkuMDUyODU0XSBpd2wzOTQ1OiBVbmtub3duIHN5bWJvbCBpd2x3aWZpX2llZWU4MDIx
MV9yZWdpc3Rlcl9odwpbICAyMTkuMDUzMTE4XSBpd2wzOTQ1OiBVbmtub3duIHN5bWJvbCBp
d2x3aWZpX2llZWU4MDIxMV93YWtlX3F1ZXVlClsgIDIxOS4wNTMyMTJdIGl3bDM5NDU6IFVu
a25vd24gc3ltYm9sIGl3bHdpZmlfaWVlZTgwMjExX3JhdGVfY29udHJvbF9yZWdpc3Rlcgpb
ICAyMTkuMDUzMzc4XSBpd2wzOTQ1OiBVbmtub3duIHN5bWJvbCBpd2x3aWZpX2l3bHdpZmlf
aWVlZTgwMjExX3JlZ2lzdGVyX2h3bW9kZQpbICAyMTkuMDUzNzU4XSBpd2wzOTQ1OiBVbmtu
b3duIHN5bWJvbCBpd2x3aWZpX2llZWU4MDIxMV91bnJlZ2lzdGVyX2h3ClsgIDIxOS4wNTM5
MTBdIGl3bDM5NDU6IFVua25vd24gc3ltYm9sIGl3bHdpZmlfaWVlZTgwMjExX3N0YXJ0X3F1
ZXVlcwo=
--------------050606010908020706070606--
