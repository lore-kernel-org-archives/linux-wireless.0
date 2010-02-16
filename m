Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090Ab0BPVgr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:36:47 -0500
From: Matthew Garrett <mjg@redhat.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-input@vger.kernel.org,
	dmitry.torokhov@gmail.com, marcel@holtmann.org,
	Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] rfkill: Add support for KEY_RFKILL
Date: Tue, 16 Feb 2010 16:36:25 -0500
Message-Id: <1266356185-10324-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1266356185-10324-1-git-send-email-mjg@redhat.com>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for handling KEY_RFKILL in the rfkill input module. This
simply toggles the state of all rfkill devices. The comment in rfkill.h
is also updated to reflect that RFKILL_TYPE_ALL may be used inside the
kernel.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 include/linux/rfkill.h |    2 +-
 net/rfkill/input.c     |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 97059d0..4f82326 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -29,7 +29,7 @@
 /**
  * enum rfkill_type - type of rfkill switch.
  *
- * @RFKILL_TYPE_ALL: toggles all switches (userspace only)
+ * @RFKILL_TYPE_ALL: toggles all switches (requests only - not a switch type)
  * @RFKILL_TYPE_WLAN: switch is on a 802.11 wireless network device.
  * @RFKILL_TYPE_BLUETOOTH: switch is on a bluetooth device.
  * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
diff --git a/net/rfkill/input.c b/net/rfkill/input.c
index a7295ad..3713d7e 100644
--- a/net/rfkill/input.c
+++ b/net/rfkill/input.c
@@ -212,6 +212,9 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 		case KEY_WIMAX:
 			rfkill_schedule_toggle(RFKILL_TYPE_WIMAX);
 			break;
+		case KEY_RFKILL:
+			rfkill_schedule_toggle(RFKILL_TYPE_ALL);
+			break;
 		}
 	} else if (type == EV_SW && code == SW_RFKILL_ALL)
 		rfkill_schedule_evsw_rfkillall(data);
@@ -295,6 +298,11 @@ static const struct input_device_id rfkill_ids[] = {
 		.keybit = { [BIT_WORD(KEY_WIMAX)] = BIT_MASK(KEY_WIMAX) },
 	},
 	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_RFKILL)] = BIT_MASK(KEY_RFKILL) },
+	},
+	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_SWBIT,
 		.evbit = { BIT(EV_SW) },
 		.swbit = { [BIT_WORD(SW_RFKILL_ALL)] = BIT_MASK(SW_RFKILL_ALL) },
-- 
1.6.6.1

