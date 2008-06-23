Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38797 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762170AbYFWUXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 16:23:22 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 06/13] rfkill: add the WWAN radio type
Date: Mon, 23 Jun 2008 17:23:01 -0300
Message-Id: <1214252588-30723-7-git-send-email-hmh@hmh.eng.br> (sfid-20080623_224913_976908_17AF3464)
In-Reply-To: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
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
index 4ae4486..79f3bbb 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -180,6 +180,9 @@ static ssize_t rfkill_type_show(struct device *dev,
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
1.5.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
