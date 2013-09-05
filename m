Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55558 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3IEOJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 10:09:07 -0400
Received: from [192.168.2.102] ([79.218.101.214]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0M1nOg-1W6fjH2KdO-00toCz for
 <linux-wireless@vger.kernel.org>; Thu, 05 Sep 2013 16:09:05 +0200
Message-ID: <52289080.80604@rempel-privat.de> (sfid-20130905_160911_825679_5B935F98)
Date: Thu, 05 Sep 2013 16:09:04 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Antonio Quartulli <ordex@autistici.org>
CC: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: WARNING with ath9k_htc on TL-WN721N
References: <20130905100914.GA1570@ritirata.org> <52285C02.8050205@rempel-privat.de> <20130905103204.GB1570@ritirata.org> <52289033.8080205@rempel-privat.de>
In-Reply-To: <52289033.8080205@rempel-privat.de>
Content-Type: multipart/mixed;
 boundary="------------040706050801020405020103"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040706050801020405020103
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Forgot attachment.


Am 05.09.2013 16:07, schrieb Oleksij Rempel:
> Hi,
>
> thank you.
>
> please do some tests for me.
>
> 1. run wireless adapter without other devices on this bus.
>
>> Bus 002 Device 003: ID 0cf3:9271 Atheros Communications, Inc. AR9271
>> 802.11n
>> Bus 002 Device 011: ID 03f0:8607 Hewlett-Packard Optical Mobile Mouse
>> Bus 002 Device 005: ID 0403:6001 Future Technology Devices
>> International, Ltd
>> FT232 USB-Serial (UART) IC
>> Bus 002 Device 006: ID 413c:8187 Dell Computer Corp. DW375 Bluetooth
>> Module
>
> probably Bluetooth can't be removed, so disable it by software.
>
> 2. if this warning disappear, plug them back and rung kernel with
> attached patch. I wont to see if this warning related to channel scan.
>
> 3. try latest wireless-next kernel
> https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git/
>
> there are some patches which will affect usb communication, this will be
> visible on your hardware, in good or bad way. Will see how it performs
> in your situation.
>
> I assume this warning is related to usb bandwidth. Since we use BULK
> transfer, we will get only rest of it. If other devices use ISO or
> Interrupt, They well have priority.
>
>> I'm not using the Intel card listed in lspci. (the iwldvm module is
>> loaded but
>> the interface is down).
>>
>> Cheers,
>>
>>
>> On Thu, Sep 05, 2013 at 12:25:06PM +0200, Oleksij Rempel wrote:
>>> Am 05.09.2013 12:09, schrieb Antonio Quartulli:
>>>> Hello list,
>>>>
>>>> I ma connected to my WPA2-PSK protected network and from time to
>>>> time I get the
>>>> following warning in dmesg. I don't experience any malfunctionng but
>>>> I thought
>>>> it was worth reporting. My kernel version is linux-3.10.10. I
>>>> remember I've seen
>>>> this warning also with previous versions.
>>>>
>>>> The device I use is a TP-LINK TL-WN721N.
>>>> lsusb says:
>>>>
>>>> Bus 002 Device 003: ID 0cf3:9271 Atheros Communications, Inc. AR9271
>>>> 802.11n
>>>>
>>>> Cheers,
>>>>
>>>
>>> Hi Antonio,
>>>
>>> pleas send out of lsusb and lspci.
>>>
>>>
>>> --
>>> Regards,
>>> Oleksij
>>
>
>


-- 
Regards,
Oleksij

--------------040706050801020405020103
Content-Type: text/x-patch;
 name="scan_dbg.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scan_dbg.diff"

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5c1bec1..29ebfcf 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1669,6 +1669,7 @@ static void ath9k_htc_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 
+	pr_info("!!!! %s:%i\n", __func__, __LINE__);
 	mutex_lock(&priv->mutex);
 	spin_lock_bh(&priv->beacon_lock);
 	set_bit(OP_SCANNING, &priv->op_flags);
@@ -1682,6 +1683,7 @@ static void ath9k_htc_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 
+	pr_info("!!!! %s:%i\n", __func__, __LINE__);
 	mutex_lock(&priv->mutex);
 	spin_lock_bh(&priv->beacon_lock);
 	clear_bit(OP_SCANNING, &priv->op_flags);

--------------040706050801020405020103--
