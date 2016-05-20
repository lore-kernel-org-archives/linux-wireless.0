Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35353 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbcETPjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 11:39:39 -0400
Received: by mail-oi0-f68.google.com with SMTP id w198so24545101oiw.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2016 08:39:33 -0700 (PDT)
Subject: Re: "kernel: BUG: scheduling while atomic:" errors with linux kernel
 4.6
To: Bob Copeland <me@bobcopeland.com>, James Feeney <james@nurealm.net>
References: <e2d89c7d-7567-c3ac-505e-7a9aa887c158@nurealm.net>
 <20160519225612.GB12028@localhost>
Cc: hostap@lists.infradead.org, linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <573F2FB3.6090206@lwfinger.net> (sfid-20160520_173943_549771_20D13029)
Date: Fri, 20 May 2016 10:39:31 -0500
MIME-Version: 1.0
In-Reply-To: <20160519225612.GB12028@localhost>
Content-Type: multipart/mixed;
 boundary="------------020503020308030304010602"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020503020308030304010602
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 05/19/2016 05:56 PM, Bob Copeland wrote:
> +linux-wireless
>
> On Thu, May 19, 2016 at 03:11:16PM -0600, James Feeney wrote:
>> Arch linux 4.6-1
>> wpa_supplicant 1:2.5-3
>> Toshiba Satellite, circa 2011, with a Pentium Dual-Core Mobile
>> Error is not seen on other machines.
>>
>> kernel: BUG: scheduling while atomic: wpa_supplicant/375/0x00000002
>
> This is a kernel bug, not a wpa_supplicant bug.  The linux-wireless mailing
> list would be a more appropriate venue for this bug report.
>
>
>> May 19 10:26:07 lapis kernel: BUG: scheduling while atomic: wpa_supplicant/627/0x00000002
> [...]
>> May 19 10:26:07 lapis kernel:  [<ffffffff815c2b39>] __schedule+0x899/0xad0
>> May 19 10:26:07 lapis kernel:  [<ffffffff815c2dac>] schedule+0x3c/0x90
>> May 19 10:26:07 lapis kernel:  [<ffffffff815c5bb2>] schedule_hrtimeout_range_clock+0xa2/0x120
>> May 19 10:26:07 lapis kernel:  [<ffffffff810e8b80>] ? hrtimer_init+0x120/0x120
>> May 19 10:26:07 lapis kernel:  [<ffffffff815c5ba6>] ? schedule_hrtimeout_range_clock+0x96/0x120
>> May 19 10:26:07 lapis kernel:  [<ffffffff815c5c43>] schedule_hrtimeout_range+0x13/0x20
>> May 19 10:26:07 lapis kernel:  [<ffffffff815c568f>] usleep_range+0x4f/0x70
>> May 19 10:26:07 lapis kernel:  [<ffffffffa0667218>] rtl_rfreg_delay+0x38/0x50 [rtlwifi]
>> May 19 10:26:07 lapis kernel:  [<ffffffffa06dd0e7>] rtl92c_phy_config_rf_with_headerfile+0xc7/0xe0 [rtl8192ce]
>
> [Probably due to this kernel change:
>
> commit 49f86ec21c01b654f6ec47f2f4567f4f9ebaa26b
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Mon Feb 15 16:12:07 2016 -0600
>
>      rtlwifi: Change long delays to sleeps
>
>
> ...apparently this function isn't in sleepable context after all.]
>

@James: Please run the command "dmesg | grep rtl_rfreg_delay". Do any of the 
resulting lines show a value other than "+0x38" for the offset? If that is the 
only one, the attached patch should fix the problem.

Thanks,

Larry


--------------020503020308030304010602
Content-Type: text/x-patch;
 name="patch_schedule_while_atomic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch_schedule_while_atomic.patch"

diff --git a/Makefile b/Makefile
index 0f9cb36..080962b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 4
-PATCHLEVEL = 6
+PATCHLEVEL = 7
 SUBLEVEL = 0
-EXTRAVERSION =
+EXTRAVERSION = rc1
 NAME = Charred Weasel
 
 # *DOCUMENTATION*
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 0f48048..2fc0e26 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -75,7 +75,7 @@ void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, u32 addr,
 		rtl_addr_delay(addr);
 	} else {
 		rtl_set_rfreg(hw, rfpath, addr, mask, data);
-		usleep_range(1, 2);
+		udelay(1);
 	}
 }
 EXPORT_SYMBOL(rtl_rfreg_delay);

--------------020503020308030304010602--
