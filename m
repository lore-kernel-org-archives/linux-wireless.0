Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360AbcBIVAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 16:00:47 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Drunk Cat <natserver2@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: alfa awus036nhr v2 and module rtl8xxxu
References: <loom.20160128T003525-188@post.gmane.org>
	<wrfjd1sco25f.fsf@redhat.com> <56B38CDF.9010806@lwfinger.net>
	<wrfjd1scmkz6.fsf@redhat.com>
Date: Tue, 09 Feb 2016 16:00:46 -0500
In-Reply-To: <wrfjd1scmkz6.fsf@redhat.com> (Jes Sorensen's message of "Thu, 04
	Feb 2016 12:41:33 -0500")
Message-ID: <wrfj60xxd2f5.fsf@redhat.com> (sfid-20160209_220049_609813_811D686C)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> On 02/04/2016 10:45 AM, Jes Sorensen wrote:
>>> Drunk Cat <natserver2@gmail.com> writes:
>>>> problem: it does not connect to any wifi network you can see the time out on
>>>> dmesg
>>>>
>>>>
>>>>> lsusb
>>>>
>>>> Bus 002 Device 007: ID 0bda:817f Realtek Semiconductor Corp. RTL8188RU
>>>> 802.11n WLAN Adapter
>>>>
>>>>> iwconfig
>>>> wlp0s20u1  IEEE 802.11bgn  ESSID:off/any
>>>>            Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>>>>            Retry short limit:7   RTS thr=2347 B   Fragment thr:off
>>>>            Power Management:off
>>>>> dmesg
>>>
>>> Not sure what distribution you are running, but I am seeing problems
>>> with NetworkManager in recent Fedora.
>>>
>>> Could you try the following:
>>> 1) Unplug the WiFi dongle
>>> 2) (Re)load the driver (rmmod rtl8xxxu ; insmod rtl8xxxu)
>>> 3) Restart NetworkManager 'systemctl restart NetworkManager'
>>> 4) Plug in the WiFi dongle
>>
>> Jes,
>>
>> I can confirm what Drunk Cat sees. There is something different about
>> the RTL8192RU as using the iwconfig utility shows no APs in the
>> scan. I hope to get to debugging the problem soon.
>
> OK - thats unfortunate. Most likely the wrong antenna path is being
> enabled for it, or something like that.
>
> Once I finish up the 8723bu/8192eu patchset, I'll try to find some time
> to look at it, if you don't nail it before.

One more time with the actual patch ...

Jes


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=rtl8xxxu-1t2r.patch

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b0adc2d..e4b8d75 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3810,7 +3810,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_FPGA1_TX_INFO, val32);
 
 		val32 = rtl8xxxu_read32(priv, REG_CCK0_AFE_SETTING);
-		val32 &= 0xff000000;
+		val32 &= 0x00ffffff;
 		val32 |= 0x45000000;
 		rtl8xxxu_write32(priv, REG_CCK0_AFE_SETTING, val32);
 

--=-=-=--
