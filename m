Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63320 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbaKSOur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 09:50:47 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so2117717wiw.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2014 06:50:46 -0800 (PST)
Message-ID: <546CAE45.6090201@parkeon.com> (sfid-20141119_155051_175390_FFD2D561)
Date: Wed, 19 Nov 2014 15:50:45 +0100
From: Martin Fuzzey <mfuzzey@parkeon.com>
MIME-Version: 1.0
To: Avinash Patil <patila@marvell.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [REGRESSION] mwifiex: memory corruption on WEP disassociation
References: <546B5E82.7000207@parkeon.com>,<20141118184241.GD13458@tuxdriver.com> <CBACCFA0AEB13A41977475BCF3E896FC666FA7DC82@SC-VEXCH2.marvell.com>,<546C57AF.1040700@parkeon.com> <CBACCFA0AEB13A41977475BCF3E896FC666FA7DC8F@SC-VEXCH2.marvell.com>
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC666FA7DC8F@SC-VEXCH2.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

