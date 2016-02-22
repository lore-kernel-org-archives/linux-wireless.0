Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35120 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbcBVTcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 14:32:10 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCHv3] rfkill: Userspace control for airplane mode
Date: Mon, 22 Feb 2016 14:31:59 -0500
Message-Id: <1456169519-22377-1-git-send-email-jprvita@endlessm.com> (sfid-20160222_203250_787206_3E2F6F5D)
In-Reply-To: <1456159001-20307-10-git-send-email-jprvita@endlessm.com>
References: <1456159001-20307-10-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide an interface for the airplane-mode indicator be controlled from
userspace. User has to first acquire the control through
RFKILL_OP_AIRPLANE_MODE_INDICATOR_ACQUIRE and keep the fd open for the
whole time it wants to be in control of the indicator. Closing the fd
restores the default policy.

To change state of the indicator, the
RFKILL_OP_AIRPLANE_MODE_INDICATOR_CHANGE operation is used, passing the
value on "struct rfkill_event.soft". If the caller has not acquired the
airplane-mode control beforehand, the operation fails.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 Documentation/rfkill.txt    | 10 ++++++++++
 include/uapi/linux/rfkill.h |  6 ++++++
 net/rfkill/core.c           | 35 +++++++++++++++++++++++++++++++++--
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index b13025a..9dbe3fc 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -87,6 +87,7 @@ RFKill provides per-switch LED triggers, which can be used to drive LEDs
 according to the switch state (LED_FULL when blocked, LED_OFF otherwise).
 An airplane-mode indicator LED trigger is also available, which triggers
 LED_FULL when all radios known by RFKill are blocked, and LED_OFF otherwise.
+The airplane-mode indicator LED trigger policy can be overridden by userspace.
 
 
 5. Userspace support
@@ -123,5 +124,14 @@ RFKILL_TYPE
 The contents of these variables corresponds to the "name", "state" and
 "type" sysfs files explained above.
 
+Userspace can also override the default airplane-mode indicator policy through
+/dev/rfkill. Control of the airplane mode indicator has to be acquired first,
+using RFKILL_OP_AIRPLANE_MODE_INDICATOR_ACQUIRE, and is only available for one
+userspace application at a time. Closing the fd reverts the airplane-mode
+indicator back to the default kernel policy and makes it available for other
+applications to take control. Changes to the airplane-mode indicator state can
+be made using RFKILL_OP_AIRPLANE_MODE_INDICATOR_CHANGE, passing the new value
+in the 'soft' field of 'struct rfkill_event'.
+
 
 For further details consult Documentation/ABI/stable/sysfs-class-rfkill.
diff --git a/include/uapi/linux/rfkill.h b/include/uapi/linux/rfkill.h
index 2e00dce..36e0770 100644
--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -61,12 +61,18 @@ enum rfkill_type {
  * @RFKILL_OP_CHANGE_ALL: userspace changes all devices (of a type, or all)
  *	into a state, also updating the default state used for devices that
  *	are hot-plugged later.
+ * @RFKILL_OP_AIRPLANE_MODE_INDICATOR_ACQUIRE: userspace acquires control of
+ * 	the airplane-mode indicator.
+ * @RFKILL_OP_AIRPLANE_MODE_INDICATOR_CHANGE: userspace changes the
+ * 	airplane-mode indicator state.
  */
 enum rfkill_operation {
 	RFKILL_OP_ADD = 0,
 	RFKILL_OP_DEL,
 	RFKILL_OP_CHANGE,
 	RFKILL_OP_CHANGE_ALL,
+	RFKILL_OP_AIRPLANE_MODE_INDICATOR_ACQUIRE,
+	RFKILL_OP_AIRPLANE_MODE_INDICATOR_CHANGE,
 };
 
 /**
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 04d7fa1..8ea8b73 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -89,6 +89,7 @@ struct rfkill_data {
 	struct mutex		mtx;
 	wait_queue_head_t	read_wait;
 	bool			input_handler;
+	bool			is_apm_owner;
 };
 
 
@@ -123,7 +124,7 @@ static struct {
 } rfkill_global_states[NUM_RFKILL_TYPES];
 
 static bool rfkill_epo_lock_active;
-
+static bool rfkill_apm_owned;
 
 #ifdef CONFIG_RFKILL_LEDS
 static struct led_trigger rfkill_apm_led_trigger;
@@ -350,7 +351,8 @@ static void rfkill_update_global_state(enum rfkill_type type, bool blocked)
 
 	for (i = 0; i < NUM_RFKILL_TYPES; i++)
 		rfkill_global_states[i].cur = blocked;
-	rfkill_apm_led_trigger_event(blocked);
+	if (!rfkill_apm_owned)
+		rfkill_apm_led_trigger_event(blocked);
 }
 
 #ifdef CONFIG_RFKILL_INPUT
@@ -1180,9 +1182,23 @@ static ssize_t rfkill_fop_read(struct file *file, char __user *buf,
 	return ret;
 }
 
+static int rfkill_airplane_mode_release(struct rfkill_data *data)
+{
+	bool state = rfkill_global_states[RFKILL_TYPE_ALL].cur;
+
+	if (rfkill_apm_owned && data->is_apm_owner) {
+		rfkill_apm_owned = false;
+		data->is_apm_owner = false;
+		rfkill_apm_led_trigger_event(state);
+		return 0;
+	}
+	return -EACCES;
+}
+
 static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *pos)
 {
+	struct rfkill_data *data = file->private_data;
 	struct rfkill *rfkill;
 	struct rfkill_event ev;
 	int ret = 0;
@@ -1218,6 +1234,20 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
 			if (rfkill->idx == ev.idx && rfkill->type == ev.type)
 				rfkill_set_block(rfkill, ev.soft);
 		break;
+	case RFKILL_OP_AIRPLANE_MODE_INDICATOR_ACQUIRE:
+		if (rfkill_apm_owned && !data->is_apm_owner) {
+			ret = -EACCES;
+		} else {
+			rfkill_apm_owned = true;
+			data->is_apm_owner = true;
+		}
+		break;
+	case RFKILL_OP_AIRPLANE_MODE_INDICATOR_CHANGE:
+		if (rfkill_apm_owned && data->is_apm_owner)
+			rfkill_apm_led_trigger_event(ev.soft);
+		else
+			ret = -EACCES;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -1234,6 +1264,7 @@ static int rfkill_fop_release(struct inode *inode, struct file *file)
 	struct rfkill_int_event *ev, *tmp;
 
 	mutex_lock(&rfkill_global_mutex);
+	rfkill_airplane_mode_release(data);
 	list_del(&data->list);
 	mutex_unlock(&rfkill_global_mutex);
 
-- 
2.5.0

