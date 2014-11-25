Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61509 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYU47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 15:56:59 -0500
Message-ID: <5474ED18.5090306@broadcom.com> (sfid-20141125_215702_650840_AA88FB6E)
Date: Tue, 25 Nov 2014 21:56:56 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] brcmutil: add helper function to format board
 revision
References: <1416945354-23346-1-git-send-email-arend@broadcom.com>	<1416945354-23346-2-git-send-email-arend@broadcom.com> <CACna6rwjieystZYnHGPiRZkgYWA=x3rOVQ8oGk=ZS4YezWiUkA@mail.gmail.com>
In-Reply-To: <CACna6rwjieystZYnHGPiRZkgYWA=x3rOVQ8oGk=ZS4YezWiUkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/14 21:39, Rafał Miłecki wrote:
> On 25 November 2014 at 20:55, Arend van Spriel<arend@broadcom.com>  wrote:
>> +/* Produce a human-readable string for boardrev */
>> +char *brcmu_boardrev_str(u32 brev, char *buf)
>> +{
>> +       char c;
>> +
>> +       if (brev<  0x100) {
>> +               snprintf(buf, 8, "%d.%d", (brev&  0xf0)>>  4, brev&  0xf);
>> +       } else {
>> +               c = (brev&  0xf000) == 0x1000 ? 'P' : 'A';
>> +               snprintf(buf, 8, "%c%03x", c, brev&  0xfff);
>> +       }
>> +       return buf;
>> +}
>
> Is this known what do 'P' and 'A' mean? Just curious.

Me too, but never found out ;-) The test boards I have over here all 
have 'P' prefix.

Regards,
Arend
