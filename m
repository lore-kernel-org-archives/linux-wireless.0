Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZIYVY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:24:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/8 v2.6.32 and w-t] iwlwifi: fix debugfs buffer handling
Date: Fri, 25 Sep 2009 14:24:21 -0700
Message-Id: <1253913868-8400-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
References: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

We keep track of where to write into a buffer by keeping a count of how
much has been written so far. When writing to the buffer we thus take the
buffer pointer and adding the count of what has been written so far.
Keeping track of what has been written so far is done by incrementing
this number every time something is written to the buffer with how much has
been written at that time.

Currently this number is incremented incorrectly when using the
"hex_dump_to_buffer" call to add data to the buffer. Fix this by only
adding what has been added to the buffer in that call instead of what has
been added since beginning of buffer.

Issue was discovered and discussed during testing of
https://bugzilla.redhat.com/show_bug.cgi?id=464598 .

When a user views any of these files they will see something like:

[  179.355202] ------------[ cut here ]------------
[  179.355209] WARNING: at ../lib/vsprintf.c:989 vsnprintf+0x5ec/0x5f0()
[  179.355212] Hardware name: VGN-Z540N
[  179.355213] Modules linked in: i915 drm i2c_algo_bit i2c_core ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table container sbs sbshc arc4 ecb iwlagn iwlcore joydev led_class mac80211 af_packet pcmcia psmouse sony_laptop cfg80211 iTCO_wdt iTCO_vendor_support pcspkr serio_raw rfkill intel_agp video output tpm_infineon tpm tpm_bios button battery yenta_socket rsrc_nonstatic pcmcia_core processor ac evdev ext3 jbd mbcache sr_mod sg cdrom sd_mod ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal fan thermal_sys
[  179.355262] Pid: 5449, comm: cat Not tainted 2.6.31-wl-54419-ge881071 #62
[  179.355264] Call Trace:
[  179.355267]  [<ffffffff811ad14c>] ? vsnprintf+0x5ec/0x5f0
[  179.355271]  [<ffffffff81041348>] warn_slowpath_common+0x78/0xd0
[  179.355275]  [<ffffffff810413af>] warn_slowpath_null+0xf/0x20
[  179.355277]  [<ffffffff811ad14c>] vsnprintf+0x5ec/0x5f0
[  179.355280]  [<ffffffff811ad23d>] ? scnprintf+0x5d/0x80
[  179.355283]  [<ffffffff811ad23d>] scnprintf+0x5d/0x80
[  179.355286]  [<ffffffff811aed29>] ? hex_dump_to_buffer+0x189/0x340
[  179.355290]  [<ffffffff810e91d7>] ? __kmalloc+0x207/0x260
[  179.355303]  [<ffffffffa02a02f8>] iwl_dbgfs_nvm_read+0xe8/0x220 [iwlcore]
[  179.355306]  [<ffffffff811a9b62>] ? __up_read+0x92/0xb0
[  179.355310]  [<ffffffff810f0988>] vfs_read+0xc8/0x1a0
[  179.355313]  [<ffffffff810f0b50>] sys_read+0x50/0x90
[  179.355316]  [<ffffffff8100bd6b>] system_call_fastpath+0x16/0x1b
[  179.355319] ---[ end trace 2383d0d5e0752ca0 ]---

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 1a0337f..f2b38d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -413,7 +413,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x ", ofs);
 		hex_dump_to_buffer(ptr + ofs, 16 , 16, 2, buf + pos,
 				   buf_size - pos, 0);
-		pos += strlen(buf);
+		pos += strlen(buf + pos);
 		if (buf_size - pos > 0)
 			buf[pos++] = '\n';
 	}
@@ -912,7 +912,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 						"0x%.4x ", ofs);
 				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
 						   buf + pos, bufsz - pos, 0);
-				pos += strlen(buf);
+				pos += strlen(buf + pos);
 				if (bufsz - pos > 0)
 					buf[pos++] = '\n';
 			}
@@ -935,7 +935,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 						"0x%.4x ", ofs);
 				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
 						   buf + pos, bufsz - pos, 0);
-				pos += strlen(buf);
+				pos += strlen(buf + pos);
 				if (bufsz - pos > 0)
 					buf[pos++] = '\n';
 			}
-- 
1.5.6.3

