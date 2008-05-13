Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:25974 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbYEMISa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:18:30 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2164607fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 01:18:29 -0700 (PDT)
Message-ID: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com> (sfid-20080513_101834_911613_BEEE2E09)
Date: Tue, 13 May 2008 11:18:29 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Jouni Malinen" <j@w1.fi>
Subject: 11n + wpa_supplicant
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Tomas Winkler" <tomasw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the spec of 11n makes the support on AES mandatory, but not TKIP.
Meaning that a NIC can support WPA2 and 11n separately, but not TKIP
in 11n. The RC4 encryption machine has a delay that makes difficult to
encrypt in TKIP (or WEP) in 11n rates. Intel's 11n are such NICs, 11n
+ TKIP/WEP is not supported.

The problem here is that the association (which can be 11n or not)
occurs before the 4-way handshake. Let's say that I have an AP that
publishes only TKIP in its WPA IE and 11n IE, I can understand that
there is no way I should do 11n association. But what happens with an
AP that publishes TKIP + AES in its RSN IE and 11n IE ? I could
associate in 11n, but then wpa_supplicant might be configured to
associate in TKIP (although the AP support AES), and I would be in an
unsupported mode.

One solution would be to make wpa_supplicant understand what 11n is,
but that's not it's job.
Another solution would be to make wpa_supplicant tell me that it
intends to use TKIP before asking me to associate.

Any ideas ?

thanks

-- 
Emmanuel Grumbach
egrumbach@gmail.com
