Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43931 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211AbcCQRfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 13:35:54 -0400
Date: Thu, 17 Mar 2016 20:35:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: christophe.ricard@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: re: nfc: st21nfca: Add support for acpi probing for i2c device.
Message-ID: <20160317173542.GA29162@mwanda> (sfid-20160317_183557_654907_4DA5C039)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christophe Ricard,

The patch dfa8070d7f64: "nfc: st21nfca: Add support for acpi probing
for i2c device." from Dec 23, 2015, leads to the following static
checker warning:

	drivers/nfc/st21nfca/i2c.c:530 st21nfca_hci_i2c_acpi_request_resources()
	error: 'gpiod_ena' dereferencing possible ERR_PTR()

drivers/nfc/st21nfca/i2c.c
   507  static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
   508  {
   509          struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
   510          const struct acpi_device_id *id;
   511          struct gpio_desc *gpiod_ena;
   512          struct device *dev;
   513  
   514          if (!client)
   515                  return -EINVAL;
   516  
   517          dev = &client->dev;
   518  
   519          /* Match the struct device against a given list of ACPI IDs */
   520          id = acpi_match_device(dev->driver->acpi_match_table, dev);
   521          if (!id)
   522                  return -ENODEV;
   523  
   524          /* Get EN GPIO from ACPI */
   525          gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN, 1,
   526                                           GPIOD_OUT_LOW);
   527          if (!IS_ERR(gpiod_ena))
   528                  phy->gpio_ena = desc_to_gpio(gpiod_ena);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is correct.

   529  
   530          phy->gpio_ena = desc_to_gpio(gpiod_ena);
                                ^^^^^^^^^^^^^^^^^^^^^^^
This will oops.  Maybe just delete this line.

   531  
   532          phy->irq_polarity = irq_get_trigger_type(client->irq);
   533  
   534          phy->se_status.is_ese_present =
   535                                  device_property_present(dev, "ese-present");
   536          phy->se_status.is_uicc_present =
   537                                  device_property_present(dev, "uicc-present");
   538  
   539          return 0;
   540  }


regards,
dan carpenter
