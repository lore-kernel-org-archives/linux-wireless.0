Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58196 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbcFIIZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 04:25:15 -0400
Message-ID: <1465460710.3442.4.camel@sipsolutions.net> (sfid-20160609_102546_760749_57A8F201)
Subject: Re: [PATCH] iw: support and enable separate build dir
From: Johannes Berg <johannes@sipsolutions.net>
To: maxin.john@gmail.com
Cc: linux-wireless@vger.kernel.org,
	"Maxin B. John" <maxin.john@intel.com>
Date: Thu, 09 Jun 2016 10:25:10 +0200
In-Reply-To: <1464770416-17514-1-git-send-email-maxin.john@gmail.com>
References: <1464770416-17514-1-git-send-email-maxin.john@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-06-01 at 11:40 +0300, maxin.john@gmail.com wrote:
> From: "Maxin B. John" <maxin.john@intel.com>
> 
> Support separation of SRCDIR and OBJDIR
> 
Doesn't seem to work:

$ mkdir /tmp/obj
$ make clean
$ make OBJDIR=/tmp/obj
[...]
 GEN  version.c
 CC   version.o
cc: error: version.c: No such file or directory
cc: fatal error: no input files
compilation terminated.
Makefile:104: recipe for target 'version.o' failed
make: *** [version.o] Error 1
$ ls *.o
event.o  genl.o  ibss.o  info.o  interface.o  iw.o  mesh.o  mpath.o
mpp.o  ocb.o  phy.o  reg.o  scan.o  station.o  survey.o  util.o

(object files are in the wrong place too)

johannes
