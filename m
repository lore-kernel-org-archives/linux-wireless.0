Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49268 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861AbYFDDKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:10:24 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	=?utf-8?q?I=C3=B1aky=20P=C3=A9rez-Gonz=C3=A1lez?=
	<inaky.perez-gonzalez@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 06/12] rfkill: add the WWAN radio type
Date: Wed,  4 Jun 2008 00:10:11 -0300
Message-Id: <1212549017-30144-7-git-send-email-hmh@hmh.eng.br> (sfid-20080604_051035_086560_A2B0FA51)
In-Reply-To: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately, instead of adding a generic Wireless WAN type, a technol=
ogy-
specific type (WiMAX) was added.  That's useless for other WWAN devices=
,
such as EDGE, UMTS, X-RTT and other such radios.

Add a WWAN rfkill type for generic wireless WAN devices.  No keys are a=
dded
as most devices really want to use KEY_WLAN for WWAN control (in a cycl=
e of
none, WLAN, WWAN, WLAN+WWAN) and need no specific keycode added.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: I=C3=B1aky P=C3=A9rez-Gonz=C3=A1lez <inaky.perez-gonzalez@intel.com=
>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: David S. Miller <davem@davemloft.net>
---
 include/linux/rfkill.h    |    2 ++
 net/rfkill/rfkill-input.c |    4 ++++
 net/rfkill/rfkill.c       |    3 +++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 844e961..c0cab7d 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -34,12 +34,14 @@
  * RFKILL_TYPE_BLUETOOTH: switch is on a bluetooth device.
  * RFKILL_TYPE_UWB: switch is on a ultra wideband device.
  * RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
+ * RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
  */
 enum rfkill_type {
 	RFKILL_TYPE_WLAN ,
 	RFKILL_TYPE_BLUETOOTH,
 	RFKILL_TYPE_UWB,
 	RFKILL_TYPE_WIMAX,
+	RFKILL_TYPE_WWAN,
 	RFKILL_TYPE_MAX,
 };
=20
diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 9d6c925..29c13d3 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -101,6 +101,7 @@ static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_=
WLAN);
 static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
 static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
 static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
+static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WWAN);
=20
 static void rfkill_event(struct input_handle *handle, unsigned int typ=
e,
 			unsigned int code, int data)
@@ -126,6 +127,9 @@ static void rfkill_event(struct input_handle *handl=
e, unsigned int type,
 		switch (code) {
 		case SW_RFKILL_ALL:
 			/* EVERY radio type. data !=3D 0 means radios ON */
+			rfkill_schedule_set(&rfkill_wwan,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
 			rfkill_schedule_set(&rfkill_wimax,
 					    (data)? RFKILL_STATE_ON:
 						    RFKILL_STATE_OFF);
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 2e19b68..c5a79ab 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -176,6 +176,9 @@ static ssize_t rfkill_type_show(struct device *dev,
 	case RFKILL_TYPE_WIMAX:
 		type =3D "wimax";
 		break;
+	case RFKILL_TYPE_WWAN:
+		type =3D "wwan";
+		break;
 	default:
 		BUG();
 	}
--=20
1.5.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
