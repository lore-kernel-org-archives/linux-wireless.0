Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36844 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab3CLQ0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 12:26:37 -0400
Message-ID: <513F5736.5020001@qca.qualcomm.com> (sfid-20130312_172646_473704_466261BD)
Date: Tue, 12 Mar 2013 21:56:30 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Julien Massot <jmassot@aldebaran-robotics.com>,
	<ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ath6kl: cold reset target after host warm boot
References: <20130309100031.432.94974.stgit@localhost6.localdomain6> <20130309100150.432.50619.stgit@localhost6.localdomain6> <CADGp=QeRNuJLeDBWPH=z89R18-sEMy6qYsfaseyLG9qR+M4AbQ@mail.gmail.com> <87mwuachtg.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87mwuachtg.fsf@kamboji.qca.qualcomm.com>
Content-Type: multipart/mixed;
	boundary="------------020002040901000407050204"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------020002040901000407050204
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 03/11/2013 04:41 PM, Kalle Valo wrote:
> Julien Massot <jmassot@aldebaran-robotics.com> writes:
>
>>> Julien reported that ar6004 usb device fails to initialise
>>> after host has been rebooted and power is still on for the ar6004 device. He
>>> found out that doing a cold reset fixes the issue.
>>>
>>> I wasn't sure what would be the best way to detect if target needs a reset so I
>>> settled on checking a timeout from htc_wait_recv_ctrl_message().
>>>
>>> Reported-by: Julien Massot <jmassot@aldebaran-robotics.com>
>>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>>> ---
>>
>> This patch fix the issue, now my adapter works after a soft reboot.
>> The log are also better: (here is what happen on soft reboot)
>>
>> [   17.328029] ath6kl: htc pipe control receive timeout!
>> [   17.328033] ath6kl: htc wait target timed out, resetting device
>> [   17.332178] ath6kl: Failed to start hardware: -110
>> [   17.332208] ath6kl: Failed to init ath6kl core: -110
>> [   17.332270] ath6kl_usb: probe of 2-1:1.0 failed with error -110
>> [   17.332306] usbcore: registered new interface driver ath6kl_usb
>> [   19.040315] ath6kl: ar6004 hw 1.3 usb fw 3.5.0.2356\x01 api 3
>
> Oh, I also need to fix that \x01 in the firmware version, the null
> termination is incorrect. But this is a separate issue.
>
>> Tested-by: Julien Massot <jmassot@aldebaran-robotics.com>
>
> Thank you. I add that to the patch.
>
Kalle,

attached the internally suggested patch with CL explanation, not rebased.

  During host crashes or some unexpected reasons causing driver reload 
without unload first, the target firmware will fail to upload again 
since it never power down or reset by host. We check the host app area 
to check target status and reset target if needed.


-- 
thanks,
shafi

--------------020002040901000407050204
Content-Type: text/x-patch;
	name="0001-ath6kl-Reset-target-if-the-firmware-is-already-uploa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-ath6kl-Reset-target-if-the-firmware-is-already-uploa.pa";
	filename*1="tch"

>From 13ca700a2fede518255727446d62eaf59807d182 Mon Sep 17 00:00:00 2001
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Date: Sun, 3 Mar 2013 00:12:21 +0530
Subject: [PATCH] ath6kl: Reset target if the firmware is already uploaded

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.c |    7 +++++++
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |   17 +++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 47800c2..65d3ed8 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -104,6 +104,13 @@ int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type)
 	ar->target_type = le32_to_cpu(targ_info.type);
 	ar->wiphy->hw_version = le32_to_cpu(targ_info.version);
 
+	if (ath6kl_get_host_app_area(ar)) {
+		ath6kl_err("Firmware already uploaded, reset target\n");
+		ath6kl_reset_device(ar, ar->target_type, true, true);
+		ret = -EAGAIN;
+		goto err_power_off;
+	}
+
 	ret = ath6kl_init_hw_params(ar);
 	if (ret)
 		goto err_power_off;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index d7202f1..4ccfaec 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -1013,6 +1013,7 @@ int ath6kl_init_hw_start(struct ath6kl *ar);
 int ath6kl_init_hw_stop(struct ath6kl *ar);
 int ath6kl_init_fetch_firmwares(struct ath6kl *ar);
 int ath6kl_init_hw_params(struct ath6kl *ar);
+int ath6kl_get_host_app_area(struct ath6kl *ar);
 
 void ath6kl_check_wow_status(struct ath6kl *ar);
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6cfd827..ad4e454 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -283,6 +283,23 @@ void ath6kl_init_profile_info(struct ath6kl_vif *vif)
 	vif->bss_ch = 0;
 }
 
+int ath6kl_get_host_app_area(struct ath6kl *ar)
+{
+	u32 address, data;
+
+	/* Fetch the address of the host_app_area_s
+	 * instance in the host interest area */
+	address = ath6kl_get_hi_item_addr(ar, HI_ITEM(hi_app_host_interest));
+	address = TARG_VTOP(ar->target_type, address);
+
+	if (ath6kl_diag_read32(ar, address, &data))
+		return -EIO;
+
+	address = TARG_VTOP(ar->target_type, data);
+
+	return address;
+}
+
 static int ath6kl_set_host_app_area(struct ath6kl *ar)
 {
 	u32 address, data;
-- 
1.7.9.5


--------------020002040901000407050204--
