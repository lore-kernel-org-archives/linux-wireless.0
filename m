Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:45815 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbeBTNq0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 08:46:26 -0500
Received: by mail-wr0-f194.google.com with SMTP id p104so13187855wrc.12
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 05:46:26 -0800 (PST)
From: Carlo Caione <carlo@caione.org>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        frederic.danis.oss@gmail.com, sebastian.reichel@collabora.co.uk,
        rafael.j.wysocki@intel.com, hdegoede@redhat.com, linux@endlessm.com
Cc: Carlo Caione <carlo@endlessm.com>
Subject: [RFC PATCH 1/2] net: rfkill: gpio: Fix NULL pointer deference
Date: Tue, 20 Feb 2018 13:46:17 +0000
Message-Id: <20180220134618.12972-2-carlo@caione.org> (sfid-20180220_144632_367185_C28DB61C)
In-Reply-To: <20180220134618.12972-1-carlo@caione.org>
References: <20180220134618.12972-1-carlo@caione.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Carlo Caione <carlo@endlessm.com>

In the rfkill_gpio code the variable type_name is not initialized and it
can point to a spurious memory location. When
device_property_read_string is not able to locate the string we are
passing to rfkill_find_type this random pointer, causing a NULL pointer
dereference when using strcmp.

Signed-off-by: Carlo Caione <carlo@endlessm.com>
---
 net/rfkill/rfkill-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 41bd496531d4..659d2edae972 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -88,7 +88,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 {
 	struct rfkill_gpio_data *rfkill;
 	struct gpio_desc *gpio;
-	const char *type_name;
+	const char *type_name = NULL;
 	int ret;
 
 	rfkill = devm_kzalloc(&pdev->dev, sizeof(*rfkill), GFP_KERNEL);
-- 
2.14.1
