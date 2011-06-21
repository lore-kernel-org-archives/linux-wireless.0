Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr9.hinet.net ([168.95.4.109]:34688 "EHLO msr9.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab1FUQZC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 12:25:02 -0400
Date: Wed, 22 Jun 2011 00:23:26 +0800
From: Ali Bahar <ali@internetdog.org>
To: Fred Plissonneau <cohomewp4@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Makefile deletes previous driver install when two WiFi
 interfaces are from the same chip vendor
Message-ID: <20110621162326.GA9922@internetdog.org> (sfid-20110621_182506_316177_A71B1B20)
Reply-To: ali@internetdog.org
References: <BANLkTimvMcb5yRHSE91VPTLdy7k5WEDo0Q@mail.gmail.com>
 <20110621130752.GB8462@internetdog.org>
 <BANLkTi=EygUbm5VB+H-mm+ofpbuaK8xafA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTi=EygUbm5VB+H-mm+ofpbuaK8xafA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fred,


On Tue, Jun 21, 2011 at 05:02:57PM +0200, Fred Plissonneau wrote:
> On Tue, Jun 21, 2011 at 3:07 PM, Ali Bahar <ali@internetdog.org> wrote:
> > On Tue, Jun 21, 2011 at 11:59:17AM +0200, Fred Plissonneau wrote:
> >> From: Fred Plissonneau <cohomewp4@gmail.com>


> >> > But when I switch-off and back on my PC, only the latest installed

> In fact only the last installed driver remains in the system
> directories (/lib/modules/...)
> The last-but-one installed driver has been removed during the "make
> install" of the second one.

I think I understand: you built a new driver, ran a 'make install' to
install it, and you suspect that the makefile removed another device's
driver. However, since the latter driver is already loaded into RAM,
you don't notice its loss until the next time you reboot.



> ./scripts/driver-select carl9170
> make
> sudo make install
> sudo modprode carl9170

> If I delete lines #318 to #326 in the Makefile (right after the "make"
> command and before "make install") it works fine now.

I don't know the makefile, nor anything specific to Ubuntu. But if the
procedure selects a specific driver, then its installation step should
not delete other drivers!

All's well that ends well! ;-)
ali
