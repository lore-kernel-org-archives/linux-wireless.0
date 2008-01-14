Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33561 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYANXhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 18:37:53 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwlwifi 1.2.23 vs. kernel 2.6.23.13
Date: Mon, 14 Jan 2008 15:19:45 -0800
Message-ID: <D936D925018D154694D8A362EEB089200364E3A5@orsmsx416.amr.corp.intel.com> (sfid-20080114_233757_585166_0BAD035C)
In-Reply-To: <20080114221610.GA9080@/bin/dnsdomainname>
References: <20080113150536.GA27544@/bin/dnsdomainname> <D936D925018D154694D8A362EEB089200364DE52@orsmsx416.amr.corp.intel.com> <20080114221610.GA9080@/bin/dnsdomainname>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: <mg@havelsoft.com>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, January 14, 2008 2:16 PM, Mario Guenterberg  wrote:

 
> The built as external module works fine, but I wonder why the
> patched kernel sources not works. If I use the old iwl3945-1.1.19
> with the 2.6.23.13 tree, the built process works in the kernel.

The external iwlwifi driver available from intellinuxwireless.org does
not patch the kernel. After you built the module you could do a "make
install" to place the module in your /lib/modules/... directory and thus
use it as though it is in the kernel, but the kernel sources will not be
modified.

> I see the patch_kernel script in 1.2.23 have the deprecated state.
> But when I do the patch_kernel after a make in the 1.2.23 source tree,
> the files are in the kernel source tree under driver/net/wireless
> including Kconfig and Makefile.
> But the module wasn't built. This makes me wonder...

As you note, "make patch_kernel" is deprecated. Using it has no effect.
The "make patch_kernel" will only print out the message that it is
deprecated and not take any further action. If you see any action taken
then there is something else going on.

After make in the 1.2.23 you could do "make install". You could also use
the modules directly from the directory where it was built. 

Reinette
