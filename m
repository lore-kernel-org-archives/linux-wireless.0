Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:33651 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965812AbXCPSNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 14:13:37 -0400
Message-ID: <45FADE37.2080708@lwfinger.net>
Date: Fri, 16 Mar 2007 13:13:11 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Add firmware version to ethtool output
References: <45eb1612.l8xsd6TwZVsRseAH%Larry.Finger@lwfinger.net>	<200703042002.39581.mb@bu3sch.de> <20070316171427.GC3426@tuxdriver.com>
In-Reply-To: <20070316171427.GC3426@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sun, Mar 04, 2007 at 08:02:39PM +0100, Michael Buesch wrote:
>> On Sunday 04 March 2007 19:55, Larry Finger wrote:
> 
>>> @@ -42,6 +43,8 @@ static void bcm43xx_get_drvinfo(struct n
>>>  	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
>>>  	strncpy(info->version, utsname()->release, sizeof(info->version));
>>>  	strncpy(info->bus_info, pci_name(bcm->pci_dev), ETHTOOL_BUSINFO_LEN);
>>> +	snprintf(info->fw_version, sizeof(info->fw_version), "0x%x",
>>> +		 bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, BCM43xx_UCODE_REVISION));
>> This will crash when the device is not up.
> 
> Larry, will you be doing a new version of this patch that accounts
> for this comment?

No. Just drop that patch. It doesn't add enough functionality to bother with it.

Larry
