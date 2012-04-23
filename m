Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab2DWSzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 14:55:47 -0400
Message-ID: <4F95A5D6.7060500@suse.cz> (sfid-20120423_205557_818530_20BB1F86)
Date: Mon, 23 Apr 2012 20:56:22 +0200
From: Michal Marek <mmarek@suse.cz>
MIME-Version: 1.0
To: "Fry, Donald H" <donald.h.fry@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kay@vrfy.org" <kay@vrfy.org>, "jcm@redhat.com" <jcm@redhat.com>,
	"linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>
Subject: Re: question on non-kernel patch
References: <1334868960.7300.10.camel@dfry-linux1> <20120420140917.GA13844@tuxdriver.com> <193F82CA5D80C84A83D67BB5D5B9FDE548154FE8@ORSMSX101.amr.corp.intel.com>
In-Reply-To: <193F82CA5D80C84A83D67BB5D5B9FDE548154FE8@ORSMSX101.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dne 20.4.2012 16:41, Fry, Donald H napsal(a):
> The base/core/common functionality is still called iwlwifi which
> interacts with the hardware.  On modprobe, the driver tries to find a
> microcode file to run based on the device/vendor id/sub-id.  While
> parsing the microcode file, it will indicate which software API it
> supports, which will indicate which specific module to use, module A
> (old) or module B (new).  This way the user still uses modprobe
> iwlwifi to install, and iwlwifi will request the appropriate specific
> module to make the hardware function.
> 
> However, since module A (for example) requires iwlwifi, an attempt to
> modprobe iwlwifi -r results in a message that iwlwifi is still in
> use.  Module A must be removed first followed by iwlwifi, etc.  While
> this may be obvious from looking at lsmod for a kernel developer, it
> is not obvious for most users.

Do users need to remove modules at all? I doubt it. And if they do, they
will use rmmod, because it is faster to type :). If your concern is
debugging bugreports from users, then simply instruct them to run
'modprobe -r iwlwifi_mod1; modprobe -r iwlwifi_mod2; modprobe -r
iwlwifi' instead of just 'modprobe -r iwlwifi'. Removing a module that
is not loaded will do nothing, it won't even print an error message.

Michal
