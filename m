Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:49069 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZHGQkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 12:40:51 -0400
Received: by pzk34 with SMTP id 34so1718240pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 09:40:51 -0700 (PDT)
Message-ID: <4A7C58CC.2040708@lwfinger.net>
Date: Fri, 07 Aug 2009 11:39:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT] p54: implement rfkill
References: <200907192354.15349.chunkeey@web.de> <20090807153602.GG7545@tuxdriver.com>
In-Reply-To: <20090807153602.GG7545@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sun, Jul 19, 2009 at 11:54:15PM +0200, Christian Lamparter wrote:
>> This patch gets rid of the deprecated radio_enabled
>>
>> fwio.c: In function ‘p54_setup_mac’:
>> fwio.c:323: warning: ‘radio_enabled’ is deprecated (declared at include/net/mac80211.h:607)
> 
> Anyone had a chance to test this?  And report the results to Christian?

Sorry - I missed this one.

I just tested it. With the patch, the warning is removed. As far as
system operation, the following is observed:

1. If b43 is loaded when using p54usb, then the hardware switch will
kill operation. This behavior is the same with or without this patch.

2. If b43 is unloaded, then p54usb no longer follows the hardware
switch, but operation can be killed with the rfkill user-space
utility. Again, this behavior does not depend on the patch.

Based on the code changes in the patch, it looks as if the radio is
turned off when the device is blocked, but I have no way to test that.

Christian - please add a
Tested-by: Larry Finger <Larry.Finger@lwfinger.net> to the patch and
submit. This change should be in 2.6.32.

Larry


