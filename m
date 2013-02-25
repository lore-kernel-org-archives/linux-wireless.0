Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58596 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639Ab3BYTFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 14:05:45 -0500
Message-ID: <512BB5FA.8050206@hauke-m.de> (sfid-20130225_200548_789994_9057ACCB)
Date: Mon, 25 Feb 2013 20:05:30 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmsmac: export firmware version to ethtool
References: <1361720494-27131-1-git-send-email-hauke@hauke-m.de> <512B72BE.5050808@broadcom.com>
In-Reply-To: <512B72BE.5050808@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2013 03:18 PM, Arend van Spriel wrote:
> On 02/24/13 16:41, Hauke Mehrtens wrote:
>> This exports the firmware version in use to userspace through ethtool.
>>
>> root@OpenWrt:/# ethtool -i wlan0
>> firmware-version: 610.812
> 
> This info is already available under debugfs although I prefer your
> formatting :-) :

I used the same formating b43 uses, I do not know what's the official
formating for this firmware version number.

Writing the firmware version to wiphy->fw_version is the official way to
do this and many drivers already are exporting their firmware version in
this way.

I would prefer export the firmware version this way and also add it to
the hardware info in debugfs, where it already is.

Hauke
