Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25660 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbaLQIck convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 03:32:40 -0500
From: Avinash Patil <patila@marvell.com>
To: Martin Fuzzey <mfuzzey@parkeon.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 17 Dec 2014 00:29:49 -0800
Subject: RE: [REGRESSION] mwifiex: memory corruption on WEP disassociation
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A01@SC-VEXCH2.marvell.com> (sfid-20141217_093243_269125_24A50C42)
References: <546B5E82.7000207@parkeon.com>,<20141118184241.GD13458@tuxdriver.com>
 <CBACCFA0AEB13A41977475BCF3E896FC666FA7DC82@SC-VEXCH2.marvell.com>,<546C57AF.1040700@parkeon.com>
 <CBACCFA0AEB13A41977475BCF3E896FC666FA7DC8F@SC-VEXCH2.marvell.com>,<546CAE45.6090201@parkeon.com>
In-Reply-To: <546CAE45.6090201@parkeon.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

Issue has been tracked down and it was discovered that with key material v1 API FW, action delete is not supported.
WEP encryption in such cases is disabled by resetting bit in mac_filter which happens in the same function.

Patch has been posted to linux-wireless list; here is link for your reference:

https://patchwork.kernel.org/patch/5505651/

I have added your "reported-by".

Thanks,
Avinash
________________________________________
From: Martin Fuzzey [mfuzzey@parkeon.com]
Sent: Wednesday, November 19, 2014 8:20 PM
To: Avinash Patil
Cc: John W. Linville; linux-wireless@vger.kernel.org; Amitkumar Karwar
Subject: Re: [REGRESSION] mwifiex: memory corruption on WEP disassociation

Hi Avinash,

On 19/11/14 09:44, Avinash Patil wrote:
> Could you please check if issue is seen with this FW as well?
> Here is link:
> http://git.marvell.com/?p=mwifiex-firmware.git;a=commit;h=3f45b8c4cc1eb1d102bc3486b19677332dd215ab

Tried that firmware  (14.66.35.p52) with kernel 3.16, same issue.
It still uses V1 keys.

I also tried kernel 3.18-rc5 (with the original 14.66.9.p96 firmware)
and, while it didn't crash, some logs I added showed that a short (10
byte) response was still being handed to
mwifiex_ret_802_11_key_material_v1().
It didn't crash because I was "lucky" enough that the non initialized
key length field happened to contain zero.


Regards,

Martin
