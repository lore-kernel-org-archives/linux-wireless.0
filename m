Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33486 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab1HFTnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2011 15:43:52 -0400
Received: by gya6 with SMTP id 6so704240gya.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Aug 2011 12:43:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A350199604D92@orsmsx506.amr.corp.intel.com>
References: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com>
	<CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com>
	<CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com>
	<CALSq=BYY8-fAqATwJaFNvzwpSo4WWXbH=pRXn0oknqKXH=4X2A@mail.gmail.com>
	<1312499702.15170.17.camel@wwguy-huron>
	<20110805225051.435fe1b0@mj>
	<E9954878DD1FB34FAE5187FB88C58A350199604D92@orsmsx506.amr.corp.intel.com>
Date: Sat, 6 Aug 2011 22:43:51 +0300
Message-ID: <CANUX_P3p3mqUjJrynivna5Fu4iv8DDdH-rY53Y36tHRVewSSuQ@mail.gmail.com> (sfid-20110806_214356_878868_1450E87B)
Subject: Re: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv pointer
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd30bb8f5d91204a9db6e5d
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd30bb8f5d91204a9db6e5d
Content-Type: text/plain; charset=ISO-8859-1

Can you please try that one ?
I don't have my machine near me, and don't want to crash it remotely,
so I didn't test it. I will test in on Sunday.


diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c
b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 69d4ec4..2fdbffa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -478,27 +478,22 @@ out_no_pci:
 	return err;
 }

-static void iwl_pci_down(struct iwl_bus *bus)
-{
-	struct iwl_pci_bus *pci_bus = (struct iwl_pci_bus *) bus->bus_specific;
-
-	pci_disable_msi(pci_bus->pci_dev);
-	pci_iounmap(pci_bus->pci_dev, pci_bus->hw_base);
-	pci_release_regions(pci_bus->pci_dev);
-	pci_disable_device(pci_bus->pci_dev);
-	pci_set_drvdata(pci_bus->pci_dev, NULL);
-
-	kfree(bus);
-}
-
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
-	void *bus_specific = priv->bus->bus_specific;
+	struct iwl_bus *bus = priv->bus;
+	struct iwl_pci_bus *pci_bus = IWL_BUS_GET_PCI_BUS(bus);
+	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);

 	iwl_remove(priv);

-	iwl_pci_down(bus_specific);
+	pci_disable_msi(pci_dev);
+	pci_iounmap(pci_dev, pci_bus->hw_base);
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+	pci_set_drvdata(pci_dev, NULL);
+
+	kfree(bus);
 }

 #ifdef CONFIG_PM

--000e0cd30bb8f5d91204a9db6e5d
Content-Type: application/octet-stream; name="pci_remove_fix.patch"
Content-Disposition: attachment; filename="pci_remove_fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gr0zrouo0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXBjaS5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtcGNpLmMKaW5kZXggNjlkNGVjNC4uMmZkYmZm
YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtcGNpLmMKKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtcGNpLmMKQEAgLTQ3OCwyNyArNDc4
LDIyIEBAIG91dF9ub19wY2k6CiAJcmV0dXJuIGVycjsKIH0KIAotc3RhdGljIHZvaWQgaXdsX3Bj
aV9kb3duKHN0cnVjdCBpd2xfYnVzICpidXMpCi17Ci0Jc3RydWN0IGl3bF9wY2lfYnVzICpwY2lf
YnVzID0gKHN0cnVjdCBpd2xfcGNpX2J1cyAqKSBidXMtPmJ1c19zcGVjaWZpYzsKLQotCXBjaV9k
aXNhYmxlX21zaShwY2lfYnVzLT5wY2lfZGV2KTsKLQlwY2lfaW91bm1hcChwY2lfYnVzLT5wY2lf
ZGV2LCBwY2lfYnVzLT5od19iYXNlKTsKLQlwY2lfcmVsZWFzZV9yZWdpb25zKHBjaV9idXMtPnBj
aV9kZXYpOwotCXBjaV9kaXNhYmxlX2RldmljZShwY2lfYnVzLT5wY2lfZGV2KTsKLQlwY2lfc2V0
X2RydmRhdGEocGNpX2J1cy0+cGNpX2RldiwgTlVMTCk7Ci0KLQlrZnJlZShidXMpOwotfQotCiBz
dGF0aWMgdm9pZCBfX2RldmV4aXQgaXdsX3BjaV9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBkZXYp
CiB7CiAJc3RydWN0IGl3bF9wcml2ICpwcml2ID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOwotCXZv
aWQgKmJ1c19zcGVjaWZpYyA9IHByaXYtPmJ1cy0+YnVzX3NwZWNpZmljOworCXN0cnVjdCBpd2xf
YnVzICpidXMgPSBwcml2LT5idXM7CisJc3RydWN0IGl3bF9wY2lfYnVzICpwY2lfYnVzID0gSVdM
X0JVU19HRVRfUENJX0JVUyhidXMpOworCXN0cnVjdCBwY2lfZGV2ICpwY2lfZGV2ID0gSVdMX0JV
U19HRVRfUENJX0RFVihidXMpOwogCiAJaXdsX3JlbW92ZShwcml2KTsKIAotCWl3bF9wY2lfZG93
bihidXNfc3BlY2lmaWMpOworCXBjaV9kaXNhYmxlX21zaShwY2lfZGV2KTsKKwlwY2lfaW91bm1h
cChwY2lfZGV2LCBwY2lfYnVzLT5od19iYXNlKTsKKwlwY2lfcmVsZWFzZV9yZWdpb25zKHBjaV9k
ZXYpOworCXBjaV9kaXNhYmxlX2RldmljZShwY2lfZGV2KTsKKwlwY2lfc2V0X2RydmRhdGEocGNp
X2RldiwgTlVMTCk7CisKKwlrZnJlZShidXMpOwogfQogCiAjaWZkZWYgQ09ORklHX1BNCg==
--000e0cd30bb8f5d91204a9db6e5d--
