Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61664 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1HMDij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 23:38:39 -0400
Received: by yie30 with SMTP id 30so2383738yie.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 20:38:39 -0700 (PDT)
Message-ID: <4E45F1BB.7010709@lwfinger.net> (sfid-20110813_053843_120324_9E92C548)
Date: Fri, 12 Aug 2011 22:38:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roman Krylov <volyrkr@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192* wifi driver
References: <4E45A973.6060305@gmail.com> <4E45AF82.5040407@lwfinger.net> <4E45D65F.6000306@gmail.com> <4E45DCB2.5020905@lwfinger.net> <4E45EA54.5010500@gmail.com>
In-Reply-To: <4E45EA54.5010500@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 10:07 PM, Roman Krylov wrote:
>
>> What do you see in the NM log file? It should be at /var/log/NetworkManager?
>>
>> I would also like to see the output of the 'iwlist scan' command when run as
>> root.
>>
>> Larry
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Activation (wlan3/wireless):
> connection 'Auto bhn 310' has security, and secrets exist. No new secrets needed.
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Config: added 'ssid' value 'bhn 310'
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Config: added 'scan_ssid' value '1'
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Config: added 'key_mgmt' value
> 'NONE'
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Config: added 'auth_alg' value
> 'OPEN'
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Config: added 'wep_key0' value
> '<omitted>'
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Config: added 'wep_key1' value
> '<omitted>'
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Config: added 'wep_tx_keyidx'
> value '0'
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Activation (wlan3) Stage 2 of 5
> (Device Configure) complete.
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Config: set interface ap_scan to 1
> Aug 12 21:26:11 volyrkr NetworkManager: <info> (wlan3): supplicant connection
> state: inactive -> scanning
> Aug 12 21:26:36 volyrkr NetworkManager: <info> Activation (wlan3/wireless):
> association took too long.
> Aug 12 21:26:36 volyrkr NetworkManager: <info> (wlan3): device state change: 5
> -> 9 (reason 7)
> Aug 12 21:26:36 volyrkr NetworkManager: <info> Activation (wlan3) failed for
> access point (bhn 310)

It worked here:

Aug 12 22:35:15 larrylap NetworkManager[3258]: <info> Activation 
(wlan5/wireless): connection 'Auto bhn 310' has security, and secrets exist.  No 
new secrets
  needed.
Aug 12 22:35:15 larrylap NetworkManager[3258]: <info> Config: added 'ssid' value 
'Auto bhn 310'
Aug 12 22:35:15 larrylap NetworkManager[3258]: <info> Config: added 'scan_ssid' 
value '1'
Aug 12 22:35:15 larrylap NetworkManager[3258]: <info> Config: added 'key_mgmt' 
value 'NONE'
Aug 12 22:35:15 larrylap NetworkManager[3258]: <info> Config: added 'wep_key0' 
value '<omitted>'
Aug 12 22:35:15 larrylap NetworkManager[3258]: <info> Config: added 
'wep_tx_keyidx' value '0'
Aug 12 22:35:15 larrylap NetworkManager[3258]: <info> Activation (wlan5) Stage 2 
of 5 (Device Configure) complete.
Aug 12 22:35:15 larrylap NetworkManager[3258]: <info> Config: set interface 
ap_scan to 1
Aug 12 22:35:15 larrylap NetworkManager[3258]: <info> (wlan5): supplicant 
connection state:  disconnected -> scanning
Aug 12 22:35:16 larrylap NetworkManager[3258]: <info> (wlan5): supplicant 
connection state:  scanning -> associating
Aug 12 22:35:16 larrylap NetworkManager[3258]: <info> (wlan5): supplicant 
connection state:  associating -> associated
Aug 12 22:35:16 larrylap NetworkManager[3258]: <info> (wlan5): supplicant 
connection state:  associated -> completed
Aug 12 22:35:16 larrylap NetworkManager[3258]: <info> Activation 
(wlan5/wireless) Stage 2 of 5 (Device Configure) successful.  Connected to 
wireless network 'Auto bhn 310'.

Something is wrong with your configuration. I suggest killing the connection in 
NM and remake it. Do you use KDE or Gnome? My tests were with KDE.

Larry

