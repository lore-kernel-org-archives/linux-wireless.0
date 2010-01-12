Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:44749 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481Ab0ALAJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 19:09:39 -0500
Message-ID: <4B4BBDBD.30208@redfish-solutions.com>
Date: Mon, 11 Jan 2010 16:09:33 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Cross-compilation issues
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of our people are running afoul of:

install-modules: modules
        $(MAKE) -C $(KLIB_BUILD) M=$(PWD) $(KMODDIR_ARG) $(KMODPATH_ARG) \
                modules_install
        @./scripts/update-initramfs



in the compat-wireless/Makefile on Ubuntu.

If they are cross-compiling, this tries to diddle their local system.

What would be a robust sanity check to inhibit this action in those cases?

Thanks,

-Philip


