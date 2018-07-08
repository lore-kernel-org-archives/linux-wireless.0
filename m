Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24171 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932692AbeGHX3C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Jul 2018 19:29:02 -0400
From: "Ghorai, Sukumar" <sukumar.ghorai@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:RFKILL" <linux-wireless@vger.kernel.org>,
        "Holtmann, Marcel" <marcel.holtmann@intel.com>
CC: "Tumkur Narayan, Chethan" <chethan.tumkur.narayan@intel.com>
Subject: RFkill for Bluetooth hard reset
Date: Sun, 8 Jul 2018 23:28:46 +0000
Message-ID: <D73ECEF0C711E34A8F972E4B87F540058FB55F8D@ORSMSX114.amr.corp.intel.com> (sfid-20180709_012906_834299_28FA99C7)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
We need an option to reset Bluetooth using GPIO toggle for a Linux product when
BT connected over USB (HCI interface). i.e I need out of band(OOB) signal for
USB to control/reset the BT. hence I opt to add ACPI device in RfKill gpio
driver(rfkill-gpio.c).

localhost /sys/class/rfkill # ls -l
total 0
lrwxrwxrwx. 1 root root 0 Jul  8 14:53 rfkill0 -> ../../devices/platform/INTL6205:00/rfkill/rfkill0
lrwxrwxrwx. 1 root root 0 Jul  8 14:53 rfkill2 -> ../../devices/pci0000:00/0000:00:1c.0/0000:01:00.0/ieee80211/phy0/rfkill2
lrwxrwxrwx. 1 root root 0 Jul  8 15:35 rfkill3 -> ../../devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/bluetooth/hci0/rfkill3

I try to use RFkill soft block option to hold/reset (toggle) GPIO. And changes
in rfkill-gpio.c as follows.
1/ reset pin configured as GPIOD_OUT_LOW, hence HW controller is not out of
reset.  I changed to high to work with our controller. 
How to configured as Low/High as a generic solution?

2/ As per existing implementation, the Shutdown gpio is mandatory for the 
framework to use. I feel we can make it an optional.

3/ Followed by /sys/class/rfkill/rfkill0/soft (1/0) is not in sync with
/sys/class/rfkill/rfkill0/uvent (RFKILL_STATE=0/1)

Please guide me to add an ACPI method to toggle the GPIO to reset the bluetooth. 

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index da6d1cf4c11c..5054694c5b3b 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -112,17 +112,17 @@ static int rfkill_gpio_probe(struct platform_device *pdev)

        rfkill->clk = devm_clk_get(&pdev->dev, NULL);

-       gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_OUT_LOW);
+       gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_OUT_HIGH);
        if (IS_ERR(gpio))
                return PTR_ERR(gpio);

        rfkill->reset_gpio = gpio;

-       gpio = devm_gpiod_get_optional(&pdev->dev, "shutdown", GPIOD_OUT_LOW);
-       if (IS_ERR(gpio))
-               return PTR_ERR(gpio);
+       //gpio = devm_gpiod_get_optional(&pdev->dev, "shutdown", GPIOD_OUT_LOW);
+       ////if (IS_ERR(gpio))
+       ////    return PTR_ERR(gpio);

-       rfkill->shutdown_gpio = gpio;
+       //rfkill->shutdown_gpio = gpio;

        /* Make sure at-least one of the GPIO is defined and that
         * a name is specified for this instance
@@ -170,6 +170,7 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 static const struct acpi_device_id rfkill_acpi_match[] = {
        { "BCM4752", RFKILL_TYPE_GPS },
        { "LNV4752", RFKILL_TYPE_GPS },
+       { "INTL6205", RFKILL_TYPE_BLUETOOTH },
        { },


Thx & rgds,
Sukumar
