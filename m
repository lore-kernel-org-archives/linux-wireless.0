Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65528 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0L1QW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 11:22:58 -0500
Received: by vws16 with SMTP id 16so3876287vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 08:22:57 -0800 (PST)
Message-ID: <4D1A0EF1.8060509@lwfinger.net>
Date: Tue, 28 Dec 2010 10:23:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Weedy <weedy2887@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Compile error for the last week inside rtlwifi/base.c
References: <loom.20101228T075242-208@post.gmane.org>
In-Reply-To: <loom.20101228T075242-208@post.gmane.org>
Content-Type: multipart/mixed;
 boundary="------------070806000806080000040707"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070806000806080000040707
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/28/2010 12:58 AM, Weedy wrote:
> I'm not sure if my kernel is too old or what but since nothing has changed I'm
> going to ask.

Older kernels used create_workqueue(), which is replaced by alloc_workqueue().
If you really need the driver for RTL8192CE/RTL8188CE, then apply the patch
shown below. If you do not need the driver, then disable it in the configuration.

Larry
---

diff --git a/drivers/net/wireless/rtlwifi/base.c
b/drivers/net/wireless/rtlwifi/base.c
index 77fa59a..f6cc073 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -225,7 +225,7 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)

 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
`	rtlpriv->works.rtl_wq = alloc_workqueue(rtlpriv->cfg->name, 0, 0);
+	rtlpriv->works.rtl_wq = create_workqueue(rtlpriv->cfg->name);
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,


--------------070806000806080000040707
Content-Type: text/plain;
 name="reverse_alloc"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="reverse_alloc"

Y29tbWl0IDNkOTg2YjI1YjVmYWE1MGJhNmFmZDk0ZjYwZjI3MGI2YzMwNjFlNWUKQXV0aG9y
OiBKb2huIFcuIExpbnZpbGxlIDxsaW52aWxsZUB0dXhkcml2ZXIuY29tPgpEYXRlOiAgIFRo
dSBEZWMgMTYgMTQ6NTk6NDkgMjAxMCAtMDUwMAoKICAgIHJ0bHdpZmk6IHVzZSBhbGxvY193
b3JrcXVldWUKICAgIAogICAgY3JlYXRlX3dvcmtxdWV1ZSBpcyBkZXByZWNhdGVkLiAgVGhl
IHdvcmtxdWV1ZSB1c2FnZSBkb2VzIG5vdCBzZWVtIHRvCiAgICBkZW1hbmQgYW55IHNwZWNp
YWwgdHJlYXRtZW50LCBzbyBkbyBub3Qgc2V0IGFueSBmbGFncyBlaXRoZXIuCiAgICAKICAg
IFNpZ25lZC1vZmYtYnk6IEpvaG4gVy4gTGludmlsbGUgPGxpbnZpbGxlQHR1eGRyaXZlci5j
b20+CiAgICBUZXN0ZWQtYnk6IExhcnJ5IEZpbmdlciA8TGFycnkuRmluZ2VyQGx3ZmluZ2Vy
Lm5ldD4KICAgIEFja2VkLWJ5OiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+CgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9iYXNlLmMgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9ydGx3aWZpL2Jhc2UuYwppbmRleCA3N2ZhNTlhLi5mNmNjMDczIDEwMDY0
NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL2Jhc2UuYworKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL2Jhc2UuYwpAQCAtMjI1LDcgKzIyNSw3IEBAIHN0
YXRpYyB2b2lkIF9ydGxfaW5pdF9kZWZlcnJlZF93b3JrKHN0cnVjdCBpZWVlODAyMTFfaHcg
Kmh3KQogCiAJLyogPDI+IHdvcmsgcXVldWUgKi8KIAlydGxwcml2LT53b3Jrcy5odyA9IGh3
OwotCXJ0bHByaXYtPndvcmtzLnJ0bF93cSA9IGNyZWF0ZV93b3JrcXVldWUocnRscHJpdi0+
Y2ZnLT5uYW1lKTsKKwlydGxwcml2LT53b3Jrcy5ydGxfd3EgPSBhbGxvY193b3JrcXVldWUo
cnRscHJpdi0+Y2ZnLT5uYW1lLCAwLCAwKTsKIAlJTklUX0RFTEFZRURfV09SSygmcnRscHJp
di0+d29ya3Mud2F0Y2hkb2dfd3EsCiAJCQkgICh2b2lkICopcnRsX3dhdGNoZG9nX3dxX2Nh
bGxiYWNrKTsKIAlJTklUX0RFTEFZRURfV09SSygmcnRscHJpdi0+d29ya3MuaXBzX25pY19v
ZmZfd3EsCg==
--------------070806000806080000040707--
