Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:32005 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYJGHuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 03:50:03 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3251506wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 00:50:01 -0700 (PDT)
Message-ID: <eb3ff54b0810070050m3256bffao6d566baa41560ae7@mail.gmail.com> (sfid-20081007_095008_252060_81B77B1A)
Date: Tue, 7 Oct 2008 09:50:01 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH ] [RESEND] iwlwifi: fix compilation warning when CONFIG_IWLWIFI_DEBUG is not set.
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	tomas.winkler@intel.com
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_71975_17449064.1223365801161"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_71975_17449064.1223365801161
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

When CONFIG_IWLWIFI_DEBUG is not set and CONFIG_IWLWIFI is set,
we get this compilation warning:
/wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c: In
function 'rs_free_sta':
/wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c:2425:
warning: unused variable 'priv'

This patch fixes it by adding __maybe_unused attribute.

Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_71975_17449064.1223365801161
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fm08cb4f0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1ycy5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXJzLmMKaW5kZXggOTM5NDRkZS4u
ZTJhNThlNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWdu
LXJzLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXJzLmMKQEAg
LTI0MjIsNyArMjQyMiw3IEBAIHN0YXRpYyB2b2lkIHJzX2ZyZWVfc3RhKHZvaWQgKnByaXZfciwg
c3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSwKIAkJCXZvaWQgKnByaXZfc3RhKQogewogCXN0cnVj
dCBpd2xfbHFfc3RhICpscV9zdGEgPSBwcml2X3N0YTsKLQlzdHJ1Y3QgaXdsX3ByaXYgKnByaXYg
PSBwcml2X3I7CisJc3RydWN0IGl3bF9wcml2ICpwcml2IF9fbWF5YmVfdW51c2VkID0gcHJpdl9y
OwogCiAJSVdMX0RFQlVHX1JBVEUoImVudGVyXG4iKTsKIAlrZnJlZShscV9zdGEpOwo=
------=_Part_71975_17449064.1223365801161--
