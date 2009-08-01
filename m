Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:45830 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbZHASyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 14:54:36 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-input@vger.kernel.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	dmitry.torokhov@gmail.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] rfkill: Add support for KEY_RFKILL_ALL
Date: Sat,  1 Aug 2009 19:54:19 +0100
Message-Id: <1249152859-14769-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1249152859-14769-1-git-send-email-mjg@redhat.com>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for handling KEY_RFKILL_ALL in the rfkill input module. This
simply toggles the state of all rfkill devices.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 net/rfkill/input.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/input.c b/net/rfkill/input.c
index a7295ad..5517089 100644
--- a/net/rfkill/input.c
+++ b/net/rfkill/input.c
@@ -212,6 +212,12 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 		case KEY_WIMAX:
 			rfkill_schedule_toggle(RFKILL_TYPE_WIMAX);
 			break;
+		case KEY_RFKILL_ALL:
+			rfkill_schedule_toggle(RFKILL_TYPE_WLAN);
+			rfkill_schedule_toggle(RFKILL_TYPE_BLUETOOTH);
+			rfkill_schedule_toggle(RFKILL_TYPE_UWB);
+			rfkill_schedule_toggle(RFKILL_TYPE_WIMAX);
+			break;
 		}
 	} else if (type == EV_SW && code == SW_RFKILL_ALL)
 		rfkill_schedule_evsw_rfkillall(data);
@@ -295,6 +301,11 @@ static const struct input_device_id rfkill_ids[] = {
 		.keybit = { [BIT_WORD(KEY_WIMAX)] = BIT_MASK(KEY_WIMAX) },
 	},
 	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_RFKILL_ALL)] = BIT_MASK(KEY_RFKILL_ALL) },
+	},
+	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_SWBIT,
 		.evbit = { BIT(EV_SW) },
 		.swbit = { [BIT_WORD(SW_RFKILL_ALL)] = BIT_MASK(SW_RFKILL_ALL) },
-- 
1.6.2.5

