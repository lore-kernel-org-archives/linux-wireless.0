Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f52.google.com ([209.85.214.52]:56964 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab1EPTrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 15:47:51 -0400
Received: by bwj24 with SMTP id 24so6270718bwj.11
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 12:47:49 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 16 May 2011 15:41:54 -0400
Message-ID: <BANLkTimDudEKPEjTrWxm1wNA00Cmyot+sA@mail.gmail.com> (sfid-20110516_214802_800576_297908F5)
Subject: what dictates the firmware directory of compat-wireless firmware?
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On an x86 Ubuntu machine, I have built ath9k_htc and successfully
gotten an AR9280 card up with the htc_7010.fw firmware file.  Now,
what I am attempting to do is move the working build to an Android
device.  I have successfully cross-compiled ath9k_htc against my
Android kernel, and I am able to successfully install and load the
ath9k_htc module and related modules on the Android device.  Simply, I
cross-compile and then package the kernel modules with my Android
kernel.  I carry nothing else over.

However, I am hitting a barrier when trying to load the firmware.
Whenever I insert the Atheros USB module, I get the error:
<3>[ 4010.997375] usb 3-1.4: ath9k_htc: Firmware - htc_7010.fw not found

I placed htc_7010.fw in /lib/firmware on my Android device, which is
the location it was on my Ubuntu machine.  However, I still get this
error.

So then I built zd1211rw from the Android kernel source (included in
the kernel source tree), and after doing so I found that /etc/firmware
was the location the in-kernel zd1211rw driver was looking for the
firmware.  By placing zd1201.fw in /etc/firmware, I was able to bring
that card up on the Android device.

Then I tried putting htc_7010.fw in /etc/firmware on the Android
device (same place zd1201.fw worked for the kernel source tree
driver), and I still get the same error that it cannot be found.  But,
the ath9k_htc driver is from compat-wireless, cross-compiled against
my kernel.  Not built from the kernel tree source like zd1211rw was.

I have tried various other locations: /lib/firmware, /etc/firmware,
/system/lib/modules, /system/lib/firmware, /system/etc  ... everything
gives me the same error.

Looking at my Android kernel Makefile, I find:

# ---------------------------------------------------------------------------
# Firmware install
INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware
export INSTALL_FW_PATH

PHONY += firmware_install
firmware_install: FORCE
  @mkdir -p $(objtree)/firmware
  $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_install

#---------------------

This suggests that the kernel is placing (and therefore looking?) for
firmware in /lib/firmware since $(INSTALL_MOD_PATH) defaults to "/"

So, I'm a little confused why it is not finding the firmware.  Does
anyone have any insight on this?

Thanks!
George
