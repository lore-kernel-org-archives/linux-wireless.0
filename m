Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:60755 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758403Ab2FZHV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 03:21:26 -0400
Received: by qaea16 with SMTP id a16so2000506qae.10
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 00:21:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE8CF77.5080400@broadcom.com>
References: <4FE8CF77.5080400@broadcom.com>
Date: Tue, 26 Jun 2012 12:51:25 +0530
Message-ID: <CAC83ZvL2ozQD1DYmtKeFa1PB1pZ1JmBUKFWmDWnbJOCDL3sKNg@mail.gmail.com> (sfid-20120626_092136_688909_6196930B)
Subject: Re: Panda ES board hang when using GPIO as interrupt
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: khilman@ti.com, tony@atomide.com, santosh.shilimkar@ti.com,
	b-cousson@ti.com, grant.likely@secretlab.ca,
	linux-omap@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf3074d3023a660204c35af2f0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--20cf3074d3023a660204c35af2f0
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jun 26, 2012 at 2:22 AM, Franky Lin <frankyl@broadcom.com> wrote:
> Hi Kevin, Tarun,
>
> We are using the expansion connector A on Panda board to mount a SDIO WiFi
> dongle on MMC2 with a level triggered interrupt signal connected to GPIO
> 138. It's been working fine until 3.5 rc1. The board hang randomly within 5
> mins during a network traffic test. After bisecting we found the culprit is
> "[PATCH 8/8] gpio/omap: fix missing check in *_runtime_suspend()" [1].
>
> I noticed Kevin raised some similar cases on other platforms and also
> provided two patches in the patch mail thread. But unfortunately those two
> patches doesn't help in our case. I tested the driver with 3.5-rc3 mainline
> kernel and the issue is still there. I can only "fix" the hang by either
> reverting the commit or disabling CONFIG_PM_RUNTIME. Also, the hang only
> happens on Panda ES board. Old Panda with 4430 works good.
>
> Any thoughts and suggestions?
I just had a quick look at the code. Can you please check if the
attached patch solves
the issue? I just boot tested on Panda and Blaze.
--
Tarun

>From 0e1b322451b7a49487d2d17a147db1aa1d1119fa Mon Sep 17 00:00:00 2001
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Date: Tue, 26 Jun 2012 12:13:47 +0530
Subject: [PATCH] gpio/omap: enabled_non_wakeup_gpios check skips
bank->saved_datain

Commit b3c64bc30af67ed328a8d919e41160942b870451
(gpio/omap: (re)fix wakeups on level-triggered GPIOs)
still skips update of bank->saved_datain in *_runtime_suspend()
which must be done irrespective of edge/level trigger types.
Therefore, move the enbaled_non_wakeup_gpios check after the
bank->saved_datain is updated.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
---
 drivers/gpio/gpio-omap.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index c4ed172..94ecdcf 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1177,9 +1177,6 @@ static int omap_gpio_runtime_suspend(struct device *dev)
                __raw_writel(wake_hi | bank->context.risingdetect,
                             bank->base + bank->regs->risingdetect);

-       if (!bank->enabled_non_wakeup_gpios)
-               goto update_gpio_context_count;
-
        if (bank->power_mode != OFF_MODE) {
                bank->power_mode = 0;
                goto update_gpio_context_count;
@@ -1191,6 +1188,10 @@ static int omap_gpio_runtime_suspend(struct device *dev)
         */
        bank->saved_datain = __raw_readl(bank->base +
                                                bank->regs->datain);
+
+       if (!bank->enabled_non_wakeup_gpios)
+               goto update_gpio_context_count;
+
        l1 = bank->context.fallingdetect;
        l2 = bank->context.risingdetect;

-- 
1.7.0.4



>
> Thanks,
> Franky
>
> [1] http://article.gmane.org/gmane.linux.ports.arm.omap/75708/
>

--20cf3074d3023a660204c35af2f0
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-gpio-omap-enabled_non_wakeup_gpios-check-skips-bank-.patch"
Content-Disposition: attachment;
	filename="0001-gpio-omap-enabled_non_wakeup_gpios-check-skips-bank-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3wna9lb0

RnJvbSAwZTFiMzIyNDUxYjdhNDk0ODdkMmQxN2ExNDdkYjFhYTFkMTExOWZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUYXJ1biBLYW50aSBEZWJCYXJtYSA8dGFydW4ua2FudGlAdGku
Y29tPgpEYXRlOiBUdWUsIDI2IEp1biAyMDEyIDEyOjEzOjQ3ICswNTMwClN1YmplY3Q6IFtQQVRD
SF0gZ3Bpby9vbWFwOiBlbmFibGVkX25vbl93YWtldXBfZ3Bpb3MgY2hlY2sgc2tpcHMgYmFuay0+
c2F2ZWRfZGF0YWluCgpDb21taXQgYjNjNjRiYzMwYWY2N2VkMzI4YThkOTE5ZTQxMTYwOTQyYjg3
MDQ1MQooZ3Bpby9vbWFwOiAocmUpZml4IHdha2V1cHMgb24gbGV2ZWwtdHJpZ2dlcmVkIEdQSU9z
KQpzdGlsbCBza2lwcyB1cGRhdGUgb2YgYmFuay0+c2F2ZWRfZGF0YWluIGluICpfcnVudGltZV9z
dXNwZW5kKCkKd2hpY2ggbXVzdCBiZSBkb25lIGlycmVzcGVjdGl2ZSBvZiBlZGdlL2xldmVsIHRy
aWdnZXIgdHlwZXMuClRoZXJlZm9yZSwgbW92ZSB0aGUgZW5iYWxlZF9ub25fd2FrZXVwX2dwaW9z
IGNoZWNrIGFmdGVyIHRoZQpiYW5rLT5zYXZlZF9kYXRhaW4gaXMgdXBkYXRlZC4KClNpZ25lZC1v
ZmYtYnk6IFRhcnVuIEthbnRpIERlYkJhcm1hIDx0YXJ1bi5rYW50aUB0aS5jb20+Ci0tLQogZHJp
dmVycy9ncGlvL2dwaW8tb21hcC5jIHwgICAgNyArKysrLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDQg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwaW8v
Z3Bpby1vbWFwLmMgYi9kcml2ZXJzL2dwaW8vZ3Bpby1vbWFwLmMKaW5kZXggYzRlZDE3Mi4uOTRl
Y2RjZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncGlvL2dwaW8tb21hcC5jCisrKyBiL2RyaXZlcnMv
Z3Bpby9ncGlvLW9tYXAuYwpAQCAtMTE3Nyw5ICsxMTc3LDYgQEAgc3RhdGljIGludCBvbWFwX2dw
aW9fcnVudGltZV9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldikKIAkJX19yYXdfd3JpdGVsKHdh
a2VfaGkgfCBiYW5rLT5jb250ZXh0LnJpc2luZ2RldGVjdCwKIAkJCSAgICAgYmFuay0+YmFzZSAr
IGJhbmstPnJlZ3MtPnJpc2luZ2RldGVjdCk7CiAKLQlpZiAoIWJhbmstPmVuYWJsZWRfbm9uX3dh
a2V1cF9ncGlvcykKLQkJZ290byB1cGRhdGVfZ3Bpb19jb250ZXh0X2NvdW50OwotCiAJaWYgKGJh
bmstPnBvd2VyX21vZGUgIT0gT0ZGX01PREUpIHsKIAkJYmFuay0+cG93ZXJfbW9kZSA9IDA7CiAJ
CWdvdG8gdXBkYXRlX2dwaW9fY29udGV4dF9jb3VudDsKQEAgLTExOTEsNiArMTE4OCwxMCBAQCBz
dGF0aWMgaW50IG9tYXBfZ3Bpb19ydW50aW1lX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2KQog
CSAqLwogCWJhbmstPnNhdmVkX2RhdGFpbiA9IF9fcmF3X3JlYWRsKGJhbmstPmJhc2UgKwogCQkJ
CQkJYmFuay0+cmVncy0+ZGF0YWluKTsKKworCWlmICghYmFuay0+ZW5hYmxlZF9ub25fd2FrZXVw
X2dwaW9zKQorCQlnb3RvIHVwZGF0ZV9ncGlvX2NvbnRleHRfY291bnQ7CisKIAlsMSA9IGJhbmst
PmNvbnRleHQuZmFsbGluZ2RldGVjdDsKIAlsMiA9IGJhbmstPmNvbnRleHQucmlzaW5nZGV0ZWN0
OwogCi0tIAoxLjcuMC40Cgo=
--20cf3074d3023a660204c35af2f0--
