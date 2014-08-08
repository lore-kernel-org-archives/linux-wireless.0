Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40943 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755593AbaHHMvz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 08:51:55 -0400
From: Avinash Patil <patila@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 8 Aug 2014 05:51:50 -0700
Subject: RE: mwifiex: switching from adhoc to 5GHz managed fails
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147BD9@SC-VEXCH2.marvell.com> (sfid-20140808_145158_913224_86B90316)
References: <CALtMJEDfVr1UxExOsiGK4G54BHB54wLt8co_98yZpFzH7NY9VA@mail.gmail.com>
In-Reply-To: <CALtMJEDfVr1UxExOsiGK4G54BHB54wLt8co_98yZpFzH7NY9VA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

Are you setting type back to managed after leaving ibss?

I quickly tried this in my setup and after setting type to managed before connection to 5GHz AP, association is successful.
If I dont set type, I see error from iw itself "operation not supported".

Thanks,
Avinash.
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Andreas Fenkart [afenkart@gmail.com]
Sent: Friday, August 08, 2014 4:47 PM
To: Bing Zhao; linux-wireless@vger.kernel.org
Subject: mwifiex: switching from adhoc to 5GHz managed fails

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
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
