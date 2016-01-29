Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36759 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbcA2RyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 12:54:12 -0500
Subject: Re: WARNING at net/mac80211/rate.c:513 ieee80211_get_tx_rates
 [mac80211]
To: Linus Torvalds <torvalds@linux-foundation.org>
References: <CA+55aFxe22iWok6UojY=hCoG2k1wNpJ9CfQ0b+STSxq67tb86Q@mail.gmail.com>
 <1453983185.2217.12.camel@sipsolutions.net>
 <CA+55aFya9K4JboNY8kB9cg6zt9otguhdzfHm3jvLmWedxQTSWg@mail.gmail.com>
 <1454013625.2332.9.camel@sipsolutions.net>
 <CA+55aFx73nv9ny-fu5BR6v8wL=f2oFomwrZoLRw=x2kNP76cYA@mail.gmail.com>
 <CA+55aFzF0gWfvmE+6ZcHmjnO4xp-oVAQ5SWxYJhOzns2ocgCsw@mail.gmail.com>
 <1454019155.2332.15.camel@sipsolutions.net>
 <CA+55aFxjpdepHYD_6uU48kW38Z9bmf2wwA8yPZt4ibhkofmfQA@mail.gmail.com>
 <56AAC66C.1080800@lwfinger.net> <1454056380.3369.2.camel@sipsolutions.net>
 <CAP71bdVZzUUNwP3py_m1pwU21qMKth=0BmMfLuUb7=B-1840zg@mail.gmail.com>
 <1454084146.2800.0.camel@sipsolutions.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56ABA73C.1060504@lwfinger.net> (sfid-20160129_185452_503497_4BCCF969)
Date: Fri, 29 Jan 2016 11:54:04 -0600
MIME-Version: 1.0
In-Reply-To: <1454084146.2800.0.camel@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------010908040302070206000802"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010908040302070206000802
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Linus,

Attached is a trial patch that fixes the problem on my system. As I told 
Johannes earlier, my AP was not configured to use VHT, thus I did not see the 
problem.

The test patch that Johannes sent earlier was close. The section needed to add 
VHT rates is:

--- a/drivers/net/wireless/realtek/rtlwifi/rc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
@@ -138,6 +138,9 @@ static void _rtl_rc_rate_set_series(struct rtl_priv *rtlpriv,
                     ((wireless_mode == WIRELESS_MODE_N_5G) ||
                      (wireless_mode == WIRELESS_MODE_N_24G)))
                         rate->flags |= IEEE80211_TX_RC_MCS;
+               if (sta && sta->vht_cap.vht_supported &&
+                   (wireless_mode == WIRELESS_MODE_AC_5G))
+                       rate->flags |= IEEE80211_TX_RC_VHT_MCS;
         }
  }

Larry


--------------010908040302070206000802
Content-Type: text/x-patch;
 name="0001-rtlwifi-Fix-warning-from-ieee80211_get_tx_rates-when.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rtlwifi-Fix-warning-from-ieee80211_get_tx_rates-when.pa";
 filename*1="tch"

>From bd34ac0c3caa9ff982194256b0e96772a17e719d Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Fri, 29 Jan 2016 11:29:10 -0600
Subject: [PATCH] rtlwifi: Fix warning from ieee80211_get_tx_rates() when using
 5G
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
    devel@driverdev.osuosl.org

When using a 5G-capable device with VHT rates enabled, the following
warning results:

WARNING: CPU: 3 PID: 2253 at net/mac80211/rate.c:625 ieee80211_get_tx_rates+0x22e/0x620 [mac80211]()
Modules linked in: rtl8821ae btcoexist rtl_pci rtlwifi fuse drbg ansi_cprng ctr ccm bnep bluetooth af_packet nfs fscache vboxpci(O) vboxnetadp(O) vboxne
tflt(O) vboxdrv(O) arc4 snd_hda_codec_generic x86_pkg_temp_thermal rtsx_pci_sdmmc mmc_core rtsx_pci_ms kvm_intel memstick iwlmvm kvm mac80211 snd_hda_intel snd_hda_cod
ec snd_hwdep snd_hda_core irqbypass snd_pcm iwlwifi crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 snd_timer lrw gf128mul glue_h
elper ablk_helper cryptd snd cfg80211 pcspkr serio_raw e1000e rtsx_pci lpc_ich ptp xhci_pci mfd_core pps_core xhci_hcd soundcore toshiba_acpi thermal sparse_keymap wmi
 toshiba_bluetooth rfkill acpi_cpufreq battery ac processor dm_mod i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
drm sr_mod cdrom video button sg autofs4 [last unloaded: rtlwifi]
CPU: 3 PID: 2253 Comm: Timer Tainted: G        W  O    4.5.0-rc1-wl+ #79
Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.20   04/17/2014
  ffffffffa05c4be6 ffff8802262036d8 ffffffff813d7912 0000000000000000
  ffff880226203710 ffffffff8106bcb6 ffff8800c6831300 ffff8800c6831330
  0000000000000000 ffff8800c683133c ffff880065923638 ffff880226203720
Call Trace:
  <IRQ>  [<ffffffff813d7912>] dump_stack+0x4b/0x79
  [<ffffffff8106bcb6>] warn_slowpath_common+0x86/0xc0
  [<ffffffff8106bdaa>] warn_slowpath_null+0x1a/0x20
  [<ffffffffa05511ee>] ieee80211_get_tx_rates+0x22e/0x620 [mac80211]
  [<ffffffffa0782232>] ? rtl_is_special_data+0x32/0x240 [rtlwifi]
  [<ffffffffa055209e>] ? rate_control_get_rate+0xce/0x150 [mac80211]
  [<ffffffff810bfc7d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff81071cc5>] ? __local_bh_enable_ip+0x65/0xd0
--- traceback terminated here ---

The problem is that IEEE80211_TX_RC_VHT_MCS is not set in the rate flags.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
index 74c14ce..e7eae63 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
@@ -138,6 +138,9 @@ static void _rtl_rc_rate_set_series(struct rtl_priv *rtlpriv,
 		    ((wireless_mode == WIRELESS_MODE_N_5G) ||
 		     (wireless_mode == WIRELESS_MODE_N_24G)))
 			rate->flags |= IEEE80211_TX_RC_MCS;
+		if (sta && sta->vht_cap.vht_supported &&
+		    (wireless_mode == WIRELESS_MODE_AC_5G))
+			rate->flags |= IEEE80211_TX_RC_VHT_MCS;
 	}
 }
 
-- 
2.1.4


--------------010908040302070206000802--
