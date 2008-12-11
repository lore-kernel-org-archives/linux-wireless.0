Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:30081 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbYLKNv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 08:51:29 -0500
Received: by fg-out-1718.google.com with SMTP id 19so459936fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 05:51:27 -0800 (PST)
Message-ID: <c6e12a010812110551o2ba3dc86j41cb911f13c2f12@mail.gmail.com> (sfid-20081211_145133_271892_26DF2ED9)
Date: Thu, 11 Dec 2008 14:51:27 +0100
From: "=?ISO-8859-1?Q?G=E1bor_Moln=E1r?=" <csirkus@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: rt2x00 vs hostapd
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
I am not a developer, just an user, but i have a problem that has to
be solved in a higher level than the rt2x00 driver or hostapd, maybe
in the new common wifi stack.

So the problem: I wanted to use my rt73-based usb dongle as an AP,
with hostapd. Therefore i checked out the rt2x00 git tree, and built a
custom kernel, with the newest rt2x00 driver. Then i compiled the
newest hostapd (v0.6.5) with nl80211 support. When i start the hostapd
(with verbose debugging), it drops the following debug message:
"wlan1: STA 00:14:a5:29:e0:98 IEEE 802.11: did not acknowledge
association response". The client associates and everything seems to
be fine, but when i try to send packages, ping or anything, the
hostapd drops messages that say that the client reassociates and
reassociates again, and it repeats. The problem like in this mail on
the hostapd mailing list:
http://readlist.com/lists/shmoo.com/hostap/1/5106.html .

The hostapd side of the story:
The hostapd wants to receive an acknowledge of the association frames
from the rt2x00 driver. They say that it must be handled by the
driver.

The rt2x00 side of the story:
They say, that the driver cannot acknowledge these frames because of
limitations of the hardware, and therefore it returns TXDONE_UNKNOWN
instead of TXDONE_SUCCESS. So the driver cant say that the operation
suceeded, but it cant say that it didnt succeeded.

As a workaround i patched the hostapd to bypass checking the return
value of this function. The other workaround is to change the driver
to give a TXDONE_SUCCESS return value instead of TXDONE_UNKNOWN. Both
solution works, and the hostapd does its job very well, i tested it
with WPA2 etc... But the problem should be solved somehow, because now
the hostapd people say they dont want to handle this issue, its the
responsibility of the driver, and rt2x00 team says it should be
handled in userspace by hostapd (see this thread:
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=3D5&t=3D4790&p=3D3=
0366
-> the first discussed patch is the interesting one, it wasnt
accepted). So what is the solution? Any idea? Who is responsible for
the problem and solution?

regards,
   G=E1bor Moln=E1r
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
