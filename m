Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49505 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757249AbYBEIfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 03:35:19 -0500
Date: Tue, 5 Feb 2008 09:35:11 +0100
From: Sebastian Siewior <ipw+2200@ml.breakpoint.cc>
To: Dan Williams <dcbw@redhat.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net
Subject: Re: ipw2200 stalls on high load
Message-ID: <20080205083511.GA28623@Chamillionaire.breakpoint.cc> (sfid-20080205_083555_240017_824DB49D)
References: <20080126132939.GA22630@Chamillionaire.breakpoint.cc> <D936D925018D154694D8A362EEB0892003800B1B@orsmsx416.amr.corp.intel.com> <20080130225738.GB2648@Chamillionaire.breakpoint.cc> <D936D925018D154694D8A362EEB08920038F4382@orsmsx416.amr.corp.intel.com> <1202128649.10632.4.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892003947453@orsmsx416.amr.corp.intel.com> <20080204224502.GA22717@Chamillionaire.breakpoint.cc> <1202167450.5190.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1202167450.5190.2.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dan Williams | 2008-02-04 18:24:10 [-0500]:

>Could you put some debugging information into ipw_rx() to print out the
>values of r and i right before the while (i != r) loop, and inside the
>if (fill_rx) block later down what count and i are?
Sure:

[ 1849.374846] Before while 0x0000001c != 0x0000001d
[ 1849.378151] Before while 0x0000001d != 0x0000001e
[ 1849.378970] Before while 0x0000001e != 0x0000001f
[ 1849.381220] Before while 0x0000001f != 0x00000000
[ 1849.383092] Before while 0x00000000 != 0x00000001
[ 1849.385513] Before while 0x00000001 != 0x00000002
[ 1849.387636] Before while 0x00000002 != 0x00000003
[ 1849.389580] Before while 0x00000003 != 0x00000004
[ 1849.391561] Before while 0x00000004 != 0x00000005
[ 1849.393720] Before while 0x00000005 != 0x00000006
[ 1849.395799] Before while 0x00000006 != 0x00000007
[ 1849.397941] Before while 0x00000007 != 0x00000008
[ 1849.399885] Before while 0x00000008 != 0x00000009
[ 1849.402127] Before while 0x00000009 != 0x0000000a
[ 1849.405144] Before while 0x0000000a != 0x0000000b
[ 1849.406376] Before while 0x0000000b != 0x0000000c
[ 1849.409953] Before while 0x0000000c != 0x0000000d
[ 1849.410070] fill_rx block, count: 0x00000000 i: 0x0000000d
[ 1849.410492] Before while 0x0000000d != 0x0000000e
[ 1849.410610] fill_rx block, count: 0x00000000 i: 0x0000000e
[ 1849.412598] Before while 0x0000000e != 0x0000000f
[ 1849.412716] fill_rx block, count: 0x00000000 i: 0x0000000f
[ 1849.414930] Before while 0x0000000f != 0x00000010
[ 1849.415048] fill_rx block, count: 0x00000000 i: 0x00000010
[ 1849.417127] Before while 0x00000010 != 0x00000011
[ 1849.417244] fill_rx block, count: 0x00000000 i: 0x00000011
[ 1849.419324] Before while 0x00000011 != 0x00000012
[ 1849.419441] fill_rx block, count: 0x00000000 i: 0x00000012
[ 1849.421367] Before while 0x00000012 != 0x00000013
[ 1849.421486] fill_rx block, count: 0x00000000 i: 0x00000013
[ 1849.423275] Before while 0x00000013 != 0x00000014
[ 1849.423392] fill_rx block, count: 0x00000000 i: 0x00000014
[ 1849.425472] Before while 0x00000014 != 0x00000015
[ 1849.425591] fill_rx block, count: 0x00000000 i: 0x00000015
[ 1849.427461] Before while 0x00000015 != 0x00000016
[ 1849.427579] fill_rx block, count: 0x00000000 i: 0x00000016
[ 1849.429440] Before while 0x00000016 != 0x00000017
[ 1849.429557] fill_rx block, count: 0x00000000 i: 0x00000017
[ 1849.431618] Before while 0x00000017 != 0x00000018
[ 1849.431736] fill_rx block, count: 0x00000000 i: 0x00000018
[ 1849.434472] Before while 0x00000018 != 0x00000019
[ 1849.434590] fill_rx block, count: 0x00000000 i: 0x00000019
[  854.288510] ipw2200: Firmware error detected.  Restarting.
[ 1109.987456] Before while 0x00000000 != 0x00000001
[  854.530339] Before while 0x00000001 != 0x00000002
[  854.566437] Before while 0x00000002 != 0x00000003
[  854.596029] Before while 0x00000003 != 0x00000004
[  854.620725] Before while 0x00000004 != 0x00000005
[  854.621141] Before while 0x00000005 != 0x00000006
[  854.621189] Before while 0x00000006 != 0x00000007
[  854.633339] Before while 0x00000007 != 0x00000008
[  854.634229] Before while 0x00000008 != 0x00000009
[  854.639772] Before while 0x00000009 != 0x0000000a
[  854.639812] Before while 0x0000000a != 0x0000000b
[  854.674365] Before while 0x0000000b != 0x0000000c
[  854.697891] Before while 0x0000000c != 0x0000000d
[  854.721436] Before while 0x0000000d != 0x0000000e
[  854.744974] Before while 0x0000000e != 0x0000000f
[  854.768516] Before while 0x0000000f != 0x00000010
[  854.792058] Before while 0x00000010 != 0x00000011
[  854.816046] Before while 0x00000011 != 0x00000012
[  854.816127] Before while 0x00000012 != 0x00000013
[  854.816172] Before while 0x00000013 != 0x00000014
[  854.816688] Before while 0x00000014 != 0x00000015
[  854.857375] Before while 0x00000015 != 0x00000016
[  855.047194] Before while 0x00000016 != 0x00000017
[  855.048013] Before while 0x00000017 != 0x00000018

I'm not sure why the timestamps aren't incrementing.

>Also, what's the procedure to reproduce this again?  I couldn't get that
>bit to trigger but I wasn't really sure what to do to stress the 2200
>that far, otherwise I could have tested the patch more before posting.

I did not get this when do something like:
| ssh box 'cat /dev/zero' >  /dev/null

but it works fine with a firefox download from the same machine. It was
triggered after a download of 22.9 MiB at rate of about 664 KiB (this is
what the download window says).

>Thanks,
>Dan

Sebastian
