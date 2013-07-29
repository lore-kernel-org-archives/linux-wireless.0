Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:48481 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3G2W7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 18:59:03 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH] Bluetooth: btmrvl: add calibration data download support
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EA3215F2E@SC-VEXCH1.marvell.com>
Date: Mon, 29 Jul 2013 15:58:59 -0700
Cc: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <791D5341-CA33-425C-BFB8-CB65F5451E39@holtmann.org> (sfid-20130730_005923_411046_AA3559C5)
References: <1375126147-28642-1-git-send-email-bzhao@marvell.com> <39BF90E7-8341-412E-A372-6039B703980D@holtmann.org> <477F20668A386D41ADCC57781B1F70430EA3215F2E@SC-VEXCH1.marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

>>> A text file containing calibration data in hex format can
>>> be provided while loading btmrvl module. The data will be
>>> downloaded to firmware.
>>> eg. insmod btmrvl.ko cal_data_cfg=mrvl/bt_cal_data.conf
>> 
>> why is this a module parameter and you do not just request a standard location via request_firmware().
> 
> Not all devices need downloading the calibration data from host to firmware.
> A module parameter seems more flexible than others.

it is also way harder to use and things need to be manually configured. Don't know know when the device needs calibration information or not. And you can just request_firmware() that file. If it is there, then load it, if not then skip the step.

> The firmware_request() requires a relative file path under /lib/firmware/.
> What is the standard location you are referring to?

You have to create proper filenames for your hardware. Like mrvl/cal_data_v1.conf or similar.

> 
>> I do not like the module parameter approach.
> 
> I'm open to any other approaches. Do you have any suggestions?

As I said above, the device should know if it needs calibration or not. And just installing a file on disk is simpler than having to modify the module parameters somewhere.

Regards

Marcel

