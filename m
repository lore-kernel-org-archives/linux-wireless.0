Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab2ISHjU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 03:39:20 -0400
Date: Wed, 19 Sep 2012 09:38:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rmmod bcma trigger a crash
Message-ID: <20120919073855.GA2378@redhat.com> (sfid-20120919_093923_866607_FD4D2C3A)
References: <20120918114830.GA3704@redhat.com>
 <5058A315.6060401@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5058A315.6060401@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 18, 2012 at 06:36:37PM +0200, Arend van Spriel wrote:
> On 09/18/2012 01:48 PM, Stanislaw Gruszka wrote:
> >modprobe -r brcmsmac). It happen on 3.5 and latest
> >wireless-testing tree.
> >
> ><4>Pid: 28372, comm: modprobe Not tainted 2.6.32.sgruszka_03 #7 Hewlett-Packard HP xw8600 Workstation/0A98h
> 
> I am doing rmmod of bcma nightly on multiple system. What does
> '2.6.32.sgruszka_03' mean here. Using compat-wireless?

It's RHEL6 kernel with brcmsmac backported from 3.5, but as I wrote
before the same crash happen on vanilla 3.5 and latest wireless-testing.

On RHEL memory dump works so I could grab dmesg after a crash. I put
photo from vanilla 3.5 here:
http://people.redhat.com/sgruszka/DSC_0075.JPG

> The gdb list seems to suggest there is NULL pointer in the list of
> cores, but need disassembly to be sure.

It's not NULL, RAX and RBX are 6b6b6b6b6b6b6b6b, so this is memory
usage after free kind of issue.

BTW: Arend, I'm testing brcmsmac currently and I hit various other
problems, in what form You (i.e. brcsmac developers) prefer to get
bug reports, mailing list, kernel bugzilla, something else ?

Stanislaw
