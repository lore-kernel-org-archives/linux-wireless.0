Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47575 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761662Ab0HMOkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Aug 2010 10:40:21 -0400
Received: by fxm13 with SMTP id 13so1752261fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Aug 2010 07:40:20 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 13 Aug 2010 20:10:19 +0530
Message-ID: <AANLkTin1=7JDXSJgTQ-L-9-r18VJY1fUVLPY+cPup8Pn@mail.gmail.com>
Subject: cfg80211 support for pre-auth
From: Dhiraj Gaurh <dhiraj.gaurh@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello folks,
 PMK caching and pre-auth are not currently supported by
cfg80211/nl80211/supplicant. Actually the former is only not supported
by wpa_supplicant. I have fixed that and will be moving the code
upstream shortly.
BUT the latter is not even supported by cfg/nl. Anybody working on
that ? Actually support is not even there for using wext in this
scenario. So you just fail certification if you use cfg/nl. I need to
change this scenario.
Currently thinking if it is better to add support in cfg/nl/supplicant
or just use wext stuff and a patch.
I need an API in cfg80211 to let the driver tell cfg that it has got
beacon from another AP it can preauth with. Then the supplicant will
start the pre-auth process when it receives the message.
Currently in wext the IWEVPMKIDCAND is used for this to pass this info
from drivers to supplicant but this framework does not exist for
cfg80211.
After my changes, hopefully you will be able to pass certification by
simply using cfg/nl and removing wext entirely from the picture.
regards
Dhiraj
