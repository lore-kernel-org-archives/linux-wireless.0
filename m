Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38862 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbaHHLRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 07:17:24 -0400
Received: by mail-qa0-f46.google.com with SMTP id v10so5342736qac.5
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2014 04:17:23 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 8 Aug 2014 13:17:23 +0200
Message-ID: <CALtMJEDfVr1UxExOsiGK4G54BHB54wLt8co_98yZpFzH7NY9VA@mail.gmail.com> (sfid-20140808_131727_761258_D10AC230)
Subject: mwifiex: switching from adhoc to 5GHz managed fails
From: Andreas Fenkart <afenkart@gmail.com>
To: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I start an adhoc network tear it down, then try to connect to
managed 5GHz networks

starting adhoc:
iw wlan0 set type ibss
ip link set wlan0 up
iw wlan0 ibss join "adhoc" 2432

connecting to 5GHz network fails with:

mwifiex_sdio mmc0:0001:1: ASSOC_RESP: failed, status code=2 err=0xfffc
a_id=0xffff

interesting that connecting to 2.4GHz works, and so does connectinug to 5GHz
afterwards. The opposite connecting to 5GHz first, which fails, and then
trying to connect 2.4GHz fails with above error

adhoc -works-> 2.4GHz -works->   5GHz
adhoc -fails->   5GHZ -fails-> 2.4GHZ

unloading/reloading the driver fixes the problem, so fw is not downloaded
again, so seems to be a pure driver issue.

where might the problem might be located?
