Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:49758 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXINRxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 13:53:53 -0400
Received: by fk-out-0910.google.com with SMTP id z23so814420fkz
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2007 10:53:51 -0700 (PDT)
Message-ID: <46EACAA5.2050706@gmail.com>
Date: Fri, 14 Sep 2007 18:53:41 +0100
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/05] orinoco: Agere/Lucent firmware download
References: <46E8557F.2080401@gmail.com> <1189746312.26312.39.camel@dv>
In-Reply-To: <1189746312.26312.39.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Wed, 2007-09-12 at 22:09 +0100, Dave wrote:
>> Implements firmware download to RAM for Lucent-Agere firmware.
>> Firmware download is a requirement to implement WPA on these cards.

Hi Pavel,

Thanks for the tips - not sure I was e-mailing the right lists/people.
 
>> The following firmwares download and run on my Dell TrueMobile 1150:
>> 7.65, 8.10, 8.42, 8.58
> 
> What some users may want to run is 6.06 or 6.16, as the 7.xx and 8.xx
> firmwares have stability issues with the monitor mode.

RAM only firmware (ie. Variant 2) is not available prior to firmware 7.52, so unfortunately this patch won't help those users. See driver readme for Summer 2001 release (driver ~v7.06) for the first announcements of variant 2.
 
>> The following firmwares download, but are not compatible with the
>> current orinoco_cs driver:
>> 9.40, 9.42, 9.48
> 
> That's great news anyway.  We may see Hermes II supported eventually.

Those are Hermes I firmwares. Hermes II versions of the same era are ~2.26, and I haven't tried to download these to my Hermes I card :). Also Hermes II download is slightly different.

> Please use sparse to check endianess and other issues.  You can use this
> command once sparse is in PATH:
> 
> make C=2 CF="-Wall -D__CHECK_ENDIAN__"

I'll have a go at that shortly.
 
Thanks,

Dave.
