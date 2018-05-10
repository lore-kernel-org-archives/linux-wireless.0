Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752343AbeEJUJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 16:09:15 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org,
        josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org,
        david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no,
        wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com,
        zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org,
        mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com,
        tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        jewalt@lgsinnovations.com, oneukum@suse.com,
        cantabile.desu@gmail.com, khc@pm.waw.pl, arve@android.com,
        tkjos@android.com, corbet@lwn.net, mchehab+samsung@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v7 14/14] Documentation: clarify firmware_class provenance and why we can't rename the module
Date: Thu, 10 May 2018 13:08:50 -0700
Message-Id: <20180510200850.5958-15-mcgrof@kernel.org> (sfid-20180510_221038_777104_46BA6EEA)
In-Reply-To: <20180510200850.5958-1-mcgrof@kernel.org>
References: <20180510200850.5958-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clarify the provenance of the firmware loader firmware_class module name
and why we cannot rename the module in the future.

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 .../driver-api/firmware/fallback-mechanisms.rst          | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/driver-api/firmware/fallback-mechanisms.rst b/Documentation/driver-api/firmware/fallback-mechanisms.rst
index a39323ef7d29..d35fed65eae9 100644
--- a/Documentation/driver-api/firmware/fallback-mechanisms.rst
+++ b/Documentation/driver-api/firmware/fallback-mechanisms.rst
@@ -72,9 +72,12 @@ the firmware requested, and establishes it in the device hierarchy by
 associating the device used to make the request as the device's parent.
 The sysfs directory's file attributes are defined and controlled through
 the new device's class (firmware_class) and group (fw_dev_attr_groups).
-This is actually where the original firmware_class.c file name comes from,
-as originally the only firmware loading mechanism available was the
-mechanism we now use as a fallback mechanism.
+This is actually where the original firmware_class module name came from,
+given that originally the only firmware loading mechanism available was the
+mechanism we now use as a fallback mechanism, which registers a struct class
+firmware_class. Because the attributes exposed are part of the module name, the
+module name firmware_class cannot be renamed in the future, to ensure backward
+compatibility with old userspace.
 
 To load firmware using the sysfs interface we expose a loading indicator,
 and a file upload firmware into:
-- 
2.17.0
