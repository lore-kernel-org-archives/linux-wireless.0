Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab2DSU54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 16:57:56 -0400
Subject: question on non-kernel patch
From: Don Fry <donald.h.fry@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Apr 2012 13:56:00 -0700
Message-ID: <1334868960.7300.10.camel@dfry-linux1> (sfid-20120419_225759_866121_F9B5055C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,
	We have a change to the iwlwifi driver for the near future
which will dynamically load a different module based on the version
of microcode installed on the system.  The driver does a
request_module_nowait after obtaining the firmware file loaded as part
of modprobe.  This all works fine, however unloading the module is not
symmetrical/straight forward.
	It looks like there are capabilities already implemented to
make this easy.  If I put the following script into /etc/modprobe.d
then modprobe iwlwifi-r will do the right thing.
	It is backward compatible with the current iwlwifi driver.
How do I get this out in the community before we submit the patch that
would break iwlwifi removal?

Thanks,
Don


# /etc/modprobe.d/iwlwifi.conf
# iwlwifi will dyamically load either iwldvm or iwlmvm depending on the
# microcode file installed on the system.  When removing iwlwifi, first
# remove the iwl?vm module and then iwlwifi.
remove iwlwifi \
(/sbin/lsmod | grep -o -e ^iwlmvm -e ^iwldvm -e ^iwlwifi | xargs /sbin/rmmod) \
&& /sbin/modprobe -r mac80211


