Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45216 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab0D0MpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 08:45:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1O6k9v-0006Wv-6r
	for linux-wireless@vger.kernel.org; Tue, 27 Apr 2010 14:45:03 +0200
Received: from 213-190-49-43.static.zebra.lt ([213.190.49.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 27 Apr 2010 14:45:03 +0200
Received: from notasas by 213-190-49-43.static.zebra.lt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 27 Apr 2010 14:45:03 +0200
To: linux-wireless@vger.kernel.org
From: Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: =?utf-8?b?d2wxMjUxX3NkaW8=?= PSM
Date: Tue, 27 Apr 2010 12:39:12 +0000 (UTC)
Message-ID: <loom.20100427T143119-272@post.gmane.org>
References: <1272230300.2349.23.camel@gnutoo-desktop>  <1272232671.2349.25.camel@gnutoo-desktop>  <1272235632.2349.28.camel@gnutoo-desktop> <1272285416.2364.1.camel@gnutoo-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GNUtoo writes:
> Unfortunately it didn't work as expected:
> # ping router
> PING router (192.168.1.1): 56 data bytes
> 64 bytes from 192.168.1.1: seq=0 ttl=64 time=7.995 ms

<snip>

> 64 bytes from 192.168.1.1: seq=32 ttl=64 time=4.303 ms
> 64 bytes from 192.168.1.1: seq=33 ttl=64 time=2194.366 ms 
> 64 bytes from 192.168.1.1: seq=34 ttl=64 time=1193.634 ms
> 64 bytes from 192.168.1.1: seq=35 ttl=64 time=193.421 ms
> 64 bytes from 192.168.1.1: seq=38 ttl=64 time=760.559 ms
> 64 bytes from 192.168.1.1: seq=39 ttl=64 time=784.851 ms
> 
> the power_save feature was activated with iw, just before the
> 64 bytes from 192.168.1.1: seq=33 ttl=64 time=2194.366 ms
> line
> then after 5 lines of ping it stopped displaying the pings.

You need a few more patches for PS to work (on top of current compat-wireless):
http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-kernel.git;a=commitdiff;h=8eb97a1915ae2ab0a19cc6eef1a2753b9514017d
http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-wifi.git;a=commitdiff;h=d16ed8871faa892f5fd4e8161412051ee11c5ecb

I'm working on mainline mergeable versions of those..



