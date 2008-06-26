Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:27894 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYFZVLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 17:11:42 -0400
Received: by ug-out-1314.google.com with SMTP id h2so295122ugf.16
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 14:11:40 -0700 (PDT)
Message-ID: <f6ca9fed0806261411y1b8bca21k66da3a5090524bc6@mail.gmail.com> (sfid-20080626_231145_197518_50EFD72F)
Date: Thu, 26 Jun 2008 23:11:40 +0200
From: drago01 <drago01@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: commit 5dc4dfd6165883b6629a48256dc4eadf76d6b65d
Cc: "Abhijeet Kolekar" <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	adel.gadllah@gmail.com, "Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <200806262259.21764.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12145132373377-git-send-email-abhijeet.kolekar@intel.com>
	 <200806262259.21764.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2008 at 10:59 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Thursday 26 June 2008, Abhijeet Kolekar wrote:
>>     iwlwifi : Patch adds rfkill subsystem for 3945
>>
>>     The patch removes the sysfs interface from iwl3945 and uses
>>     the rfkill subsystem instead.
>
> Shouldn't the driver depend on CONFIG_RFKILL?
> Otherwise compilation will fail when CONFIG_RFKILL isn't selected...

"[PATCH -next] iwlwifi: fix build for CONFIG_INPUT=n" adresses part of this.

IWLWIFI_RFKILL depends on IWLCORE but iwl3945 does not use iwlcore module.
Should we just add a IWL3945_RFKILL and add he changes from the
mentioned patch to 3945 too?

If its ok I can send a patch.
